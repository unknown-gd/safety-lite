local d_Write = file.Write
local d_SysTime = SysTime
local d_Read = file.Read
local d_type = type
local pairs = pairs

local lastRemove = 0
local trashBin = {}
local counter = 0

local sysTime = 0

_G.file.Delete = Detour.attach(file.Delete, function(hk, name)
	local name_ty = d_type(name)
	if name_ty ~= "number" and name_ty ~= "string" then
		-- Error
		return hk(name)
	end

	sysTime = d_SysTime()

	if ( sysTime - lastRemove ) < 1 then
		counter = counter + 1
	else
		for filePath in pairs( trashBin ) do
			trashBin[ filePath ] = nil
		end

		counter = 1
	end

	if counter > 32 then
		Log( 2, "Someone tried to delete too many files at once! [%s]", name )

		for filePath, content in pairs( trashBin ) do
			d_Write( filePath, content )
			trashBin[ filePath ] = nil
		end

		return nil
	end

	trashBin[ name ] = d_Read( name, "DATA" )
	lastRemove = sysTime
	return hk( name )
end)
