-module(tcp_client).

-export([start/4, stop/1]).

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