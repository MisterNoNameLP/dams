local _M = ...

local channel = _M.thread.getChannel("PROGRAM_IS_RUNNING")

return function()
	return channel:peek()
end