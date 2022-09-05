-module(tcp_client).

-export([batch_connect/5]).

batch_connect(Host, Port, TcpOptions, ConfigBehaviorImpl, Numbers) ->
  tcp_msg_handler_sup:start_link(),
    IndexList = lists:seq(1, Numbers),
      lists:foreach(
        fun(Index) ->
          tcp_msg_handler_sup:start_child(Host, Port, TcpOptions, ConfigBehaviorImpl, Index)
        end,
        IndexList
      ).