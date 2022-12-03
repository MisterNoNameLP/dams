return function(path) --generates avtion/site functions.
    local siteCode = _M.lib.ut.readFile(path)
    local tracebackPathNote = path

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "userData")) + 2)

    if not siteCode then
        return false, "File not found: " .. tracebackPathNote 
    end

    siteCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _E, _D, _S, requestData, request, header, cookie, Session, response, body = _M, _M.dyn, _M.shared, args[1], args[1].request, args[1].headers, _M.cookie, _M.dyn.Session, {html = {}, error = {}}, _M.dyn.html.Body.new(); " .. siteCode
    
    return load(siteCode)
end