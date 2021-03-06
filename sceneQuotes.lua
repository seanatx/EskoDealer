---------------------------------------------------------------------------------
--
-- sceneQuote.lua
--
---------------------------------------------------------------------------------
--local appswitch = require("AppSwitch")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
--local grid = require( "grid" ) 
local widget = require("widget")
require "sqlite3"
local database = require( "DataBase" )
local db
local top = display.statusBarHeight*2
local listRecsQuoteMain = {}
--listRecsQuoteMain = database:loadDataIntoTable(listRecsQuoteMain, "select * from MachineQuotes")
local list = nil
local showDetails
local image

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
 


local function showRecords()
	
	local function onRowRender( event )
		local row = event.row
		local rowGroup = event.view
		local idx = row.index or 0
		local color = 0
		
		row.textObj = display.newRetinaText( listRecsQuoteMain[idx].name, 0, 0, "Helvetica", 16 )
		row.textObj:setTextColor( color )
		row.textObj:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj.x = 150
		row.textObj.y = rowGroup.contentHeight * 0.35
		
		row.textObj2 = display.newRetinaText( listRecsQuoteMain[idx].category, 0, 0, "Helvetica", 12 )
		row.textObj2:setTextColor( color )
		row.textObj2:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj2.x = 150
		row.textObj2.y = rowGroup.contentHeight * 0.65
		
		local function delRow( event )
			print("Delete hit: " .. tostring(event.target.id))
			local dbid = listRecsQuoteMain[event.target.id].id
			list:deleteRow(event.target.id)
			table.remove(listRecsQuoteMain, event.target.id)
			display.remove( detailGrp )
			-- delete from database
			-- deleteData(dbid)
		end
		
		row.delButton = widget.newButton{
	        id = row.index,
	        top = rowGroup.contentHeight * 0.2,
	        left = rowGroup.contentWidth - 90,
	        default = "deletebtn.png",
	        width = 64, height = 33,
	        onRelease = delRow
	    }
	    row.delButton.alpha = 0
	    
	    if listRecsQuoteMain[idx].showDel == true then
	    	row.delButton.alpha = 1
	    end
		
		row.thumbButton = widget.newButton{
	        id = row.index,
	        top = rowGroup.contentHeight*.05,
	        left = 10,
	        default = listRecsQuoteMain[idx].thumbnail,
	        width = 132, height = 90,
	        --onRelease = delRow
	    }
	    row.thumbButton.alpha = 0
	    
	    if listRecsQuoteMain[idx].showDel ~= true then
	    	row.thumbButton.alpha = 1
	    end
	    
		rowGroup:insert(row.delButton)
		rowGroup:insert(row.thumbButton)
		rowGroup:insert(row.textObj)
		rowGroup:insert(row.textObj2)
		
	end -- onRowRender

	
	local function rowListener( event )
		local row = event.row
		local background = event.background
		local phase = event.phase
		
		if phase == "press" then
			print( "Pressed row: " .. row.index )
			background:setFillColor(67,141,241,180)
			
		elseif phase == "release" or phase == "tap" then
			print( "Tapped and/or Released row: " .. row.index )
			row.reRender = true
			
			_G.currIdx = row.index
			local nm = listRecsQuoteMain[_G.currIdx].name 
			storyboard.gotoScene( "sceneQuoteDetail", {effect="fade", params={nameToGet=nm, database=db}} )
			-- go to new scene
			
--		elseif phase == "swipeLeft" then
--			print( "Swiped Left row: " .. row.index )
--			listRecsQuoteMain[row.index].showDel = true
--			row.reRender = true
			    
--    	elseif phase == "swipeRight" then
--			print( "Swiped Right row: " .. row.index )
--			listRecsQuoteMain[row.index].showDel = false
--			display.remove( row.delButton )
--			
		end
		
		
	end -- rowListener
	

	for x = 1, #listRecsQuoteMain do
		list:insertRow {
			height = 140,
			onRender = onRowRender,
			listener = rowListener
		}
	end	-- set up listview
	
end -- showRecords

	local bg = display.newImageRect("assets/Default@2.png", display.contentWidth, display.contentHeight )
	bg.x = display.contentWidth / 2
	bg.y = display.contentHeight / 2 --+ display.statusBarHeight
	
	local topBoundary = display.screenOriginY + 60
	local bottomBoundary = display.screenOriginY -290

	list = widget.newTableView {
--		top = top + 10,
--		height = 404,
		top = topBoundary,
		bottom = bottomBoundary,
		--maskFile = "mask454.png",
--		width = 304
		width = 404
--		height = 504
	}
	list.x = 1
--	list.y = 5
--	list.maskFile.x - 15
--	list.maskFile = "mask404.png"
		-- create embossed text to go on toolbar
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

	local titleText = display.newEmbossedText( "Machine Selection", 0, 0, native.systemFontBold, 20 )
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

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print( "\n1: entering createScene Quote  event")
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
	
	-- next 2 lines draw a grid (see grid.lua )
	-- local t = createGrid( design, data )
	-- t.x, t.y = 30, 150

	screenGroup:insert(bg)
	screenGroup:insert(list)
	screenGroup:insert(shadow) 
	screenGroup:insert(titleBar) 
	screenGroup:insert(titleText) 

	db = database.db
	listRecsQuoteMain = database:loadMachineDataIntoTable(listRecsQuoteMain, "select * from MachineQuotes")
	showRecords()	
	
	---- create scene
	print( "\n1: createScene Quote  event")
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	screenGroup = self.view
	print( "1: enterScene Quote event" )
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
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "Quote: start exitScene event" )
	
	if (_G.debug) then
		-- remove touch listener for image
		image:removeEventListener( "touch", image )
		-- cancel timer
		timer.cancel( memTimer ); memTimer = nil;
		-- reset label text
		text2.text = "MemUsage: "
	end
	
	--storyboard.purgeScene( "sceneQuotes" )
	print( "Quote: leaving exitScene event" ) 
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
	print( "((destroying scene Quote's view))" )
	
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