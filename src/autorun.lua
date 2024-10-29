--[[
	Configs
]]

local require = Autorun.require

local Settings = require("settings")

-- Note the lack of _G. This is to only be used in autorun files
Detour = require("detour")

local d_format = string.format
local d_getinfo = debug.getinfo
local d_collectgarbage = collectgarbage

local function getLocation(n)
	local data = d_getinfo(n, "S")
	return data and (data.source .. ":" .. n)
end

local color_white = { 199, 199, 199 }
local color_logo = { 186, 230, 126 }
local log = Autorun.log

---@param urgency number
---@param fmt string
function Log(urgency, fmt, ...)
	if urgency == 3 then
		Autorun.print( color_white, "[", color_logo, "SL", color_white, "] ", d_format( fmt, ... ) )
		return nil
	end

	-- Atrocious debug.getinfo spam
	log( d_format(fmt, ...) .. " -> " .. ( getLocation(6) or getLocation(5) or getLocation(4) or getLocation(3) or getLocation(2) ), urgency )
	return nil
end

--- Startup
Log( 3, d_format( "Safety-Lite %s by %s\n", Autorun.Plugin.VERSION, Autorun.Plugin.AUTHOR ) )
Log( 3, d_format( "Connected to %s ( %s )", GetHostName(), Autorun.IP ) )

if Settings.WhitelistedIPs[ Autorun.IP ] then
	Log( 3, "IP is whitelisted: " .. Autorun.IP .. " startup aborted." )
	return
end

--[[
	Run detours
]]

local SAFETY_MEMUSED
function MemCounter()
	local out = d_collectgarbage("count")
	if SAFETY_MEMUSED then
		return out - SAFETY_MEMUSED
	end

	return out
end

require("detour/builtins")
require("detour/debug")
require("detour/ents")
require("detour/file")
require("detour/game")
require("detour/gui")
require("detour/jit")
require("detour/mtable")
require("detour/net")
require("detour/os")
require("detour/registry")
require("detour/string")

SAFETY_MEMUSED = d_collectgarbage("count")
