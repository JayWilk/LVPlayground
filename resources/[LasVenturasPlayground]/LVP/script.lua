addCommandHandler("kill", 
	function(thePlayer)
		setElementHealth(thePlayer, 0)
	end
)
	
playerVehicles = {}
	
addCommandHandler("v",
	function(thePlayer, theCommand, vehicle)
		if not vehicle then
			outputChatBox("USE: /v [id/name]", thePlayer, 255, 0, 0)
			return
		end 
	
		local theVehicle = nil
	
		theVehicle = getVehicleModelFromName(vehicle)
		
		if not theVehicle then
			theVehicle = tonumber(vehicle)
		end 
		
		if theVehicle < 400 or theVehicle > 612 then
			outputChatBox("Vehicle not found", thePlayer, 255, 0, 0)
		end 
		
		if playerVehicles[thePlayer] ~= nil then
			destroyElement(playerVehicles[thePlayer])
		end 

		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		
		playerVehicles[thePlayer] = createVehicle(theVehicle, x, y, z, rx, ry, rz, getPlayerName(thePlayer))
		warpPedIntoVehicle(thePlayer, playerVehicles[thePlayer])
	end 
)
	
addEventHandler("onPlayerJoin", getRootElement(), 
	function()
		local thePlayer = source
		setTimer(
			function()
				exports.display:showHint(thePlayer, "Welcome to LVP MTA. This is an early build, and there will be bugs.")
				exports.display:showHint(thePlayer, "If you need to spawn an Infernus, use /v 411")
				exports.display:showHint(thePlayer, "Other Commands: /taxi, /locations, /kill")
				exports.display:showHint(thePlayer, "There are multiple features such as The Pirate Ship, LVP Radio, Ramping Challenge, 2048 Game, Dancing, Graffiti, and More.")
				exports.display:showHint(thePlayer, "Any problems, speak to Jay. Have fun!")
			end,
		8000, 1)
	end
);

addEventHandler("onResourceStart", resourceRoot,
	function(res)
		setDevelopmentMode(true)
		outputDebugString(getResourceName(res) .. ": onResourceStart()")
	end
);


function respawnExplodedVehicle()
	setTimer(respawnVehicle, 15000, 1, source)
end
addEventHandler("onVehicleExplode", getRootElement(), respawnExplodedVehicle)
