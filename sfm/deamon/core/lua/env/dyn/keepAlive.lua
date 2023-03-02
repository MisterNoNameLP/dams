return function()
	getmetatable(_M)._internal.threadIsActive = true
end