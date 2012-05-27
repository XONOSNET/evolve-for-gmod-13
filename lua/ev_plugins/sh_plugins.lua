/*-------------------------------------------------------------------------------------------------------------------------
	Run a console command on the server
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Plugin-List"
PLUGIN.Description = "Shows all loaded Plugins in Console"
PLUGIN.Author = "Northdegree"
PLUGIN.ChatCommand = "plugins"
PLUGIN.Usage = ""
PLUGIN.Privileges = { "ListPlugins" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "ListPlugins" )) then
		print("----------------   Loaded Plugins:   ----------------")
		for key, plugin in ipairs( evolve.plugins ) do
			ply:ChatPrint(""..key..": "..plugin.Title.." ("..plugin.File..")")
		end
		print("-----------------------------------------------------")
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )