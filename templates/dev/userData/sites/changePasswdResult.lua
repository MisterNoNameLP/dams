local requestData = ...

local body = env.dyn.html.Body.new()

if requestData.exitCode == 0 then
    body:addHeader(3, "Password changed successfully!")
    body:goTo("/", 3)
else
    body:addHeader(3, "Password not changed!")
    
    if requestData.exitCode >= 1 and requestData.exitCode <= 3 then
        body:addP(requestData.error)
    else
        body:addP(requestData.error)
        body:addP("Error code: " .. tostring(requestData.exitCode))
    end
    body:addGoBackButton(requestData, "Try again")
end

return body:generateCode()