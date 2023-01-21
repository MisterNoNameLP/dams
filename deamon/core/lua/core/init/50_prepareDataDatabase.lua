debug.setFuncPrefix("[DB]")
dlog("Prepare data DB")

--os.execute("rm " .. _M._I.devConf.dataDatabasePath) --DEBUG

local db, err = _I.lib.sqlite.open(_M._I.devConf.dataDatabasePath)

ldlog(db, err)

dlog("Create data table: " .. tostring(db:exec([[
	CREATE TABLE dbTable (
		tableIndex TEXT NOT NULL UNIQUE,
		contentType TEXT NOT NULL,
		content TEXT
	);
]])))


do --debug
    log(_I.dataDB:exec([[INSERT INTO dbTable VALUES (".tbl1", "table", NULL)]]))
    log(_I.dataDB:exec([[INSERT INTO dbTable VALUES (".tbl1.tbl2", "table", NULL)]]))
    log(_I.dataDB:exec([[INSERT INTO dbTable VALUES (".tbl1.tbl2.var1", "string", "value1")]]))
    log(_I.dataDB:exec([[INSERT INTO dbTable VALUES (".str1", "string", "value1")]]))
    log(_I.dataDB:exec([[INSERT INTO dbTable VALUES (".str2", "string", "value2")]]))
    log(_I.dataDB:exec([[INSERT INTO dbTable VALUES (".str3", "string", "value3")]]))
end



db:close()