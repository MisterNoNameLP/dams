local version = "v0.2"

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

    local responseHeaders = {}
    local responseData = nil

    --set up request
    request.headers:upsert(":method", "ACTION")
    request.headers:upsert("request-format", "lua-table")
    request.headers:upsert("response-format", "lua-table")
    request:set_body(ut.tostring(requestTable))
    
    --error check
    responseHeaders, responseStream = request:go()
    if responseHeaders == nil then
        return false, 1, responseStream
    end

    responseBody, responseError = responseStream:get_body_as_string()
    if not responseBody or responseError then
        return false, 2, responseError
    end

    --process response
    for index, value in responseHeaders:each() do
        responseHeaders[index] = value
    end

    if args.getRawResponse then
        responseData = responseBody    
    else
        responseData = load(responseBody)()
    end

    return responseHeaders, responseData
end

return DamsClient
