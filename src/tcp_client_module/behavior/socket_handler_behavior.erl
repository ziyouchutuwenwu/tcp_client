-module(socket_handler_behavior).

-callback on_server_connected(Socket :: port(), IP :: atom(), Port :: integer()) ->
    noreplay.

-callback on_server_data(Socket :: port(), Cmd :: integer(), InfoBin :: any()) ->
    noreplay.

-callback on_disconnected(IP :: atom(), Port :: integer()) ->
    noreplay.