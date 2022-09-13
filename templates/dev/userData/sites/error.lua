body:addRaw([[
<style>
    div.error {
        text-align: center;
        margin: 5px 0;
        line-height: 130%;
        padding-left: 5px;
        padding-right: 5px;
        padding-top: 5px;
        padding-bottom: 5px;
    }

    .tight {
        margin: 5px 0;
    }

    .line-break {
        white-space: pre-line
    }

</style>
]])

local traceback = ""

if requestData.error.traceback ~= nil then
    traceback = [[<p class="line-break"><b>Traceback: </b>]] .. requestData.error.traceback or "" .. [[</p>]]
end

if requestData.error.msg == nil then
    requestData.error.msg = requestData.error.err
end

body:addRaw([[
    <div class="error">
        <h1>]] .. tostring(requestData.error.headline) .. [[</h1>
        <h2>]] .. tostring(requestData.error.err) .. [[</h2>
        <p class="line-break"><b>Code: </b>]] .. tostring(requestData.error.code) .. [[</p>
        <p class="line-break"><b>Description: </b>]] .. tostring(requestData.error.msg) .. [[</p>
        ]] .. traceback .. [[

    </div>
]])


return body:generateCode()