return function(path) --generates avtion/site functions.
    local siteCode = _M._I.lib.ut.readFile(path)
    local tracebackPathNote = path

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "userData")) + 2)

    if not siteCode then
        return false, "File not found: " .. tracebackPathNote 
    end

    siteCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _I, _S, requestData, request, header, cookie, Session, response, body = _M._I, _M._I.shared, args[1], args[1].request, args[1].headers, _M._I.cookie, _M._I.Session, {html = {}, error = {}}, _M._I.html.Body.new(); " .. siteCode
    
    return load(siteCode)
end