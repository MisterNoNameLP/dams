local dbTable = {}
local db = _I.dataDB
local metafunctions = {}
local legalValueTypes = {string = true, number = true, table = true, boolean = true, ["nil"] = true}

--===== local functions =====--
local function isValueLegal(value)
	local valueType = type(value)
	if legalValueTypes[valueType] then
		return true, valueType
	else
		return false, valueType
	end
end
local function getValue(index, internalCall)
	if internalCall ~= true then
		debug.dataDBLog("Get value: " .. index)
	end
	local valueType, value
	local suc = db:exec([[SELECT valueType, value FROM dataDB WHERE fullIndex = "]] .. index .. [["]], function(udata, cols, values, names)
		valueType, value = values[1], values[2]
		return 0
	end)
    if suc ~= 0 then
        error("Unknown dbAPIData error: " .. tostring(suc), 2)
    end
	return valueType, value
end
local function addValue(index, valueType, value)
	debug.dataDBLog("Add value: " .. index .. ", " .. valueType .. ", " .. tostring(value))
	local suc
	if valueType == "table" then
		value = nil
	end
	if valueType == "table" then
		suc = db:exec([[INSERT INTO dataDB VALUES ("]] .. index .. [[", "]] .. valueType .. [[", NULL);]])
	else
		suc = db:exec([[INSERT INTO dataDB VALUES ("]] .. index .. [[", "]] .. valueType .. [[", "]] .. tostring(value) .. [[");]])
	end
	if suc ~= 0 then
		error("Could not add to dataDB (" .. tostring(suc) .. "): " .. tostring(fullIndex) .. ", " .. tostring(value), 2)
	end
end
local function addTableRecursively(index, tbl)
	debug.dataDBLog("Add table recursively: " .. index .. ", " .. tostring(value))
	local valueIsLegal, valueType
	addValue(index, "table")
	for i, v in pairs(tbl) do
		valueIsLegal, valueType = isValueLegal(v)
		if not valueIsLegal then
			error("Table contains invalid value type: " .. tostring(valueType), 3)
		end
		if valueType == "table" then
			addTableRecursively(index .. "." .. i, v)
		else
			addValue(index .. "." .. i, valueType, v)
		end
	end
	
end
local function updateValue(index, valueType, value)
	debug.dataDBLog("Update value: " .. index .. ", " .. valueType .. ", " .. tostring(value))
	local suc
	if valueType == "table" then
		value = nil
	end
	if valueType == "table" then
		suc = db:exec([[UPDATE dataDB SET valueType = "]] .. valueType .. [[", value = NULL WHERE fullIndex = "]] .. index .. [[";]])
	else
		suc = db:exec([[UPDATE dataDB SET valueType = "]] .. valueType .. [[", value = "]] .. tostring(value) .. [[" WHERE fullIndex = "]] .. index .. [[";]])
	end
	if suc ~= 0 then
		error("Could not update in dataDB: " .. tostring(fullIndex) .. ", " .. tostring(value), 2)
	end
end
local function removeValue(index, valueType)
	debug.dataDBLog("Remove value: " .. index)
	local suc
	if valueType ~= "table" then
		suc = db:exec([[DELETE FROM dataDB WHERE fullIndex = "]] .. index .. [[";]])
	else
		suc = db:exec([[DELETE FROM dataDB WHERE fullIndex LIKE "]] .. index .. [[%";]])
	end
	if suc ~= 0 then
		error("Could not remove from dataDB: " .. tostring(fullIndex) .. ", " .. tostring(value), 2)
	end
end


--===== metafunctions =====--
metafunctions.newindex = function(handler, index, value)
	local fullIndex = _I.ut.parseArgs(getmetatable(handler).fullIndex, "") .. "." .. index
	local storedValueType = getValue(fullIndex, true)
	local valueIsLegal, valueType = isValueLegal(value)

	if not valueIsLegal then
		error("Invalid value type: " .. tostring(valueType), 2)
	end
	if storedValueType then
		if valueType == "nil" then
			removeValue(fullIndex, storedValueType)
		else
			if valueType == "table" then
				removeValue(fullIndex, storedValueType)
				addTableRecursively(fullIndex, value)
			else
				updateValue(fullIndex, valueType, value)
			end
		end
	elseif valueType ~= "nil" then
		if valueType == "table" then
			addTableRecursively(fullIndex, value)
		else
			addValue(fullIndex, valueType, value)
		end
	end
end
metafunctions.index = function(handler, index)
	local fullIndex = _I.ut.parseArgs(getmetatable(handler).fullIndex, "") .. "." .. index
    local valueType, value = getValue(fullIndex)

    if valueType == "string" then
		return value 
	elseif valueType == "number" then
		return tonumber(value)
	elseif valueType == "boolean" then
		if value == "true" then
			return true
		else
			return false
		end
	elseif valueType == "table" then
		local newHandler = setmetatable({}, {
			fullIndex = fullIndex,
			__index = metafunctions.index,
			__newindex = metafunctions.newindex,
			__tostring = metafunctions.tostring,
		})
		return newHandler
	end
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