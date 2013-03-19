module(...,package.seeall)

local bodytext = "content not found"
local tableName = ""
local cost = 0
local listRecsDetailQuote = {}
local email = {}
local email_mt = { __index = email }

-- NOTE: options table (and all child properties) are optional
local options = {  
					to = "",
					bcc = "emailtosalesforce@p4iylvcs2mvk3v4vacz4er5m674g69ltkdm9caay3qkp46c24.d-lccrmam.d.le.salesforce.com" ,
					subject = "Kongsberg quote for ",
					isBodyHtml = true,
					body = bodytext
				}


local database 

-------------------------------------------------
-- HTML variables

local docMarker = "<!DOCTYPE html>"

local htmlOpen = "<!DOCTYPE html>\n<html> \n"
local htmlClose = "\n</html>"

local bodyOpen = "<body> \n"
local bodyClose = "\n</body>"

local headerOpen = "<h1>"
local headerClose = "</h1>"

local paraOpen = "<p>"
local paraClose = "</p>"

local headerIncrement = 0

local openHtmlText = bodytext .. htmlOpen .. bodytext ..bodyOpen .. headerOpen .. options["subject"] .. tableName ..headerClose .."\n\n"
local closeHtmlText = "\n\n " .. bodytext .. bodyClose .. htmlClose
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
local function getDBRecord( nameToGet )	-- local; only visible in this module	
	return tableData
end

local function extractQuoteData()
	for x = 1, #listRecsDetailQuote do
		bodytext = bodytext .. listRecsDetailQuote[x].description
		cost = cost + listRecsDetailQuote[x].listprice
	end
	
end

local function buildEmailContent()
	-- do something
	print( "building email" )
	
	bodytext = ""
	cost = 0
	extractQuoteData()
	local openHtmlText = bodytext .. htmlOpen .. bodytext ..bodyOpen .. headerOpen .. options["subject"] .. tableName .. " : $" .. cost ..headerClose .."\n\n"
	local closeHtmlText = "\n\n " .. bodytext .. bodyClose .. htmlClose

	bodytext = openHtmlText .. closeHtmlText
	options["body"] = bodytext
	print( "bodytext: \n" .. options["body"])
end
	
local function sendEmail()
	buildEmailContent()
	if system.getInfo ("environment") == "simulator" then
		print ( "---\n\native.cancelAlert------- email simulator -------------")
		print ( "email body for: " .. tableName)
		
--		for key,value in pairs(options) do
--        	print( key, value )
--    	end
	else
		native.showPopup("mail", options)
	end
end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function email.new ( nameToGet, lr )  -- constructor
	local newMail = {
		name = nameToGet
	}
	tableName = nameToGet
	listRecsDetailQuote = lr
	
	return setmetatable( newMail, email_mt )
end 
--------------------------------------------------
function email:getBody()
	return bodytext
end
--------------------------------------------------
function email:getName()
	return self.name
end
--------------------------------------------------
function email:send()
	sendEmail()
end

return email