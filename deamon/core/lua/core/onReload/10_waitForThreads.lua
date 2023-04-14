local programActiveChannel = _M._I.thread.getChannel("PROGRAM_IS_RUNNING")

_M._I.getInternal().stopThreads()

programActiveChannel:pop()
programActiveChannel:push(true)