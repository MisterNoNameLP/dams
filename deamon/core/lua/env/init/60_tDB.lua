local dbTable = {}
local db = _I.dataDB
local metafunctions = {}
local legalValueTypes = {string = true, number = true, table = true, boolean = true, ["nil"] = true}
local legalIndexTypes = {string = true, number = true}

--===== init db error handlers =====--
db:busy_handler(function(_, attempt) 
	love.timer.sleep(_I.devConf.sqlite.busyWaitTime)
	if attempt >= _I.devConf.sqlite.maxBusyTries then
		err("dataDB action took too long")
		return false
	end
	return 1
end)

--===== local functions =====--
local function isValueLegal(value)
	local valueType = type(value)

	if legalValueTypes[valueType] then
		return true, valueType
	else
		return false, valueType
	end
end
local function isIndexLegal(index)
	local indexType = type(index)

	if legalIndexTypes[indexType] then
		return true, indexType
	else
		return false, indexType
	end
end
local function getValue(index, internalCall)
	if internalCall ~= true then
		debug.dataDBLog("Get value: " .. index)
	end
	local valueType, value
	local suc = db:exec([[SELECT valueType, value FROM data WHERE fullIndex = "]] .. index .. [["]], function(udata, cols, values, names)
		valueType, value = values[1], values[2]
		return 0
	end)
    if suc ~= 0 then
		error("Could not get dataDB value: " .. tostring(index) .. ": " .. _I.getSQLiteErrMsg(db, suc))
    end
	return valueType, value
end
local function getFullTable(index)
	debug.dataDBLog("Get full table: " .. index)
	local returnValues = {}

	local suc = db:exec([[SELECT fullIndex, valueType, value FROM data WHERE fullIndex LIKE "]] .. index .. [[%"]], function(udata, cols, values, names)
		local fullIndex, valueType, value = values[1], values[2], values[3]
		local cutIndex, lastIndexValue
		local gsubTarget = returnValues
		cutIndex = fullIndex:gsub(index, "")

		for indexFragment in cutIndex:gmatch("[^.]+") do
			indexFragment = indexFragment:sub(1)

			if not indexFragment:find("[']") then
				indexFragment = tonumber(indexFragment)
			else
				indexFragment = indexFragment:sub(2, -2)
				indexFragment = indexFragment:gsub("''", "'")
			end

			if lastIndexValue then
				gsubTarget = gsubTarget[lastIndexValue]
			end
			if not gsubTarget[indexFragment] then 
				gsubTarget[indexFragment] = {}
			end
			lastIndexValue = indexFragment
		end
		if valueType ~= "table" then
			gsubTarget[lastIndexValue] = value
		end

		return 0
	end)
	if suc ~= 0 then
		error("Could not get dataDB value: " .. tostring(index) .. ": " .. _I.getSQLiteErrMsg(db, suc))
    end

	return returnValues
end
local function addValue(index, valueType, value)
	debug.dataDBLog("Add value: " .. index .. ", " .. valueType .. ", " .. tostring(value))
	local suc

	if valueType == "table" then
		value = nil
	end

	if valueType == "table" then
		suc = db:exec([[INSERT INTO data VALUES ("]] .. index .. [[", "]] .. valueType .. [[", NULL, 1);]])
	else
		suc = db:exec([[INSERT INTO data VALUES ("]] .. index .. [[", "]] .. valueType .. [[", "]] .. tostring(value) .. [[", 1);]])
	end
	if suc ~= 0 then
		error("Could not add to dataDB: " .. tostring(fullIndex) .. ", " .. tostring(value) .. ": " .. _I.getSQLiteErrMsg(db, suc))
	end
end
local function addTableRecursively(index, tbl)
	debug.dataDBLog("Add table recursively: " .. index .. ", " .. tostring(value))
	local valueIsLegal, valueType
	local indexIsLegal, indexType

	addValue(index, "table")
	for i, v in pairs(tbl) do
		valueIsLegal, valueType = isValueLegal(v)
		indexIsLegal, indexType = isIndexLegal(i)
		if not valueIsLegal then
			error("Table contains invalid value type: " .. tostring(valueType), 3)
		elseif not indexIsLegal then
			error("Table contains invalid index type: " .. tostring(indexType), 3)
		end
		if valueType == "table" then
			addTableRecursively(_I.appendIndex(index, i), v)
		else
			addValue(_I.appendIndex(index, i), valueType, v)
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
		suc = db:exec([[UPDATE data SET valueType = "]] .. valueType .. [[", value = NULL WHERE fullIndex = "]] .. index .. [[";]])
	else
		suc = db:exec([[UPDATE data SET valueType = "]] .. valueType .. [[", value = "]] .. tostring(value) .. [[" WHERE fullIndex = "]] .. index .. [[";]])
	end
	if suc ~= 0 then
		error("Could not update in dataDB: " .. tostring(fullIndex) .. ", " .. tostring(value) .. ": " .. _I.getSQLiteErrMsg(db, suc))
	end
end
local function removeValue(index, valueType)
	debug.dataDBLog("Remove value: " .. index)
	local suc

	if valueType ~= "table" then
		suc = db:exec([[DELETE FROM data WHERE fullIndex = "]] .. index .. [[";]])
	else
		suc = db:exec([[DELETE FROM data WHERE fullIndex LIKE "]] .. index .. [[%";]])
	end
	if suc ~= 0 then
		error("Could not remove from dataDB: " .. tostring(fullIndex) .. ", " .. tostring(value))
	end
end
local function insertNumValue(index, valueType, value)
	debug.dataDBLog("Insert value: " .. valueType .. ", " .. tostring(value))
	local numericInsertionIndex, lastNumericInsertionIndex
	local canInsert
	local insertionChecks = 0
	local function errCheck(code)
		if code ~= 0 then 
			error("Could not insert value: " .. tostring(code) .. ", " .. tostring(_I.getSQLiteErrMsg(db, suc)), 4)
		end
	end

	errCheck(db:exec([[SELECT numericInsertionIndex FROM data WHERE fullIndex = "]] .. tostring(index) .. [[";]], function(udata, cols, values, names)
		numericInsertionIndex = values[1]
		return 0
	end))
	while not canInsert do
		errCheck(db:exec([[SELECT fullIndex FROM data WHERE fullIndex LIKE "]] .. tostring(index) .. "." .. tostring(numericInsertionIndex) .. [[%";]], function(udata, cols, values, names)
			if values[1] then
				numericInsertionIndex = numericInsertionIndex + 1
				canInsert = false
			end
			return 0
		end))
		if canInsert == nil or lastNumericInsertionIndex == numericInsertionIndex then --if the dbExec is not called the target index is not occupied. so the while can break.
			break
		else
			lastNumericInsertionIndex = numericInsertionIndex
		end
		insertionChecks = insertionChecks +1
		if insertionChecks >= 10000 then
			error("[INTERNAL]: Max insertion attemts reached", 3)
		end
	end
	errCheck(db:exec([[UPDATE data SET numericInsertionIndex = ]] .. tostring(numericInsertionIndex + 1) .. [[ WHERE fullIndex = "]] .. index .. [[";]]))
	return addValue(tostring(index) .. "." .. tostring(numericInsertionIndex), valueType, value)
end

--===== metafunctions =====--
metafunctions.newindex = function(handler, index, value)
	--local fullIndex = _I.ut.parseArgs(getmetatable(handler)._fullIndex, "") .. "." .. index
	local fullIndex = _I.appendIndex(getmetatable(handler)._fullIndex, index)
	local storedValueType = getValue(fullIndex, true)
	local valueIsLegal, valueType = isValueLegal(value)
	local indexIsLegal, indexType = isIndexLegal(index)

	if not valueIsLegal then
		error("Invalid value type: " .. tostring(valueType), 2)
	elseif not indexIsLegal then
		error("Invalid index type: " .. tostring(indexType), 2)
	end
	if storedValueType then
		if valueType == "nil" then
			removeValue(fullIndex, storedValueType)
		else
			if valueType == "table" then
				removeValue(fullIndex, storedValueType)
				addTableRecursively(fullIndex, value)
			else
				if storedValueType == "table" then
					removeValue(fullIndex, storedValueType)
					addValue(fullIndex, valueType, value)
				else
					updateValue(fullIndex, valueType, value)
				end
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
	local fullIndex = _I.appendIndex(getmetatable(handler)._fullIndex, index)
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
			_fullIndex = fullIndex,
			__index = metafunctions.index,
			__newindex = metafunctions.newindex,
			__tostring = metafunctions.tostring,
			__call = metafunctions.call,
		})
		return newHandler
	end
end
metafunctions.tostring = function(handler)
    return "dbHandler: " .. string.sub(_I.ut.parseArgs(getmetatable(handler)._fullIndex, ".(root)"), 2)
end
metafunctions.call = function(handler, order, ...) --TODO: add lock feature.
	--debug.dump(getmetatable(handler))

	if order == "get" then
		return getFullTable(getmetatable(handler)._fullIndex)
	elseif order == "dump" then
		debug.dump(getFullTable(getmetatable(handler)._fullIndex))
	elseif order == "insert" then
		local args = {...}
		local value = args[1]
		local valueIsLegal, valueType = isValueLegal(value)
		if not valueIsLegal then
			error("Invalid value type: " .. tostring(valueType), 2)
		end
		insertNumValue(getmetatable(handler)._fullIndex, valueType, value)
	elseif order == "lock" then
		debug.warn("_DB lock feature not implemented yet!")
	end
end

--===== set root handler =====--
dbTable = setmetatable(dbTable, {
    __index = metafunctions.index,
    __newindex = metafunctions.newindex,
    __tostring = metafunctions.tostring,
	__call = metafunctions.call,
})

_M._DB = dbTable