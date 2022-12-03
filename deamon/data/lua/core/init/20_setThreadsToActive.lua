local _M = ...

local programActiveChannel = _M.thread.getChannel("PROGRAM_IS_RUNNING")

programActiveChannel:pop()
programActiveChannel:push(true)