local _M = ...

_G.sleep = _M._I.timer.sleep

return _M._I.timer.sleep