local require = Autorun.require
local Util = require("util")

local WhitelistedIPs = Util.LUTSetting("WhitelistedIPs")
WhitelistedIPs.loopback = true

return {
	BlockedNetMessages = Util.LUTSetting("BlockedNetMessages"),
	BlockedConcommands = Util.LUTSetting("BlockedConcommands"),
	WhitelistedIPs = WhitelistedIPs
}
