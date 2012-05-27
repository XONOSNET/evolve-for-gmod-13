/*-------------------------------------------------------------------------------------------------------------------------
	Ban a player
		To do: Clean up this piece of shit.
-------------------------------------------------------------------------------------------------------------------------*/
--                             VERBINDE MIT DATENBANK
require("tmysql");

tmysql.initialize("nope", "isaidnope", "cantyouread?", "ahhhh! Fuck you!", 3306);
-----------------------------------------------------------------------------
local PLUGIN = {}
PLUGIN.Title = "BanID"
PLUGIN.Description = "Ban a player by the Steam-ID."
PLUGIN.Author = "Northdegree"
PLUGIN.ChatCommand = "banid"
PLUGIN.Usage = "<steamid> [time=5] [reason]"
PLUGIN.Privileges = { "BanID", "PermabanID" }

function PLUGIN:Call( ply, args )
	local time = math.Clamp( tonumber( args[2] ) or 5, 0, 200000 )
	
	if ( ( time > 0 and ply:EV_HasPrivilege( "BanID" ) ) or ( time == 0 and ply:EV_HasPrivilege( "PermabanID" ) ) ) then
		/*-------------------------------------------------------------------------------------------------------------------------
			Get the unique ID to ban
		-------------------------------------------------------------------------------------------------------------------------*/
		
		local uid, pl
		
		if ( string.match( args[1] or "", "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
			uid = evolve:UniqueIDByProperty( "SteamID", args[1] )
			pl = player.GetByUniqueID( uid )
		else
			evolve:Notify( ply, evolve.colors.white, "This is not a ", evolve.colors.red, "Steam-ID", evolve.colors.white, "! (Did you use a name? Use !ban instead.)" )
			return
		end
		
		/*-------------------------------------------------------------------------------------------------------------------------
			Gather data and perform ban
		-------------------------------------------------------------------------------------------------------------------------*/
		
		local length = math.Clamp( tonumber( args[2] ) or 5, 0, 200000 ) * 60
		local reason = table.concat( args, " ", 3 )
		if ( #reason == 0 ) then reason = "No Reason" end
		local nick = pl:Name() or "N/A"
		if ( length == 0 ) then
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, nick, evolve.colors.white, " permanently (" .. reason .. ")." )
			
			tmysql.query("INSERT INTO bans (Admin,ASteamID,User,USteamID,Minutes,Reason,Server) VALUES('"..ply:Name().."','"..ply:SteamID().."','"..nick.."','"..pl:SteamID().."','Permanent','"..reason.."','Build');");
			
		else
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, nick, evolve.colors.white, " for " .. length / 60 .. " minutes (" .. reason .. ")." )
			
			tmysql.query("INSERT INTO bans (Admin,ASteamID,User,USteamID,Minutes,Reason,Server) VALUES('"..ply:Name().."','"..ply:SteamID().."','"..nick.."','"..pl:SteamID().."','" .. length / 60 .. "','"..reason.."', 'Build');");
			
		end
		evolve:Ban( uid, length, reason, ply:UniqueID() )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

if ( SERVER ) then
	function PLUGIN:InitPostEntity()
		for uid, data in pairs( evolve.PlayerInfo ) do
			if ( evolve:IsBanned( uid ) ) then
				game.ConsoleCommand( "banid " .. ( data.BanEnd - os.time() ) / 60 .. " " .. data.SteamID .. "\n" )
			end
		end
	end
end
evolve:RegisterPlugin( PLUGIN )