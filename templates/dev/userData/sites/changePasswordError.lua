local body = env.dyn.html.Body.new()

body:addHeader(3, "Changing password failed")
body:addP("Reason: " .. tostring(requestData.reason))
body:addP("Error: " .. tostring(requestData.error))
body:addRefButton("Try again", "changePassword")

return body:generateCode()