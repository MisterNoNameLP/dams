_M.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump_lockTable",
    threadID = _M.getThreadInfos().id,
})