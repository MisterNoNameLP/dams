--LÖVE main file 
--this version is based on v0.19.1
local version = "1.0-prerelease-46"

function love.load(args)
	print("--===== Starting DAMS v" .. tostring(version) .. " =====--")
	
	loadfile("core/lua/core/init.lua")(version, args)
end