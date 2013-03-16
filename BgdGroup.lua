-----------------------------------------------------------------------------------------
--
-- BgdGroup.lua
--
-----------------------------------------------------------------------------------------
local modname = ...
local BgdGroup = {}
package.loaded[modname] = BgdGroup
module(..., package.seeall)
local assetDir = "BgdGroup"
local storyboard = require ( "storyboard" )
--local screenGroup = self.view

-----------------------------------------------------------------------------------------
--
-- Create buttons table for the tab bar
--
-----------------------------------------------------------------------------------------
 
tabButtons = {
	{
		label = "ArtiosCAD",
		default = "assets/tabIcon.png",
		down = "assets/tabIcon-down.png",
		width = 32, height = 32,
		onPress=function() storyboard.gotoScene( "sceneArtiosCAD" ); end,
		selected = true
	},
	{
		label = "Kongsberg",
		default = "assets/tabIconKberg.png",
		down = "assets/tabIconKberg-down.png",
		width = 32, height = 32,
		onPress = function() storyboard.gotoScene( "sceneKongsberg" ); end, 
	},
	{
		label = "Quotes",
		default = "assets/tabIconQuote.png",
		down = "assets/tabIconQuote-down.png",
		width = 32, height = 32,
		onPress = function() storyboard.gotoScene( "sceneQuotes" ); end,
	}
}


-----------------------------------------------------------------------------------------
--
-- Create main bgd 
--
-----------------------------------------------------------------------------------------local backgrounds = {

function backgroundMain()
			local bgMain = display.newImageRect( "Default-568h@2x.png", 360, 570 )
			bgMain.x = display.contentWidth / 2
			bgMain.y = display.contentHeight / 2
end

function backgroundArtiosCAD()
		local bgCAD = display.newImageRect( "Default-568h@2x.png", 360, 570 )
		bgCAD.x = display.contentWidth / 2
		bgCAD.y = display.contentHeight / 2
end

function backgroundKongsberg()
		bgKongsberg = display.newImageRect( "Default-568h@2x.png", 360, 570 )
		bgKongsberg.x = display.contentWidth / 2
		bgKongsberg.y = display.contentHeight / 2
end

function removeMainBackground()
		display.remove(bgMain)
		print( "\n1: removed background?")
end


return BgdGroup