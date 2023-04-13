log("Starting thread manager")

local threadRegistrationChannel = _M._I.thread.getChannel("THREAD_REGISTRATION")
local activeThreadsChannel = _M._I.thread.getChannel("ACTIVE_THREADS")

local function newThread(thread) 
	if thread ~= nil then
		tdlog("Registering new thread (".. tostring(thread.id) .."): " .. _M._I.ut.parseArgs(thread.name, "UNKNOWN") .. "(" .. tostring(thread.thread) .. ")")
		
		activeThreadsChannel:push(thread)
	end
end

local function update()
	newThread(threadRegistrationChannel:demand(1))
end

_I.keepAlive()