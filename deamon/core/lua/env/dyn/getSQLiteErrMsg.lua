local errMsgs = {
    [5] = "Database is busy. Please try again soon.",
}

return function(db, code)
    local errMsg = errMsgs[code]

    if errMsg then
        return errMsg
    else
        return "Unknown sqlite error: " .. tostring(db:errmsg())
    end
end