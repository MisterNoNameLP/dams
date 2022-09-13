local body = env.dyn.html.Body.new()

body:addRaw([[
<style>
    div {
        margin: 5px 0;
        text-align: center;
    }
</style>
]])

body:addRaw([[<div>]])
body:addHeader(1, "Signup")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "signup"},
    {"input", target = "username", name = "Username:", value = ""},
    {"input", target = "password", name = "Password:", type = "password", value = ""},
    {"input", target = "password2", name = "Repeate password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Signup"},
})
body:addRaw([[</div>]])


return body:generateCode()