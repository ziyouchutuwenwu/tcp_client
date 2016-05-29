-module(socket_handler_impl).

-behaviour(socket_handler_behavior).

-export([on_server_connected/1, on_server_data/2, on_disconnected/1]).

on_server_connected(IP) ->
    io:format("连接服务器~p成功~n",[IP]),
    noreplay.

on_server_data(Cmd, InfoBin) ->
    io:format("收到服务器数据~p ~p~n",[Cmd, InfoBin]),
    noreplay.

on_disconnected(IP) ->
    io:format("服务器~p断开连接~n",[IP]),
    noreplay.