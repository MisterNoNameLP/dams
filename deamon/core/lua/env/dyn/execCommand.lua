return function(commandString)
    local command = ""
    local args = {}
    for c in string.gmatch(commandString, "[^ ]+") do
		if command == "" then
			command = c
		else	
			table.insert(args, c)
		end
	end
    if _M._I.commands[command] ~= nil then
        local suc, err = xpcall(_M._I.commands[command], debug.traceback, _M, args, _M._I.lib)
        return suc, err
    elseif command ~= "" then
        return false, "Command \"" .. command .. "\" not found"
    end
end