return function(requestData, noError)
    if type(requestData) == "table" and requestData.headers then
        if requestData.headers["proxy-authority"] then
            return requestData.headers["proxy-authority"].value
        elseif requestData.headers[":authority"] then
            return requestData.headers[":authority"].value
        end
    end

    -- in case nothing can be returned
    if noError then
        return false, "Can not find necessary headers in requestData."
    else
        error("Can not find necessary headers in requestData.", 2)
    end
end