log("Open user DB")
_M._I.userDB = _M._I.lib.sqlite.open(_M._I.devConf.userDatabasePath)
_M._I.dataDB = _M._I.lib.sqlite.open(_M._I.devConf.dataDatabasePath)