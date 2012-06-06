/*-------------------------------------------------------------------------------------------------------------------------
	AGC Global Chat!!
-------------------------------------------------------------------------------------------------------------------------*/
GlobalChatOnline = 1
EnableTime = 0
local PLUGIN = {}
PLUGIN.Title = "Global Chat"
PLUGIN.Description = "Connect Server-chats"
PLUGIN.Author = "Northdegree"
PLUGIN.ChatCommand = "!g"
PLUGIN.Usage = "<message> (Sends a Message to all Servers)"
PLUGIN.Privileges = { "Toggle-Global-Chat"}

function PLUGIN:Call( ply, args )
	if not args then
		if GlobalChatOnline == 1 then
			GlobalChatOnline = 0
			EnableTime = tonumber(os.time())
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has", evolve.colors.red, " disabled", evolve.colors.white, " the Global Chat")
			return
		else
			GlobalChatOnline = 1
			EnableTime = tonumber(os.time())
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has", evolve.colors.blue, " enabled", evolve.colors.white, " the Global Chat")
			return
		end
	else
	
	end
end

hook.Add( "PlayerSay", "EV_PlayerChat", function( ply, txt )
	if GlobalChatOnline == 1 then
		local playername = ply:Nick()
		print("lol-public.com/gmodfastdl/updateserver/globalchat/globalchatinsert.php?sent="..os.time().."&author="..playername.."&from=Build&text="..txt)
		http.Get( "lol-public.com/gmodfastdl/updateserver/globalchat/globalchatinsert.php?sent="..os.time().."&author="..playername.."&from=Build&text="..txt, "", function( contins, sizeins )
		print(";;Content: "..contins.."; Size"..sizeins..";;" ) 
		end )
	end
end )
function RecieveGlobalChats()
	if GlobalChatOnline == 1 then
		http.Get( "lol-public.com/gmodfastdl/updateserver/globalchat/globalchatget.php?enabletime="..EnableTime.."&server=Build", "", function( cont, s )
			if tostring(cont)=="" or s==0 then return end
				glcgstrsplit1 = string.Explode("|---|",cont)
				for _,val in pairs(glcgstrsplit1) do
					if val != "" then
						glcgstrsplit = string.Explode("|--|",val)
						evolve:Notify( evolve.colors.white, "["..glcgstrsplit[1].."]", evolve.colors.blue, glcgstrsplit[2], evolve.colors.white, ": "..glcgstrsplit[3].."")
					end
				end
		end )
	end
end
timer.Create("RecGlobalChats",2,0,RecieveGlobalChats)

evolve:RegisterPlugin( PLUGIN )