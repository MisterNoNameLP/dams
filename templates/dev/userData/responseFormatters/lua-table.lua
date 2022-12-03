local responseData = ...

if responseData.returnValue and responseData.returnValue.html then
    responseData.returnValue.html = nil
end

local returnString = _M._I.lib.serialization.dump(responseData)

if type(returnString) == "string" then
    return returnString
else
    return returnString
end