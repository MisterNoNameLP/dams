local Body = {}

local parseArgs = env.lib.ut.parseArgs

function Body.new()
    local self = setmetatable({}, {__index = function(...)
        local _, index = ...
        return function(...)
            local args = {...}

            if type(args[1]) ~= "table" then
                return Body[index]({content = {}}, unpack(args))
            else 
                return Body[index](...)
            end
        end
    end})

    self.head = {}
    self.body = {}

    return self
end

function Body:addHead(text)
    local html = "\n" .. text .. "\n"
    table.insert(self.head, html)
    return html
end

function Body:addToBody(text)
    if self then 
        table.insert(self.body, text)
    end
    return text
end

function Body:addRaw(text)
    local html = "\n" .. text .. "\n"
    table.insert(self.body, html)
    return html
end

function Body:addRefButton(name, link)
    local html = [[
<a href="]]..link..[[">  
    <input type="button" value="]]..name..[["/>  
</a> 
]]
    table.insert(self.body, html)
    return html
end

function Body:addGoBackButton(requestData, name)
    local html
    local referer = env.dyn.http.getReferer(requestData, true)
    if referer then
        html = [[
<a href="]]..referer..[[">  
    <input type="button" value="]]..name..[["/>  
</a> 
]]
    else
        html = [[
<p>(Go back error. Please contact an admin.)</p>
]]
    end
    table.insert(self.body, html)
    return html
end

function Body:addAction(link, method, actions)
    local actionString = [[<form action="]]..link..[[" method="]]..method..[[">]]
    for _, action in pairs(actions) do
        if action[1] == "input" then
            local target = parseArgs(action.target, action.id, action.name)
            local type = parseArgs(action.type, "text")
            local value = parseArgs(action.value, "")
            local name = parseArgs(action.name, "")
            actionString = actionString .. [[
<div>
    <label for="]]..name..[[">]]..name..[[</label>
    <input type="]]..type..[[" name="]]..target..[[" value="]]..value..[[">
</div>
]]
        elseif action[1] == "hidden" then
            local target = parseArgs(action.target, action.id, action.name)
            actionString = actionString .. [[
<div>
    <input type="hidden" name="]]..target..[[" value="]]..action.value..[[">
</div>
]]
        elseif action[1] == "textarea" then
            local value = parseArgs(action.value, "")
            actionString = actionString .. [[
<label>]]..action.name..[[</label>
<div>
    <textarea for="]]..action.target..[[" name="]]..action.target..[[">]]..value..[[</textarea>
</div>
]]
        elseif action[1] == "button" or action[1] == "submit" then
            local type = parseArgs(action.type, action[1])
            local value = parseArgs(action.value, action.name, "")
            actionString = actionString .. [[
<div>
    <button type="]]..type..[[">]]..value..[[</button>
</div>
]]
        end
    end
    actionString = actionString .. "</form>"
    table.insert(self.body, actionString)
    return actionString
end

function Body:addHeader(level, text)
    local html = [[
<h]]..tostring(level)..[[>]]..tostring(text)..[[</h]]..tostring(level)..[[>
    ]]
    table.insert(self.body, html)
end

function Body:addP(text)
    local html = [[
<p>]]..tostring(text)..[[</p>
]]
    table.insert(self.body, html)
    return html
end 

function Body:addLink(link, name)
    local html = [[
<a href="]] .. link .. [[">]] .. parseArgs(name, link) .. [[</a>]]
    table.insert(self.body, html)
    return html
end


function Body:goTo(link, delay)
    local html = [[
<meta http-equiv="refresh" content="]]..tostring(delay or 0)..[[; url=']]..link..[['" />
]]
    table.insert(self.body, html)
    return html
end

function Body:goBack(requestData, delay)
    local html
    local referer = env.dyn.http.getReferer(requestData, true)
    if referer then
        html = [[
<meta http-equiv="Refresh" content="]]..tostring(delay or 0)..[[; url=']]..referer..[['" />
]]
    else
        html = [[
<p>(Go back error. Please contact an admin.)</p>
]]
    end
    table.insert(self.body, html)
    return html
end

function Body:generateCode()
    local htmlCode = "<!DOCTYPE html>\n<html>\n<head>\n"

    for _, c in pairs(self.head) do
        htmlCode = htmlCode .. c
    end
    htmlCode = htmlCode .. "\n</head>\n<body>\n"
    for _, c in pairs(self.body) do
        htmlCode = htmlCode .. c
    end
    htmlCode = htmlCode .. "\n</body>\n</html>"

    return htmlCode
end

return Body