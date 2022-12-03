_M.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump",
    threadID = _M.getThreadInfos().id,
})