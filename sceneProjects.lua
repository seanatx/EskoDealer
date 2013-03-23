---------------------------------------------------------------------------------
--
-- sceneQuote.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
--local grid = require( "grid" ) 
local widget = require("widget")
require "sqlite3"
local image
local db
---------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------

-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		-- storyboard.gotoScene( "screen2", "slideLeft", 800  )
		
		return true
	end
end

local sbHeight = display.statusBarHeight
local tbHeight = 44
local top = sbHeight + tbHeight

-- create a gradient for the top-half of the toolbar
local toolbarGradient = graphics.newGradient( {168, 181, 198, 255 }, {139, 157, 180, 255}, "down" )

local titleBar = widget.newTabBar{
	top = sbHeight,
	gradient = toolbarGradient,
	bottomFill = { 117, 139, 168, 255 },
	height = 44
}

local titleText = display.newEmbossedText( "Project Selection", 0, 0, native.systemFontBold, 20 )
titleText:setReferencePoint( display.CenterReferencePoint )
titleText:setTextColor( 255 )
titleText.x = titleBar.width/2
titleText.y = titleBar.y

-- create a shadow underneath the titlebar (for a nice touch)
local shadow = display.newImage( "assets/shadow.png" )
shadow:setReferencePoint( display.TopLeftReferencePoint )
shadow.x, shadow.y = 0, top
shadow.xScale = display.contentWidth / shadow.contentWidth
shadow.alpha = 0.45
local top = display.statusBarHeight*2
local list = nil

--Text to show which item we selected
local itemSelected = display.newText( "You selected", 0, 0, native.systemFontBold, 24 )
itemSelected:setTextColor( 0 )
itemSelected.x = display.contentWidth + itemSelected.contentWidth * 0.5
itemSelected.y = display.contentCenterY

local topBoundary = display.screenOriginY + 60
local bottomBoundary = display.screenOriginY -290

list = widget.newTableView {
	height = 864,
	width = 768,
	top = topBoundary,
	bottom = bottomBoundary,
	bottomPadding = 8,
	--maskFile = "mask454.png",
--	width = 304
--	height = 504
}
list.x = 1
list.y = titleBar.y + titleBar.contentHeight * 0.5

--Forward reference for our back button
local backButton

--Items to show in our list
local listItems = {
	{ title = "A", items = {  } },
	{ title = "B", items = {  } },
	{ title = "C", items = {  } },
	{ title = "D", items = {  } },
	{ title = "E", items = { "BxampleA", "JxampleB","Example2","ExampleD" } },
	{ title = "F", items = {  } },
	{ title = "G", items = {  } },
	{ title = "H", items = {  } },
	{ title = "I", items = {  } },
	{ title = "J", items = {  } },
	{ title = "K", items = {  } },
	{ title = "L", items = {  } },
	{ title = "M", items = {  } },
	{ title = "N", items = {  } },
	{ title = "O", items = {  } },
	{ title = "P", items = {  } },
	{ title = "Q", items = {  } },
	{ title = "R", items = {  } },
	{ title = "S", items = {  } },
	{ title = "T", items = {  } },
	{ title = "U", items = {  } },
	{ title = "V", items = {  } },
	{ title = "W", items = {  } },
	{ title = "X", items = {  } },
	{ title = "Y", items = {  } },
	{ title = "Z", items = {  } },
}


--Used for displaying row text
local rowTitles = {}

--Handle row rendering
local function onRowRender( event )
	local row = event.row
	local rowGroup = event.view
	local label = rowTitles[ row.index ]
	local color = 0
		
	if row.isCategory then
		color = 255
	end
	
	--Set the row's name
	row.itemName = label
	
	--Create the row's text
	row.textObj = display.newRetinaText( rowGroup, label, 0, 0, native.systemFontBold, 16 )
	row.textObj:setTextColor( color )
	row.textObj:setReferencePoint( display.CenterLeftReferencePoint )
	row.textObj.x, row.textObj.y = 20, rowGroup.contentHeight * 0.5
	rowGroup:insert( row.textObj )
	
	if not (row.isCategory) then
		--Create the row's arrow
		row.arrow = display.newImage( "assets/rowArrow.png", false )
		row.arrow.x = rowGroup.contentWidth - row.arrow.contentWidth * 2
		row.arrow.y = rowGroup.contentHeight * 0.5
		rowGroup:insert( row.arrow )
	end
end

--Handle the back button release event
local function onBackRelease()
	--Transition in the list, transition out the item selected text and the back button
	transition.to( list, { x = 0, time = 400, transition = easing.outExpo } )
	transition.to( itemSelected, { x = display.contentWidth + itemSelected.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	transition.to( backButton, { x = 60, alpha = 0, time = 400, transition = easing.outQuad } )
end

--Create the back button
backButton = widget.newButton{
	style = "backSmall",
	label = "Back", 
	yOffset = - 3,
	onRelease = onBackRelease
}
backButton.alpha = 0
backButton.x = 80
backButton.y = titleBar.y

--Hande row touch events
local function onRowTouch( event )
	local row = event.row
	local background = event.background
	
	if event.phase == "press" then
		print( "Pressed row: " .. row.index )
		background:setFillColor( 0, 110, 233, 255 )

	elseif event.phase == "release" or event.phase == "tap" then
		--Update the item selected text
		itemSelected.text = "You selected " .. row.itemName
		
		--Transition out the list, transition in the item selected text and the back button
		transition.to( list, { x = - list.contentWidth, time = 400, transition = easing.outExpo } )
		transition.to( itemSelected, { x = display.contentCenterX, time = 400, transition = easing.outExpo } )
		transition.to( backButton, { x = 40, alpha = 1, time = 400, transition = easing.outQuad } )
		
		print( "Tapped and/or Released row: " .. row.index )
		background:setFillColor( 0, 110, 233, 255 )
		row.reRender = true
	end
end

local function fillRows() 
	-- insert rows into list (tableView widget)
	for i = 1, #listItems do
		--Add the rows category title
		rowTitles[ #rowTitles + 1 ] = listItems[i].title
	
		--Insert the category
		list:insertRow{
			height = 24,
			rowColor = { 150, 160, 180, 200 },
			onRender = onRowRender,
			isCategory = true,
		}

		--Insert the item
		for j = 1, #listItems[i].items do
			-- sort the rows
			table.sort(listItems[i])
			--Add the rows item title
			rowTitles[ #rowTitles + 1 ] = listItems[i].items[j]
		
			--Insert the item
			list:insertRow{
				height = 72,
				onRender = onRowRender,
				isCategory = false,
				listener = onRowTouch
			}
		end
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print( "\n3: entering createScene Project  event")
	screenGroup = self.view
	
	if (_G.debug) then
		image = display.newRect(0, 0, display.contentWidth, display.contentHeight)
		image:setFillColor(255, 255, 255)
		screenGroup:insert( image )
		image.touch = onSceneTouch
	
		text1 = display.newText( "Quote", 0, 0, native.systemFontBold, 24 )
		text1:setTextColor( 0 )
		text1:setReferencePoint( display.CenterReferencePoint )
		text1.x, text1.y = display.contentWidth * 0.5, 50
		screenGroup:insert( text1 )
	
		text2 = display.newText( "MemUsage: ", 0, 0, native.systemFont, 16 )
		text2:setTextColor( 0 )
		text2:setReferencePoint( display.CenterReferencePoint )
		text2.x, text2.y = display.contentWidth * 0.5, display.contentHeight - 90
		screenGroup:insert( text2 )
	
		text3 = display.newText( "Debug Mode", 0, 0, native.systemFontBold, 18 )
		text3:setTextColor( 0 ); text3.isVisible = false
		text3:setReferencePoint( display.CenterReferencePoint )
		text3.x, text3.y = display.contentWidth * 0.5, display.contentHeight - 70
		screenGroup:insert( text3 )
	end

	local bg = display.newImageRect(  "assets/Default@2.png", display.contentWidth, display.contentHeight )
	bg.x = display.contentWidth / 2
	bg.y = display.contentHeight / 2 --+ display.statusBarHeight
	

--	list.y = 5
--	list.maskFile.x - 15
--	list.maskFile = "mask404.png"
		-- create embossed text to go on toolbar


	
	screenGroup:insert(bg)
	screenGroup:insert(list)
	screenGroup:insert(shadow) 
	screenGroup:insert(titleBar) 
	screenGroup:insert(titleText) 
	screenGroup:insert( itemSelected )
	screenGroup:insert( backButton )
	
	fillRows()

	---- create scene
	print( "\n3: createScene Project  event")
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	screenGroup = self.view
	print( "1: enterScene Project event" )
	if (_G.debug) then
		-- Update Lua memory text display
		local showMem = function()
			image:addEventListener( "touch", image )
			text3.isVisible = true
			text2.text = text2.text .. collectgarbage("count")/1000 .. "MB"
			text2.x = display.contentWidth * 0.5
		end
		memTimer = timer.performWithDelay( 1000, showMem, 1 )
	end
--	table.sort(listItems["E"])
	print( "Project: end exit Project event" )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "Project: start exitScene event" )
	
	if (_G.debug) then
		-- remove touch listener for image
		image:removeEventListener( "touch", image )
		-- cancel timer
		timer.cancel( memTimer ); memTimer = nil;
		-- reset label text
		text2.text = "MemUsage: "
	end
	
	--storyboard.purgeScene( "sceneQuotes" )
	print( "Project: leaving exitScene event" ) 
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
	print( "((destroying scene Project's view))" )
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------
return scene
------return scene