/*-------------------------------------------------------------------------------------------------------------------------
	AGC Global Chat!!
-------------------------------------------------------------------------------------------------------------------------*/
local GlobalChatOnline = 0
local EnableTime
local PLUGIN = {}
PLUGIN.Title = "Global Chat"
PLUGIN.Description = "Connect Server-chats"
PLUGIN.Author = "Northdegree"
PLUGIN.ChatCommand = "globalchat"
PLUGIN.Usage = ""
PLUGIN.Privileges = { "Toggle-Global-Chat"}

function PLUGIN:Call( ply, args )
	if GlobalChatOnline then
		GlobalChatOnline = 0
		EnableTime = tonumber(os.time())
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has", evolve.colors.red, " disabled", evolve.colors.white, " the Global Chat")
		return
	else
		GlobalChatOnline = 1
		EnableTime = tonumber(os.time())
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has", evolve.colors.green, " enabled", evolve.colors.white, " the Global Chat")
		return
	end
end

function GlobalChatHook( playerindex, playername, text, messagetype )
	if GlobalChatOnline then
		http.Get( "lol-public.com/gmodfastdl/updateserver/globalchat/globalchatinsert.php?sent="..tonumber(os.time()).."&author="..playername.."&from=Build&text="..text.."", "", function( c, s )end )
	end
	return
end
// Hook the event.
hook.Add( "ChatText", "Evolve-ChatHook", GlobalChatHook );
function RecieveGlobalChats()
	if GlobalChatOnline then
		http.Get( "lol-public.com/gmodfastdl/updateserver/globalchat/globalchatget.php?enabletime="..EnableTime.."&server=Build", "", function( c, s )
			if not c then return end
				glcgstrsplit1 = string.Explode(s, "New12String32")
				for _,val in pairs(glcgstrsplit1) do
					glcgstrsplit =  = string.Explode(val, "|--|")
					evolve:Notify( evolve.colors.white, "["..glcgstrsplit[0].."]", evolve.colors.blue, glcgstrsplit[1], evolve.colors.white, ": "..glcgstrsplit[2].."")
				end
		end )
	end
end
timer.Create("RecGlobalChats",2,0,RecieveGlobalChats)

evolve:RegisterPlugin( PLUGIN )