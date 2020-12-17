-module(tcp_client_handler).
-behaviour(gen_server).

-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(socket_info_record, {config_behavior, socket, server_ip, server_port, recv_timer_ref, recv_timeout_count}).

start_link({Ip, Port}, ConfigBehavior) ->
	gen_server:start_link(?MODULE, [{Ip, Port}, ConfigBehavior], []).

init([{Ip, Port}, ConfigBehavior]) ->
	{ok, #socket_info_record{config_behavior = ConfigBehavior, server_ip = Ip, server_port = Port}, 0}.

handle_call(Msg, _From, State) ->
	{reply, {ok, Msg}, State}.

handle_cast(stop, State) ->
	io:format("stop~n"),
	{stop, normal, State}.

handle_info({tcp, Socket, Data}, #socket_info_record{config_behavior = ConfigBehavior, recv_timer_ref = OldRecvTimerRef} = State) ->
	OptionsModule = ConfigBehavior:get_socket_options_module(),

	erlang:cancel_timer(OldRecvTimerRef),
	NewRecvTimerRef = erlang:send_after(OptionsModule:get_tcp_recv_timeout(), self(), recv_time_out),

	%% 收到数据
	SocketCodecModule = ConfigBehavior:get_socket_codec_module(),
	DataBin = SocketCodecModule:decode(Data),

	SocketUnpackModule = ConfigBehavior:get_socket_package_module(),
	{Cmd, InfoBin} = SocketUnpackModule:unpack(DataBin),

	SocketHandlerModule = ConfigBehavior:get_socket_handler_module(),
	SocketHandlerModule:on_server_data(Socket, Cmd, InfoBin),

	{noreply, State#socket_info_record{recv_timer_ref = NewRecvTimerRef}};

handle_info({tcp_passive, Socket}, #socket_info_record{config_behavior = ConfigBehavior} = State) ->
	OptionsModule = ConfigBehavior:get_socket_options_module(),
	inet:setopts(Socket, [{active, OptionsModule:get_active_count()}]),
	{noreply, State};

handle_info({tcp_closed, _Socket}, #socket_info_record{config_behavior = ConfigBehavior, server_ip = Ip, server_port = Port} = State) ->
	%% 服务器断开连接
	SocketHandlerMod = ConfigBehavior:get_socket_handler_module(),
	SocketHandlerMod:on_disconnected(Ip, Port),

	io:format("tcp_closed~n"),

	{stop, normal, State};

handle_info({tcp_error, _Socket, Reason}, State) ->
	io:format("tcp_error~n"),
	{stop, Reason, State};

handle_info(timeout, #socket_info_record{config_behavior = ConfigBehavior, server_ip = Ip, server_port = Port} = State) ->
	OptionsModule = ConfigBehavior:get_socket_options_module(),
	Options = OptionsModule:get_tcp_options(),

	case gen_tcp:connect(Ip, Port, Options, OptionsModule:get_tcp_conn_timeout()) of
		{ok, Socket} ->
			inet:setopts(Socket, [{active, OptionsModule:get_active_count()}]),

			RecvTimeoutCount = 0,
			RecvTimerRef = erlang:send_after(OptionsModule:get_tcp_recv_timeout(), self(), recv_time_out),

			%%和服务器连接成功
			{ok, {IP, ConnectedPort}} = inet:peername(Socket),
			SocketHandlerModule = ConfigBehavior:get_socket_handler_module(),
			SocketHandlerModule:on_server_connected(Socket, IP, ConnectedPort),

			{noreply, State#socket_info_record{
				socket = Socket, server_ip = Ip, server_port = ConnectedPort,
				recv_timer_ref = RecvTimerRef, recv_timeout_count = RecvTimeoutCount}
			};
		{error, Reason} ->
			{stop, Reason, State}

	end;

handle_info(recv_time_out, #socket_info_record{config_behavior = ConfigBehavior, recv_timer_ref = RecvTimerRef, recv_timeout_count = RecvTimeoutCount} = State) ->
	OptionsModule = ConfigBehavior:get_socket_options_module(),

	NewRecvTimeoutCount = RecvTimeoutCount + 1,
	RecvTimeOutLimit = OptionsModule:get_tcp_recv_timeout_count(),

	%% 超过最大限制
	if	NewRecvTimeoutCount >= RecvTimeOutLimit ->
			erlang:cancel_timer(RecvTimerRef),
			{stop, recv_timeout, State#socket_info_record{recv_timeout_count = NewRecvTimeoutCount}};
		true ->
			erlang:cancel_timer(RecvTimerRef),
			NewRecvTimerRef = erlang:send_after(OptionsModule:get_tcp_recv_timeout(), self(), recv_time_out),
			{noreply, State#socket_info_record{recv_timeout_count = NewRecvTimeoutCount, recv_timer_ref = NewRecvTimerRef}}
	end;

handle_info({delay, Module, CallBack, Args}, State) ->
	Module:CallBack(Args),
	{noreply, State};

handle_info(_Info, StateData) ->
	{noreply, StateData}.

terminate(_Reason, #socket_info_record{socket = Socket}) ->
	io:format("socket process terminated~n"),
	(catch gen_tcp:close(Socket)),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.