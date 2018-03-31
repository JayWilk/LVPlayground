addCommandHandler("kill", 
	function(thePlayer)
		setElementHealth(thePlayer, 0)
	end
)
	
playerVehicles = {}
	
addCommandHandler("v",
	function(thePlayer, theCommand, vehicle)
	
		if getPedOccupiedVehicle(thePlayer) then
			exports.display:outputCommandError(thePlayer, getLocalizedText(thePlayer, "command.v.onfoot"))
			return
		end 
	
		if not vehicle then
			exports.display:outputCommandSyntax(thePlayer, theCommand, getLocalizedText(thePlayer, "command.v.syntax"))
			return
		end 
	
		local theVehicle = nil
	
		theVehicle = getVehicleModelFromName(vehicle)
		
		if not theVehicle then
			theVehicle = tonumber(vehicle)
		end 
		
		if not theVehicle or theVehicle < 400 or theVehicle > 612 then
			exports.display:outputCommandError(thePlayer, getLocalizedText(thePlayer, "command.v.notfound"))
			return
		end 
		
		if playerVehicles[thePlayer] ~= nil then
			destroyElement(playerVehicles[thePlayer])
		end 

		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		
		playerVehicles[thePlayer] = createVehicle(theVehicle, x, y, z, rx, ry, rz, getPlayerName(thePlayer))
		warpPedIntoVehicle(thePlayer, playerVehicles[thePlayer])
		exports.display:addNotification(thePlayer, getLocalizedText(thePlayer, "command.v.success", getVehicleName(playerVehicles[thePlayer])))
	end 
)
	
addEventHandler("onPlayerJoin", getRootElement(), 
	function()
		exports.languagemanager:setPlayerLanguage(source, "en");
		local thePlayer = source
		setTimer(
			function()
				local i = 0
				while i ~= 4 do
					i = i + 1
					exports.display:showHint(thePlayer, getLocalizedText(thePlayer, "lvp.welcome" ..tostring(i)))
				end 
			end,
		8000, 1)
	end
);

addEventHandler("onResourceStart", root,
	function(res)
		setDevelopmentMode(true)
		outputDebugString(getResourceName(res) .. ": onResourceStart()")
	end
);


function respawnExplodedVehicle()
	setTimer(respawnVehicle, 15000, 1, source)
end
addEventHandler("onVehicleExplode", getRootElement(), respawnExplodedVehicle)



function getLocalizedText(player, lang_code, ...)
	return exports.languagemanager:getLocalizedText(player, lang_code, ...)
end
	
