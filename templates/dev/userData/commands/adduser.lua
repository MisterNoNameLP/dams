local _M, args = ...
local username, password = args[1], args[2]


log(_M._I.User.create(username, password))