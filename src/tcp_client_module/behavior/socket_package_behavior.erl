-module(socket_package_behavior).

%% 业务级别拆包
%% 把封包拆解为cmd和list，也就是json
-callback unpack(DataBytes :: any()) ->
    {Cmd :: integer(), Info :: list()}.

-callback pack(Cmd :: integer(), Info :: list()) ->
    DataBytes :: any().