if _M.devConf.session.cleanupExpiredSessionsAtShutdown then
    log("Cleanup expired sessions")
    --log(_M.loginDB:exec([[DELETE FROM sessions WHERE expireTime != -1 AND expireTime <= ]] .. os.time() .. [[]]))
    log(_M.loginDB:exec([[DELETE FROM sessions WHERE deletionTime != -1 AND deletionTime <= ]] .. os.time() .. [[]]))
end