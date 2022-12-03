local responseData = ...

if responseData.returnValue and responseData.returnValue.html then
    responseData.returnValue.html = nil
end

return _M._I.lib.ut.tostring(responseData)