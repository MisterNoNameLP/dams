local _M = ...

local channel = _M._I.thread.getChannel("PROGRAM_IS_RUNNING")

return function()
	return channel:peek()
end