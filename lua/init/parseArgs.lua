local main, args = ...
local parser = require("lua.libs.thirdParty.argparse")("DAMS")



parser:flag("-v --version", "prints DAMS version"):target("version")
parser:flag("-D --dev", "forces dev mode"):target("devMode")



args = parser:parse(args)

if args.version then
	print("DAMS " .. main.version)
	os.exit(0)
end

if args.devMode then
	main.devConf.devMode = true
end

return args