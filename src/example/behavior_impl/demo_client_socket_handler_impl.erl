-module(demo_client_socket_handler_impl).

-behaviour(tcp_client_socket_handler_behavior).

-export([on_server_connected/3, on_server_data/3, on_disconnected/2]).

on_server_connected(Socket, IP, Port) ->
  io:format("连接服务器 ~ts:~p 成功~n", [IP, Port]),
  tcp_client_demo:send_by_socket(Socket),
  noreplay.

on_server_data(_Socket, Cmd, InfoBin) ->
  Info = utf8_list:binary_to_list(InfoBin),
  io:format("收到服务器数据 ~p ~ts~n", [Cmd, Info]),
  noreplay.

on_disconnected(Socket, Reason) ->
  io:format("服务器 ~p 由于 ~s 断开连接~n", [Socket, Reason]),
  noreplay.