rocketVehicleData = {}
rocketVehicleElements = {}

crossHair = nil

addEventHandler("onClientResourceStart", resourceRoot,

	function()
		crossHair = guiCreateStaticImage(0.48, 0.32, 0.04, 0.05, "client/img/cross.png", true, nil)
		guiSetVisible(crossHair, false)
	end 
)

addEvent("onClientPlayerEnterRocketCar", true)
addEventHandler("onClientPlayerEnterRocketCar", localPlayer,
	function(rocketVehicleElement)
		guiSetVisible(crossHair, true)
		setCameraViewMode(3)
		bindKey("vehicle_fire", "down", fireRocketFromVehicle, getElementChildren(rocketVehicleElement, "vehicle")[1])
	end 
)

addEvent("onClientPlayerExitRocketCar", true)
addEventHandler("onClientPlayerExitRocketCar", localPlayer,
	function()
		guiSetVisible(crossHair, false)
		unbindKey("vehicle_fire", "down", fireRocketFromVehicle)
	end 
)


function fireRocketFromVehicle(key, keyState, theVehicle)

	-- todo: camera angles sort
	local x, y, z = getElementPosition(theVehicle)
	
	createProjectile(theVehicle, 19, x, y, z+1.5)
end 


addEventHandler("onClientPlayerWasted", localPlayer,
	function()
		guiSetVisible(crossHair, false)
	end 
)