local _M = ...

--local serialize = require("ser")

return function(code, initData)
	local initData = _M._I.ut.parseArgs(initData, {})
	initData.mainThread = false
	
	local newCode = [[
		local _M, shared = loadfile('core/lua/env/envInit.lua')(]] .. _M._I.serialization.line(initData) .. [[); ]] .. code .. [[
		
		do
			local suc, err = xpcall(function()	
				if type(update) == 'function' then --main while (incl. event handler)
					while _M._I.isRunning() and _M._I.threadIsRunning() do
						local suc, err
						
						_M._I.event.pull()
						
						suc, err = xpcall(update, debug.traceback)
						
						if suc ~= true then
							debug.err(suc, err)
						end
					end
				else --only event handler
					while _M._I.isRunning() and _M._I.threadIsRunning() do
						_M._I.event.pull(1)
					end
				end
				
				do --on program stop
					if type(stop) == "function" then
						local suc, err = xpcall(stop, debug.traceback)
						
						if suc ~= true then
							debug.err(suc, err)
						end
					end
				end
				
			end, debug.traceback)
			if suc ~= true then
				debug.setLogPrefix("[INTERNAL_ERROR]" .. debug.getLogPrefix())
				debug.fatal(suc, err)
			end
		end


		
	]]
	
	return newCode
end