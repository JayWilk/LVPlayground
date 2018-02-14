function getTaxiLocationsHandler()

	outputDebugString("getTaxiLocationsHandler. Client player source: " ..getPlayerName(client))
	
	local taxiLocations = {}
	local i = 1

	for theKey, theTaxiData in ipairs(getElementsByType("taxiLocation")) do 
		taxiLocations[i] = { }
		taxiLocations[i].x = getElementData(theTaxiData, "locationX")
		taxiLocations[i].y = getElementData(theTaxiData, "locationY")
		taxiLocations[i].z = getElementData(theTaxiData, "locationZ")
		taxiLocations[i].r = getElementData(theTaxiData, "rotation")
		taxiLocations[i].name = getElementData(theTaxiData, "name")
		i = i + 1
	end
	
	triggerClientEvent(client, "updateClientTaxiLocationData", client, taxiLocations)
end
	
addEvent("onClientRequestTaxiLocations", true)
addEventHandler("onClientRequestTaxiLocations", getRootElement(), getTaxiLocationsHandler)
	