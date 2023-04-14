<<<<<<< HEAD
local requestData = ...

local body = _I.html.Body.new()

body:addHeader(2, "DAMS dev main page")

body:addRefButton("login", "/login")
body:addP("")
body:addRefButton("signup", "/signup")
body:addP("")
body:addRefButton("test", "/test")
body:addP("")
body:addRefButton("test2", "/test2")
body:addP("")
body:addRefButton("CMS test 1", "/cmsTest")
body:addP("")
body:addRefButton("Change OS Password", "/changeOSPasswd")
body:addP("")
body:addAction("TEST", "POST", {{"submit", name = "dumpRequest"}, {"hidden", name="action", value="dumpRequest"}})
=======
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
>>>>>>> b29c425b93f20094192a84d87a50c60e69b33d9e

return body:generateCode()