local _M = ...

dlog("Loading libs")


--===== load libs =====--
--NOTE: could add dynamic lib loading to reduce processing time of thread init.

_M.lib = {}

_M.lib.thread = require("love.thread")
_M.lib.timer = require("love.timer")
_M.lib.serialization = require("serpent")

_M.lib.cqueues = require("cqueues")
_M.lib.sqlite = require("lsqlite3complete")

_M.lib.fs = require("love.filesystem")
_M.lib.ut = require("UT")
_M.lib.lfs = require("lfs")
_M.lib.argon2 = require("argon2")
_M.lib.ini = require("LIP")


--====== legacy =====--
--ToDo: have to be removed from older source files.
_M.thread = require("love.thread")
_M.timer = require("love.timer")
_M.serialization = require("serpent")

_M.cqueues = require("cqueues")
_M.sqlite = require("lsqlite3complete")
