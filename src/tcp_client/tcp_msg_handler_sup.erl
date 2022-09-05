-module(tcp_msg_handler_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).
-export([start_child/5]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Host, Port, TcpOptions, ConfigBehaviorImpl, ClientId) ->
  supervisor:start_child(?MODULE, [Host, Port, TcpOptions, ConfigBehaviorImpl, ClientId]).

init([]) ->
  MaxRestarts = 5,
  MaxSecondsBetweenRestarts = 10,

  SupervisorFlags =
    #{strategy => simple_one_for_one,
      intensity => MaxRestarts,
      period => MaxSecondsBetweenRestarts},

  ChildSpec =
    #{id => tcp_msg_handler,
      start =>
        {tcp_msg_handler, start_link, []},
      restart => transient,
      shutdown => brutal_kill,
      type => worker,
      modules => [tcp_msg_handler]},

  Children = [ChildSpec],
  {ok, {SupervisorFlags, Children}}.
