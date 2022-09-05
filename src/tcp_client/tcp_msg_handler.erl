-module(tcp_msg_handler).

-export([start_link/5, loop/3, connect/5]).

start_link(Host, Port, TcpOptions, ConfigBehaviorImpl, ClientId) ->
    Pid = spawn_link(?MODULE,
                     connect,
                     [Host, Port, TcpOptions, ConfigBehaviorImpl, ClientId]),
    {ok, Pid}.

connect(Host, Port, TcpOptions, ConfigBehaviorImpl, ClientId) ->
    case gen_tcp:connect(Host, Port, TcpOptions, 6000) of
        {ok, Sock} ->
            {ok, {ServerIp, ServerPort}} = inet:peername(Sock),
            IpStr = inet:ntoa(ServerIp),
            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
            SocketHandlerModule:on_server_connected(Sock, IpStr, ServerPort),
            loop(Sock, ConfigBehaviorImpl, ClientId);
        {error, Reason} ->
            io:format("connect error: ~p~n", [Reason])
    end.

loop(Sock, ConfigBehaviorImpl, ClientId) ->
    receive
        {tcp, _Sock, Data} ->
            SocketUnpackModule = ConfigBehaviorImpl:get_socket_package_module(),
            {Cmd, InfoBin} = SocketUnpackModule:unpack(Data),

            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
            SocketHandlerModule:on_server_data(Sock, Cmd, InfoBin),

            loop(Sock, ConfigBehaviorImpl, ClientId);
        {tcp_closed, _Sock} ->
            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
            SocketHandlerModule:on_disconnected(Sock, "tcp_closed");
        {tcp_error, _Sock, Reason} ->
            SocketHandlerModule = ConfigBehaviorImpl:get_socket_handler_module(),
            SocketHandlerModule:on_disconnected(Sock, Reason);
        Other ->
            io:format("connection ~w unexpected: ~p", [ClientId, Other])
    end.
