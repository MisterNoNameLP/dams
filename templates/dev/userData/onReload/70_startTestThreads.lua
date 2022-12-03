local _I, shared = ...

log("Start test threads")

--_I.startFileThread("lua/threads/test/terminalTestThread1.lua", "TerminalTestThread#1")
--[[

log("Waiting for old test threads to stop")
local testThreadsActiveChannel = _I.thread.getChannel("TEST_THREAD_ACTIVE")
if _I.oldEnv ~= nil and _I.oldEnv.testThreads ~= nil then
	testThreadsActiveChannel:pop()
	testThreadsActiveChannel:push(false)
	
	for i, thread in pairs(_I.oldEnv.testThreads) do
		thread:wait()
	end
end

log("Starting test threads")
testThreadsActiveChannel:pop()
testThreadsActiveChannel:push(true)

_I.testThreads = {}

table.insert(_I.testThreads, select(2, _I.startFileThread("lua/threads/shared/sharedMain.lua", "SharingManagerThread")))

table.insert(_I.testThreads, select(2, _I.startFileThread("lua/threads/test/shared/sharedTestThread1.lua", "SharedTestThread#1")))
table.insert(_I.testThreads, select(2, _I.startFileThread("lua/threads/test/shared/sharedTestThread2.lua", "SharedTestThread#2")))
table.insert(_I.testThreads, select(2, _I.startFileThread("lua/threads/test/shared/sharedControlThread.lua", "SharedControlThread")))

]]

--_I.startFileThread("lua/threads/test/shared/sharedTestThread1.lua", "SharedTestThread#1")
--_I.startFileThread("lua/threads/test/shared/sharedTestThread2.lua", "SharedTestThread#2")
--_I.startFileThread("lua/threads/test/shared/sharedControlThread.lua", "SharedControlThread")

--_I.startFileThread("lua/threads/test/event/eventTestThread1.lua", "EventTestThread#1")
--_I.startFileThread("lua/threads/test/event/eventTestThread2.lua", "EventTestThread#2")
--_I.startFileThread("lua/threads/test/event/eventControllThread.lua", "eventControllThread#2")

--_I.startFileThread("lua/threads/test/http/httpTest.lua", "HTTPTest")

--_I.startFileThread("lua/threads/test/printLoop.lua", "PrintLoop")

--_I.startFileThread("lua/threads/test/corr.lua", "CORRUPTION_TEST_THREAD")

--_I.startFileThread("lua/threads/test/argTest.lua", "argTest", {t1 = "T!"})

--_I.startFileThread("lua/threads/test/sqlite/inputHandler.lua", "SQLITE_BRUTEFORCE_INPUT_HANDLER")

--_I.startFileThread("lua/threads/test/memTest/inputHandler.lua", "MEM_LEAK_TEST_INPUT_HANDLER")



