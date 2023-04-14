local body = _I.html.Body.new()

body:addRaw([[
<style>
    div {
        margin: 5px 0;
        text-align: center;
    }
</style>
]])


body:addRaw([[<div>]])
body:addHeader(1, "Login")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "login"},
    {"input", target = "username", name = "Username:", value = ""},
    {"input", target = "password", name = "Password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Login"},
})

body:addP("")
body:addRefButton("Sign up", "signup")
body:addRaw([[</div>]])

return body:generateCode()