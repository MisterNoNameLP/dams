local _M, args = ...


_M.commands.rlenv(_M, {}, {})



local user, reason = _M.dyn.User.new(1)
print(_M.lib.ut.tostring(user), reason)

print(user:checkPassword("123"))

--print(_M.dyn.User.checkPassword({id=1}, "123"))

--tret

--print(getUserIDByName(args[1]))
--print(login(args[1], args[2]))