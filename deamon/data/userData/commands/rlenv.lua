-- reloads the main _M. not affecting thread environments yet.

_M.dl.load({
	target = _M.dyn, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
	overwrite = true,
})

_M.dl.load({ --legacy
	target = _M, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
	overwrite = true,
})

for i, c in pairs(_M._G) do
	_G[i] = c
end