--[[

<°))><

Public Services - Shops
(c) 2008 mabako network. All Rights reserved.

]]

local shops = { }
local shopFromCol = { }



function onResourceStart(res)
	local shopElements = getElementsByType ( "shop", getResourceRootElement(res) )
	for k,v in ipairs(shopElements) do
		local num = #shops+1
		shops[num] = { }
		shops[num].ID = getElementData( v, "id" )
		shops[num].Type = getElementData( v, "type" )
		shops[num].Name = getElementData( v, "name" )
		
		shops[num].PosX = tonumber( getElementData( v, "posX" ) )
		shops[num].PosY = tonumber( getElementData( v, "posY" ) )
		shops[num].PosZ = tonumber( getElementData( v, "posZ" ) )
		shops[num].Rotation = tonumber( getElementData( v, "rotation" ) )
		shops[num].Interior = tonumber( getElementData( v, "interior" ) )
		-- gui Stuff
		shops[num].Rows = tonumber( getElementData( v, "rows" ) )
		shops[num].Columns = tonumber( getElementData( v, "columns" ) )
		
		local max_item_count = shops[num].Rows * shops[num].Columns
		
		-- now get all Items to sell there
		shops[num].Articles = { }
		
		local sInfo = getElementChildren( v )
		for sk,sv in ipairs( sInfo ) do
			if (getElementType( sv ) == "article") then
				local sNum = #shops[num].Articles + 1
				shops[num].Articles[ sNum ] = { }
				shops[num].Articles[ sNum ].ID = getElementData( sv, "id" )
				shops[num].Articles[ sNum ].Name = getElementData( sv, "name" )
				shops[num].Articles[ sNum ].Price = tonumber( getElementData( sv, "price" ) )
				
				-- Ammu-Nation specific, others will have false
				shops[num].Articles[ sNum ].Ammo = tonumber( getElementData( sv, "ammo" ) )
				shops[num].Articles[ sNum ].WeaponID = tonumber( getElementData( sv, "weaponid" ) )
				
			end
		end
		
		-- create a marker & col-shape
		shops[num].Col = createColTube( shops[num].PosX, shops[num].PosY, shops[num].PosZ - 1, 1, 3)
		shopFromCol[ shops[num].Col ] = num
	end
end

function onColShapeHit( hitPlayer, matching_dimension )
	if( getElementType( hitPlayer ) ~= "player" ) then return end -- not for Vehicles
	
	local num = shopFromCol[ source ]
	if( not num ) then 
		return 
	end
	
	toggleAllControls( hitPlayer, false, true, false )
	
	triggerClientEvent( hitPlayer, "createShopWindow", hitPlayer, shops[num].Type, shops[num].Columns, shops[num].Rows, shops[num].Name, num )
	for v = 1,#shops[num].Articles,1 do 
		local additional = nil
		if( shops[num].Articles[v].Ammo ) then 
			additional = tostring( shops[num].Articles[v].Ammo ) .. "x" 
		end
		
		triggerClientEvent( hitPlayer, "addShopArticle", hitPlayer, shops[num].Articles[v].ID, shops[num].Articles[v].Name, shops[num].Articles[v].Price, v, additional )
	end
	
	setTimer( 
		function(h,x,y,z,r)
			setElementPosition( h,x,y,z )
			setPedRotation( h,r )
		end, 
	250, 1, hitPlayer, shops[num].PosX, shops[num].PosY, shops[num].PosZ, shops[num].Rotation )
end

addEventHandler( "onResourceStart", getResourceRootElement(getThisResource()), onResourceStart)
addEventHandler( "onColShapeHit", getResourceRootElement(getThisResource()), onColShapeHit )


function requestServicesShopMarkers( )
	for num = 1,#shops,1 do
		triggerClientEvent( source, "recieveServicesShopMarkers", source, shops[num].PosX, shops[num].PosY, shops[num].PosZ, shops[num].Interior )
	end
end



addEvent( "requestServicesShopMarkers", true )
addEventHandler( "requestServicesShopMarkers", getRootElement(), requestServicesShopMarkers )




function buyShopArticle( shopID, articleID )
	-- get the article's ID
	if( not shops[shopID] ) then return end
	
	if( not shops[shopID].Articles[articleID] ) then return end
	

	-- enough money?
	if( getPlayerMoney( source ) < shops[shopID].Articles[articleID].Price ) then
		outputChatBox("You don't have enough money for a " .. shops[shopID].Articles[articleID].Name .. "!", source, 255, 255, 0 )
		return
	end

	takePlayerMoney( source, shops[shopID].Articles[articleID].Price )
	
	-- give it
	outputChatBox("You bought a " .. shops[shopID].Articles[articleID].Name .. "! Costs: $" .. shops[shopID].Articles[articleID].Price, source, 0, 255, 0)
	

	if( shops[shopID].Articles[articleID].WeaponID ) then
		if( shops[shopID].Articles[articleID].Ammo and tonumber( shops[shopID].Articles[articleID].Ammo ) > 1 ) then
			giveWeapon( source, shops[shopID].Articles[articleID].WeaponID, shops[shopID].Articles[articleID].Ammo, false )
		else
			giveWeapon( source, shops[shopID].Articles[articleID].WeaponID, 1, false )
		end
	end
end

addEvent( "buyShopArticle", true )
addEventHandler( "buyShopArticle", getRootElement(), buyShopArticle )

