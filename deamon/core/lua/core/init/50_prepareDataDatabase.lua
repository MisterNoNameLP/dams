debug.setFuncPrefix("[DB]")
dlog("Prepare login DB")

os.execute("rm " .. _M._I.devConf.dataDatabasePath) --DEBUG

local db, err = _I.lib.sqlite.open(_M._I.devConf.dataDatabasePath)

ldlog(db, err)

dlog("Create data table: " .. tostring(db:exec([[
	CREATE TABLE data (
		name TEXT NOT NULL,
		content TEXT NOT NULL
	);
]])))



db:close()