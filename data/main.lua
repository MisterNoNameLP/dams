--LÖVE main file 
local version = "v0.8"

function love.load(args)
	print("--===== Starting DAMS " .. tostring(version) .. " =====--")
	
	loadfile("data/lua/core/init.lua")(version, args)
end