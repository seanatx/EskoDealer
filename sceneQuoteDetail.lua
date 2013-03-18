---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local ui = require( "ui")
local scene = storyboard.newScene()
--local grid = require( "grid" ) 
--local KongsList = require( "KongsList" )
local widget = require("widget")
require "sqlite3"
--local screenGroup
local nameOfQuoteToGet
local image
local top = display.statusBarHeight*2
local listRecsDetailQuote = {}
local list = nil
local db
local showDetails
local screenGroup
local MachinePrice = 0

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		-- storyboard.gotoScene( "screen2", "slideLeft", 800  )
		
		return true
	end
end


local function loadData()
	local sql = "select * from " ..nameOfQuoteToGet --listRecsDetailQuote[_G.currIdx].name 
	local i = 0
--	print( " ready to query details: " ..sql)
	for a in db:nrows(sql) do
		listRecsDetailQuote[#listRecsDetailQuote+1] =
		{
		id = a.id,
		productcode = a.ProductCode,
		description = a.Description,
		quantity = a.Quantity,
		listprice = a.ListPrice,
		discountable = a.Discountable,
		mcprice = a.MCPrice
		}

end

	
	print( "finsihed loading detail data" )
end


local function showRecords()
	
	local function onRowRender( event )
		local row = event.row
		local rowGroup = event.view
		local idx = row.index or 1
		local color = 0
		
--		print( " in on row render description" )
--		print( " list rec description: " ..listRecsDetailQuote[idx].description)
		row.textObj = display.newRetinaText( listRecsDetailQuote[idx].description, 0, 0, "Helvetica", 12 )
		row.textObj:setTextColor( color )
		row.textObj:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj.x = 20
		row.textObj.y = rowGroup.contentHeight * 0.35
		
--		print( " in on row render prod code" )
		row.textObj2 = display.newRetinaText( listRecsDetailQuote[idx].productcode, 0, 0, "Helvetica", 9 )
		row.textObj2:setTextColor( color )
		row.textObj2:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj2.x = 20
		row.textObj2.y = rowGroup.contentHeight * 0.65
		
--		if listRecsDetailQuote[idx].ListPrice ~= nil then
			print( "trying machineprice")
			MachinePrice = MachinePrice + listRecsDetailQuote[idx].listprice
--		end
				
--		print( " in del row " )
		local function delRow( event )
			print("Delete hit: " .. tostring(event.target.id))
			local dbid = listRecsDetailQuote[event.target.id].id
			list:deleteRow(event.target.id)
			table.remove(listRecsDetailQuote, event.target.id)
			display.remove( detailGrp )
			-- delete from database
			-- deleteData(dbid)
		end
		
--		print( " in del button" )
		row.delButton = widget.newButton{
	        id = row.index,
	        top = rowGroup.contentHeight * 0.1,
	        left = rowGroup.contentWidth - 80,
	        default = "deletebtn.png",
	        width = 64, height = 33,
	        onRelease = delRow
	    }
	    row.delButton.alpha = 0
	    
	    if listRecsDetailQuote[idx].showDel == true then
	    	row.delButton.alpha = 1
	    end
		
		rowGroup:insert(row.delButton)
		rowGroup:insert(row.textObj)
		rowGroup:insert(row.textObj2)
		
	end -- onRowRender

	
	local function rowListener( event )
		local row = event.row
		local background = event.background
		local phase = event.phase
		
		if phase == "press" then
			print( "Pressed row: " .. row.index )
			background:setFillColor( 196, 255, 156, 255 )
			
		elseif phase == "release" or phase == "tap" then
			print( "Tapped and/or Released row: " .. row.index )
			--background:setFillColor( 196, 255, 156, 255 )
			row.reRender = true
			
--			_G.currIdx = row.index
--			storyboard.showOverlay( "storyboard-details", { effect="fade", params={lr = listRecsDetailQuote}, isModal=true } )
--			-- go to new scene
			
		elseif phase == "swipeLeft" then
			print( "Swiped Left row: " .. row.index )
			listRecsDetailQuote[row.index].showDel = true
			row.reRender = true
			    
    	elseif phase == "swipeRight" then
			print( "Swiped Right row: " .. row.index )
			listRecsDetailQuote[row.index].showDel = false
			display.remove( row.delButton )
			
		end
		
		
	end -- rowListener
	

	for x = 1, #listRecsDetailQuote do
		list:insertRow {
			height = 40,
			onRender = onRowRender,
			listener = rowListener
		}
	end	
	
end -- showRecords

local function backBtnRelease( event )
	print("back button released")
	--transition.to(myList, {time=400, x=0, transition=easing.outExpo })
	--transition.to(sceneQuotes, {time=400, x=display.contentWidth, transition=easing.outExpo })
	--transition.to(backBtn, {time=400, x=math.floor(backBtn.width/2)+backBtn.width, transition=easing.outExpo })
	transition.to(priceBar, {time=400, alpha=0})
	transition.to(priceHeader, {time=400, alpha=0})
	transition.to(backBtn, {time=400, alpha=0 })
	storyboard.gotoScene( "sceneQuotes", "fade", 400 ) 

	--delta, velocity = 0, 0
end

local function emailBtnRelease( event )
	-- compose an HTML email with two attachments
--	print ( "emailToRecip" )

--	   to = "butch@gmail.com"
	local options =
	{

	   bcc = { "emailtosalesforce@p4iylvcs2mvk3v4vacz4er5m674g69ltkdm9caay3qkp46c24.d-lccrmam.d.le.salesforce.com" },
	   subject = "Kongsberg Quote",
	   isBodyHtml = true,
	   body = "<html><body>Kongsberg Quote <b>US$" ..MachinePrice .." </b>!!! Please call me with any questions you have</body></html>",
	   --attachment =

	}
	native.showPopup("mail", options)
--	   {
--		  { baseDir=system.ResourceDirectory, filename="email.png", type="image" },
--	   },	
	-- NOTE: options table (and all child properties) are optional
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print( "\n1: entering detail Quote create event")
	screenGroup = self.view
--	listRecsDetailQuote = event.params.lr
	nameOfQuoteToGet = event.params.nameToGet
	db = event.params.database
	--image = display.newImageRect( "assets/Default-568h@2x.png", 360, 570 )
	--image.x = display.contentWidth / 2
	--image.y = display.contentHeight / 2
	--screenGroup:insert( image )
	
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
	print( "\n1: starting detail list loading  Quote  event")
	
--	db = setUpDatabase("EskoData.sqlite")

--	local bg = display.newRect( 0, top, display.contentWidth, display.contentHeight - top)
	local bg = display.newImageRect( "assets/EskoStripeBG5.png", 360, 570 )
	bg.x = display.contentWidth / 2
	bg.y = display.contentHeight / 2 
--	bg:setFillColor(80, 110, 200)
	list = widget.newTableView {
		top = top + 40,
		height = 404,
		maskFile = "mask404.png"
	}
	screenGroup:insert(bg)
	screenGroup:insert(list)
	
	print( "\n1: inserted detailed bg and list, createScene Quote  event")
	
	loadData()
	showRecords()
	
	--Setup the price bar 
	print( "starting priceBar" )
	priceBar = ui.newButton{
		default = "assets/navBar.png",
		onRelease = scrollToTop
	}
	priceBar.x = display.contentWidth*.5
	--print ("priceBar coords: " ..display.contentWidth*.5 .."," ..display.screenOriginY + display.statusBarHeight + navBar.height*0.5)
	priceBar.y = math.floor(display.screenOriginY + display.statusBarHeight + 20) --navBar.height*0.5)

	priceHeader = display.newText("Price: $" ..string.format("%i",MachinePrice), 0, 0, native.systemFontBold, 16)
	priceHeader:setTextColor(255, 255, 255)
	priceHeader.x = display.contentWidth*.5
	priceHeader.y = priceBar.y
	screenGroup:insert( priceBar )
	screenGroup:insert( priceHeader )
	
	--	--Setup the back button
	backBtn = ui.newButton{ 
		default = "assets/backButton.png", 
		over = "assets/backButton_over.png", 
		onRelease = backBtnRelease
	}
	backBtn.x = math.floor(backBtn.width/2) + 5 
	backBtn.y = priceHeader.y 
	backBtn.alpha = 1
	screenGroup:insert( backBtn )
	
		--	--Setup the email button
	emailBtn = ui.newButton{ 
		default = "assets/email.png", 
		over = "assets/email.png", 
		onRelease = emailBtnRelease
	}
	emailBtn.x = display.contentWidth - emailBtn.width + 5 
	emailBtn.y = priceHeader.y 
	emailBtn.alpha = 1
	screenGroup:insert( emailBtn )
	
--	priceHeader.x = display.contentWidth - ( backBtn.contentWidth/2 )

--	sceenGroup:insert( priceBar )
--	screenGroup:insert( backBtn )
	
	---- create scene
	print( "\n1: created Scene Quote  event")
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	screenGroup = self.view
	print( "1: enterScene Quote event" )
	
	-- remove previous scene's view
	--storyboard.purgeScene( "scene4" )
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
	
	transition.to(priceBar, {time=400, alpha=1 })
	transition.to(priceHeader, {time=400, alpha=1 })
	transition.to(backBtn, {time=400, alpha=1 })
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