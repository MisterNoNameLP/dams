return function(subject, text, ...)
    local additional = {...}
    
    assert(type(subject) == "string", "Subject needs to be a string")
    assert(type(text) == "string", "Text needs to be a string")
    assert(type(_M._I.damsConf.mail.sender) == "string", "Mail sender not configured correctly")
    assert(type(_M._I.damsConf.mail.reciever) == "string", "Mail reciever not configured correctly")

    for _, arg in ipairs(additional) do
        text = text .. _M._I.lib.ut.tostring(arg)
    end

    if _M._I.damsConf then
        if string.sub(subject, 0, 1) == "[" then
            subject = "[" .. _M._I.damsConf.main.name .. "]" .. subject
        else
            subject = "[" .. _M._I.damsConf.main.name .. "]:" .. subject
        end
    end

    exec("echo '" .. tostring(text) .. "' | mail -r " .. _M._I.damsConf.mail.sender .. " -s '" .. subject .. "' " .. _M._I.damsConf.mail.reciever)
end