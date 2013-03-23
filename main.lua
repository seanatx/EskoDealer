
--local appswitch = require( "appSwitch" )
local widget = require ( "widget" )
local storyboard = require ( "storyboard" )
--widget.setTheme( "theme_ios" )
local bgrp = require("BgdGroup")
_G.debug = false
_G.destroyDB = true 
_G.EskoData = nil
 
-- Background Width/Height/Alignment

--iPhone
--local backgroundWidth = 320
--local backgroundHeight = 480

--Android
--local backgroundWidth = 360 
--local backgroundHeight = 570

-- iPhone5
--local backgroundWidth = 640
--local backgroundHeight = 1136

-- iPad
--local backgroundWidth = 768
--local backgroundHeight = 1024
--local backgroundAlignment = "center"


--Create a tab-bar and place it at the bottom of the screen
local demoTabs = widget.newTabBar{
	top = display.contentHeight - 50 - display.screenOriginY,
	buttons = bgrp.tabButtons
}


--demoTabs.height = deviceSwitch.demoTabBarHeight
--demoTabs.width = deviceSwitch.demoTabBarWidth
--demoTabs.x = deviceSwitch.demoTabsXloc
--demoTabs.y = deviceSwitch.demoTabsYloc

--demoTabs.height = 60
--demoTabs.width = display.contentWidth
--demoTabs.x = display.contentWidth/2
--demoTabs.y = display.contentHeight-60

-- load first scene
storyboard.gotoScene( "sceneSplash", "fade", 400 )  