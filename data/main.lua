--LÖVE main file 
local version = "v0.0.9"

function love.load(args)
	print("--===== Starting DAMS " .. tostring(version) .. " =====--")
	
	loadfile("data/lua/core/init/init.lua")(version, args)
end