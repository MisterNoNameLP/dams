local body = _I.html.Body.new()

body:addAction("", "POST", {
    {"hidden", target = "action", value = "errorTest"},
    {"submit", value = "test"}
})


return body:generateCode()