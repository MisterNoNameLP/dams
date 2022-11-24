return function(subject, text, ...)
    local additional = {...}
    
    assert(type(subject) == "string", "Subject needs to be a string")
    assert(type(text) == "string", "Text needs to be a string")
    assert(type(_E.damsConf.mail.sender) == "string", "Mail sender not configured correctly")
    assert(type(_E.damsConf.mail.reciever) == "string", "Mail reciever not configured correctly")

    for _, arg in ipairs(additional) do
        text = text .. _E.lib.ut.tostring(arg)
    end

    if _E.damsConf then
        if string.sub(subject, 0, 1) == "[" then
            subject = "[" .. _E.damsConf.main.name .. "]" .. subject
        else
            subject = "[" .. _E.damsConf.main.name .. "]:" .. subject
        end
    end

    exec("echo '" .. tostring(text) .. "' | mail -r " .. _E.damsConf.mail.sender .. " -s '" .. subject .. "' " .. _E.damsConf.mail.reciever)
end