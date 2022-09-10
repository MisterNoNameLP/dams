local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local body = env.dyn.html.Body.new()

body:addHeader(3, "Dashboard")
body:addP("Welcome back " .. user:getName())

body:addRefButton("Auth tokens", "authTokens")
body:addP("")
body:addRefButton("Change username", "changeUsername")
body:addP("")
body:addRefButton("Change password", "changePassword")
body:addP("")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "logout"},
    {"button", type = "submit", value = "Logout"},
})

return body:generateCode()