return function()
	_M._I.event.ignoreAll()
	getmetatable(_M)._internal.threadIsActive = false
end