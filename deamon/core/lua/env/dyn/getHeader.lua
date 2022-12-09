return function(requestData, name)
    local headers
    if requestData.headers ~= nil then
        headers = requestData.headers
    else
        headers = requestData
    end
    if headers[name] ~= nil then
        return headers[name].value
    else
        return false
    end
end