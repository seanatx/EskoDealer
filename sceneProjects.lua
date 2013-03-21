---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local bgrp = require("BgdGroup")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image, text1, text2, text3, memTimer

-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		-- storyboard.gotoScene( "screen2", "slideLeft", 800  )
		
--	local onTouch = function( event )
--    	if isRotated then
--                event.x = display.contentWidth - event.x
--                event.y = display.contentHeight - event.y
--        end
--        --*REST OF YOUR CODE HERE*--
--        print( "\n: Rotated coords" )
-- 	end
--        Runtime:addEventListener( "touch", onTouch )
--		
--		return true
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	

	image = display.newImageRect( deviceSwitch.welcomeSplash, deviceSwitch.masterScreenWidth, deviceSwitch.masterScreenHeight )
	image.x = display.contentWidth / 2
	image.y = display.contentHeight / 2
	screenGroup:insert( image )
	
	image.touch = onSceneTouch
	if (_G.debug) then
		text1 = display.newText( "Projects", 0, 0, native.systemFontBold, 24 )
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
	
	print( "\n1: createScene Projects  event")
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	print( "1: enterScene Projects event" )
	
	-- remove previous scene's view
	--storyboard.purgeScene( "scene4" )
	
	-- Update Lua memory text display
	if (_G.debug) then
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
	
	print( "1: exitScene Projects event" )
	
	-- remove touch listener for image
	image:removeEventListener( "touch", image )
	
	-- cancel timer
	if (_G.debug) then
		timer.cancel( memTimer ); memTimer = nil;
	
		-- reset label text
		text2.text = "MemUsage: "
	end
	
	-- remove scene's view
	storyboard.purgeScene( "sceneProjects" )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
	print( "((destroying Projects view))" )
	
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