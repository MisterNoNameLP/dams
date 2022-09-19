local Session = {}

function Session.new(sessionLogin, force)
    local self = setmetatable({}, {__index = Session})

    local seperatorPos = string.find(sessionLogin, "[$]") or 999999999

    local sessionID = string.sub(sessionLogin, 0, seperatorPos - 1)
    local token = string.sub(sessionLogin, seperatorPos + 1)

    self.sessionData = {}
    self.sessionData.sessionID = sessionID
    

    if sessionID == "" then
        return false, -12, "No valid session token given"
    end

    errCode = env.loginDB:exec([[SELECT token, userID, expireTime, name, note, createdAutomatically, deletionTime FROM sessions WHERE sessionID = "]] .. sessionID .. [[" AND status == 0]], function(_, cols, values, names)
        for index, name in ipairs(names) do
            self.sessionData[name] = values[index]
        end
		return 0
	end)

    if errCode ~= 0 then
        return false, errCode
    end

    if not self.sessionData.userID then
        return false, -10, "sessionID not found"
    end

    if tonumber(self.sessionData.expireTime) ~= -1 and tonumber(self.sessionData.expireTime) < os.time() then
        if env.devConf.session.deleteExpiredSessions then
            self:delete()
        end

        return false, -11, "sessionID expired"
    end

    if not env.verifyPasswd(self.sessionData.token, token) and not force then
        return false, -13, "Can not verify session token"
    end

    return self
end

function Session.create(user, expireTime, name, note, requestData, createdAutomatically) --expireTime in seconds ongoing from 1970 00:00:00 UTC (os.time(...) in unix systems) or a time table.
    local token = env.lib.ut.randomString(32)
    local sessionID = env.lib.ut.randomString(16)
    local userAgent = env.dyn.getHeader(requestData, "user-agent")
    local suc


    if type(expireTime) == "table" then
        expireTime = os.time(expireTime)
    end
    if userAgent == nil then
        userAgent = "UNKNOWN"
    end
    
    --print([[INSERT INTO sessions VALUES ("]] .. sessionID .. [[", "]] .. env.hashPasswd(token) .. [[", ]] .. expireTime ..[[, ]] .. tostring(user:getID()) .. [[)]])

    suc = env.loginDB:exec([[INSERT INTO sessions VALUES ("]] .. sessionID .. [[", "]] .. env.hashPasswd(token) .. [[", ]] .. os.time() ..[[, ]] .. expireTime .. [[, ]] .. tostring(user:getID()) .. [[, "]] .. tostring(name) .. [[", "]] .. tostring(note) .. [[", "]] .. userAgent .. [[", ]] .. env.ut.parseArgs(createdAutomatically, 1) .. [[, 0, -1)]])

    if suc ~= 0 then
        return false, suc
    else
        return true, Session.new(sessionID .. "$" .. token), sessionID .. "$" .. token
    end
end


function Session:getSessionID()
    return self.sessionData.sessionID
end

function Session:getUserID()
    return tonumber(self.sessionData.userID)
end

function Session:getName()
    return self.sessionData.name
end

function Session:getDescription()
    return self.sessionData.note
end

function Session:getExpireTime()
    return self.sessionData.expireTime
end

function Session:setName(name)
    local suc

    if type(name) ~= "string" then
        error("Invalid name given", 2)
    end

    suc = env.loginDB:exec([[UPDATE sessions SET name = "]] .. tostring(name) .. [[" WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end

function Session:setNote(note)
    local suc

    if type(note) ~= "string" then
        error("Invalid note given", 2)
    end

    suc = env.loginDB:exec([[UPDATE sessions SET note = "]] .. tostring(note) .. [[" WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end

function Session:setExpireTime(expireTime)
    local suc

    if type(expireTime) == "table" then
        expireTime = os.time(expireTime)
    end

    if type(expireTime) ~= "number" then
        error("Invalid expire time given", 2)
    end

    suc = env.loginDB:exec([[UPDATE sessions SET expireTime = ]] .. tostring(expireTime) .. [[ WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end

function Session:setDeletionTime(deletionTime)
    local suc

    if type(deletionTime) == "table" then
        deletionTime = os.time(deletionTime)
    end

    if type(deletionTime) ~= "number" then
        error("Invalid deletion time given", 2)
    end

    suc = env.loginDB:exec([[UPDATE sessions SET deletionTime = ]] .. tostring(deletionTime) .. [[ WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end

function Session:delete()
    local suc

    suc = env.loginDB:exec([[DELETE FROM sessions WHERE sessionID = "]] .. self:getSessionID() .. [["]])

    if suc == 0 then
        return true
    else
        return false, suc
    end
end


return Session