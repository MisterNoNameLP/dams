return function(requestData, noError)

    --[[if type(requestData) == "table" and requestData.headers and requestData.headers[":authority"] and requestData.headers[":path"] then
        return requestData.headers[":authority"].value .. requestData.headers[":path"].value
        ]]

    if type(requestData) == "table" and requestData.headers and requestData.headers["referer"] then
        return requestData.headers["referer"].value
    elseif noError then
        return false, "Can not find necessary headers in requestData."
    else
        error("Can not find necessary headers in requestData.", 2)
    end
end