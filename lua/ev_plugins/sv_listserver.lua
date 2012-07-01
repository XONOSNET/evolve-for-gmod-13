/*-------------------------------------------------------------------------------------------------------------------------
	Rank colors
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Server Lister"
PLUGIN.Description = "Displays the Server on the Homepage"
PLUGIN.Author = "Northdegree"

function UpdateServer()
	local hostip = ""
	http.Get("http://whatismyip.akamai.com/", "", function(strIP, iLen)
		hostip = ""..strIP..""
	local serverip = hostip..":"..GetConVarString("hostport")
	local servername = GetConVarString("hostname")
	local servername = string.gsub(servername,"% ","%%20")
	local players = player.GetAll()
	http.Get("http://evolve.sg-community.de/index.php?page=updateserver&ip="..serverip.."&name="..servername.."&players="..#players.."&maxplayers="..MaxPlayers().."", "", function(returning, lenght)end) 
	end)
end
UpdateServer()
timer.Create("ListServer",300,0,UpdateServer)
evolve:RegisterPlugin( PLUGIN )