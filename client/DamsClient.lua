local DamsClient = {}

local htmlRequest = requrie("html.request")

function DamsClient.new(uri)
    local self = setmetatable({}, {__index = DamsClient})

    self.uri = uri

    return self
end

function DamsClient:send(requestTable)
    
end

return DamsClient