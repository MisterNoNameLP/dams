debug.setFuncPrefix("[DB]")
log("Prepare data DB")

--os.execute("rm " .. _M._I.devConf.dataDatabasePath) --DEBUG

local db, err = _I.lib.sqlite.open(_M._I.devConf.dataDatabasePath)

ldlog(db, err)

log("Create data table: " .. tostring(db:exec([[
	CREATE TABLE data (
		fullIndex TEXT NOT NULL UNIQUE,
		valueType TEXT NOT NULL,
		value TEXT,
		numericInsertionIndex INTEGER
	);
]])))

db:close()

--[[
log("Create shared lock table")
_M._S._dbLockTable = {}
]]