local require = Autorun.require
local Url = require("url")

_G.gui.OpenURL = Detour.attach(gui.OpenURL, function(hk, url)
	if not Url.isWhitelisted(url) then
		return Log( 3, "Blocked unwhitelisted gui.OpenURL(%q)", url )
	end

	Log( 3, "gui.OpenURL(%q)", url )
	return hk(url)
end)

_G.gui.HideGameUI = Detour.attach(gui.HideGameUI, function(hk)
	Log( 3, "Blocked gui.HideGameUI" )
end)
