return function(requestData)
    local referer = _M._I.http.getReferer(requestData, true)
    local returnString = [[
<html>
    <head>
        <title>Success!</title>  
    </head>    
    <h3>Success!</h3>
]]

    if referer then
        returnString = returnString .. [[
<body>     
    <a href="]]..referer..[[">  
        <input type="button" value="Go back"/>  
    </a>    
</body>    
]] 
    end
    
    return returnString .. "\n</html>"
end