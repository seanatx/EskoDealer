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

local top = display.statusBarHeight*2
local list = nil


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

	local bg = display.newImageRect( deviceSwitch.welcomeSplash, deviceSwitch.masterScreenWidth, deviceSwitch.masterScreenHeight)
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
	list.x = 8
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

	local titleText = display.newEmbossedText( "Project Selection", 0, 0, native.systemFontBold, 20 )
	titleText:setReferencePoint( display.CenterReferencePoint )
	titleText:setTextColor( 255 )
	titleText.x = titleBar.width/2
	titleText.y = titleBar.y

	-- create a shadow underneath the titlebar (for a nice touch)
	local shadow = display.newImage( "assets/shadow.png" )
	shadow:setReferencePoint( display.TopLeftReferencePoint )
	shadow.x, shadow.y = 0, top
	shadow.xScale = 320 / shadow.contentWidth
	shadow.alpha = 0.45

	
	screenGroup:insert(bg)
	screenGroup:insert(list)
	screenGroup:insert(shadow) 
	screenGroup:insert(titleBar) 
	screenGroup:insert(titleText) 
	
	
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