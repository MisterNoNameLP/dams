local _M, args = ...
local username, password = args[1], args[2]


log(_M._I.dyn.User.create(username, password))