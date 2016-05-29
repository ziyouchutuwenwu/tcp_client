-module(socket_client_test).

-export([start/0]).

start()->
    tcp_client:start("robot",{"127.0.0.1",9999}, 2,my_socket_behavior_config_impl).