function updateRadioSettings()
	triggerClientEvent("updateRadioStreamUrl", resourceRoot, get("streamUrl"))
	triggerClientEvent("updateRadioStreamName", resourceRoot, get("streamName"))
end

addEventHandler ( "onVehicleStartEnter", getRootElement(), updateRadioSettings)
addEventHandler ( "onPlayerJoin", getRootElement(), updateRadioSettings)
