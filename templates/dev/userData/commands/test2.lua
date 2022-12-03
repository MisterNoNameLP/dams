local _M, args = ...

--===== test start =====--
print(_M.setPermission(1, "test_perm2", 5))

print(_M.getPermissionLevel(1, "test_perm2"))