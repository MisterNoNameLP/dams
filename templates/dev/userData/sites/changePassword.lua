local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local body = env.dyn.html.Body.new()

body:addHeader(3, "Change password")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "changePassword"},
    {"input", target = "currentPassword", name = "Current password:", type = "password", value = ""},
    {"input", target = "newPassword", name = "New password:", type = "password", value = ""},
    {"input", target = "newPassword2", name = "Repeate password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Submit"},
})

return body:generateCode()