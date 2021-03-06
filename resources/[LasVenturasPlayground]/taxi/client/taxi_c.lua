-- Taxi script by Jay
taxiLocations = nil
playerTaxiId = 0
hasPlayerCalledTaxi = false

addEvent("onServerProvideTaxiLocationData", true)
addEventHandler("onServerProvideTaxiLocationData", localPlayer,
	function(taxiData)
		taxiLocations = taxiData
	end 
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		triggerServerEvent("onClientRequestTaxiLocations", resourceRoot)
	end
)

addEvent("onClientCancelTaxi")
addEventHandler("onClientCancelTaxi", localPlayer,
	function()
		exports.display:addNotification("You've cancelled your taxi", "success")
		resetTaxiData()
		setTimer(
			function()
				exports.display:showHint("You can complete taxi missions at Kaufman Cabs near Old Venturas Strip to decrease taxi waiting times.")
			end, 
		6000, 1)
	end 
)

addEvent("onClientTaxiArrive")
addEventHandler("onClientTaxiArrive", localPlayer,
	function()
		fadeCamera(false, 1.0, 255, 255, 0)
		toggleAllControls(false)
		
		setTimer( function()
		
			setElementPosition(localPlayer, 
				getElementData(taxiLocations[playerTaxiId], "posX"), 
				getElementData(taxiLocations[playerTaxiId], "posY"), 
				getElementData(taxiLocations[playerTaxiId], "posZ"))
				
			setElementInterior(localPlayer, 0)
			
			fadeCamera(true)
			
			toggleAllControls(true)
			resetTaxiData()
		end, 1500, 1)
	end 
)


addCommandHandler("taxi", 
	function(theCommand, taxiId)
		
		if hasPlayerCalledTaxi then
			return
		end
		
		if(getPedOccupiedVehicle(localPlayer) ~= false) then 
			exports.display:outputCommandError(getLocalizedText("command.taxi.onfoot"))
			return 
		end
		
		if tonumber(taxiId) == nil then
				exports.display:outputCommandSyntax(theCommand, "taxiId")
				setTimer(
					function()
						exports.display:showHint(getLocalizedText("command.taxi.locations.hint"))
					end, 
				1000, 1)
			return 
		end 
		
		taxiId = tonumber(taxiId)
		if(taxiId < 0 or taxiId > #taxiLocations -1) then 
			exports.display:outputCommandError(getLocalizedText("command.taxi.invalid.location"))
			setTimer(
					function()
						exports.display:showHint(getLocalizedText("command.taxi.locations.hint"))
					end, 
				1000, 1)
			return 
		end

		triggerEvent("onClientRequestTaxi", localPlayer, taxiId + 1)

	end,
false, false)

addCommandHandler("locations", 
	function()
		outputChatBox(getLocalizedText("command.locations").." (" ..#taxiLocations  .."):", 255, 0, 255)

		for theKey, theElement in ipairs(taxiLocations) do 
			outputChatBox( tostring( theKey -1 ) .. ". " ..getElementData(theElement, "name", false), 255, 255, 0)
		end 
	end, 
false, false)

addEvent("onClientRequestTaxi")
addEventHandler("onClientRequestTaxi", localPlayer,
	function(taxiLocationId)
	
		playerTaxiId = taxiLocationId
		hasPlayerCalledTaxi = true
		
		showTaxiPane(0.0005 + math.random()  * (0.00009 - 0.0005))		
		
		exports.display:addNotification(getLocalizedText("taxi.confirmation.notification") .." "..getElementData(taxiLocations[taxiLocationId], "name"), "success")
	end 
)

addEventHandler("onClientPlayerVehicleEnter", localPlayer,
	function()
		if hasPlayerCalledTaxi then
			resetTaxiData()
			setTimer(
				function()
					exports.display:addNotification(getLocalizedText("taxi.cancelled.vehicle.enter"), "info")
				end,
			3000, 1)
		end 
	end 
)

addEventHandler("onClientPlayerWasted", localPlayer,
	function()
		if hasPlayerCalledTaxi then
			resetTaxiData()
		end
	end 
)


function resetTaxiData()
	resetTaxiInterfaceData()
	playerTaxiId = 0
	hasPlayerCalledTaxi = false
end 

function getLocalizedText(lang_code, ...)
	return exports.languagemanager:getLocalizedText(localPlayer, lang_code, ...)
end
	
