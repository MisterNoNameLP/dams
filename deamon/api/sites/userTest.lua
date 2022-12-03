local requestData = ...
local responseHeaders = {}

local User = _I.User

local user = User.new("test")

log("Change username: ", user:setName("test"))

log("Change passwd: ", user:setPasswd("1233"))
log("Passwd: ", user:checkPasswd("1233"))

log("Set perm: ", user:setPerm("test_perm3", 7))
log("Perm: ", user:getPerm("test_perm3"))
log("Del perm: ", user:delPerm("test_perm3"))
log("Perm: ", user:getPerm("test_perm3"))

log("Perm: ", user:getPerm("test_perm"))

log("Cookie raw: ", requestData.headers.cookie.value)
log("Cookie: ", debug.tostring(_I.getCookies(requestData)))

responseHeaders = {
    --["set-cookie"] = "test name=tv rrr; HttpOnly",
}

log(_I.cookie.current.test)

_I.cookie.new.test = "t1_4"

return "User test", responseHeaders