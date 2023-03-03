--[[loads a lua/pleal file and prepares it for internal use.
    reutrns: returnCode, function or nil, error

    returnCodes:
        0 == anything worked fine
        1 == invalid path given
        2 == could not find file
        3 == could not load fileCode
        4 == a pleal as well as a lua script with the same name is present
        5 == unsupported file type
]]

return function(givenPath)
    local fileCode
    local tracebackPathNote = givenPath
    local scriptFunc, scriptFuncLoadingError
    local path, file, ending = _I.ut.seperatePath(givenPath)
    local fullPath

    if not file then
        return 1, "Invalid path given: " .. givenPath
    end

    tracebackPathNote = string.sub(tracebackPathNote, select(2, string.find(tracebackPathNote, "api")) + 2)

    --dlog(givenPath)
    --dlog(path .. file .. ending)

    if not ending then
        if _I.lib.lfs.attributes(path .. file .. ".lua") then
            if ending then
                return 4, "The requestet script exists multiple times. Refusing to execute to prevent unexpected behaviour."
            end
            ending = ".lua"
        end
        if _I.lib.lfs.attributes(path .. file .. ".pleal") then
            if ending then
                return 4, "The requestet script exists multiple times. Refusing to execute to prevent unexpected behaviour."
            end
            ending = ".pleal"
        end
    end
    if not ending then
        return 2, "File not found: " .. tracebackPathNote 
    end
    fullPath = path .. file .. ending

    if ending ~= ".lua" and ending ~= ".pleal" then
        return 5, "Unsupported file type: " .. ending
    end

    fileCode = _I.lib.ut.readFile(fullPath)

    if ending == ".pleal" then
        local suc, conf, newFileCode = _I.lib.pleal.transpile(fileCode)
        if not suc then
            err("Transpiling pleal script failed: " .. tracebackPathNote .. "; error: " .. conf)
        else
            fileCode = newFileCode
        end
    end

    --log(fileCode)

    fileCode = "--[[" .. tracebackPathNote .. "]] local args = {...}; local _I, _E, _S, _DB, requestData, request, header, cookie, Session, response, body = _M._I, _M._E, _M._I.shared, _M._DB, args[1], args[1].request, args[1].headers, _M._I.cookie, _M._I.Session, {html = {}, error = {}}, _M._I.html.Body.new(); do " .. fileCode .. "\n end return response"

    scriptFunc, scriptFuncLoadingError = load(fileCode)
    
    if scriptFunc then
        return 0, scriptFunc
    else
        return 3, scriptFuncLoadingError
    end
end