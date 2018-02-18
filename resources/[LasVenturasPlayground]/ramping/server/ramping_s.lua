function updateRampingObjectIdInformation()
	triggerClientEvent("onServerProvideRampingObjectIdInformation", root, get("rampObjectId"))
end 

function updateRampingTimeInformation()
	triggerClientEvent("onServerProvideRampingTimeInformation", root, get("rampVisibilityTime"))
end 

function updateRampingControlKey()
	triggerClientEvent("onServerProvideRampingControlInformation", root, get("rampControlKey"))
end 

addEvent("onClientRequestRampingControlKey", true)
addEventHandler("onClientRequestRampingControlKey", root, updateRampingControlKey)

addEvent("onClientRequestRampingObjectId", true)
addEventHandler("onClientRequestRampingObjectId", root, updateRampingObjectIdInformation)

addEvent("onClientRequestRampingVisbilityTime", true)
addEventHandler("onClientRequestRampingVisbilityTime", root, updateRampingTimeInformation)