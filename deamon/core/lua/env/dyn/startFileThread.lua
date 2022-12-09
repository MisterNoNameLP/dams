local _M, shared = ...

return function(dir, name, args)
	local thread, id = _M._I.newFileThread(dir, name, args)
	
	if thread ~= false then
		tdlog("Starting thread: " .. tostring(name) .. " (" .. tostring(thread) .. "): " .. tostring(suc))
		local _, suc = xpcall(thread.start, debug.traceback, thread)
		return suc, thread, id
	else
		warn("Cant start thread: " .. id)
	end
end