local body = env.dyn.html.Body.new()

body:addP("Palala: " .. body.addLink("example.com"))
--body:addP("test text")

return body:generateCode()