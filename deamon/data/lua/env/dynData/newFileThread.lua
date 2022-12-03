local _M, shared = ...

local idChannel = _M.thread.getChannel("GET_THREAD_ID")
local threadRegistrationChannel = _M.thread.getChannel("THREAD_REGISTRATION")

return function(dir, name, args)
	ldlog("Load thread " .. name .. " from file: " .. dir)

	if type(name) == "string" then name = "[" .. name .. "]" end
	local suc, file = pcall(io.open, "data/" .. dir, "r")
	local threadID, threadCode

	if type(file) == "userdata" then
		local thread

		threadID = idChannel:push(name); idChannel:pop() --potential BUG if 2 threads acll this line at the exact same moment.
		threadCode = _M.getThreadInitCode(file:read("*all"), {name = name, id = threadID, args = args, damsVersion = _E.damsVersion})
		file:close()

		thread = _M.thread.newThread(threadCode)
		
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