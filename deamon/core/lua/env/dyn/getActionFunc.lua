return function(path) --generates avtion/site functions.
    local fileCode
    local tracebackPathNote = path
    local actionFunc

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "api")) + 2)

    if select(3, _I.ut.seperatePath(path)) then
        fileCode = _I.lib.ut.readFile(path)
    elseif _I.lib.lfs.attributes(path .. ".lua") then
        fileCode = _I.lib.ut.readFile(path .. ".lua")
    elseif _I.lib.lfs.attributes(path .. ".pleal") then
        fileCode = select(3, _I.lib.pleal.transpileFile(path .. ".pleal"))
    end

    if not fileCode then
        return false, "File not found: " .. tracebackPathNote 
    end

    if select(3, _I.ut.seperatePath(path)) == ".pleal" then
        local suc, conf, newFileCode = _I.lib.pleal.transpile(fileCode)

        if not suc then
            err("Preparsing script failed: " .. tracebackPathNote .. "; error: " .. conf)
        else
            fileCode = newFileCode
        end
    end

    --log(fileCode)

    fileCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _I, _E, _S, _DB, requestData, request, header, cookie, Session, response, body = _M._I, _M._E, _M._I.shared, _M._DB, args[1], args[1].request, args[1].headers, _M._I.cookie, _M._I.Session, {html = {}, error = {}}, _M._I.html.Body.new(); do " .. fileCode .. " end return response"
    
    return load(fileCode)
end