local id = tostring(env.getThreadInfos().id)

local returnTable = {}

local suc, output = execScript("changePasswd.exp " .. id, {
    ["DAMS_USER_" .. id] = requestData.request.username,
    ["DAMS_PASSWD_" .. id] = requestData.request.currentPasswd,
    ["DAMS_NEWPASSWD1_" .. id] = requestData.request.newPasswd1,
    ["DAMS_NEWPASSWD2_" .. id] = requestData.request.newPasswd2,
}, true)

--create return table
if suc == 0 then
    returnTable.success = true
else
    returnTable.success = false
end

returnTable.exitCode = suc
if suc == 1 then
    returnTable.error = "User does not exist"
elseif suc == 2 then
    returnTable.error = "Wrong password"
elseif suc == 2 then
    returnTable.error = "Password do not match"
else
    returnTable.error = "Something unexpected happened"
end

returnTable.html = {}
returnTable.html.forwardInternal = "changePasswdResult"

return returnTable