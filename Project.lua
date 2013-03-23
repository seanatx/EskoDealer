module(...,package.seeall)


local project = {}
local project_mt = { __index = project }


local projectTable = {
	name = "project1",
	contactPerson = "person",
	contactEmail = "email",
	quote = {},
	Picture = "",
	soundClip = "",
	movieClip = "",
		
}
-------------------------------------------------
-- HTML variables

-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 

	
local function sendEmail()

end

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function project.new ( nameToGet )  -- constructor
	local newProject = {
		name = nameToGet
	}

	
	return setmetatable( newProject, project_mt )
end 
--------------------------------------------------
function project:addObject()
	return bodytext
end
--------------------------------------------------
function project:save()
	return self.name
end
--------------------------------------------------
function project:open()
	sendEmail()
end

return project