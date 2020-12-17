-module(tcp_client).

-export([start/4, stop/1, send_socket_msg/4]).

start(Name, {Ip, Port}, ClientNumber, ConfigBehavior) ->
  case tcp_client_handler_sup:start_link(Name, {Ip, Port}, ConfigBehavior) of
    {ok, Pid} ->
      IndexList = lists:seq(1, ClientNumber),
      lists:foreach(
        fun(_Index) ->
          tcp_client_handler_sup:start_child(Name)
        end,
        IndexList
      ),
      {ok, Pid};
    _ ->
      {error, failed}
  end.

stop(_S) ->
  ok.

send_socket_msg(Socket, Cmd, InfoBin, ConfigBehavior) ->
  SocketPackModule = ConfigBehavior:get_socket_package_module(),
  DataBin = SocketPackModule:pack(Cmd, InfoBin),

  SocketCodecModule = ConfigBehavior:get_socket_codec_module(),
  Data = SocketCodecModule:encode(DataBin),

  gen_tcp:send(Socket, Data).