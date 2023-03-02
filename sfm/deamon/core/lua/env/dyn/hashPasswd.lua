return function(password)
	local randomFile = io.open("/dev/random")

	return string.sub(_M._I.lib.argon2.hash_encoded(password, randomFile:read(128), {
		t_cost = 3,
		m_cost = 4 * 1024,
		parallelism = 8,
	}), 0, -2)
end