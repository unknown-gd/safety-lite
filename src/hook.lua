local files = Autorun.Plugin.Settings.BlockedLuaFiles
if not files then
    return nil
end

local fileName = string.lower( Autorun.NAME )
local find = string.find

for index = 1, #files do
    if find( fileName, files[ index ], 1, false ) ~= nil then
        Autorun.log( "[SL] File " .. fileName .. " was blocked from running.", 2 )
        return true
    end
end
