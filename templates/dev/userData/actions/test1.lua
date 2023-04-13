local _I, shared, requestData = ...

_I.debug.setFuncPrefix("[TEST1]")

--dlog(_I, shared, requestData)
dlog(requestData.request.test)

shared.testValue = requestData.request.newValue

return "T1"