return function(site, requestData)
    local sitePath = site
    local siteFunc
    local suc, err, headers
    local returnValue

    if site == "/" then
        sitePath = "_root"
    end
    sitePath = "userData/sites/" .. sitePath .. ".lua" --completing sitePath

    if _M._I.lib.lfs.attributes("data/" .. sitePath) ~= nil then
        siteFunc, err = _M._I.getActionFunc("data/" .. sitePath)

        if type(siteFunc) ~= "function" then
            debug.err("Cant execute site: " .. site .. "\n" .. err)
            suc = false
        else
            suc, err, headers = xpcall(siteFunc, debug.traceback, requestData)
        end

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
        warn("Someone (" .. tostring(requestData.meta.realIP) .. ") tryed to access non existing site: '" .. site .. "'")
        returnValue = "Error 404\nSite not found"
        headers = {[":status"] = 404}
    end

    return suc, returnValue, headers
end