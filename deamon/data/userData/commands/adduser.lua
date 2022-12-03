local _M, args = ...
local username, password = args[1], args[2]


log(_M.dyn.User.create(username, password))