local requestData = ...
local returnString = "<!DOCTYPE html> <html>"


log("TTTT")


returnString = returnString .. "<h3>Raw request: </h3><p>" .. requestData.body .. "</p>"
returnString = returnString .. "<h3>Decoded request: </h3><p>" .. env.lib.ut.tostring(requestData.request) .. "</p>"

return {html = {body = returnString .. "</html>" .. env.dyn.html.code.success(requestData)}}