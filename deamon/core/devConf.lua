local devConf = {
	userDatabasePath = "users.sqlite3", --contains user, permissions and session data.
	dataDatabasePath = "data.sqlite3", --contains data used by API functions (_DB).
	
	requirePath = "core/lua/libs/?.lua;core/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua",
	cRequirePath = "core/bin/libs/?.so;",
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
		busyWaitTime = .5, --defines the time the system waits every time the sqlite DB is busy.
		maxBusyTries = 10, --defines how often the priogeam will try to accoplish new sqlite actions if the database is busy.
	},
	
	onReload = {
		core = true,
	},
	
	debug = {
		logfile = "./logs/dams.log",

		logDirectInput = false,
		logInputEvent = false,

		--[[ the colors are defined per log function.
		it uses ANSI escape sequences to achiev colors.
		8bit color codes can be found in the notes dir.

		more information about ANSI escape codes can be douns here: https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
		]]
		terminalColors = { 
			default = "\027[38;5;250m",
			log = "\027[38;5;250m",
			dlog = "\027[38;5;68m",
			warn = "\027[38;5;178m",
			--err = "\027[38;5;124m",
			err = "\027[38;5;160m",
			crucial = "\027[48;5;52m",
			fatal = "\027[48;5;88m\027[38;5;196m",

			--[[
			default = "250,0",
			log = "250,0",
			warn = "184",
			err = "124,0",
			crucial = "0,124",
			fatal = "232,88",
			]]
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

			plealTranspiling = false,
			require = false,
			loadfile = false,

			dataLoading = true, --dyn data loading debug.
			dataExecution = true, --dyn data execution debug.
			lowDataLoading = false, --low level dyn data loading debug.
			lowDataExecution = false, --low dyn data execution debug.

			exec = false, --prints whats is executet in the shell. WARNING: if used wrong this can expose passwords in the logfile!
			user = false, --print User / login db actions.
			dataDB = false, --prints dataDB actions.
		},
	},
}

return devConf

