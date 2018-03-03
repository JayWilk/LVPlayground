markers = {}
rampChallengeObjects = {}

addEventHandler("onResourceStart", resourceRoot,
	function()
		local blip = getElementByIndex("blip", 1)

		if(blip and getElementID(blip) == "rampingOfficeBlip") then
			setBlipVisibleDistance(blip, 200) -- todo: manage settings
		end 
	end 
)


addEventHandler("onMarkerHit", resourceRoot, 
	function(hitElement)
		if(getElementType(hitElement) ~= "player") then
			return
		end
	
		if getPedOccupiedVehicle(hitElement) then
			return
		end
	
		if(getElementID(source) == "rampChallengeSignupMarker") then
		
			triggerClientEvent(hitElement, "onClientEnterRampingChallengeSignupMarker", hitElement)
		
			-- workaround for an issue with setElementVisibleTo()
			-- we need to set the visible flag to true before the hide flag will work
			setElementVisibleTo(source, hitElement, true)
			setElementVisibleTo(source, hitElement, false)
		end 
	end 
)

addEventHandler("onMarkerLeave", resourceRoot,
	function(leftElement)
		if(getElementType(leftElement) ~= "player") then
			return
		end

		-- reshow the marker if the player leaves it
		if(getElementID(source) == "rampChallengeSignupMarker") then
			setElementVisibleTo(source, leftElement, true)
		end 
	end
)

addEvent("onClientRequestRampingChallengeEnvironmentInitialise", true)
addEventHandler("onClientRequestRampingChallengeEnvironmentInitialise", resourceRoot,
	function()
		local dimensionId = findEmptyDimensionId()
		
		local rampChallengeVehicle = getElementByIndex("rampChallengeVehicle", 0)
		local theVehicle = spawnRampingChallengeVehicleWithMarkerAndBlip(rampChallengeVehicle, client)
		
		local rampChallengeStartPos = getElementByIndex("rampChallengeStartPos", 0)
		spawnPlayerAtRampingChallengeStartPos(client, rampChallengeStartPos)
		
		setElementDimension(theVehicle, dimensionId)
		setElementDimension(client, dimensionId)
		
		setElementData(client, "rampingChallengeDimensionId", dimensionId)
		setElementData(client, "rampingChallengeVehicle", theVehicle)
		
		local rampChallengeObjectElements = getElementsByType("rampChallengeObject")
		
		for theKey, theElement in ipairs(rampChallengeObjectElements) do
	
			local model, x, y, z, rx, ry, rz
			
			model = getElementData(theElement, "model")
			x = getElementData(theElement, "posX")
			y = getElementData(theElement, "posY")
			z = getElementData(theElement, "posZ")
			rx = getElementData(theElement, "rotX")
			ry = getElementData(theElement, "rotY")
			rz = getElementData(theElement, "rotZ")			
			
			local object = createObject(model, x, y, z, rx, ry, rz)
			setElementDimension(object, dimensionId)
			
			table.insert(rampChallengeObjects, object)
		end 
		
		-- provide the markers to the client
		triggerClientEvent(client, "onServerProvideRampingChallengeMarkers", client, getElementsByType("rampChallengeMarker"))
	end 
)


addEvent("onClientRequestRampingChallengeVehicleDestroy", true)
addEventHandler("onClientRequestRampingChallengeVehicleDestroy", resourceRoot,
	function(theVehicle)		
		if(theVehicle) then
			if destroyElement(theVehicle) then
				removeElementData(client, "rampingChallengeVehicle")
			end 
		end 
	end 
)

addEvent("onClientRequestRampingChallengeVehicleMarkerAndBlipDestroy", true)
addEventHandler("onClientRequestRampingChallengeVehicleMarkerAndBlipDestroy", resourceRoot,
	function(theVehicle)
	
		local children = getElementChildren(theVehicle)
		
		for theKey, theElement in ipairs(children) do
			
			if(getElementType(theElement) == "marker") then
				destroyElement(theElement) 
			elseif(getElementType(theElement) == "blip") then
				destroyElement(theElement)
			end 
		end 
		
	end
)

addEvent("onClientRequestRampingChallengeDimensionDestroy", true)
addEventHandler("onClientRequestRampingChallengeDimensionDestroy", resourceRoot,
	function(dimensionId)
		if(dimensionId) then
			removeElementData(client, "rampingChallengeDimensionId")
		end 
	end 
)

addEvent("onClientRequestRampingChallengeObjectsDestroy", true)
addEventHandler("onClientRequestRampingChallengeObjectsDestroy", resourceRoot,
	function()
		for theKey, theElement in ipairs(rampChallengeObjects) do
			destroyElement(theElement)
		end 
		
		rampChallengeObjects = {}
	end
)

addEvent("onClientRequestDimensionRestore", true)
addEventHandler("onClientRequestDimensionRestore", resourceRoot,
	function()
		setElementDimension(client, 0)
	end
)


function spawnPlayerAtRampingChallengeStartPos(thePlayer, rampChallengeStartPos)
	
	if(thePlayer and rampChallengeStartPos) then
		
		local x, y, z, rz
		x = getElementData(rampChallengeStartPos, "posX")
		y = getElementData(rampChallengeStartPos, "posY")
		z = getElementData(rampChallengeStartPos, "posZ")
		rz = getElementData(rampChallengeStartPos, "rotZ")

		setElementPosition(thePlayer, x, y, z)
		setElementRotation(thePlayer, 0, 0, rz)
		
		setTimer(setCameraTarget, 75, 1, thePlayer, thePlayer)
	end 
end 

function spawnPlayerAtRampingChallengeEndedPos(thePlayer)
	
	if(thePlayer) then
		local endPos = getElementByIndex("rampChallengeEndedPos", 0)
		
		if(endPos) then
			local x, y, z, rz
			x = getElementData(endPos, "posX")
			y = getElementData(endPos, "posY")
			z = getElementData(endPos, "posZ")
			rz = getElementData(endPos, "rotZ")
			
			setElementPosition(thePlayer, x, y, z)
			setElementRotation(thePlayer, 0, 0, rz)
			
			setTimer(setCameraTarget, 75, 1, thePlayer, thePlayer)
		end 
	end 
end 

addEvent("onClientRequestSpawnAtRampingEndedPos", true)
addEventHandler("onClientRequestSpawnAtRampingEndedPos", resourceRoot, 
	function()
		spawnPlayerAtRampingChallengeEndedPos(client)
	end
)


function findEmptyDimensionId()

	local dimensionIdOffset = tonumber(get("dimensionIdOffset"))
	outputDebugString("dimension id offset: " ..tostring(dimensionIdOffset))
	local iter = 0
	
	if(not dimensionIdOffset) then
		outputDebugString("Unable to obtain dimensionIdOffset", 1 )
	end 
	
	while(iter ~= getPlayerCount()) do
	
		local dimensionId = dimensionIdOffset + iter
		local players = getElementsInDimension("player", dimensionId)
		
		if(#players == 0) then
			return dimensionId
		else
			outputDebugString("No of players in dimension Id "..tostring(dimensionId) .. ": " ..tostring(#players))
		end 

		iter = iter + 1
	end 
	
	-- should, in theory, be impossible to ever get here. And if we do ever get here, it means
	-- someone else is using our dimension ids for other activities. 
	outputDebugString("No available dimension Ids were found for the ramping challenge", 1 )
	return false
end 



function spawnRampingChallengeVehicleWithMarkerAndBlip(rampChallengeVehicle, thePlayer)

	local model, posX, posY, posZ, rotZ
	
	model = getElementData(rampChallengeVehicle, "model")
	posX = getElementData(rampChallengeVehicle, "posX")
	posY = getElementData(rampChallengeVehicle, "posY")
	posZ = getElementData(rampChallengeVehicle, "posZ")
	rotZ = getElementData(rampChallengeVehicle, "rotZ")
		
	local theVehicle = createVehicle(model, posX, posY, posZ, 0, 0, rotZ, "R3MP-ME")
	local vehicleMarker = createMarker(posX, posY, posZ + 6, "arrow", 1.0, 255, 0, 0, 150, thePlayer)
	local vehicleBlip = createBlipAttachedTo(theVehicle, 0, 2, 255, 0, 0, 255, 1, 9999, thePlayer)
	
	setElementParent(vehicleMarker, theVehicle)
	setElementParent(vehicleBlip, theVehicle)
	
	attachElements(vehicleMarker, theVehicle, 0, 0, 4)
	
	return theVehicle
end 



