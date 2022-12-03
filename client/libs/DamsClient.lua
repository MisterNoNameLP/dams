local version = "v0.3"

local DamsClient = {}

local httpRequest = require("http.request")
local ut = require("UT")

local pa = ut.parseArgs

--===== global functions =====--
function DamsClient.new(args)
    local self = setmetatable({}, {__index = DamsClient})
    args = pa(args, {})

    self.uri = assert(args.uri, "No valid URI set")
    self.timeout = pa(args.timeout, 3)

    return self
end

function DamsClient:request(requestTable, args)
    assert(type(requestTable) == "table", "No valid request table given")
    args = pa(args, {})

    --setting up local vars
    local request = httpRequest.new_from_uri(self.uri)

    local responseHeaders, responseStream, responseBody, responseError

    --set up request
    request.headers:upsert(":method", "ACTION")
    request.headers:upsert("request-format", "lua-table")
    request.headers:upsert("response-format", "lua-table")
    request:set_body(ut.tostring(requestTable))
    
    --error check
    responseHeaders, responseStream = request:go()
    if responseHeaders == nil then
        return false, nil, responseStream
    end

    --build header table
    for index, value in responseHeaders:each() do
        responseHeaders[index] = value
    end

    --get response body
    responseBody, responseError = responseStream:get_body_as_string()
    if not responseBody or responseError then
        return false, responseHeaders, responseError
    end

    --build response
    if args.getRawResponse then
        return nil, responseHeaders, responseBody
    elseif responseHeaders["dams-version"] == nil or responseHeaders["content-type"] ~= "lua-table" then
        return false, responseHeaders, responseBody
    else --BUG; DANGEROUS; CRUCIAL; executing the response opens a door to execute harmful code!
        local _, responseData = pcall(load(responseBody))

        if not responseData.success then
            return false, responseHeaders, responseData
        else
            return true, responseHeaders, responseData.returnValue
        end
    end
end

return DamsClient
