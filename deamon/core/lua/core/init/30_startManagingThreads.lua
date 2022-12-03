local _M = ...

dlog("Starting event manager")
_M._I.startFileThread("core/lua/threads/threadManager.lua", "THREAD_MANAGER")
dlog("Starting sharing manager")
_M._I.startFileThread("core/lua/threads/sharingManager.lua", "SHARING_MANAGER")
dlog("Starting event manager")
_M._I.startFileThread("core/lua/threads/eventManager.lua", "EVENT_MANAGER")
dlog("Starting event listener")
_M._I.startFileThread("core/lua/threads/eventListener.lua", "EVENT_LISTENER")