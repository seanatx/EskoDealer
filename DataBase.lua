

module(..., package.seeall)

--Include sqlite
require "sqlite3"

local sql = "select * from projects"
local db
local database = {}
local database_mt = { __index = database }
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
local function setUpDatabase(dbName)
	
	local path = system.pathForFile( dbName, system.DocumentsDirectory )
	
	-- check global if we are working and building the DB it persists so we have to destroy it
	if (_G.destroyDB) then
		print("\n destroyed the cached DB: " .. path)
		os.remove(path)
	end
	
	local file = io.open( path, "r" )
 
	if ( file == nil ) then
		-- copy the database file if doesn't exist
		local pathSource     = system.pathForFile( dbName, system.ResourceDirectory )
		local fileSource     = io.open( pathSource, "r" )
		local contentsSource = fileSource:read( "*a" )
                
		local pathDest = system.pathForFile( dbName, system.DocumentsDirectory )
		local fileDest = io.open( pathDest, "w" )
		fileDest:write( contentsSource )
            
		io.close( fileSource )
		io.close( fileDest )
	end

	local EskoDB = system.pathForFile(dbName, system.DocumentsDirectory)
	local dbNew = sqlite3.open( EskoDB )
	
	return dbNew

end


local function executeSQL(stmt)
	return
end

local function loadData()
	local sql = "select * from MachineQuotes"
	
	for a in db:nrows(sql) do
		listRecsQuoteMain[#listRecsQuoteMain+1] =
		{
		id = a.id,
		name = a.name,
		category = a.category,
		rating = a.rating,
		thumbnail = a.thumb,
		--print ( "from DB: " ..a.thumb)
		}
	end
end


--Handle the applicationExit event to close the db
local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end


-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function database.new ( )  -- constructor
	local newDatabase = {
	}
	
	return setmetatable( newDatabase, database_mt )
end 

function getDatabase( name )
	setUpDatabase( name )
	
	--return db
end

-- need to make this generic table loader and private
function database:loadMachineDataIntoTable( tableToFill, sqlStmt)
	
	-- change to k, v load any pairs into the table
	for a in db:nrows(sqlStmt) do
		tableToFill[#tableToFill+1] =
		{
		id = a.id,
		name = a.name,
		category = a.category,
		rating = a.rating,
		thumbnail = a.thumb,
		--print ( "from DB: " ..a.thumb)
		}
	end
	
	return tableToFill
end

-- need to make this generic table loader and private
function database:loadQuoteDetailDataIntoTable( tableToFill, sqlStmt)
	
	-- change to k, v load any pairs into the table
	for a in db:nrows(sqlStmt) do
		tableToFill[#tableToFill+1] =
		{
		id = a.id,
		productcode = a.ProductCode,
		description = a.Description,
		quantity = a.Quantity,
		listprice = a.ListPrice,
		discountable = a.Discountable,
		mcprice = a.MCPrice,
		master = a.Master,
		subordinate = a.Subordinate
		}

	end
	
	return tableToFill
end


db = setUpDatabase("EskoData.sqlite")
print("database loaded")

return database

