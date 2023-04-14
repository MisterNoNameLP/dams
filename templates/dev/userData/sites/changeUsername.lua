local session, user = _I.loginRequired(requestData)
if session == false then
    return user
end

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
body:addHeader(1, "Change username")
body:addAction("", "POST", {
    {"hidden", target = "action", value = "changeUsername"},
    {"input", target = "username", name = "New username:", value = ""},
    {"input", target = "password", name = "Password:", type = "password", value = ""},
    {"button", type = "supmit", value = "Submit"},
})
body:addRaw([[</div>]])

return body:generateCode()