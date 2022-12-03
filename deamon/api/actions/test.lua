response.testValue = request.value

log(tostring(_M), tostring(_E), tostring(_D), tostring(_I))

log("\n_M #################")
for i, v in pairs(_M) do
    log(i, v)
end

log("\n_M._I #################")
for i, v in pairs(_M._I) do
    log(i, v)
end

return response

