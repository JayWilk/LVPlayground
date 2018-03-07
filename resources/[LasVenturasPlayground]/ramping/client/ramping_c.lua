rampModelId = 0
rampVisbilityTime = 0
rampObject = nil
rampTimer = nil
rampControlKey = nil
rampSpawnDistance = nil
rampLastCollisionTime = nil
numberOfConsecutiveRampsClimbed = 0
checkToEndRampingSequenceTimer = nil

addEvent("onClientStartRamping")
addEventHandler("onClientStartRamping", root,
	function()
	end 
)

addEvent("onClientEndRamping")
addEventHandler("onClientEndRamping", root,
	function()
	end 
)

addEvent("onClientPerformRamping")
addEventHandler("onClientPerformRamping", localPlayer, 
	function(numberOfConsecutiveRamps) 
		if(numberOfConsecutiveRamps > 1) then -- todo: manage settings
			playSFX("genrl", 52, 18, false)
		end 
	end
)

addEventHandler("onClientVehicleEnter", root,
	function()
		if(getVehicleType(source) == "Automobile" or getVehicleType(source) == "Bike" or getVehicleType(source) == "BMX"
		or getVehicleType(source) == "Monster Truck" or getVehicleType(source) == "Quad") then 
			bindKey(rampControlKey, "down", spawnRampInfrontOfPlayer)
		end
	end 
)	

addEventHandler("onClientVehicleExit", root, 
	function()
		unbindKey(rampControlKey, "down", spawnRampInfrontOfPlayer)
		unbindKey(rampControlKey, "down", showRampingInformationToPlayer)
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
			unbindKey(rampControlKey, "down", spawnRampInfrontOfPlayer)
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

addEventHandler("onClientVehicleCollision", root, 
	function(theHitElement)
		if(theHitElement and source == getPedOccupiedVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0) then
			if getElementModel(theHitElement) == tonumber(rampModelId) then
			
				if(rampLastCollisionTime) then 
				
					local timeSinceLastRampCollision = getTickCount() - rampLastCollisionTime
					if(timeSinceLastRampCollision > 500 and timeSinceLastRampCollision < 3000) then
							numberOfConsecutiveRampsClimbed = numberOfConsecutiveRampsClimbed + 1
							triggerEvent("onClientPerformRamping", localPlayer, numberOfConsecutiveRampsClimbed)
					end 
				else  
					triggerEvent("onClientStartRamping", localPlayer)
				    checkToEndRampingSequenceTimer = setTimer(checkToEndRampingSequence, 100, 0)
				end 
				
				rampLastCollisionTime = getTickCount()
			end 
		end
	end 
)

function spawnRampInfrontOfPlayer()

	if not isRampingEnabled() then
		return
	end

	if rampObject then
		destroyElement(rampObject)
		if(rampTimer) then
			killTimer(rampTimer)
		end 
	end 

	local rx, ry, rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
	local x, y, z = getElementPosition( localPlayer ) 
	
    local rotation = getPedRotation( localPlayer ) 
    rotation = rotation / 180 * math.pi
    x = x - ( math.sin(rotation) * rampSpawnDistance ) 
    y = y + ( math.cos(rotation) * rampSpawnDistance ) 
	
	rampObject = createObject(rampModelId, x, y, z, 0, 0, rz)
	setElementDimension(rampObject, getElementDimension(localPlayer))
	
	rampTimer = setTimer(destroyRamp, rampVisbilityTime, 1)
	
end 


function destroyRamp()
	destroyElement(rampObject)
	killTimer(rampTimer)
	
	rampTimer = nil
	rampObject = nil
end 

function checkToEndRampingSequence()
	if(not getPedOccupiedVehicle(localPlayer) or (getTickCount() - rampLastCollisionTime > rampSpawnDistance * 100)) then
	
		triggerEvent("onClientEndRamping", localPlayer, numberOfConsecutiveRampsClimbed)
		killTimer(checkToEndRampingSequenceTimer)
		
		numberOfConsecutiveRampsClimbed = 0
		checkToEndRampingSequenceTimer = nil
		rampLastCollisionTime = nil
	end 
end 

