/*-------------------------------------------------------------------------------------------------------------------------
	This command eliminate serverlags. Very useful if crappy adv-dupe shit got spawned and fuck up the server.
	Visit http://www.rodcust.eu/
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Lag"
PLUGIN.Description = "With !lag you can freeze all props at once."
PLUGIN.Author = "dOiF [AUT]"
PLUGIN.ChatCommand = "lag"
PLUGIN.Privileges = { "Lag" }

function PLUGIN:Call( ply )
	if ( ply:EV_HasPrivilege( "Lag" ) ) then
	local Ent = ents.FindByClass("prop_physics")
		for _,Ent in pairs(Ent) do
			if Ent:IsValid() then
				local phys = Ent:GetPhysicsObject()
				phys:EnableMotion(false)
			end
		end
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has frozen all props on the server." )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
	
end

evolve:RegisterPlugin( PLUGIN )
