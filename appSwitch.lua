
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
			globalBackgroundImage = "assets/EskoStripeBG5.png"
        }

elseif string.sub(system.getInfo("model"),1,4) == "iPad" then
	print("iPad configuration detected " ..system.getInfo("model"))
        deviceSwitch =    -- (768x1024)
        {
        	masterScreenWidth = 768,
        	masterScreenHeight = 1024,
        	demoTabsXloc = display.contentWidth/2,
        	demoTabsYloc = display.contentHeight - display.statusBarHeight - 5,
           	welcomeSplash = "assets/Default@2.png",
           	
           	topScrollMargin = 200,
           	
           	
        	listViewTop = display.statusBarHeight*2,
			navBar = "assets/navBar@2.png",
			priceBarYloc =  math.floor(display.screenOriginY + display.statusBarHeight+8),
			globalBackgroundImage = "assets/EskoStripeBG5.png"
        }

elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
	print("iPhone5 configuration detected " ..system.getInfo("model"))

        deviceSwitch =
        {
        	masterScreenWidth = 640,
        	masterScreenHeight = 1136,
        	demoTabsXloc = display.contentWidth/2,
        	demoTabsYloc = display.contentHeight - display.statusBarHeight - 5,
        	welcomeSplash = "assets/Default.png",
        	listViewTop = display.statusBarHeight*2+40,
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
