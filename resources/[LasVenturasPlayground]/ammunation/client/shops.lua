--[[

<°))><

Public Services - Shops
(c) 2008 mabako network. All Rights reserved.

]]

local _local = getLocalPlayer()
local shops = { }
local shopFromCol = { }

function recieveServicesShopMarkers( x, y, z, i )
	local num = #shops+1
	shops[num] = { }
	shops[num].PosX = x
	shops[num].PosY = y
	shops[num].PosZ = z
	shops[num].Interior = i
	
	shops[num].Col = createColTube ( x, y, z-20, 40, z+20 )
	shops[num].Marker = nil
	
	setElementInterior( shops[num].Col, i )
	
	shopFromCol[ shops[num].Col ] = num
end

function onClientColShapeHitx( hitPlayer ) 
	if( hitPlayer ~= _local ) then return end

	local num = shopFromCol[ source ] 
	if( not num ) then return end
	
	if( shops[num].Marker == nil ) then
		shops[num].Marker = createMarker( shops[num].PosX, shops[num].PosY, shops[num].PosZ-1, "cylinder", 0.5, 255, 0, 0, 100 )
		setElementParent( shops[num].Marker, shops[num].Col )
		setElementDimension( shops[num].Marker, getElementDimension( _local ) )
		setElementInterior( shops[num].Marker, getElementInterior(localPlayer) )
	end
end

function onClientColShapeLeavex( hitPlayer ) 
	if( hitPlayer ~= _local ) then return end

	local num = shopFromCol[ source ] 
	if( not num ) then return end
	
	if( shops[num].Marker ) then
		destroyElement( shops[num].Marker )
		shops[num].Marker = nil
	end
end

function onClientResourceStartx( res )
	setTimer( triggerServerEvent, 3000, 1, "requestServicesShopMarkers", _local )
end

addEvent( "recieveServicesShopMarkers", true )
addEventHandler( "recieveServicesShopMarkers", getRootElement(), recieveServicesShopMarkers )

addEventHandler( "onClientColShapeHit", getResourceRootElement(getThisResource()), onClientColShapeHitx )
addEventHandler( "onClientColShapeLeave", getResourceRootElement(getThisResource()), onClientColShapeLeavex )
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), onClientResourceStartx )

---

local sMenu = nil
local sButtons = { }
local sImages = { }
local sNoStockImages = { }
local lastColumn = 0
local lastRow = 0
local columns
local rows
local width
local height
local sType 
local x,y
local RefFromID = { }
local IDFromButton = { }
local shopID = nil
local WeaponsEnabled = false

function setToBG( )
	guiMoveToBack( source )
end

function destroyShopMenu( )
	destroyElement( sMenu )
	showCursor( false )
	toggleAllControls( true, true, false )
	
	-- destroy all images/buttons
	for k,v in pairs( RefFromID ) do
		destroyElement( v.Image )
		destroyElement( v.Button )
		
		if(isElement(v.NoStock)) then 
			destroyElement( v.NoStock )
		end 
		
		IDFromButton[ v.Button ] = nil
		RefFromID[k] = nil
		sButtons[k] = nil
		sImages[k] = nil
	end	
	destroyElement( sButtons.Exit )
	
	sMenu = nil
	shopID = nil
	
	-- do something about weapons
	if( WeaponsEnabled == false ) then
		toggleControl( "fire", false )
		toggleControl( "aim_weapon", false )
	end
end

function buyShopArticle( button, state )
	local id = IDFromButton[source]
	
	if( not id ) then return end
	if( guiGetVisible( sButtons[id] ) == false ) then return end
	
	triggerServerEvent( "buyShopArticle", _local, shopID, id )
end

function createShopWindow( type, cols, ros, name, id )
	if( sMenu ) then
		destroyShopMenu( )
	end
	
	columns = cols
	rows = ros
	sType = type
	x, y = guiGetScreenSize()
	shopID = id
	lastColumn = 0
	lastRow = 0
	
	if( type == "ammu" ) then
		width = columns * 110 + 10
		height = rows * 120 + 50
	else	
		width = columns * 100
		height = rows * 100
	end
	
	sMenu = guiCreateWindow ( x/2 - width/2, y - height - 20, width, height, name, false )
		guiWindowSetMovable( sMenu, false )
		guiWindowSetSizable( sMenu, false )
		guiSetAlpha( sMenu, 0.60 )
	addEventHandler( "onClientGUIClick", sMenu, setToBG )
		
	sButtons.Exit = guiCreateButton ( x/2 + width/2 - 70, y - 50, 60, 20, "Exit", false, nil )
	guiBringToFront( sButtons.Exit )
	addEventHandler( "onClientGUIClick", sButtons.Exit, destroyShopMenu )

	guiSetVisible( sMenu, true )
	showCursor( true )
	
	setTimer(setCameraTarget, 300, 1, localPlayer, localPlayer)
	
end

function addShopArticle( img, name, price, articleID, additional, enabled )
	if( not sMenu ) then return end
	
	if( sType == "ammu" ) then
		sImages[articleID] = guiCreateStaticImage( x/2 - width/2 + 110*lastColumn + 28, y - height - 2 + 120*lastRow, 64, 64, "client/img/"  .. img .. ".png", false, nil )
		
		if( enabled == "false" ) then 
			sNoStockImages[articleID] = guiCreateStaticImage( x/2 - width/2 + 110*lastColumn + 28, y - height - 2 + 120*lastRow, 64, 64, "client/img/NOSTOCK.png", false, nil )
		end 
		
		
		local buttonText = ""
		
		if enabled == "false" then
			buttonText = "Out of Stock"
		else
			if( additional ) then 
				buttonText = name .. "\n" .. tostring( additional ) .. " - $" .. tostring( price )
			else
				buttonText = name .. "\n$" .. tostring( price )
			end
		end
		
		sButtons[articleID] = guiCreateButton( x/2 - width/2 + 110*lastColumn + 10, y - height + 70 + 120*lastRow, 100, 40, buttonText, false, nil )
		
		if enabled == "false" then
			guiSetEnabled(sButtons[articleID], false)
			guiSetEnabled(sImages[articleID], false)
		end 
		
	end
	
	if( sButtons[articleID] ) then
		
		lastColumn = lastColumn + 1
		if( lastColumn == columns ) then
				lastRow = lastRow + 1 
				lastColumn = 0
		end
		
		-- some stuff for ease
		RefFromID[ articleID ] = { }
		RefFromID[ articleID ].Image = sImages[articleID]
		RefFromID[ articleID ].NoStock = sNoStockImages[articleID]
		RefFromID[ articleID ].Button = sButtons[articleID]
		
		
		IDFromButton[ sButtons[articleID] ] = articleID
		
		addEventHandler( "onClientGUIClick", sButtons[articleID], buyShopArticle )
	end
end

addEvent( "destroyShopMenu", true )
addEventHandler( "destroyShopMenu", getRootElement(), destroyShopMenu )
addEvent( "createShopWindow", true )
addEventHandler( "createShopWindow", getRootElement(), createShopWindow )
addEvent( "addShopArticle", true )
addEventHandler( "addShopArticle", getRootElement(), addShopArticle )
addEvent( "changeWeaponsEnabled", true )
addEventHandler( "changeWeaponsEnabled", getRootElement(), function(e)
	WeaponsEnabled = e
end)

