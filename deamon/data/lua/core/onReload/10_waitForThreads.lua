local programActiveChannel = _M.thread.getChannel("PROGRAM_IS_RUNNING")

_M.getInternal().stopThreads()

programActiveChannel:pop()
programActiveChannel:push(true)