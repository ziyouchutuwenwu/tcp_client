-module(tcp_client_send).

%% API
-export([send_data_by_pid/3, send_data_by_socket/4]).

send_data_by_socket(Socket, Cmd, InfoBin, ConfigBehavior) ->
  SocketPackModule = ConfigBehavior:get_socket_package_module(),
  DataBin = SocketPackModule:pack(Cmd, InfoBin),

  SocketCodecModule = ConfigBehavior:get_socket_codec_module(),
  Data = SocketCodecModule:encode(DataBin),

  gen_tcp:send(Socket, Data),
  ok.

send_data_by_pid(Pid, Cmd, JsonBin) ->
  case erlang:is_pid(Pid) of
    true ->
      gen_server:cast(Pid, {send_socket_msg, Cmd, JsonBin});
    false ->
      io:format("socket pid invalid, ignore~n")
  end.