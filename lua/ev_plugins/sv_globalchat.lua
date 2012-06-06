/*-------------------------------------------------------------------------------------------------------------------------
	AGC Global Chat!!
-------------------------------------------------------------------------------------------------------------------------*/
local PLUGIN = {}
PLUGIN.Title = "Global Chat"
PLUGIN.Description = "Connect Server-chats"
PLUGIN.Author = "Northdegree"
PLUGIN.ChatCommand = "g"
PLUGIN.Usage = "<message>"
PLUGIN.Privileges = { "Toggle Global Chat", "Global Chat"}

/*------------------ Variablen ----------------------*/
GlobalChatOnline = 1
EnableTime = tonumber(os.time())
/*--------------------------------------------------*/

function PLUGIN:Call( ply, args )
	if not args[1] then
		if ply:EV_HasPrivilege( "Toggle Global Chat" ) then
			if GlobalChatOnline == 1 then
				GlobalChatOnline = 0
				EnableTime = 0
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has", evolve.colors.red, " disabled", evolve.colors.white, " the Global Chat")
				return
			else
				GlobalChatOnline = 1
				EnableTime = tonumber(os.time())
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has", evolve.colors.blue, " enabled", evolve.colors.white, " the Global Chat")
				return
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
		end
	else
		if ply:EV_HasPrivilege( "Toggle Global Chat" ) then
			if GlobalChatOnline == 1 then
				local unargs={unpack(args)}
				local outputstring = table.concat(unargs, " ")
				local data = evolve.ranks[ ply:EV_GetRank() ]
				local color = data.Color
				evolve:Notify( evolve.colors.white, "[AGC-Global] " , color, ply:Nick(), evolve.colors.white, ": "..outputstring)
				local plyname = DB.MySQLDB:escape(ply:Nick())
				local text = DB.MySQLDB:escape( outputstring )
				DB.Query("INSERT INTO `globalchat` (`time`, `site`, `user`, `text`) VALUES ('"..os.time().."', 'Build', '"..plyname.."', '"..text.."');")
			else
				evolve:Notify( ply, evolve.colors.red, "The Global Chat is deactivated!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
		end
	end
end
/*
hook.Add( "PlayerSay", "EV_PlayerChat", function( ply, txt )
	if GlobalChatOnline == 1 then
		local plyname = DB.MySQLDB:escape(ply:Nick())
		local text = DB.MySQLDB:escape(txt)
		DB.Query("INSERT INTO `globalchat` (`time`, `site`, `user`, `text`) VALUES ('"..os.time().."', 'Build', '"..plyname.."', '"..text.."');")
	end
end )
*/

function RecieveGlobalChats()
	if GlobalChatOnline == 1 then
		DB.Query("SELECT * FROM `globalchat` WHERE time>"..EnableTime.." AND sentBuild=0 and site!='Build' ORDER BY id DESC LIMIT 0 , 5;", function(results)
			if results then
				for k,v in pairs(results) do
					evolve:Notify( evolve.colors.white, "["..v.site.."] ", evolve.colors.blue, v.user, evolve.colors.white, ": "..v.text )
					DB.Query("UPDATE `globalchat` SET sentBuild=1 WHERE id="..v.id..";")
				end
			end
		end)
	end
end
timer.Create("RecGlobalChats",2,0,RecieveGlobalChats)

evolve:RegisterPlugin( PLUGIN )