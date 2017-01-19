-module(tcp_client_options_impl).

-behavior(tcp_client_options_behavior).
-export([get_tcp_options/0, get_active_count/0]).
-export([get_tcp_recv_timeout/0, get_tcp_conn_timeout/0, get_tcp_recv_timeout_count/0]).

get_tcp_options() ->
	[
		{active, false},

		binary,
		{packet, 2},

		{nodelay, true},
		{send_timeout, 50 * 1000},
		{send_timeout_close, true},

		{reuseaddr, true},
		{keepalive, true},
		{packet_size, 4096}
	].

get_active_count() ->
	50.


%% 50秒超时
get_tcp_recv_timeout() ->
	5 * 1000.

%% 允许超时多少次
get_tcp_recv_timeout_count() ->
	2.

get_tcp_conn_timeout() ->
	3600 * 1000.
