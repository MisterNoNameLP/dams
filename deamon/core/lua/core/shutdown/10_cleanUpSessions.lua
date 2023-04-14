if _M._I.devConf.session.cleanupExpiredSessionsAtShutdown then
    log("Cleanup expired sessions")
    --log(_M._I.userDB:exec([[DELETE FROM sessions WHERE expireTime != -1 AND expireTime <= ]] .. os.time() .. [[]]))
    log(_M._I.userDB:exec([[DELETE FROM sessions WHERE deletionTime != -1 AND deletionTime <= ]] .. os.time() .. [[]]))
end