rampId = nil
rampVisbilityTime = nil
rampObject = nil
rampTimer = nil
rampControlKey = nil

function spawnRamp()
	outputDebugString("spawnRamp")

	if rampObject then
		destroyElement(rampObject)
		if(rampTimer) then
			killTimer(rampTimer)
		end 
	end 
	
	
	local x,y,z = getElementPosition( localPlayer ) 

	rampObject = createObject(rampId, getXYInFrontOfPlayer(5), 0, 0, 0)
	rampTimer = setTimer(destroyRamp, rampVisbilityTime, 1)
end 

function destroyRamp()
	destroyElement(rampObject)
	killTimer(rampTimer)
	
	rampTimer = nil
	rampObject = nil
end 

addEventHandler("onClientVehicleEnter", root,
	function()
		if(getVehicleType(source) == "Automobile" or getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX"
		or getVehicleType(source) == "Monster Truck" or getVehicleType(source) == "Quad") then 
			bindKey("lctrl", "down", spawnRamp)
		end
	end 
)

addEventHandler("onClientVehicleExit", root, function()
		unbindKey("lctrl", "down", spawnRamp)
	end 
)



addEvent("onServerProvideRampingObjectIdInformation", true)
addEventHandler("onServerProvideRampingObjectIdInformation", resourceRoot,
	function(theRampId)
		outputDebugString("The ramp id: " ..tostring(theRampId))
		rampId = theRampId
	end 
)

addEvent("onServerProvideRampingTimeInformation", true)
addEventHandler("onServerProvideRampingTimeInformation", resourceRoot,
	function(theTime)
		rampVisbilityTime = theTime
		outputDebugString("The ramp VIS time: " ..tostring(theTime))
	end 
)

addEvent("onServerProvideRampingControlInformation", true)
addEventHandler("onServerProvideRampingControlInformation", resourceRoot,
	function(theKey)
		rampControlKey = theKey
		outputDebugString("The ramp key : " ..tostring(theKey))
	end 
)

addEventHandler("onClientResourceStart", root,
	function()
		triggerServerEvent("onClientRequestRampingObjectId", resourceRoot)
		triggerServerEvent("onClientRequestRampingVisbilityTime", resourceRoot)
		triggerServerEvent("onClientRequestRampingControlKey", resourceRoot)
	end
)

function getXYInFrontOfPlayer( distance )
	local x, y, z = getElementPosition( localPlayer)
	local rot = getPlayerRotation( localPlayer )
	x = x + math.sin( math.rad( rot ) ) * distance
	y = y + math.cos( math.rad( rot ) ) * distance
	return x, y, z
end
