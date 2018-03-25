-- Taxi script by Jay
taxiLocations = nil
timeLastUsedTaxi = nil

function taxiCommandHandler( commandName, taxiId)
	
	if(timeLastUsedTaxi ~= nil ) then
		if(getTickCount() - timeLastUsedTaxi < 60000) then 
			exports.display:outputCommandError("Kaufman Cabs are busy - please call again soon.")
			return 
		end
	end 
	
	if(getPedOccupiedVehicle(localPlayer) ~= false) then 
		exports.display:outputCommandError("You need to be on foot.")
		return 
	end
	
	if tonumber(taxiId) == nil then
			exports.display:outputCommandSyntax(commandName, "taxiId")
			setTimer(
				function()
					exports.display:showHint("Use /locations to see a list of taxi locations.")
				end, 
			1000, 1)
		return 
	end 
	
	taxiId = tonumber(taxiId)
	
	if(taxiId < 0 or taxiId > #taxiLocations -1) then 
		exports.display:outputCommandError("Invalid taxi ID.")
		setTimer(
				function()
					exports.display:showHint("Use /locations to see a list of taxi locations.")
				end, 
			1000, 1)
		return 
	end

	timeLastUsedTaxi = getTickCount()
	taxiId = taxiId + 1
	
	fadeCamera(false, 3)
	toggleAllControls(false)
	
	exports.display:addNotification("You've called a taxi to " ..taxiLocations[taxiId].name, "success")
	
	setTimer( function()
		setElementPosition(localPlayer, taxiLocations[taxiId].x, taxiLocations[taxiId].y, taxiLocations[taxiId].z)
		fadeCamera(true)
		toggleAllControls(true)
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

