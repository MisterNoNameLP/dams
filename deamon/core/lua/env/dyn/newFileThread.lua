local _M, shared = ...

local idChannel = _M._I.thread.getChannel("GET_THREAD_ID")
local threadRegistrationChannel = _M._I.thread.getChannel("THREAD_REGISTRATION")

return function(dir, name, args)
	ldlog("Load thread " .. name .. " from file: " .. dir)

	if type(name) == "string" then name = "[" .. name .. "]" end
	local suc, file = pcall(io.open, dir, "r")
	local threadID, threadCode

	if type(file) == "userdata" then
		local thread

		threadID = idChannel:push(name); idChannel:pop() --potential BUG if 2 threads acll this line at the exact same moment.
		threadCode = _M._I.getThreadInitCode(file:read("*all"), {name = name, id = threadID, args = args, damsVersion = _M._I.damsVersion})
		file:close()

		thread = _M._I.thread.newThread(threadCode)
		
		threadRegistrationChannel:push({
			thread = thread,
			name = name,
			id = threadID,
		})
		
		return thread, threadID
	else
		warn("Cant load thread from file: (" .. dir .. ")")
		return false, "File not found"
	end
end