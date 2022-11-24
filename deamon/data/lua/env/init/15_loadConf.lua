log("LOAD INI")

local conf = _E.lib.ini.load("../conf.ini")

assert(type(conf) == "table", "Cant load dams conf")

do
    if type(conf.main) ~= "table" then
        conf.main = {}
    end
    if type(conf.main.name) ~= "string" then
        warn("Not API name set. Falling back to default")
        conf.main.name = _E.devConf.fallbacks.defaultName
    end
end

_E.damsConf = conf

--_E.backupConf = _E.lib.ini.load()