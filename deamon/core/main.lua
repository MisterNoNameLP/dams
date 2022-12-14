--LÖVE main file 
local version = "v0.19.1p-v1_14"

function love.load(args)
	print("--===== Starting DAMS " .. tostring(version) .. " =====--")
	
	loadfile("core/lua/core/init.lua")(version, args)
end