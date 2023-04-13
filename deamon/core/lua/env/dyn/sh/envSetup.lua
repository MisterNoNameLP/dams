return function(envTable)
    local execString = "_M "

    for index, value in pairs(envTable) do
        execString = execString .. index .. "=\"" .. tostring(value) .. "\" " 
    end

    return execString
end