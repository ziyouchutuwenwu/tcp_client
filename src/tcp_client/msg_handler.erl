-module(msg_handler).

-export([loop/3, connect/5]).

connect(Host, Port, TcpOptions, ConfigBehaviorImpl, ClientId) ->
    case gen_tcp:connect(Host, Port, TcpOptions, 6000) of
        {ok, Sock} ->
            {ok, {ServerIp, ServerPort}} = inet:peername(Sock),
            IpStr = inet:ntoa(ServerIp),

            % 连接回调
            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
            SocketHandlerModule:on_server_connected(Sock, IpStr, ServerPort),

            msg_handler:loop(Sock, ConfigBehaviorImpl, ClientId);
        {error, Reason} ->
            io:format("connect error: ~p~n", [Reason])
    end.

loop(Sock, ConfigBehaviorImpl, ClientId) ->
    % Timeout = 500000 + rand:uniform(5000),
    receive
        {tcp, Sock, Data} ->
            SocketUnpackModule = ConfigBehaviorImpl:get_socket_package_module(),
			{Cmd, InfoBin} = SocketUnpackModule:unpack(Data),

			SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
			SocketHandlerModule:on_server_data(Sock, Cmd, InfoBin),

            loop(Sock, ConfigBehaviorImpl, ClientId);
        {tcp_closed, Sock} ->
            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
			SocketHandlerModule:on_disconnected(Sock, "tcp_closed");
        {tcp_error, Sock, Reason} ->
            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
			SocketHandlerModule:on_disconnected(Sock, Reason);
        Other ->
            io:format("connection ~w unexpected: ~p", [ClientId, Other])
    % after
    %     Timeout ->
    %       io:format("timeout~n")
    %         % _ = send(Num, Sock), loop(Num, Sock)
    end.