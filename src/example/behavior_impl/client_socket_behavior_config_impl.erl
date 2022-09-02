-module(client_socket_behavior_config_impl).

-export([get_socket_handler_module/0, get_socket_package_module/0, get_socket_options_module/0]).

get_socket_handler_module() ->
  demo_client_socket_handler_impl.

%% 业务级别拆包
get_socket_package_module() ->
  demo_client_socket_package_impl.

get_socket_options_module() ->
  demo_client_options_impl.