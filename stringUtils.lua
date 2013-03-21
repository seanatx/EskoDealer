module(...,package.seeall)

local stringutils = {}
local stringutils_mt = { __index = stringutils }
local stringToSplit = ""
local splitterString = ""
local pPattern = ""
local pString = ""

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function stringutils.new ( )  -- constructor
	local newStringUtils = {

	}
	
	return setmetatable( newStringUtils, stringutils_mt )
end 

---------------------------------------------------

function stringutils:split(pString, pPattern)
   local Table = {}
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end 
--------------------------------------------------

return stringutils