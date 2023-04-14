local env, args = ...
local username, password = args[1], args[2]


log(env.dyn.User.create(username, password))