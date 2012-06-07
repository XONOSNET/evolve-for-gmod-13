print("-----> Starting Evolve MySQL Plugin <-----")
Evolve_SQLConf = {} 

Evolve_SQLConf.EnableMySQL = true 
Evolve_SQLConf.Host = "ag-community.de" 
Evolve_SQLConf.Username = "user_evolve" 			
Evolve_SQLConf.Password = "agc1337evolve" 	
Evolve_SQLConf.Database_name = "evolve" 
Evolve_SQLConf.Database_port = 3306

/*---------------------------------------------------------------------------
MySQL HANDLER
---------------------------------------------------------------------------*/
if file.Exists("lua/includes/modules/gmsv_mysqloo.dll", true) or file.Exists("lua/includes/modules/gmsv_mysqloo_i486.so", true) then
	require("mysqloo")
end

local CONNECTED_TO_MYSQL = false
DB.MySQLDB = nil

function DB.Begin()
	if not CONNECTED_TO_MYSQL then sql.Begin() end
end
function DB.Commit()
	if not CONNECTED_TO_MYSQL then sql.Commit() end
end

function DB.Query(query, callback)
	if CONNECTED_TO_MYSQL then 
		if DB.MySQLDB and DB.MySQLDB:status() == mysqloo.DATABASE_NOT_CONNECTED then
			DB.ConnectToMySQL(Evolve_SQLConf.Host, Evolve_SQLConf.Username, Evolve_SQLConf.Password, Evolve_SQLConf.Database_name, Evolve_SQLConf.Database_port)
		end
		
		local query = DB.MySQLDB:query(query)
		local data
		query.onData = function(Q, D)
			data = data or {}
			data[#data + 1] = D
		end
		
		query.onError = function(Q, E) Error(E) callback() /*DB.Log("MySQL Error: ".. E)*/ end
		query.onSuccess = function()
			if callback then callback(data) end 
		end
		query:start()
		return
	end
	sql.Begin()
	local Result = sql.Query(query)
	sql.Commit()
	if callback then callback(Result) end
	return Result
end

function DB.QueryValue(query, callback)
	if CONNECTED_TO_MYSQL then
		if DB.MySQLDB and DB.MySQLDB:status() == mysqloo.DATABASE_NOT_CONNECTED then
			DB.ConnectToMySQL(Evolve_SQLConf.Host, Evolve_SQLConf.Username, Evolve_SQLConf.Password, Evolve_SQLConf.Database_name, Evolve_SQLConf.Database_port)
		end
		
		local query = DB.MySQLDB:query(query)
		local data
		query.onData = function(Q, D)
			data = D
		end
		query.onSuccess = function()
			for k,v in pairs(data or {}) do
				callback(v)
				return
			end
			callback()
		end
		query.onError = function(Q, E) Error(E) callback() 
		--DB.Log("MySQL Error: ".. E) 
		print("MySQL Error: ".. E) end
		query:start()
		return
	end
	callback(sql.QueryValue(query))
end

function DB.ConnectToMySQL(host, username, password, database_name, database_port)
	if not mysqloo then Error("MySQL modules aren't installed properly!") /*DB.Log("MySQL Error: MySQL modules aren't installed properly!")*/ end
	local databaseObject = mysqloo.connect(host, username, password, database_name, database_port)
	
	databaseObject.onConnectionFailed = function(msg)
		Error("Connection failed! " ..tostring(msg))
		--DB.Log("MySQL Error: Connection failed! "..tostring(msg))
		print("MySQL Error: Connection failed! "..tostring(msg))
	end
	
	databaseObject.onConnected = function()
		----DB.Log("MySQL: Connection to external database "..host.." succeeded!")
		CONNECTED_TO_MYSQL = true
		print("-----> Evolve MySQL Plugin Initialized! <-----")
		DB.Init() -- Initialize database
	end
	databaseObject:connect() 
	DB.MySQLDB = databaseObject
end
DB.ConnectToMySQL(Evolve_SQLConf.Host, Evolve_SQLConf.Username, Evolve_SQLConf.Password, Evolve_SQLConf.Database_name, Evolve_SQLConf.Database_port)
/*---------------------------------------------------------
 Database initialize
 ---------------------------------------------------------*/
function DB.Init()
	DB.Begin()
		DB.Query("CREATE TABLE IF NOT EXISTS `globalchat` (`id` bigint(20) NOT NULL AUTO_INCREMENT,`time` bigint(20) NOT NULL,`site` varchar(50) NOT NULL,`user` varchar(50) NOT NULL,`text` mediumtext NOT NULL,`sentBuild` int(11) NOT NULL DEFAULT '0',`sentTTT` int(11) NOT NULL DEFAULT '0',`sentStronghold` int(11) NOT NULL DEFAULT '0',`sentMC` int(11) NOT NULL DEFAULT '0',PRIMARY KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;")
		DB.Query("CREATE TABLE IF NOT EXISTS `bans` (`SteamID` varchar(255) NOT NULL,`Name` varchar(255) NOT NULL,`UnBan` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',`Ban` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,`Reason` mediumtext NOT NULL,`ServerIP` varchar(255) NOT NULL,`Admin` varchar(255) NOT NULL,`id` bigint(20) NOT NULL AUTO_INCREMENT,PRIMARY KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;")
	DB.Commit()
end