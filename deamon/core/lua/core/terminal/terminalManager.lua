--DAMS main file
local _M, shared = ...

local getch = require("getch")

local terminal = {
	input = "",
	currentTerminal = nil,
	currentTerminalPrefix = "",
	
	terminal = loadfile(_M._I.devConf.terminalPath .. "terminal.lua")(_M),
}

function terminal.setTerminal(t, prefix)
	terminal.currentTerminal = t
	terminal.currentTerminalPrefix = prefix or ""
end
function terminal.getTerminal()
	return terminal.currentTerminal, terminal.currentTerminalPrefix
end

function terminal.input(input) 
	local command, args = "", {}
	local callMainTerminal = false
	
	for c in string.gmatch(input, "[^ ]+") do
		if command == "" then
			if c == _M._I.devConf.terminal.commands.forceMainTerminal then
				callMainTerminal = true
			else
				command = c
			end
		else	
			table.insert(args, c)
		end
	end
	
	if terminal.currentTerminal ~= nil and not callMainTerminal then
		debug.setFuncPrefix(terminal.currentTerminalPrefix, true, true)
	else
		debug.setFuncPrefix("[MAIN_TERMINAL]", true, true)
	end

	plog("> " .. tostring(input))
	
	if terminal.currentTerminal ~= nil and not callMainTerminal then
		terminal.currentTerminal.input(input, command, args)
	elseif _M._I.commands[command] ~= nil then
		local suc, err = xpcall(_M._I.commands[command], debug.traceback, _M, args, _M._I.lib)
		--local suc, err = _M._I.startFileThread("userData/commands/" .. command .. ".lua", "[COMMAND_THREAD][" .. command .. "]") --terminal.setTerminal is not working this way.
		
		plog(suc, err)
	elseif command ~= "" then
		plog("Command \"" .. command .. "\" not found")
	end
end

function terminal.autoComp(ti)
	if terminal.currentTerminal ~= nil and terminal.currentTerminal.autoComp ~= nil then
		terminal.currentTerminal.autoComp(ti.text, ti)
	end
end

function love.update()
	--local input = tostring(io.read())
	--local input = getch.blocking()
	terminal.terminal.update()
	terminal.terminal.draw()
end

_M._I.terminal = terminal