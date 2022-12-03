local _M = ...

dlog("Starting event manager")
_M._I.startFileThread("lua/threads/threadManager.lua", "THREAD_MANAGER")
dlog("Starting sharing manager")
_M._I.startFileThread("lua/threads/sharingManager.lua", "SHARING_MANAGER")
dlog("Starting event manager")
_M._I.startFileThread("lua/threads/eventManager.lua", "EVENT_MANAGER")
dlog("Starting event listener")
_M._I.startFileThread("lua/threads/eventListener.lua", "EVENT_LISTENER")