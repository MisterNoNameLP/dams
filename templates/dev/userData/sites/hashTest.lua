local requestData = ...
local randomFile = io.open("/dev/random")

log("ENCODE")


local encoded = env.lib.argon2.hash_encoded("password", randomFile:read(128), {
    t_cost = 3,
    m_cost = 4 * 1024,
    parallelism = 8,
})

log(encoded)
log("DECODE")
log(env.lib.argon2.verify(encoded, "passwd"))
log("DONE")


do --brute force test
    local socket = require("socket")
    local startTime, endTime

    log("BF start")
    startTime = socket.gettime()
    for c = 0, 10 do
        env.lib.argon2.verify(encoded, "passwd")
    end
    endTime = socket.gettime() - startTime
    log("BF done")

    log(endTime * 1000)
end


return "Hash test"