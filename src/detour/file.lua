local d_SysTime = SysTime
local d_Open = file.Open
local d_type = type
local pairs = pairs

local lastRemove = 0
local trashBin = {}
local counter = 0

local function Read( filename, path )
	local f = d_Open( filename, "rb", path )
	if f then
		return f:Read( f:Size() ) or "", f:Close()
	end

	return ""
end

local function Write( filename, contents )
	local f = d_Open( filename, "wb", "DATA" )
	if f then
		f:Write( contents )
		f:Close()
	end
end

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
			Write( filePath, content )
			trashBin[ filePath ] = nil
		end

		return nil
	end

	trashBin[ name ] = Read( name, "DATA" )
	lastRemove = sysTime
	return hk( name )
end)
