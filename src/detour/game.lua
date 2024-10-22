_G.game.MountGMA = Detour.attach(game.MountGMA, function(hk, path)
	Log( 3, "Mounting GMA: %q", path )
	return hk(path)
end)
