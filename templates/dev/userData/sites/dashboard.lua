local body = env.dyn.html.Body.new()
local session = env.dyn.getSessionByRequestData(requestData)
local user

if session == false then
    return env.dyn.html.Body.new():goTo("login", 0)
end

user = log(env.dyn.User.new(session:getUserID()))

body:addHeader(3, "Dashboard")
body:addP("Welcome back " .. user:getName())

body:addAction("", "POST", {
    {"hidden", target = "action", value = "logout"},
    {"button", type = "submit", value = "Logout"},
})

return body:generateCode()