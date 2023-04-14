local _M = ...

dlog("Loading libs")


--===== load libs =====--
--NOTE: could add dynamic lib loading to reduce processing time of thread init.

_M._I.lib = {}

_M._I.lib.thread = require("love.thread")
_M._I.lib.timer = require("love.timer")
_M._I.lib.serialization = require("serpent")

_M._I.lib.cqueues = require("cqueues")
_M._I.lib.sqlite = require("lsqlite3complete")

_M._I.lib.fs = require("love.filesystem")
_M._I.lib.ut = require("UT")
_M._I.lib.lfs = require("lfs")
_M._I.lib.argon2 = require("argon2")
_M._I.lib.ini = require("LIP")
_M._I.lib.json = require("json")

_M._I.lib.pleal = require("plealTranspilerAPI")
_M._I.lib.pleal.setLogFunctions({
	log = debug.plealTranspilingLog, 
	warn = debug.warn, 
	err = debug.error
})


--====== legacy =====--
--ToDo: have to be removed from older source files.
_M._I.thread = require("love.thread")
_M._I.timer = require("love.timer")
_M._I.serialization = require("serpent")

_M._I.cqueues = require("cqueues")
_M._I.sqlite = require("lsqlite3complete")
