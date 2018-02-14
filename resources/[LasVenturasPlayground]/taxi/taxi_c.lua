-- Taxi script by Jay
taxiLocations = nil
timeLastUsedTaxi = nil

function taxiCommandHandler( commandName, taxiId)
	
	if(timeLastUsedTaxi ~= nil ) then
		if(getTickCount() - timeLastUsedTaxi < 60000) then 
			outputChatBox("* Kaufman Cabs are currently busy. Please call again soon.", 255, 0, 0)
		return end
	end 
	
	if(getPedOccupiedVehicle(localPlayer) ~= false) then 
		outputChatBox("You need to be on foot.", 255, 0, 0)
	return end
	
	if tonumber(taxiId) == nil then
		outputChatBox("Please enter a taxi ID number. See /locations", 255, 0, 0)
	return end 
	
	taxiId = tonumber(taxiId)
	
	if(taxiId < 0 or taxiId > #taxiLocations -1) then 
		outputChatBox("Invalid taxi ID, see /locations.", 255, 0, 0)
	return end

	timeLastUsedTaxi = getTickCount()
	taxiId = taxiId + 1
	
	fadeCamera(false, 3)
	toggleAllControls(false)
	
	setTimer( function()
		setElementPosition(localPlayer, taxiLocations[taxiId].x, taxiLocations[taxiId].y, taxiLocations[taxiId].z)
		fadeCamera(true)
		toggleAllControls(true)
		outputChatBox("*** Thanks for using Kaufman Cabs v0.1 - I'll add more features to it soon ;)", 255, 255, 0)
	end, 3000, 1)
	
end 
addCommandHandler("taxi", taxiCommandHandler, false, false)

function locationsCommandHandler()
	outputChatBox("Taxi Locations(" ..#taxiLocations  .."):", 255, 0, 255)

	for theKey, theTaxiData in ipairs(taxiLocations) do 
		outputChatBox( tostring( theKey -1 ) .. ". " ..tostring(taxiLocations[theKey].name), 255, 255, 0)
	end 
end
addCommandHandler("locations", locationsCommandHandler, false, false)


addEvent("updateClientTaxiLocationData", true)
addEventHandler("updateClientTaxiLocationData", localPlayer,
	function(taxiData)
		outputDebugString("Taxi: updateClientTaxiLocations from server. Data: " ..inspect(taxiData))
		taxiLocations = taxiData
	end 
)

addEventHandler("onClientResourceStart", root,
	function(startedResource)
		if(startedResource == resource) then 
			triggerServerEvent("onClientRequestTaxiLocations", resourceRoot)
		end
	end
)

