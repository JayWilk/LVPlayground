rampModelId = nil
rampVisbilityTime = nil
rampObject = nil
rampTimer = nil
rampControlKey = nil
rampSpawnDistance = nil

function spawnRamp()

	if rampObject then
		destroyElement(rampObject)
		if(rampTimer) then
			killTimer(rampTimer)
		end 
	end 

	local theVehicle = getPedOccupiedVehicle(localPlayer)
	local x, y, z = getElementPosition(theVehicle)
	local rx, ry, rz = getElementRotation(theVehicle)
	
	x,y = getXYInFrontOfPlayer(rampSpawnDistance)
	
	rampObject = createObject(rampModelId, x, y, z, 0, 0, rz)
	rampTimer = setTimer(destroyRamp, rampVisbilityTime, 1)
end 

function destroyRamp()
	destroyElement(rampObject)
	killTimer(rampTimer)
	
	rampTimer = nil
	rampObject = nil
end 

function getXYInFrontOfPlayer( distance ) 
    local x,y,z = getElementPosition( localPlayer ) 
    local rotation = getPlayerRotation( localPlayer ) 
    rotation = rotation/180*3.141592 
    x = x - ( math.sin(rotation) * distance ) 
    y = y + ( math.cos(rotation) * distance ) 
    return x, y 
end 

addEventHandler("onClientVehicleEnter", root,
	function()
		if(getVehicleType(source) == "Automobile" or getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX"
		or getVehicleType(source) == "Monster Truck" or getVehicleType(source) == "Quad") then 
			bindKey(rampControlKey, "down", spawnRamp)
		end
	end 
)	

addEventHandler("onClientVehicleExit", root, 
	function()
		unbindKey(rampControlKey, "down", spawnRamp)
	end 
)

addEvent("onServerProvideRampingObjectIdInformation", true)
addEventHandler("onServerProvideRampingObjectIdInformation", resourceRoot,
	function(therampModelId)
		rampModelId = therampModelId
	end 
)

addEvent("onServerProvideRampingTimeInformation", true)
addEventHandler("onServerProvideRampingTimeInformation", resourceRoot,
	function(theTime)
		rampVisbilityTime = theTime
	end 
)

addEvent("onServerProvideRampingControlInformation", true)
addEventHandler("onServerProvideRampingControlInformation", resourceRoot,
	function(theKey)
		if(rampControlKey) then 
			-- Remove any existsing binds in case this is being updated
			unbindKey(rampControlKey, "down", spawnRamp)
		end
		rampControlKey = theKey
	end 
)

addEvent("onServerProvideRampingSpawnDistanceInformation", true)
addEventHandler("onServerProvideRampingSpawnDistanceInformation", resourceRoot,
	function(theDistance)
		rampSpawnDistance = theDistance
	end 
)

addEventHandler("onClientResourceStart", root,
	function()
		triggerServerEvent("onClientRequestRampingObjectId", resourceRoot)
		triggerServerEvent("onClientRequestRampingVisbilityTime", resourceRoot)
		triggerServerEvent("onClientRequestRampingControlKey", resourceRoot)
		triggerServerEvent("onClientRequestRampingSpawnDistance", resourceRoot)
	end
)