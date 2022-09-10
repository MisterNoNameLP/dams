local body = env.dyn.html.Body.new()

body:addHeader(3, "Login")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "login"},
    {"input", target = "username", name = "Username:", value = ""},
    {"input", target = "password", name = "Password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Login"},
})

body:addP("")
body:addRefButton("Sign up", "signup")

return body:generateCode()