debug.setLogPrefix("[BACKUP_MANAGER]")

log("Init")

_E.event.listen("RELOAD_BACKUP_MANAGER", function()
    log("Reload")
    _E.stop()
end)

_E.event.listen("PULL_BACKUP", function(args)
    if _S.backup[args.backup].status == "queued" then
        local suc, logString
        log("Processing pull request: " .. args.backup)
        _S.backup[args.backup].status = "pulling"
        suc, logString = osExec("ltrs/ltrs " .. args.backup)
        if suc ~= 0 then
            crucial("Pulling backup failed: " .. args.backup .. "; log:\n" .. logString)
            _S.backup[args.backup].status = "failed"   
            _S.backup[args.backup].log = logString   
        else
            log("Sucessfully pulled backup: " .. args.backup .. "; log:\n" .. logString)
            _S.backup[args.backup].status = "done"   
            _S.backup[args.backup].log = logString  
        end
    else
        crucial("Cant process backup: " .. args.backup .. "; status is: " .. _S.backup[args.backup].status)
        _S.backup[args.backup].status = "failed"
        _S.backup[args.backup].reason = "Invalid status"
    end
end)

log("Done")