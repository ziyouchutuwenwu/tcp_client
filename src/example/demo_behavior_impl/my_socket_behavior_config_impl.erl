-module(my_socket_behavior_config_impl).

-export([get_socket_handler_module/0, get_socket_codec_module/0, get_socket_package_module/0, get_socket_options_module/0]).

get_socket_handler_module() ->
	socket_handler_impl.

get_socket_codec_module() ->
	socket_codec_impl.

%% 业务级别拆包
get_socket_package_module() ->
	socket_package_impl.

get_socket_options_module() ->
	tcp_client_options_impl.