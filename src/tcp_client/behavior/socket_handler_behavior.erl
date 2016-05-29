-module(socket_handler_behavior).

-callback on_server_connected(IP :: atom()) ->
    noreplay.

-callback on_server_data(Cmd :: integer(), InfoBin :: any()) ->
    noreplay.

-callback on_disconnected(IP :: atom()) ->
    noreplay.