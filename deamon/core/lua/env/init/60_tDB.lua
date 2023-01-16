local db = {}

log("=================")

local t = {}

local metatable = {
    __newindex = function(_, index, value)
        dlog("NEWINDEX", index, value)

        local varType = type(value)
        local newText = "do local _ = "

        if varType == "number" or varType == "table" then
            newText = newText .. _I.ut.tostring(value) 
        elseif varType == "string" then
            newText = newText .. "\"" .. _I.ut.tostring(value)  .. "\""
        else
            error("Invalid value type: " .. varType, 2)
        end
        newText = newText .. "; return _ end"
        t[index] = newText
    end,
    __index = function(_, index)
        dlog("INDEX", index)

        local content = load(t[index])()
        local varType = type(content)

        if varType == "table" then
            local rootTable = index
            local handler = {}
            

            handler = setmetatable(handler, {
                __newindex = function(tbl, index, value)
                    --dlog(content, tbl)
                    dlog("_NEWINDEX", index, value)
                    

                    --tbl[index] = value
                    --metatable.__newindex(nil, rootTable, content)
                end,
                __index = content,
                __tostring = function() return "DBTable: " .. rootTable end,
            })

            --debug.dump(content)

            return handler
        else
            return content
        end
    end
}

db = setmetatable(db, metatable)

_M._DB = db