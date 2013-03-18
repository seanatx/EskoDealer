---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scrollNav = require("scrollNav")
local content = require("contentKongs")
local scene = storyboard.newScene()

local spacing = 20
local leftMargin = 50
local topMargin = 100
local scrollbarY = 380


---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image, text1, text2, text3, memTimer
--local locOrientation = "land"

-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		-- storyboard.gotoScene( "screen2", "slideLeft", 800  )
		
		return true
	end
end

local function onOrientationEventArtiosCAD( event )
	
	if string.sub( event.type,1,4 ) == "land" then
		print( " hit inner orient event on landscape:  " )
		-- load landscape
		--local screenGroup = self.view
		-- screenGroup:removeObject("portrait")
		image = display.newImageRect( "assets/Default.png", 360, 570 )
		image.x = display.contentWidth / 2
		image.y = display.contentHeight / 2
		screenGroup:insert( image )
		
	else
		print( " hit inner orient event on potrait" )
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	screenGroup = self.view

	
	self.scrollNav = scrollNav.new({left=0, right=0, tm=topMargin, lm=leftMargin, sp=spacing})
	
	-- Iterate through content and add to scrollNav
	for index, value in ipairs(content) do
	    local thumb = display.newImage(content[index].thumb)
	    self.scrollNav:insertButton(thumb, content[index].asset)
	end

	-- Add the scrollbar to the scrollNav
	self.scrollNav:addScrollBar(scrollbarY)
	
	image = display.newImageRect( "assets/Default.png", 360, 570 )
	image.x = display.contentWidth / 2
	image.y = display.contentHeight / 2
	image.name = "portrait"
	screenGroup:insert( image )
	
	image.touch = onSceneTouch
	
	if (_G.debug) then
		text1 = display.newText( "Kongsberg", 0, 0, native.systemFontBold, 24 )
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
	
	print( "\n1: createScene Kongsberg  event")
end


 -- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	print( "2: enterScene Kongsberg event" )
	-- Update Lua memory text display
	if (_G.debug ) then
		local showMem = function()
			image:addEventListener( "touch", image )
			text3.isVisible = true
			text2.text = text2.text .. collectgarbage("count")/1000 .. "MB"
			text2.x = display.contentWidth * 0.5
		end
		memTimer = timer.performWithDelay( 1000, showMem, 1 )
	end -- end if
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "2: exitScene Kongsberg event" )
	
	-- remove touch listener for image
	image:removeEventListener( "touch", image )
	
	if (_G.debug) then
		-- cancel timer
		timer.cancel( memTimer ); memTimer = nil;
	
		-- reset label text
		text2.text = "MemUsage: "
	end
	
	storyboard.purgeScene( "sceneKongsberg" )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	self.scrollNav:cleanUp()
	self.scrollNav:removeSelf()
	self.scrollNav = nil
	print( "((destroying scene Kongsberg's view))" )
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

-- Add the Orientation callback event
Runtime:addEventListener( "orientation", onOrientationEventArtiosCAD );

return scene