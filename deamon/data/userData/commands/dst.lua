local requestChannel = _M.thread.getChannel("SHARED_REQUEST")

log("Dumping shared table")
requestChannel:push({
    request = "dump_shared_table",
    threadID = -1,
})