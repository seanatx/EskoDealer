
if string.sub(system.getInfo("model"),1,4) == "iPad" and display.pixelHeight > 1024 then
	print("iPad Retina configuration detected " ..system.getInfo("model"))

        deviceSwitch =
        {
        	demoTabsXloc = display.contentWidth/2,
        	demoTabsYloc = display.contentHeight - display.statusBarHeight - 5,
        	welcomeSplash = "assets/Default@2x.png",
        	listViewTop = display.statusBarHeight*2+40,
			navBar = "assets/navBar.png",
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight + 19), --navBar.height*0.5)
			globalBackgroundImage = "assets/EskoStripeBG5.png",
			listRecsRowHeight = 60,
        }

elseif string.sub(system.getInfo("model"),1,4) == "iPad" then
	print("iPad configuration detected " ..system.getInfo("model"))
        deviceSwitch =    -- (768x1024)
        {
        	masterScreenWidth = 768,
        	masterScreenHeight = 1024,
           	welcomeSplash = "assets/Default@2.png",
           	listRecsRowHeight = 60,
           	listUnitsRowHeight = 160,
           	topScrollMargin = 200,
           	listRowTextSize1 = 16,
           	listRowTextSize2 = 12,
           	rowDelButtonAdjustY = 0.2,
           	demoTabBarHeight = 54,
           	rowDelButtonAdjustY = 0.20,
           	rowLinkButtonAdjustY = 0.3,
           	demoTabBarWidth = display.contentWidth,
           	demoTabsXloc = display.contentWidth/2,
        	demoTabsYloc = display.contentHeight - display.statusBarHeight -7,
        	listViewTop = display.statusBarHeight*2,
			navBar = "assets/navBar@2.png",
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight+20),
			globalBackgroundImage = "assets/EskoStripeBG5.png",
        }

elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
	print("iPhone5 configuration detected " ..system.getInfo("model"))

        deviceSwitch =
        {
        	masterScreenWidth = 640,
        	masterScreenHeight = 1136,
        	demoTabsXloc = display.contentWidth/2,
        	demoTabsYloc = display.contentHeight - display.statusBarHeight+15,
        	welcomeSplash = "assets/Default-568h@2x.png",
        	listViewTop = display.statusBarHeight*2+40,
        	listRecsRowHeight = 50,
        	listUnitsRowHeight = 100,
        	listRowTextSize1 = 12,
           	listRowTextSize2 = 9,
           	rowDelButtonAdjustY = 0.20,
           	rowLinkButtonAdjustY = 0.3,
			navBar = "assets/navBar.png",
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight + 19), --navBar.height*0.5)
			globalBackgroundImage = "assets/EskoStripeBG5.png"
        }


elseif string.sub(system.getInfo("model"),1,2) == "iP" then
	print("iPhone4? configuration detected " ..system.getInfo("model"))
        deviceSwitch =
        {
        	welcomeSplash = "assets/Default.png",
        	listViewTop = display.statusBarHeight*2+40,
			navBar = "assets/navBar.png",
			listRecsRowHeight = 40,
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight + 19), --navBar.height*0.5)
			globalBackgroundImage = "assets/EskoStripeBG5.png"
        }

elseif display.pixelHeight / display.pixelWidth > 1.72 then
	print("?? configuration detected " ..system.getInfo("model"))
        deviceSwitch =
        {
        	welcomeSplash = "assets/Default.png",
        	listViewTop = display.statusBarHeight*2+40,
			navBar = "assets/navBar.png",
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight + 19), --navBar.height*0.5)
			globalBackgroundImage = "assets/EskoStripeBG5.png"
 
        }

else
	print("?? configuration detected " ..system.getInfo("model"))
        deviceSwitch =
        {
        	welcomeSplash = "assets/Default.png",
        	listViewTop = display.statusBarHeight*2+40,
			navBar = "assets/navBar.png",
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight + 19), --navBar.height*0.5)
			globalBackgroundImage = "assets/EskoStripeBG5.png"

        }

end
