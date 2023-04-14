--log(Session)

--debug.setLogPrefix("TTTT")

local user = env.User.new(1)
local session, err

local timeTable = os.date("*t")
timeTable.sec = timeTable.sec + 120

if false then
    _, session, sessionLogin = Session.create(user, timeTable)
    log("session:", session)
    log("sessionID:", session:getSessionID())
    log("sessionLogin:", sessionLogin)
end

log(Session.new("kOpqMEc0FWlMfwezwMqiL9z40K9VQG1m$QupxElPl6pTPXHWnhjknJaXVSHpNlLIc"))

timeTable = os.date("*t")
timeTable.min = timeTable.min + 5
--print("RENEW:", session:renew(timeTable))

--print("DEL:", session:delete())