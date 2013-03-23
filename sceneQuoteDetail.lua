---------------------------------------------------------------------------------
--
-- sceneQoteDetail.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
--local appswitch = require( "appSwitch" )
local stringutils = require( "stringUtils" )
local email = require( "email" )
local ui = require( "ui")
local scene = storyboard.newScene()
local widget = require("widget")
require "sqlite3"
local emailSending = nil
local nameOfQuoteToGet
local image
local top = display.statusBarHeight*2
local database = require( "DataBase" )
local db
local listRecsDetailQuote = {}
local listMaster = nil
local db
local showDetails
local screenGroup
local MachinePrice = 0
local priceBar

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local strutils = stringutils.new()

-- Touch event listener for background image
local function onSceneTouch( self, event )
	if event.phase == "began" then
		
		-- storyboard.gotoScene( "screen2", "slideLeft", 800  )
		
		return true
	end
end

local function resetMachinePrice()
	MachinePrice = 0
	for x = 1, #listRecsDetailQuote do
		MachinePrice = MachinePrice + listRecsDetailQuote[x].listprice
	end
	print( "new price calculated: " .. MachinePrice )
--	priceHeader.text = "" .. MachinePrice
end

-- the assumption is that each DB table items contains 2 fields; Master, Subordinate
-- neither field value can be null/nil or Lua will freak out
-- So far, single tier logic; Master items should not have a Master value, Subordinates same
-- Further logic would need to be implimented to support Subs in mor ethan one Master
local function markLinkedBundle(event, mark)
	local index = event.row.index
	local mstr = listRecsDetailQuote[index].master
	local subd = listRecsDetailQuote[index].subordinate
	local subslist = {}
	print ( "Master value: " .. mstr .. ", Subordinate value: " .. subd )
	if (mstr == "" and subd == "" ) then
			listRecsDetailQuote[index].showDel = mark
			event.parent.content.rows[index].reRender = true	
	else
		if mstr ~= "" then -- we have a subordinate, find the master, then process subs list
			for x = 1, #listRecsDetailQuote do
				if listRecsDetailQuote[x].productcode == mstr then
					-- set the master delete and link buttons "on"
					listRecsDetailQuote[x].showDel = mark --true
					listRecsDetailQuote[x].showLink = mark --true
					-- set the delBtn back to off since this is a subordinate
--					listRecsDetailQuote[index].showDel = not(mark) --false
					event.parent.content.rows[x].reRender = true
					--- now do a subordinate discovery
					subslist = strutils:split( listRecsDetailQuote[x].subordinate, "," )
				end
			end 
		else
			-- we have a bundle master, get sub list and process
			listRecsDetailQuote[index].showDel = mark
			listRecsDetailQuote[index].showLink = mark

			subslist = strutils:split( listRecsDetailQuote[index].subordinate, "," )
		end 
		for k, v in pairs (subslist) do
			for x = 1, #listRecsDetailQuote do
				if listRecsDetailQuote[x].productcode == v then
					--event.row.showDel = true
					listRecsDetailQuote[x].showLink = mark --true
					event.parent.content.rows[x].reRender = true
				end 
			end 
		end
	end -- end single item if
end	

local function deleteBundle(event, list)
	-- old delete row
	print( " in del bundle " )
	print("Delete hit: " .. tostring(event.target.id))
	-- local dbid = listRecsDetailQuote[event.target.id].id
	-- delete from database
	-- deleteData(dbid)
			
	local index = event.target.id
	local mstr = listRecsDetailQuote[index].master
	local subd = listRecsDetailQuote[index].subordinate
	local subslist = {}
	if subd ~= "" then
		subslist = strutils:split( listRecsDetailQuote[index].subordinate, "," )
		for k, v in pairs (subslist) do
			for x = 1, #listRecsDetailQuote-1 do
				if listRecsDetailQuote[x].productcode == v then
					listMaster:deleteRow(x)
					table.remove(listRecsDetailQuote, x)
				end 
			end 
		end
	end -- end subordinate deletions
	listMaster:deleteRow(index)
	table.remove(listRecsDetailQuote, index)
	resetMachinePrice()
	priceHeader.text = "Price: $" .. MachinePrice
end
			
local function showRecords()
	local function onRowRender( event )
		local row = event.row
		local rowGroup = event.view
		local idx = row.index or 0
		local color = 0
		
--		print( " in on row render description" )
		row.textObj = display.newRetinaText( listRecsDetailQuote[idx].description, 0, 0, "Helvetica", 18)
		row.textObj:setTextColor( color )
		row.textObj:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj.x = 20
		row.textObj.y = rowGroup.contentHeight * 0.35
		
--		print( " in on row render prod code" )
		row.textObj2 = display.newRetinaText( listRecsDetailQuote[idx].productcode, 0, 0, "Helvetica", 14 )
		row.textObj2:setTextColor( color )
		row.textObj2:setReferencePoint( display.CenterLeftReferencePoint )
		row.textObj2.x = 20
		row.textObj2.y = rowGroup.contentHeight * 0.65
					
		local function delRow( event, list )
			deleteBundle(event)
		end
		
		row.delButton = widget.newButton{
	        id = row.index,
	        top = rowGroup.contentHeight * .2,
	        left = rowGroup.contentWidth - 80,
	        default = "deletebtn.png",
	        width = 64, height = 33,
	        onRelease = delRow
	    }
	    row.delButton.alpha = 0
	    if listRecsDetailQuote[idx].showDel == true then
	    	row.delButton.alpha = 1
	    end
	    	    
		row.linkButton = widget.newButton{
	        id = row.index,
	        top = rowGroup.contentHeight * .2,
	        left = rowGroup.contentWidth - rowGroup.contentWidth + 10,
	        default = "assets/link.png",
	        width = 24, height = 24,
	        --onRelease = delRow
	    }
	    row.linkButton.alpha = 0
	    
	    if listRecsDetailQuote[idx].showLink == true then
	    	row.linkButton.alpha = 1
	    	row.textObj.xOrigin = row.textObj.xOrigin + 24
	    	row.textObj2.xOrigin = row.textObj2.xOrigin + 24
	    end
		
		rowGroup:insert(row.delButton)
		rowGroup:insert(row.linkButton)
		rowGroup:insert(row.textObj)
		rowGroup:insert(row.textObj2)
		
	end -- onRowRender

	
	local function rowListener( event )
		local row = event.row
		local background = event.background
		local phase = event.phase
		
		if phase == "press" then
			print( "Pressed row: " .. row.index )
			print( "\n " .. listRecsDetailQuote[row.index].listprice ) 
			background:setFillColor(67,141,241,180)
			
		elseif phase == "release" or phase == "tap" then
			print( "Tapped and/or Released row: " .. row.index )
			row.reRender = true
--			storyboard.showOverlay( "storyboard-details", { effect="fade", params={lr = listRecsDetailQuote}, isModal=true } )
--			-- go to new scene
			
		elseif phase == "swipeLeft" then
--			print( "Swiped Left row: " .. row.index )
			markLinkedBundle(event, true)
			row.reRender = true
			    
    	elseif phase == "swipeRight" then
--			print( "Swiped Right row: " .. row.index )
			markLinkedBundle(event, false)
			row.reRender = true
		end
	end -- rowListener

	for x = 1, #listRecsDetailQuote do
		list:insertRow {
			height = 60,
			onRender = onRowRender,
			listener = rowListener
		}
	end	
	
end -- showRecords



local function backBtnRelease( event )
--	print("back button released")
	transition.to(priceBar, {time=100, alpha=0})
	transition.to(priceHeader, {time=00, alpha=0})
	transition.to(backBtn, {time=100, alpha=0 })
	storyboard.gotoScene( "sceneQuotes", "fade", 400 ) 
	--delta, velocity = 0, 0
end

local function emailBtnRelease( event )
	-- compose an HTML email 
	if emailSending == nil then
		emailSending = email.new( nameOfQuoteToGet, listRecsDetailQuote )
	end
	emailSending:send()	
end

	--Setup the price bar 
	print( "starting priceBar" )
	priceBar = ui.newButton{
		default = "assets/navBar@2.png",
--		default = deviceSwitch.navBar,
		onRelease = scrollToTop
	}
	priceBar.x = display.contentWidth*.5
	--print ("priceBar coords: " ..display.contentWidth*.5 .."," ..display.screenOriginY + display.statusBarHeight + navBar.height*0.5)
--	priceBar.y = math.floor(display.screenOriginY + display.statusBarHeight + 19) --navBar.height*0.5)
	priceBar.y = math.floor(display.screenOriginY + display.statusBarHeight+20)
	resetMachinePrice()
	priceHeader = display.newText("Price: $" ..string.format("%i",MachinePrice), 0, 0, native.systemFontBold, 16)
	priceHeader:setTextColor(255, 255, 255)
	priceHeader.x = display.contentWidth*.5
	priceHeader.y = priceBar.y

	
	--	--Setup the back button
	backBtn = ui.newButton{ 
		default = "assets/backButton.png", 
		over = "assets/backButton_over.png", 
		onRelease = backBtnRelease
	}
	backBtn.x = math.floor(backBtn.width/2) + 5 
	backBtn.y = priceHeader.y 
	backBtn.alpha = 1
	
	
		--	--Setup the email button
	emailBtn = ui.newButton{ 
		default = "assets/email.png", 
		over = "assets/email-down.png", 
		onRelease = emailBtnRelease
	}
	emailBtn.x = display.contentWidth - emailBtn.width + 5 
	emailBtn.y = priceHeader.y 
	emailBtn.alpha = 1
	
	local bg = display.newImageRect(   "assets/Default@2.png", display.contentWidth, display.contentHeight )
--	local bg = display.newImageRect( deviceSwitch.globalBackgroundImage, 360, 570 )
	bg.x = display.contentWidth / 2
	bg.y = display.contentHeight / 2 + display.statusBarHeight
	list = widget.newTableView {
--		top = display.contentHeight-100,
		top = display.statusBarHeight*3,
		height = 864,
		width = 758,
--		height = device.contentHeight - 200,
		maskFile = "mask758.png"
	}
	list.x = 1

-- Called when the scene's view does not exist:
function scene:createScene( event )
	print( "\n1: entering detail Quote create event")
	screenGroup = self.view
	nameOfQuoteToGet = event.params.nameToGet
	db = event.params.database
	
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
	
--	print( "\n1: starting detail list loading  Quote  event")

	
	print( "\n\n -----------list area width: ".. display.contentWidth  .. " and " .. display.contentHeight .. "----------------------")
	listMaster = list
	screenGroup:insert(bg)
	screenGroup:insert(list)
	screenGroup:insert( priceBar )
	screenGroup:insert( priceHeader )
	screenGroup:insert( backBtn )
	screenGroup:insert( emailBtn )
	
	print( "\n1: inserted detailed bg and list, createScene Quote  event")
	
--	loadData()
	db = database.db
	listRecsDetailQuote = database:loadQuoteDetailDataIntoTable(listRecsDetailQuote, "select * from " ..nameOfQuoteToGet)
	showRecords()
	
--	resetMachinePrice()
--	priceHeader.text = "Price: $" .. MachinePrice
	 
--	priceHeader.x = display.contentWidth - ( backBtn.contentWidth/2 )

--	sceenGroup:insert( priceBar )
--	screenGroup:insert( backBtn )
	
	---- create scene
	print( "\n1: created Scene Quote  event")
end

--*** iPad: The lines below are some layout tweaks for the larger display size ***
--if system.getInfo("model") == "iPad" then	
--	Rather than creating a new graphic, let's just stretch the black bar at the top of the screen
--	priceBar.xScale = 6  
--
--	Set new default text since the list is now on the left
--	detailScreenText.text = "Tap an item on the left" 
--
--	Change the width and x position of the detail screen
--	detailBg.width = display.contentWidth - myList.width
--	detailScreen.x = myList.x + myList.width*0.5 + 1
--
--	Insert the selected color fill one level before the last item (which was the background inserted above)
--	list:insert(2,selected)
--	Adjust the x position of the selected color fill
--	selected.x = list.x + list.width*0.5
--end

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
	
--	listRecsQuoteMain = database:loadDataIntoTable(listRecsQuoteMain, "select * from " ..nameOfQuoteToGet)
--	showRecords()
	
	transition.to(priceBar, {time=400, alpha=1 })
	transition.to(priceHeader, {time=400, alpha=1 })
	transition.to(backBtn, {time=400, alpha=1 })
	
	resetMachinePrice()
	priceHeader.text = "Price: $" .. MachinePrice
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