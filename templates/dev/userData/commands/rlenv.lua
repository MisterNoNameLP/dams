-- reloads the main _M._I. not affecting thread environments yet.

_M._I.dl.load({
	target = _M._I, 
	dir = "core/lua/_I/dyn", 
	name = "dyn", 
	structured = true,
	execute = true,
	overwrite = true,
})

_M._I.dl.load({ --legacy
	target = _M, 
	dir = "core/lua/_I/dyn", 
	name = "dyn", 
	structured = true,
	execute = true,
	overwrite = true,
})

for i, c in pairs(_M._I._G) do
	_G[i] = c
end