function updateVehicleBlipRadius()
	local element
	if client then element = client else element = root end
	outputDebugString("Updating vehicle blip radius to " ..tostring(get("blipStreamRadius")))
	triggerClientEvent("onClientReceiveBlipRadiusInformation", element, get("blipStreamRadius"))
end

addEventHandler("onSettingChange", resourceRoot, 
	function(theSetting)
		if(theSetting == "*" .. getResourceName(resource) .. ".blipStreamRadius") then
			updateVehicleBlipRadius()
		end 
	end
)

addEvent("onClientRequestVehicleBlipRadiusValue", true)
addEventHandler("onClientRequestVehicleBlipRadiusValue", resourceRoot, updateVehicleBlipRadius)
