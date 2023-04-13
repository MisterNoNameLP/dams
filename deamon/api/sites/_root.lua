local body = _I.html.Body.new()

local session, user = _I.loginRequired(requestData)
if session then
	return body:goTo("/dashboard")
end

body:addRaw([[
<style>
   div {
		margin: 5px 0;
		text-align: center;
	}
</style>
]])

body:addRaw([[<div>]])
body:addHeader(1, "Useful Little Web Interface")
body:addRefButton("login", "/login")
body:addP("")
body:addRefButton("signup", "/signup")

body:addRaw([[</div>]])

return body:generateCode()