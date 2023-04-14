local body = env.dyn.html.Body.new()

body:addHeader(3, "Signup failed")
body:addP("Reason: " .. tostring(requestData.reason))
body:addP("Error: " .. tostring(requestData.error))
body:addRefButton("Try again", "changeUsername")

return body:generateCode()