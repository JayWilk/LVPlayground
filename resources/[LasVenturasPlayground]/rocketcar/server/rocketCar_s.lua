rocketVehicleRoot = createElement("rocketVehicleRootElement")

playerRocketElegy = {}


addCommandHandler("rocketcar", 
	function(thePlayer, theCommand)
		
		if playerRocketElegy[thePlayer] then
			destroyElement(playerRocketElegy[thePlayer])
		end 
		
		local x, y, z = getElementPosition(thePlayer)
		playerRocketElegy[thePlayer] = createRocketVehicle(562, x, y, z, 3267, 0, -1.5, -0.7, -28, 0, 0)
		exports.display:addNotification(thePlayer, "Rocket elegy has been spawned at your location", "success")
	end 
)

addCommandHandler("destroyrocketcar",
	function(thePlayer, theCommand)
		if not playerRocketElegy[thePlayer] then
			exports.display:outputCommandError(thePlayer, "You have not spawned any rocket elegy cars.")
			return
		end 
		
		destroyElement(playerRocketElegy[thePlayer])
		playerRocketElegy[thePlayer] = nil
		exports.display:addNotification(thePlayer, "Your rocket elegy has been destroyed", "success")
	end
)


function createRocketVehicle(vehicleModel, spawnX, spawnY, spawnZ, objectModel, xOffset, yOffset, zOffset, xRotOffset, yRotOffset, zRotOffset)
	assert(vehicleModel)
	assert(spawnX)
	assert(spawnY)
	assert(spawnZ)
	assert(objectModel)

	if not xOffset then xOffset = 0 end 
	if not yOffset then yOffset = 0 end 
	if not zOffset then zOffset = 0 end 
	if not xRotOffset then xRotOffset = 0 end 
	if not yRotOffset then yRotOffset = 0 end
	if not zRotOffset then zRotOffset = 0 end 
	
	local theElement = createElement("rocketVehicle")
	
	local theVehicle = createVehicle(562, spawnX, spawnY, spawnZ)
	setElementParent(theVehicle, theElement)
	
	local theObject = createObject(objectModel, spawnX, spawnY, spawnZ)
	setElementParent(theObject, theElement)
	attachElements(theObject, theVehicle, xOffset, yOffset, zOffset, xRotOffset, yRotOffset, zRotOffset)

	setElementParent(theElement, rocketVehicleRoot)
	
	return theElement
end

addEventHandler("onPlayerVehicleEnter", root, 
	function(theVehicle, seat)
		
		local parent = getElementParent(theVehicle)
		
		if isElement(parent) and getElementType(parent) == "rocketVehicle" then
			triggerClientEvent(source, "onClientPlayerEnterRocketCar", source, parent)
		end
	end 
)

addEventHandler("onPlayerVehicleExit", root,
	function(theVehicle)
		local parent = getElementParent(theVehicle)
		if isElement(parent) and getElementType(parent) == "rocketVehicle" then
			triggerClientEvent(source, "onClientPlayerExitRocketCar", source, theElement)
		end
	end
)


