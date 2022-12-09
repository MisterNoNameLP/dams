return function(path) --generates avtion/site functions.
    local fileCode = _M._I.lib.ut.readFile(path)
    local tracebackPathNote = path
    local actionFunc

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "api")) + 2)

    do 	
        local suc, conf, newFileCode = _I.dl.preparse(fileCode)
        if not suc then
            err("Preparsing script failed: " .. tracebackPathNote .. "; error: " .. conf)
        else
            fileCode = newFileCode
        end
    end

    print(fileCode)

    if not fileCode then
        return false, "File not found: " .. tracebackPathNote 
    end

    fileCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _I, _E, _S, requestData, request, header, cookie, Session, response, body = _M._I, _M._E, _M._I.shared, args[1], args[1].request, args[1].headers, _M._I.cookie, _M._I.Session, {html = {}, error = {}}, _M._I.html.Body.new(); " .. fileCode
    
    return load(fileCode)
end