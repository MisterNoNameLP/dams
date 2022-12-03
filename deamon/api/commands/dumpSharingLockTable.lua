_M._I.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump_lockTable",
    threadID = _M._I.getThreadInfos().id,
})