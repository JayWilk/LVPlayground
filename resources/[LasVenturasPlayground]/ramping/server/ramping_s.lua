function updateRampingObjectIdInformation()
	triggerClientEvent("onServerProvideRampingObjectIdInformation", root, get("rampObjectId"))
end 

function updateRampingTimeInformation()
	triggerClientEvent("onServerProvideRampingTimeInformation", root, get("rampVisibilityTime"))
end 

function updateRampingControlKey()
	triggerClientEvent("onServerProvideRampingControlInformation", root, get("rampControlKey"))
end 

function updateRampingSpawnDistance()
	triggerClientEvent("onServerProvideRampingSpawnDistanceInformation", root, get("rampSpawnDistance"))
end 



addEvent("onClientRequestRampingControlKey", true)
addEventHandler("onClientRequestRampingControlKey", root, updateRampingControlKey)

addEvent("onClientRequestRampingObjectId", true)
addEventHandler("onClientRequestRampingObjectId", root, updateRampingObjectIdInformation)

addEvent("onClientRequestRampingVisbilityTime", true)
addEventHandler("onClientRequestRampingVisbilityTime", root, updateRampingTimeInformation)

addEvent("onClientRequestRampingSpawnDistance", true)
addEventHandler("onClientRequestRampingSpawnDistance", root, updateRampingSpawnDistance)

addEventHandler("onSettingChange", root, 
	function(theSetting)
	
		if(theSetting == "*" .. getResourceName(resource) .. ".rampObjectId") then
			updateRampingObjectIdInformation()
		return end 
	
		if(theSetting == "*" .. getResourceName(resource) .. ".rampVisibilityTime") then
			updateRampingTimeInformation()
		return end 
		
		if(theSetting == "*" .. getResourceName(resource) .. ".rampControlKey") then
			updateRampingControlKey()
		return end 
		
		if(theSetting == "*" .. getResourceName(resource) .. ".rampSpawnDistance") then
			updateRampingSpawnDistance()
		return end 
	
	end
)
