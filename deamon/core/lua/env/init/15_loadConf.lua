log("LOAD INI")

local conf = _M._I.lib.ini.load("../conf.ini")

assert(type(conf) == "table", "Cant load dams conf")

do
    if type(conf.main) ~= "table" then
        conf.main = {}
    end
    if type(conf.main.name) ~= "string" then
        warn("Not API name set. Falling back to default")
        conf.main.name = _M._I.devConf.fallbacks.defaultName
    end
end

_M._I.damsConf = conf

--_M._I.backupConf = _M._I.lib.ini.load()