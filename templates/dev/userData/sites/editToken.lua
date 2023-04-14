local session, user = env.dyn.loginRequired(requestData)
if session == false then
    return user
end

local head, action, button, secondsOption = "Add token", "addToken", "Add token", [[<option value="sec">Seconds</option>]]
local name, description, expireTimeValue, expireTimeUnit, tokenID = "", "", "", "", ""



if request then
    local session, err, msg = env.dyn.Session.new(request.tokenID, true)

    if session == false then
        return select(2, env.dyn.execSite("error", {error = {
            headline = "Token editor failure",
            err = msg,
            code = err,
        }}, requestData))
        --return env.dyn.execSite("error", {})
    end

    log(session)

    head = "Edit token"
    action = "editToken"
    button = "Edit token"
    secondsOption = [[<option value="sec" selected>Seconds</option>]]

    name = session:getName()
    description = session:getDescription()
    expireTimeValue = session:getExpireTime() - os.time()
    tokenID = request.tokenID
end

body:addHead([[<style>
    .block {
        display: block;
    }

    .inline-block {
        display: inline-block;
    }

    .max-width {
        box-sizing: border-box;
        width: 100%
    }

    div.token-editor-mainpage {
        text-align: center;
    }

    div.token-editor {
        display: inline-block;
        text-align: center;
    }

    

</style>]])

body:addRaw([[
    <div class="token-editor-mainpage">
        <div class="token-editor">
            <h1>]] .. head .. [[</h1>
            <form action="" method="POST">
                <input type="hidden" name="action" value="]] .. action .. [[">
                <input type="hidden" name="tokenID" value="]] .. tokenID .. [[">

                <input type="text" class="block max-width" name="name" placeholder="Name" value="]] .. name .. [[">
                <textarea name="description" class="block max-width" placeholder="Description">]] .. description .. [[</textarea>  
                <div>
                    <label>Expire in:</label>
                    <input type="number" name="expireTimeValue" value="]] .. expireTimeValue .. [[">
                    <select name="expireTimeUnit">
                        <option value="never">Never</option>
                        ]] .. secondsOption .. [[
                        <option value="min">Minutes</option>
                        <option value="day">Days</option>
                        <option value="month">Months</option>
                        <option value="year">Years</option>
                    </select>
                </div>
                

                <input type="submit" value="]] .. button .. [[">
            </form>
        </div>
    </div>
]])

return body:generateCode()