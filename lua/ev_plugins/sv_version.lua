/*-------------------------------------------------------------------------------------------------------------------------
	Evolve version
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Version"
PLUGIN.Description = "Returns the version of Evolve."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = { "version", "about" }

function PLUGIN:Call( ply, args )
	evolve:Notify( ply, evolve.colors.white, "This server is running ", evolve.colors.red, "revision " .. evolve.version, evolve.colors.white, " of Evolve." )
end

function PLUGIN:PlayerInitialSpawn( ply )
	if ( ply:EV_IsOwner() ) then
		if ( !self.LatestVersion ) then
			http.Get( "http://evolve.sg-community.de/version.php", "", function( src )
				self.LatestVersion = tonumber( src )
				self:PlayerInitialSpawn( ply )
			end )
			return
		end
		
		if ( evolve.version < self.LatestVersion ) then
			evolve:Notify( ply, evolve.colors.red, "Warning: A newer Version of Evolve is available!" )
			evolve:Notify( ply, evolve.colors.green, "Newest Version: "..self.LatestVersion, evolve.colors.white.." - "..evolve.colors.red.."You're using Version: "..evolve.version, evolve.colors.white.."!" )
		end
	end
end

evolve:RegisterPlugin( PLUGIN )