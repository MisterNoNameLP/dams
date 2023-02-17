--loads a lua/pleal file and prepares it for dams internal use.

--[[return codes
    nil == could not load fileCode
    1 == could not find file
    2 == a pleal as well as a lua script with the same name is present
]]

return function(givenPath) --generates action/site functions.
    local fileCode
    local tracebackPathNote = givenPath
    local actionFunc
    local path, file, ending = _I.ut.seperatePath(givenPath)
    local fullPath

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "api")) + 2)

    --dlog(givenPath)
    --dlog(path .. file .. ending)

    if not ending then
        if _I.lib.lfs.attributes(path .. file .. ".lua") then
            ending = ".lua"
        end
        if _I.lib.lfs.attributes(path .. file .. ".pleal") then
            if ending then
                return 2, "The requestet action exists multiple times. Refusing to execute to prevent unexpected behaviour."
            end
            ending = ".pleal"
        end
    end
    if not ending then
        return 1, "File not found: " .. tracebackPathNote 
    end
    fullPath = path .. file .. ending

    if ending == ".lua" then
        fileCode = _I.lib.ut.readFile(fullPath)
    elseif ending == ".pleal" then
        fileCode = select(3, _I.lib.pleal.transpileFile(fullPath))
    end

    if ending == ".pleal" then
        local suc, conf, newFileCode = _I.lib.pleal.transpile(fileCode)
        if not suc then
            err("Transpiling pleal script failed: " .. tracebackPathNote .. "; error: " .. conf)
        else
            fileCode = newFileCode
        end
    end

    --log(fileCode)

    fileCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _I, _E, _S, _DB, requestData, request, header, cookie, Session, response, body = _M._I, _M._E, _M._I.shared, _M._DB, args[1], args[1].request, args[1].headers, _M._I.cookie, _M._I.Session, {html = {}, error = {}}, _M._I.html.Body.new(); do " .. fileCode .. " end return response"
    
    return load(fileCode)
end