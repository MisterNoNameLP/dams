local _M = ...

return function()
	return getmetatable(_M)._internal.threadIsActive
end