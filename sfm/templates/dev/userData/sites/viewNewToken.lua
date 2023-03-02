body:addHead([[
    <style>
        body {
            text-align: center;
        }

    </style>
]])

body:addRaw([[
<div>
    <h1>New token</h1>
    <p>This token can only be seen right now. It will not be possible to show it ever again.</p>
    <p><b>Token: </b> ]] .. tostring(request.token) .. [[</p>
</div>
]])

--body:addGoBackButton(requestData, "Go back")

return body:generateCode()