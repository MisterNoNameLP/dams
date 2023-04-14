local body = env.dyn.html.Body.new()

body:addHeader(3, "Login failed")
body:addP("Reason: " .. tostring(requestData.reason))
body:addP("Error: " .. tostring(requestData.error))
body:addRefButton("Try again", "login")

return body:generateCode()