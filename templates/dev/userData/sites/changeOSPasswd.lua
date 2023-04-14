local body = env.dyn.html.Body.new()

body:addHeader(3, "Change password")
body:addP("Here you can change your password.")
body:addP("Tip: do never use the same passwoed for multiple services.")

body:addAction("", "POST", {
    {"hidden", target = "action", value = "changeOSPasswd"},
    {"input", name = "Username:", target = "username", value = "testuser"},
    {"input", type = "password", name = "Current password:", target = "currentPasswd"},
    {"input", type = "password", name = "New password:", target = "newPasswd1"},
    {"input", type = "password", name = "Repeat password:", target = "newPasswd2"},
    {"submit", value = "Change password"},
})

return body:generateCode()