function updateRadioStreamInformation(localPlayer)	
	local element
	if client then element = client else element = root end
	
	triggerClientEvent("onClientReceiveRadioStreamUrlInformation", element, get("streamUrl"))
	triggerClientEvent("onClientReceiveRadioStreamTitleInformation", element, get("streamName"))
end

addEventHandler("onSettingChange", root, 
	function(theSetting)
	
		local resourceName = getResourceName(resource)
	
		if(theSetting == "*" ..resourceName ..".streamName" or theSetting == "*" ..resourceName ..".streamUrl") then
			updateRadioStreamInformation()
		end
	end
)
addEvent("onClientRequestRadioStreamInformation", true)
addEventHandler("onClientRequestRadioStreamInformation", resourceRoot, updateRadioStreamInformation)
