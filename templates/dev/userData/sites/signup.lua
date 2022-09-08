local body = env.dyn.html.Body.new()

body:addHeader(3, "Signup")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "signup"},
    {"input", target = "username", name = "Username:", value = ""},
    {"input", target = "password", name = "Password:", type = "password", value = ""},
    {"input", target = "password2", name = "Repeate password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Signup"},
})


return body:generateCode()