do return end

log("TEST")

_I.shared.t1 = {}
_I.shared.t1.t2 = {}
_I.shared.t1.t2.test = "test var"
_I.shared.t1.t2[1] = "1"

log(_I.shared.t1.t2.test)
log(_I.shared.t1.t2[1])
