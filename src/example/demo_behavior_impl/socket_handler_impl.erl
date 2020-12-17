-module(socket_handler_impl).

-behaviour(socket_handler_behavior).

-export([on_server_connected/3, on_server_data/3, on_disconnected/2]).

on_server_connected(Socket, IP, Port) ->
    io:format("连接服务器~p:~p成功~n",[IP, Port]),
    socket_client_demo:send(Socket),
    noreplay.

on_server_data(_Socket, Cmd, InfoBin) ->
    io:format("收到服务器数据~p ~p~n",[Cmd, InfoBin]),
    noreplay.

on_disconnected(IP, Port) ->
    io:format("服务器~p:~p断开连接~n",[IP, Port]),
    noreplay.