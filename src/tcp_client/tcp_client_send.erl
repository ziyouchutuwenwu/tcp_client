-module(tcp_client_send).

-export([send_data_by_socket/4]).

send_data_by_socket(Socket, Cmd, InfoBin, ConfigBehaviorImpl) ->
  SocketPackModule = ConfigBehaviorImpl:get_socket_package_module(),
  Data = SocketPackModule:pack(Cmd, InfoBin),
  gen_tcp:send(Socket, Data),
  ok.