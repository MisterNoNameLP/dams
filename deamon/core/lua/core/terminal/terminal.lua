--ToDo: replace string.len with utf8.len when avaiable.
local _M = ...
local terminal = {}

--===== require libs =====--
local getch = require("getch")
local textInput = loadfile(_M._I.devConf.terminalPath .. "TextInput.lua")()
local constants = require(_M._I.devConf.terminalPath .. "terminalConstants")
local utf8 = require("utf8")
local thread = require("love.thread")

--===== set constants =====--
local terminalSizeRefreshTime = _M._I.devConf.terminalSizeRefreshDelay

local ansi = constants.ansi
local keyTable = constants.keyTable

--===== set local variables =====--
local writeCursorPos = 1
local terminalLength, terminalHeight = 80, 25
local previusTerminalSizeRefreshTime = 0
local drawNeeded = true

local textBox = textInput.new()

local debug_print = thread.getChannel("debug_print")

--===== set local functions =====--
--local ioWrite = io.write
local ioWrite = _M._I.org.io.write
local function w(...)
	ioWrite(...)
end

local function getTerminalSize()
	local timeSeconds = os.time(os.date("*t"))
	
	local tputLinesHandler, tputColsHandler
	local newTerminalHeight, newTerminalLength

	if previusTerminalSizeRefreshTime + terminalSizeRefreshTime < timeSeconds then
		tputLinesHandler = io.popen("tput lines")
		tputColsHandler = io.popen("tput cols")
		
		if tputColsHandler == nil or tputLinesHandler == nil then
			warn("Can't read terminal size! This can result in a broken terminal.")
		else
			newTerminalHeight = tputLinesHandler:read("*a")
			newTerminalLength = tputColsHandler:read("*a")
		end

		if tonumber(newTerminalHeight) == nil then
			warn("Cant get current terminal height.")
			warn(newTerminalHeight)
		else
			terminalHeight = tonumber(newTerminalHeight)
		end
		if tonumber(newTerminalLength) == nil then
			warn("Cant get current terminal length.")
			warn(newTerminalLength)
		else
			terminalLength = tonumber(newTerminalLength)
		end

		previusTerminalSizeRefreshTime = timeSeconds
	end
	
	return terminalLength, terminalHeight
end

local function resetCursor()
	local terminalLength, terminalHeight = getTerminalSize()
	local _, cursorPos = textBox:get(terminalLength)
	
	w(ansi.setCursor:format(terminalHeight, cursorPos))
end

local function getMsg(...)
	local msgs = ""
	if #{...} == 0 then
		msgs = "nil"
	else
		for _, msg in pairs({...}) do
			msgs = msgs .. tostring(msg) .. "  "
		end
	end
	return msgs
end

local function write(...) --not used anymore! --io.write() replacement
	local _, terminalHeight = getTerminalSize()
	
	w(ansi.setCursor:format(terminalHeight -1, writeCursorPos))
	
	for _, arg in pairs({...}) do
		writeCursorPos = writeCursorPos + utf8.len(tostring(arg))
	end

	if _M._I.devConf.terminal.movieLike then --just for the lulz
		for _, s in ipairs({...}) do 
			for _, s2 in ipairs(_M._I.lib.ut.getChars(tostring(s))) do
				w(s2)
				_M._I.org.io.flush()
				sleep(_M._I.devConf.terminal.movieLikeDelay)
			end
		end
	else
		w(getMsg(...))
	end

	_M._I.debug.logfile:write(getMsg(...))
	_M._I.debug.logfile:flush()

	resetCursor()
end

local function print(...)
	local _, terminalHeight = getTerminalSize()
	w(ansi.setCursor:format(terminalHeight, writeCursorPos))
	w(ansi.clearLine)
	if _M._I.devConf.terminal.movieLike then --just for the lulz
		for _, s in ipairs({...}) do 
			for _, s2 in ipairs(_M._I.lib.ut.getChars(tostring(s))) do
				w(s2)
				_M._I.org.io.flush()
				sleep(_M._I.devConf.terminal.movieLikeDelay)
			end
		end
	else
		w(getMsg(...))
	end
	w("\n")

	_M._I.debug.logfile:write(getMsg(...))
	_M._I.debug.logfile:write("\n")
	_M._I.debug.logfile:flush()

	writeCursorPos = 1 --used for write() / io.write()
	resetCursor()
end

local function get_mbs(callback, keyTable, max_i, i)
	assert(type(keyTable)=="table")
	i = tonumber(i) or 1
	max_i = tonumber(max_i) or 10
	local key_code = callback(_M._I.devConf.sleepTime)
	if _M._I.devConf.debug.logDirectInput and key_code ~= nil then
		print(key_code)
	end
	if i>max_i then
		return key_code, false
	end
	local key_resolved = keyTable[key_code]
	if type(key_resolved) == "function" then
		key_resolved = key_resolved(callback, key_code)
	end
	if type(key_resolved) == "table" then
		-- we're in a multibyte sequence, get more characters recursively(with maximum limit)
		return get_mbs(callback, key_resolved, max_i, i+1)
	elseif key_resolved then
		-- we resolved a multibyte sequence
		return key_code, key_resolved
	else
		-- Not in a multibyte sequence
		return key_code
	end
end

local function draw(text, cursorPos)
	local _, terminalHeight = getTerminalSize()

	w("\027[1;0m")
	w(ansi.setCursor:format(terminalHeight, 1))
	w(ansi.clearLine)
	w(text)
	resetCursor()
	--io.flush()
	_M._I.org.io.flush()
end

--===== initialisation =====--
textBox.listedFunction = function(t)
	_M._I.terminal.input(t.text)
end
textBox.autoCompFunction = function(t)
	_M._I.terminal.autoComp(t)
end

--===== main functions =====--
function terminal.update()
	local code, action = get_mbs(getch.non_blocking, keyTable)

	if code ~= nil then
		if _M._I.devConf.debug.logInputEvent then
			print(action)
		end
		if action ~= nil then --sending key press events defined in terminalConstants.
			local actionFragments = {}
			for fragment in string.gmatch(action, "[^_]+") do
				table.insert(actionFragments, fragment)
			end
			if actionFragments[1] == "EVENT" then
				local event = actionFragments[2]
				table.remove(actionFragments, 1)
				table.remove(actionFragments, 1)
				_M._I.event.push(event, actionFragments)
			end
		end

		if action == "RELOAD_CORE" then
			loadfile("core/lua/core/reload.lua")(_M, shared)
		elseif action == "RELOAD_USER" then
			_M._I.dl.executeDir("api/onReload", "RELOAD_USER")
		elseif action == "RELOAD_SYSTEM" then
			_M._I.dl.executeDir("core/lua/onReload", "RELOAD_SYSTEM")
		elseif action == "RELOAD_COMMANDS" then
			log("Reload commands")
			_M._I.dl.load({
				target = _M._I.commands, 
				dir = "api/commands", 
				name = "commands",
				overwrite = true,
			})
		elseif action == "tab" then	
			if _M._I.terminal.getTerminal() == nil then
				local autoComp = {}

				for i, _ in pairs(_M._I.commands) do
					table.insert(autoComp, i)
				end
				if #autoComp == 1 then
					textBox.autoCompBase = autoComp[1]
					lastAutoCompBase = textBox.autoCompBase
				end
				textBox.autoComplete = autoComp
			end

			textBox:update(terminalLength, code, action)
		else
			textBox:update(terminalLength, code, action)
		end
		drawNeeded = true
	end
	
	while debug_print:peek() ~= nil and true do
		local msgData = debug_print:pop()
		if msgData.colors then 
			w("\027[1;0m" .. msgData.colors)
		end
		print(msgData.msg)
		drawNeeded = true
	end
end

function terminal.draw()
	if not drawNeeded then return false end
	
	local terminalLength = getTerminalSize()
	
	draw(textBox:get(terminalLength))
	
	drawNeeded = false
end

terminal.print = print
--terminal.write = write

_G.print = print
--_G.io.write = write

return terminal
