log("Open user DB")
_M.loginDB = _M.lib.sqlite.open(_M.devConf.userLoginDatabasePath)