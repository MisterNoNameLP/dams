local env, shared, requestData = ...

env.debug.setFuncPrefix("[TEST1]")

--dlog(env, shared, requestData)
dlog(requestData.request.test)

shared.testValue = requestData.request.newValue

return "T1"