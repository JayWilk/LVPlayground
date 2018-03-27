railElement = nil

addEvent("onClientRequestGivePlayerPirateShipMoney", true)
addEventHandler("onClientRequestGivePlayerPirateShipMoney", resourceRoot,
	function()
		
		if not client then
			return
		end
		
		givePlayerMoney(client, get("*pirateShipMoneyAmount"))
		
	end 
)


addEventHandler("onSettingChange", resourceRoot,
	function(theSetting, oldValue, newValue)
		if theSetting == "*" ..getResourceName(resource) ..".pirateShipEnableRail" then
			processShipRail()
		end 
	end 
)



function processShipRail()

	if get("*pirateShipEnableRail") == "true" then
	
		local xml = xmlLoadFile(get("@pirateShipRailMapFile"))
		loadMapData(xml, resourceRoot)
		xmlUnloadFile(xml)
		
	else
	
		destroyElement(getElementsByType("shipRamp")[1])
		
	end 
end 

addEventHandler("onResourceStart", resourceRoot, processShipRail)