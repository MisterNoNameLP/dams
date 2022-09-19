local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

--log(os.date("%Y/%m/%d %H:%M:%S"))

--env.dyn.newSession(user, {year = 2023, month = 5, day = 10}, "test token", "this is a test token")

local body = env.dyn.html.Body.new()

body:addHead([[
<style>

    p{
        display: inline;
    }
    br {
        display: block;
        margin: 2px 0;
    }
    h1 {
        display: block;
        margin: 5px 0;
        text-align: center;
    }
    h2 {
        display: block;
        margin: 5px 0;
        text-align: center;
    }
    h3 {
        display: block;
        margin: 5px 0;
        text-align: center;
    }

    div.container {
        display: flex;
        justify-content: center;
    }

    .token {
        width: 90%;
        text-align: center;
        border: 3px solid black;
        line-height: 130%;
        padding-left: 5px;
        padding-right: 5px;
        padding-top: 5px;
        padding-bottom: 5px;
    }

</style>
]])

body:addHeader(1, "Token dashboard")
body:addRaw([[
    <div style="display: flex;">
        <iframe src="editToken" width="100%" height="230" style="border-style: none;"></iframe> 
    </div>
]])

local function addTokenWidged(udata, cols, value, name)
    local expireDateDisplay, deletionDateDisplay = "", ""
    local deleteDisplay = [[<button name="tokenAction", value="disable">Disable</button>]]

    if value[5] == "-1" then
        expireDateDisplay = "Never"
    else
        expireDateDisplay = os.date("%Y/%m/%d %H:%M:%S", tonumber(value[5]))
    end

    if value[7] == "1" then
        deleteDisplay = [[<button name="tokenAction", value="restore">Restore</button>
        <button name="tokenAction", value="delete">Delete</button>]]
        deletionDateDisplay = [[<b>Deletion date: </b><p>]] .. os.date("%Y/%m/%d %H:%M:%S", tonumber(value[8])) .. [[<p><br></br>]]
    end

    body:addRaw([[
        <form action="", method="POST">
        <input type="hidden", name="tokenID", value="]] .. value[6] .. [["</input>
        <input type="hidden", name="action", value="tokenAction">
            <div class="container">
            <div class="token">
                <b>]] .. value[1] .. [[</b><br></br>
                <b>Note: </b><p style="white-space: pre-wrap;">]] .. value[2] .. [[</p><br></br>
                <b>User agent: </b><p>]] .. value[3] .. [[</p><br></br>
                <b>Token ID: </b><p> ]] .. value[6] .. [[</p><br></br>
                <b>Creation date: </b><p>]] .. os.date("%Y/%m/%d %H:%M:%S", tonumber(value[4])) .. [[<p><br></br>
                <b>Expire date: </b><p>]] .. expireDateDisplay .. [[</p><br></br>
                ]] .. deletionDateDisplay .. [[
            
                <b>Actions: </b>
                <button name="tokenAction", value="edit">Edit</button> 
                ]] .. deleteDisplay .. [[
            </div>
            </div>
        </form>  
    ]])

    body:addRaw([[<br style="margin: 8px;"></br>]])
end

body:addHeader(2, "Manually createt auth tokens")
env.loginDB:exec([[SELECT name, note, userAgent, creationTime, expireTime, sessionID FROM sessions WHERE userID == ]] .. tostring(user:getID() .. [[ AND createdAutomatically == 0 AND status == 0]]), function(udata, cols, value, name)
    local suc, err = xpcall(addTokenWidged, debug.traceback, udata, cols, value, name)
    if suc ~= true then
        debug.err(err, debug.traceback())
    end
    return 0
end)


body:addHeader(2, "Automatically createt auth tokens")
env.loginDB:exec([[SELECT name, note, userAgent, creationTime, expireTime, sessionID FROM sessions WHERE userID == ]] .. tostring(user:getID() .. [[ AND createdAutomatically > 0 AND status == 0]]), function(udata, cols, value, name)
    local suc, err = xpcall(addTokenWidged, debug.traceback, udata, cols, value, name)
    if suc ~= true then
        debug.err(err, debug.traceback())
    end
    return 0
end)

body:addHeader(2, "Deactivated tokens")
env.loginDB:exec([[SELECT name, note, userAgent, creationTime, expireTime, sessionID, status, deletionTime FROM sessions WHERE userID == ]] .. tostring(user:getID() .. [[ AND status == 1]]), function(udata, cols, value, name)
    local suc, err = xpcall(addTokenWidged, debug.traceback, udata, cols, value, name)
    if suc ~= true then
        debug.err(err, debug.traceback())
    end
    return 0
end)

return body:generateCode()