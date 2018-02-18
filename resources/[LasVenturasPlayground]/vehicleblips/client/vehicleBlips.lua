local blipRadius = nil

function vehicleStreamInHandler()
	
	if getElementType(source) ~= "vehicle" then
		return
	end
	
	if isVehicleBlown(source) then
		return
	end
	
	if getVehicleOccupant(source) ~= false then
		return
	end

	local blip = createBlipAttachedTo(source, 0, 1, 150, 150, 150, 255, 0, blipRadius)
	setElementParent(blip, source)
end

function vehicleStreamOutHandler()

	if getElementType(source) ~= "vehicle" then
		return
	end
	
	removeVehicleBlips(source)
end 
	
function removeVehicleBlips(vehicle)

	local blips = getElementChildren(vehicle, "blip")
	
	for k, v in ipairs(blips) do
		destroyElement(v)
	end
end 

function updateBlipRadius(theRadius)
	blipRadius = theRadius
end 

addEventHandler("onClientResourceStart", getRootElement(), 
	function(theResource)
		if(theResource == resource) then
			triggerServerEvent("onClientRequestVehicleBlipRadiusValue", resourceRoot)
		end
	end
)

addEventHandler("onClientVehicleExplode", getRootElement(), function()
		removeVehicleBlips(source)
	end 
)

addEvent("onClientReceiveBlipRadiusInformation", true)
addEventHandler("onClientReceiveBlipRadiusInformation", resourceRoot, updateBlipRadius)

addEventHandler("onClientElementStreamIn", getRootElement(), vehicleStreamInHandler)
addEventHandler("onClientElementStreamOut", getRootElement(), vehicleStreamOutHandler)