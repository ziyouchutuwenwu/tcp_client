-module(socket_client_demo).

-export([start/0, send/1]).

start()->
    tcp_client:start("robot", {"192.168.88.234",9999}, 2, my_socket_behavior_config_impl).

%% 需要的时候，手动在 on_server_connected 的实现 里面调用
send(Socket)->
    tcp_client:send_socket_msg(Socket, 111, <<"this is info">>, my_socket_behavior_config_impl).