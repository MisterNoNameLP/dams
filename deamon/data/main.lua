--LÖVE main file 
local version = "v0.19.1p-v1_v0.5"

function love.load(args)
	print("--===== Starting DAMS " .. tostring(version) .. " =====--")
	
	loadfile("data/lua/core/init.lua")(version, args)
end