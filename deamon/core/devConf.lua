local devConf = {
	userLoginDatabasePath = "users.sqlite3",
	
	requirePath = "core/lua/libs/?.lua;core/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua",
	cRequirePath = "core/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so",
	terminalPath = "core/lua/core/terminal/",
	
	sleepTime = .1, --the time the terminal is waiting for an input. this affect the CPU time as well as the time debug messanges needs to be updated.
	terminalSizeRefreshDelay = 1,

	devMode = true,

	dateFormat = "%X",
	--dateFormat = "%Y/%m/%d/ %H:%M:%S",

	fallbacks = { --fallback values for non correctly setup user configs.
		name = "DAMS API",
	},

	http = {
		certPath = "cert/cert.pem",
		privateKeyPath = "cert/privatekey.pem",
		forceTLS = false,

		startHTTPServer = true,

		defaultRequestFormat = "lua-table",
		defaultResponseFormat = "lua-table",
	},

	session = {
		deleteExpiredSessions = true, --if true an expired session gets deletet if the system tryed to enter it.
		cleanupExpiredSessionsAtShutdown = true,  --if true expired sessions gets cleaned up on shutdown.
	},
	
	terminal = {
		commands = {
			forceMainTerminal = "_MT",
		},
		keys = { --char codes for specific functions
			enter = 10,
			autoComp = 9,
			
		},
		movieLike = false, --just for the lulz :)
		movieLikeDelay = .004,
	},

	preParsing = {
		loadConfLine = true,
		preparseScripts = true,
		replacePrefix = nil, --$ per default
	},
	
	sqlite = {
		busyWaitTime = .05, --defines the time the system waits every time the sqlite DB is busy.
	},
	
	onReload = {
		core = true,
	},
	
	debug = {
		logfile = "./logs/dams.log",

		logDirectInput = false,
		logInputEvent = false,

		--[[ the colors are defined per log function.
		err = "160;0" means foreground color = 160 and background color = 0.
		if a value is not defined default values are used.
		the color codes can be found in the notes dir.
		]]
		terminalColors = { 
			default = "250;0",
			err = "160",
		},
		
		logLevel = {
			debug = true,
			lowLevelDebug = false,
			threadDebug = false,
			threadEnvInit = false, --print env init debug from every thread.
			eventDebug = false,
			lowLevelEventDebug = false,
			sharingDebug = false,
			sharingThread = false,

			require = false,
			loadfile = false,

			dataLoading = true, --dyn data loading debug.
			dataExecution = true, --dyn data execution debug.
			lowDataLoading = false, --low level dyn data loading debug.
			lowDataExecution = false, --low dyn data execution debug.

			exec = false, --prints whats is executet in the shell. WARNING: if used wrong this can expose passwords in the logfile!
			user = true, --print User / login db actions.
		},
	},
}

return devConf
