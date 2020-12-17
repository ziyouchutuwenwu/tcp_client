-module(tcp_client_handler_sup).
-behaviour(supervisor).

-export([start_link/3, start_child/1]).
-export([init/1]).

start_link(Name, {Ip, Port}, ConfigBehavior) ->
	LocalModuleName = safe_atom:list_to_atom(Name ++ "_" ++ ?MODULE_STRING),
	supervisor:start_link({local, LocalModuleName}, ?MODULE, [{Ip, Port}, ConfigBehavior]).

start_child(Name) ->
	LocalModuleName = safe_atom:list_to_atom(Name ++ "_" ++ ?MODULE_STRING),
	supervisor:start_child(LocalModuleName, []).

init([{Ip, Port}, ConfigBehavior]) ->

	RestartMode = simple_one_for_one,
	MaxRestarts = 0,
	MaxSecondsBetweenRestarts = 1,

	RestartStrategy = {RestartMode, MaxRestarts, MaxSecondsBetweenRestarts},

	Restart = temporary,
	Shutdown = brutal_kill,
	Type = worker,

	Child = {
		tcp_client_handler,
		{tcp_client_handler, start_link, [{Ip, Port}, ConfigBehavior]},
		Restart, Shutdown, Type,
		[tcp_client_handler]
	},

	Children = [Child],
	{ok, {RestartStrategy, Children}}.