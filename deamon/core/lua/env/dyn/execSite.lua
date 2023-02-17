return function(site, requestData)
    local sitePath = site
    local siteFunc
    local suc, err, headers
    local returnValue

    if site == "/" then
        sitePath = "_root"
    end
    sitePath = "api/sites/" .. sitePath --completing sitePath
    siteFunc, err = _M._I.getActionFunc(sitePath)

    if siteFunc == 1 then
        warn("Someone (" .. tostring(requestData.meta.realIP) .. ") tryed to access non existing site: '" .. site .. "'")
        returnValue = "Error 404\nSite not found"
        headers = {[":status"] = 404}
    elseif siteFunc == 2 then
        debug.err("Requestet site exists multiple times: " .. site)
        returnValue = "Error: -405\nSite exists multiple times. Pleas contact an admin."
        headers = {[":status"] = 500}
    elseif type(siteFunc) == "function" then
        suc, err, headers = xpcall(siteFunc, debug.traceback, requestData)

        if suc ~= true then
            debug.err("Site execution failed")
            debug.err(suc, err)
            returnValue = [[
Site script crashed. Please contact a system administrator.
Stack traceback:
]] .. err
        else
            if err == nil then
                err = ""
            end
            returnValue = err
        end
    else
        debug.err("Cant execute site: " .. site .. "\n" .. err)
        suc = false
        returnValue = err
    end

    return suc, returnValue, headers
end