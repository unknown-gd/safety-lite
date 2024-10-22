local require = Autorun.require
local Settings = require("settings")

_G.net.Start = Detour.attach(net.Start, function(hk, str, unreliable)
	if Settings.BlockedNetMessages[str] then
		return Log(3, "Blocked net.Start(%q, %s)!", str, unreliable)
	end

	Log( 5, "net.Start(%s, %s)", str, unreliable )

	return hk(str,unreliable)
end)
