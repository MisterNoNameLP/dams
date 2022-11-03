local DamsClient = {}

local htmlRequest = requrie("html.request")

--===== local functions =====--
function pa(...) --ripped from UT (v0.8.7) by MisterNoNameLP
	for _, a in pairs({...}) do
		if a ~= nil then
			return a
		end
	end
end

--===== global functions =====--
function DamsClient.new(uri, args)
    local self = setmetatable({}, {__index = DamsClient})

    self.uri = uri
    self.timeout = pa(args.timeout, 3)

    return self
end

function DamsClient:request(request, args)
    
end

return DamsClient
