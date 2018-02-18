addEvent("onClientRequestVehicleBlipRadiusValue", true)
addEventHandler("onClientRequestVehicleBlipRadiusValue", resourceRoot,
	function()
		outputDebugString("Updating vehicle blip radius to " ..tostring(get("blipStreamRadius")))
		triggerClientEvent("onClientReceiveBlipRadiusInformation", resourceRoot, get("blipStreamRadius"))
	end
)