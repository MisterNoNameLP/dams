return function()
	_M.event.ignoreAll()
	getmetatable(_M)._internal.threadIsActive = false
end