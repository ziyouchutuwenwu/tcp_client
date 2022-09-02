-module(tcp_client_demo).

-export([start/0, tcp_opts/0, send_by_socket/1]).

tcp_opts() ->
    [binary, {packet, 2}].

start() ->
    tcp_client:batch_connect("127.0.0.1", 9999, tcp_opts(), client_socket_behavior_config_impl, 2).


send_by_socket(Socket) ->
  InfoBin = utf8_list:list_to_binary("这是客户端发的测试数据"),
  tcp_client_send:send_data_by_socket(Socket, 111, InfoBin, client_socket_behavior_config_impl).