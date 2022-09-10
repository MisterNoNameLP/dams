local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local body = env.dyn.html.Body.new()

body:addHeader(3, "Change username")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "changeUsername"},
    {"input", target = "username", name = "New username:", value = ""},
    {"input", target = "password", name = "Password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Submit"},
})

return body:generateCode()