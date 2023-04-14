--default debug _M for all threads.

local devConf, defaultPrefix, _M = ...
local _I = _M._I

local orgDebug = _G.debug
local debug = {
	global = {},
	
	internal = {
		logPrefix = "",
		debugPrefix = "",
		internalPrefix = "",
		functionPrefixes = {},
	},
	
	debug = orgDebug,
	orgDebug = orgDebug,

	silenceMode = false,

	currentColors
}

--===== set basic log functions =====--
local function mail(subject, text, ...)
	if _I.mail then
		_I.mail(subject, text, ...)
	end
end

local function getSilenceMode()
	return debug.silenceMode
end
local function setSilenceMode(silence)
	debug.silenceMode = silence
end

local function getDebugPrefix()
	return debug.internal.debugPrefix
end
local function setDebugPrefix(prefix)
	debug.internal.debugPrefix = tostring(prefix)
end

local function getFuncPrefix(stackLevel, fullPrefixStack)
	local prefix, exclusive = "", false
	local prefixTable
	if fullPrefixStack == nil then fullPrefixStack = true end
	
	if stackLevel == nil or type(stackLevel) == "number" then 
		prefix, exclusive, fullStack = getFuncPrefix(orgDebug.getinfo(stackLevel or 2).func)
	elseif type(stackLevel) == "function" then
		local prefixTable = debug.internal.functionPrefixes[stackLevel]
		if prefixTable == nil then
			return "", false
		else
			return tostring(prefixTable.prefix), prefixTable.exclusive, prefixTable.fullStack
		end	
	end
	
	if fullPrefixStack and fullStack or fullStack == nil then
		for stackLevel = stackLevel +1, math.huge do
			local stackInfo = orgDebug.getinfo(stackLevel)
			local stackPrefix = ""
			local stackExclusive, fullStack
		
			if stackInfo == nil then break end
		
			stackPrefix, stackExclusive, fullStack = getFuncPrefix(stackInfo.func)
			
			if stackExclusive then
				exclusive = true
			end
			
			prefix = stackPrefix .. prefix
			
			if fullStack == false then
				break
			end
		end
	end
	
	return tostring(prefix), exclusive
end
local function setFuncPrefix(prefix, exclusive, noFullStack, stackLevel) 
	local prefixTable = {}
	local func
	
	if stackLevel == nil or type(stackLevel) == "number" then
		func = orgDebug.getinfo(stackLevel or 2).func
	elseif type(stackLevel) == "function" then
		func = stackLevel
	end
	
	if prefix ~= nil then
		prefixTable.prefix = prefix
		prefixTable.exclusive = exclusive
		if noFullStack == false or noFullStack == nil then
			prefixTable.fullStack = true
		else
			prefixTable.fullStack = false
		end
		debug.internal.functionPrefixes[func] = prefixTable
	else
		debug.internal.functionPrefixes[func] = nil
	end
end
local function setInternalPrefix(prefix)
	debug.internal.internalPrefix = prefix
end
local function getInternalPrefix(prefix)
	return debug.internal.internalPrefix
end

local function getLogPrefix()
	return tostring(debug.internal.logPrefix)
end
local function setLogPrefix(prefix, keepPrevious)
	if keepPrevious then
		debug.internal.logPrefix = getLogPrefix() .. prefix
	else
		debug.internal.logPrefix = prefix
	end
end

local function setColors(colors)
	local firstRun = true
	if not colors then
		colors = _I.devConf.debug.terminalColors.default
	end
	debug.currentColors = colors
end

local function clog(...) --clean log
	local msgs, msgString = "", ""
	
	for _, msg in pairs({...}) do
		msgs = msgs .. tostring(msg) .. "  "
	end

	msgString = "[" .. os.date(_I.devConf.dateFormat) .. "]" .. getInternalPrefix() .. msgs

	if not debug.silenceMode then
		--print(_I.mainThread, _I.terminal, _I.initData.logfile, msgString)
		print(msgString)
	end
	setInternalPrefix("")
	return ...
end
local function plog(...)
	local prefix = ""
	local funcPrefix, allowLogPrefix = getFuncPrefix(3)
	
	if allowLogPrefix then
		prefix = funcPrefix .. prefix
	else
		prefix = getLogPrefix() .. funcPrefix .. prefix
	end	
	prefix = prefix .. ":"
	
	setInternalPrefix(getDebugPrefix() .. prefix .. " ")
	clog(...)
	
	setDebugPrefix("")
	return ...
end
local function log(...)
	setDebugPrefix("[INFO]")
	setColors(_I.devConf.debug.terminalColors.log)
	plog(...)
	return ...
end
local function warn(...)
	setDebugPrefix("[WARN]")
	setColors(_I.devConf.debug.terminalColors.warn)
	plog(...)
	return ...
end
local function err(...)
	local silenceMode = debug.getSilenceMode()
	debug.setSilenceMode(false)
	setDebugPrefix("[ERROR]")
	setColors(_I.devConf.debug.terminalColors.err)
	plog(...)
	if silenceMode then
		debug.setSilenceMode(true)
	end
	return ...
end
local function crucial(...)
	local silenceMode = debug.getSilenceMode()
	debug.setSilenceMode(false)
	setDebugPrefix("[CRUCIAL]")
	setColors(_I.devConf.debug.terminalColors.crucial)
	plog(...)
	if silenceMode then
		debug.setSilenceMode(true)
	end
	mail("[CRUCIAL]", ...)
	return ...
end
local function fatal(...)
	setDebugPrefix("[FATAL]")
	setColors(_I.devConf.debug.terminalColors.fatal)
	plog(...)
	--love.quit(1, ...) --ToDo: replace with an exit event once event system is done.
	--os.exit(1)
	mail("[FATAL]", ...)
	if _G._I.stopProgram() then
		_G._I.stopProgram()
	else
		io.stderr:write("Usual stopProgram routine not avaiable. Not even fully initialized?")
		for _, line in pairs({...}) do
			io.stderr:write(tostring(line))
		end
		io.stderr:flush()
		--os.exit(1)
	end
	return ...
end

--===== add advanced log levels =====--
local function addDebugLogLevel(name, prefix, confLevelIndex, global)
	local func = function(...) return ... end
	
	if devConf.devMode and devConf.debug.logLevel[confLevelIndex] then
		func = function(...)
			setColors(_I.devConf.debug.terminalColors[name])
			setDebugPrefix(prefix)
			plog(...)
			return ...
		end
	end
	
	debug[name] = func
	if global then
		debug.global[name] = func
	end
end

addDebugLogLevel("dlog", "[DEBUG]", "debug", true)
addDebugLogLevel("ldlog", "[LOW_DEBUG]", "lowLevelDebug", true)
addDebugLogLevel("tdlog", "[THREAD_DEBUG]", "threadDebug", true)
addDebugLogLevel("edlog", "[EVENT_DEBUG]", "eventDebug", true)
addDebugLogLevel("ledlog", "[LOW_EVENT_DEBUG]", "lowLevelEventDebug", true)
addDebugLogLevel("sharingDebug", "[SHARING_DEBUG]", "sharingDebug", false)
addDebugLogLevel("sharingThreadLog", "[SHARIG_THREAD]", "sharingThread", false)
addDebugLogLevel("requireLog", "[REQUIRE]", "require", false)
addDebugLogLevel("plealTranspilingLog", "[PLEAL]", "plealTranspiling", false)
addDebugLogLevel("loadfileLog", "[LOADFILE]", "loadfile", false)
addDebugLogLevel("dataLoadingLog", "[DATA_LOADING]", "dataLoading", false)
addDebugLogLevel("lowDataLoadingLog", "[LOW_DATA_LOADING]", "lowDataLoading", false)
addDebugLogLevel("dataExecutionLog", "[DATA_EXECUTION]", "dataExecution", false)
addDebugLogLevel("lowDataExecutionLog", "[LOW_DATA_EXECUTION]", "lowDataExecution", false)
addDebugLogLevel("exec", "[EXEC]", "exec", false)
addDebugLogLevel("ulog", "[USER]", "user", false)
addDebugLogLevel("dataDBLog", "[DATA_DB]", "dataDB", false)

--===== set debug function =====--
setLogPrefix(defaultPrefix)

debug.clog = clog
debug.plog = plog
debug.log = log
debug.warn = warn
debug.err = err
debug.crucial = crucial
debug.fatal = fatal

debug.setSilenceMode = setSilenceMode
debug.getSilenceMode = getSilenceMode

debug.setLogPrefix = setLogPrefix
debug.getLogPrefix = getLogPrefix

debug.setFuncPrefix = setFuncPrefix
debug.getFuncPrefix = getFuncPrefix

debug.setDebugPrefix = setDebugPrefix
debug.getDebugPrefix = getDebugPrefix

debug.setColors = setColors

--===== set global debug functions =====--
debug.global.clog = clog
debug.global.plog = plog
debug.global.log = log
debug.global.warn = warn
debug.global.err = err
debug.global.crucial = crucial
debug.global.fatal = fatal

--=== set global metatables ===--
_G.debug = setmetatable(orgDebug, {__index = function(t, i)
	if debug[i] ~= nil then
		return debug[i]
	else
		return nil
	end
end})

_G = setmetatable(_G, {__index = function(t, i)
	return debug.global[i]
end})

--=== init ===--
setColors()

return debug