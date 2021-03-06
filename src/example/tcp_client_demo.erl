-module(tcp_client_demo).

-export([start/0, send_by_socket/1, send_by_pid/1]).

start() ->
  ClientNumber = 1,
  tcp_client:start("demo_name", {"127.0.0.1", 9999}, ClientNumber, demo_client_socket_behavior_config_impl).

send_by_socket(Socket) ->
  tcp_client_send:send_data_by_socket(Socket, 111, <<"msg send by socket">>, demo_client_socket_behavior_config_impl).

send_by_pid(Pid) ->
  tcp_client_send:send_data_by_pid(Pid, 111, <<"msg send by pid">>).
