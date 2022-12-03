-- reloads the main _M._I. not affecting thread environments yet.

_M._I.dl.load({
	target = _M._I, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
	overwrite = true,
})

_M._I.dl.load({ --legacy
	target = _M, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
	overwrite = true,
})

for i, c in pairs(_M._I._G) do
	_G[i] = c
end