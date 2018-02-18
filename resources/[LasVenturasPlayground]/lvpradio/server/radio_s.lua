function updateRadioStreamInformation()
	triggerClientEvent("onClientReceiveRadioStreamUrlInformation", resourceRoot, get("streamUrl"))
	triggerClientEvent("onClientReceiveRadioStreamTitleInformation", resourceRoot, get("streamName"))
end

addEvent("onClientRequestRadioStreamInformation", true)
addEventHandler("onClientRequestRadioStreamInformation", resourceRoot, updateRadioStreamInformation)
addEventHandler("onSettingChange", resourceRoot, updateRadioStreamInformation)