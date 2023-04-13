return function(subject, text, ...)
    local additional = {...}
    
    assert(type(subject) == "string", "Subject needs to be a string")
    assert(type(text) == "string", "Text needs to be a string")

    for _, arg in ipairs(additional) do
        text = text .. _M._I.lib.ut.tostring(arg)
    end

    log("Sending mail:\nSubject: " .. subject .. "\n\n" .. tostring(text))

    if _M._I.damsConf then
        if string.sub(subject, 0, 1) == "[" then
            subject = "[" .. _M._I.damsConf.main.name .. "]" .. subject
        else
            subject = "[" .. _M._I.damsConf.main.name .. "]: " .. subject
        end
    end

    if type(_M._I.damsConf.mail.sender) ~= "string" then
        warn("Mail sender not configured correctly")
        return false
    elseif type(_M._I.damsConf.mail.reciever) ~= "string" then
        warn("Mail reciever not configured correctly")
        return false
    end

    exec("echo '" .. tostring(text) .. "' | mail -r " .. _M._I.damsConf.mail.sender .. " -s '" .. subject .. "' " .. _M._I.damsConf.mail.reciever)
end