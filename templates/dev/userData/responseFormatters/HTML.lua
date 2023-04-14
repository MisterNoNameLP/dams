local responseData, headers, requestData = ...

debug.setFuncPrefix("[HTML_RESPONSE_FORMATTER]", true)

local responseString
local body = env.dyn.html.Body.new()

if responseData.success then
    responseData.returnValue.headers = headers
    if responseData.returnValue.html then
        if responseData.returnValue.html.forwardInternal then
            responseData.returnValue.meta = requestData.meta
            responseData.returnValue.request = responseData.returnValue
            _, responseString = env.dyn.execSite(responseData.returnValue.html.forwardInternal, responseData.returnValue)
        elseif responseData.returnValue.html.forward then
                local body = env.dyn.html.Body.new()
                body:goTo(responseData.returnValue.html.forward)
                responseString = body:generateCode()
        elseif responseData.returnValue.html.body then
            responseString = responseData.returnValue.html.body
        end
    end
else
    body:addHeader(3, "Something went wrong!")
    body:addHeader(3, "Please contact an administrator.")
    body:addP("Error code: " .. tostring(responseData.errorCode))
    body:addP("Error message: " .. tostring(responseData.error))

    body:addRaw('<span style="white-space: pre-line">')
    body:addP("Script error: " .. tostring(responseData.scriptError))
    body:addRaw('</span>')

    responseString = body:generateCode()
end

if type(responseString) ~= "string" then
    debug.err("Could not create response string.\nresponseData:\n" .. env.lib.ut.tostring(responseData))
    responseData.returnValue.headers = nil
    responseString = "Can not create propper response. Maybe this function is not supposed to be used in a browser. Please contact an admin.\nfull return table:\n" .. env.lib.ut.tostring(responseData.returnValue)
end

return responseString