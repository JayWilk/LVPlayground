


myCar = nill

-- create the function the command handler calls, with the arguments: thePlayer, command, vehicleModel
function createVehicleForPlayer(thePlayer, command, vehicleModel)
   
   if(vehicleModel == nill) then 
	outputChatBox("Use: /v [model number]");
	return
   end
   
   local carModel
   
   -- do we have a string? 
   if(tonumber(vehicleModel) == nil) then
       carModel = getVehicleModelFromName(vehicleModel)
   else
	  carModel = tonumber(vehicleModel)
   end 
   
	if(carModel == nill or carModel == false ) then 
		outputChatBox("No car found", thePlayer )
		return
	end 
   -- create a vehicle and stuff
   local x,y,z = getElementPosition(thePlayer)
   
   if(myCar ~= nill) then
	destroyElement(myCar)
   end
   
   myCar = createVehicle(carModel, x, y, z )
   
   if(myCar ~= false) then 
		outputChatBox("The vehicle was created, wohoo", thePlayer)
		warpPedIntoVehicle ( thePlayer, myCar)
      end
end
 
-- create a command handler
addCommandHandler("v", createVehicleForPlayer)

function easyText(thePlayer, command, text)

	if(text == nill) then
		outputChatBox("USE: /text [text]", thePlayer)
		return
	end
	
	outputChatBox("attempting to output hehe", thePlayer)
	displayMessageForPlayer ( thePlayer, 1, "test", 6000, 0.5, 0.5, 255, 255, 255, 255, 2 )
	outputChatBox("done", thePlayer)
end 
addCommandHandler("text", easyText)
	

addCommandHandler("kill", 
	function(thePlayer)
		setElementHealth(thePlayer, 0)
	end
);
	
	
	
addEventHandler("onPlayerJoin", getRootElement(), 
	function()
		outputChatBox("Welcome to Las Venturas Playground MTA. There are 3 commands: /v /text /kill. More to come! ;)")
	end
);

addEventHandler("onResourceStart", getRootElement(),
	function(res)
		if res == getThisResource() then
			setDevelopmentMode(true)
		end 
		outputChatBox("Resource " .. getResourceName(res) .. " just started.")
		outputDebugString(getResourceName(res) .. ": onResourceStart()")
	end
);

function respawnExplodedVehicle()
	setTimer(respawnVehicle, 15000, 1, source)
	setVehicleFuelTankExplodable(source, true)
end
addEventHandler("onVehicleExplode", getRootElement(), respawnExplodedVehicle)
