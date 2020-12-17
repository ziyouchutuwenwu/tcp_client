-module(on_app_start).

-export([main/1]).

main(Args) ->
  io:format("~n"),
  io:format("*********************************************************~n"),
  io:format("on app start~n"),
  io:format("*********************************************************~n"),
  io:format("~n").