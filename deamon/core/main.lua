--LÖVE main file 
--this version is based on v0.19.1
<<<<<<< HEAD
local version = "1.0-prerelease-43"
=======
local version = "1.0-prerelease-44"
>>>>>>> b29c425b93f20094192a84d87a50c60e69b33d9e

function love.load(args)
	print("--===== Starting DAMS v" .. tostring(version) .. " =====--")
	
	loadfile("core/lua/core/init.lua")(version, args)
end