local _M, args = ...


_M._I.commands.rlenv(_M, {}, {})



local user, reason = _M._I.User.new(1)
print(_M._I.lib.ut.tostring(user), reason)

print(user:checkPassword("123"))

--print(_M._I.User.checkPassword({id=1}, "123"))

--tret

--print(getUserIDByName(args[1]))
--print(login(args[1], args[2]))