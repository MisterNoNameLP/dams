local dbTable = {}
local db = _I.dataDB
local metafunctions = {}

log("=================")
--===== local functions =====--
local function getContent(index)
	local contentType, content
	local suc = db:exec([[SELECT contentType, content FROM dbTable WHERE tableIndex = "]] .. index .. [["]], function(udata, cols, values, names)
		contentType, content = values[1], values[2]
		return 0
	end)
    if suc ~= 0 then
        err("Unknown dataDB error: " .. tostring(suc))
    end
	return contentType, content
end

--===== metafunctions =====--
metafunctions.index = function(handler, index)
    debug.setFuncPrefix("[DDB_MAININDEX]", true)
	--dlog("T")

	local fullIndex = _I.ut.parseArgs(getmetatable(handler).fullIndex, "") .. "." .. index
    local contentType, content = getContent(fullIndex)

    if contentType == "string" then
		return content 
	elseif contentType == "number" then
		return tonumber(content)
	elseif contentType == "table" then
		local newHandler = setmetatable({}, {
			fullIndex = fullIndex,
			__index = metafunctions.index,
			__tostring = metafunctions.tostring,
		})
		return newHandler
	end
end
metafunctions.newindex = function(handler, index, value)
	local fullIndex = getmetatable(handler).fullIndex


end
metafunctions.tostring = function(handler)
    return "dbHandler: " .. string.sub(_I.ut.parseArgs(getmetatable(handler).fullIndex, ".(root)"), 2)
end

--===== set root handler =====--
dbTable = setmetatable(dbTable, {
    __index = metafunctions.index,
    __newindex = metafunctions.newindex,
    __tostring = metafunctions.tostring,
})

_M._DB = dbTable