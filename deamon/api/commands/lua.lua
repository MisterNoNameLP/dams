--local _M, args = ...
local lua = {}
local luaShell = loadfile("core/lua/libs/thirdParty/luaShell.lua")(_M._I)
local lastAutoCompBase = ""

function lua.input(input, command, args)
	debug.setFuncPrefix("[LUA]", true, true)
	
	luaShell.textInput(input)
end

function lua.autoComp(text, ti)
	if ti.autoCompBase ~= lastAutoCompBase then
		lastAutoCompBase = ti.autoCompBase
		ti.autoCompPos = 1
		
		local autoComp = luaShell.readHandler(ti.text, ti.cursorPosition + ti.stringPosition)
		
		if #autoComp == 1 then
			ti.autoCompBase = autoComp[1]
			lastAutoCompBase = ti.autoCompBase
		end
		
		ti.autoComplete = autoComp
	end
end

_M._I.terminal.setTerminal(lua, "[LUA]")