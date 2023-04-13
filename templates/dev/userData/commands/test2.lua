local _M, args = ...

--===== test start =====--
print(_M._I.setPermission(1, "test_perm2", 5))

print(_M._I.getPermissionLevel(1, "test_perm2"))