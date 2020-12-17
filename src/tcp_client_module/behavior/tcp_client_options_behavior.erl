-module(tcp_client_options_behavior).

-callback get_tcp_options() ->
	Options :: list().

-callback get_active_count() ->
	Count :: integer().

%% 收包超时
-callback get_tcp_recv_timeout() ->
	RecvTimeOut :: timeout().

%% 允许超时多少次
-callback get_tcp_recv_timeout_count() ->
	TimeOutCount :: integer().

%% 连接超时
-callback get_tcp_conn_timeout() ->
	ConnectingTimeOut :: integer().