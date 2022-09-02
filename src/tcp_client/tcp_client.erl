-module(tcp_client).

-export([batch_connect/5]).

batch_connect(Host, Port, TcpOptions, ConfigBehaviorImpl, Numbers) ->
    IndexList = lists:seq(1, Numbers),
      lists:foreach(
        fun(Index) ->
          spawn_link(msg_handler, connect, [Host, Port, TcpOptions, ConfigBehaviorImpl, Index])
        end,
        IndexList
      ).