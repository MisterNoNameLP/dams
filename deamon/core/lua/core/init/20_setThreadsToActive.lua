local _M = ...

local programActiveChannel = _M._I.thread.getChannel("PROGRAM_IS_RUNNING")

programActiveChannel:pop()
programActiveChannel:push(true)