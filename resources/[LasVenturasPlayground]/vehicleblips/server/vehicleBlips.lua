function updateVehicleBlipRadius()
	outputDebugString("Updating vehicle blip radius to " ..tostring(get("blipStreamRadius")))
	triggerClientEvent("onClientReceiveBlipRadiusInformation", resourceRoot, get("blipStreamRadius"))
end

addEvent("onClientRequestVehicleBlipRadiusValue", true)
addEventHandler("onClientRequestVehicleBlipRadiusValue", resourceRoot, updateVehicleBlipRadius)
addEventHandler("onSettingChange", resourceRoot, updateVehicleBlipRadius)