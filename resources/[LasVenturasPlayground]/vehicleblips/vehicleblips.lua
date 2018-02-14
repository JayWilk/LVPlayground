-- SA-MP style vehicle blips by Jay v0.1 -- 


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

	
	local blip = createBlipAttachedTo(source, 0, 1, 150, 150, 150, 255, 0, 150)
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


addEventHandler("onClientElementStreamIn", getRootElement(), vehicleStreamInHandler)
addEventHandler("onClientElementStreamOut", getRootElement(), vehicleStreamOutHandler)

addEventHandler("onClientVehicleExplode", getRootElement(), function()
		removeVehicleBlips(source)
	end 
)
