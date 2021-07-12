-module(on_app_start).

main(_Args) ->
  io:format("~n"),
  interprete_modules(),
  io:format("try tcp_client_demo:start().~n").

interprete_modules() ->
  int:ni(utf8_list),
  int:ni(data_format),
  int:ni(crypt),
  int:ni(safe_atom),
  int:ni(data_convert),
  int:ni(random_generator),
  int:ni(tcp_client),
  int:ni(demo_client_socket_codec_impl),
  int:ni(tcp_client_socket_codec_behavior),
  int:ni(demo_client_options_impl),
  int:ni(tcp_client_handler),
  int:ni(demo_client_socket_package_impl),
  int:ni(tcp_client_handler_sup),
  int:ni(tcp_client_options_behavior),
  int:ni(tcp_client_socket_package_behavior),
  int:ni(demo_client_socket_behavior_config_impl),
  int:ni(tcp_client_socket_handler_behavior),
  int:ni(tcp_client_send),
  int:ni(tcp_client_app),
  int:ni(tcp_client_sup),
  int:ni(demo_client_socket_handler_impl),
  int:ni(tcp_client_demo),

  io:format("输入 int:interpreted(). 或者 il(). 查看模块列表~n").