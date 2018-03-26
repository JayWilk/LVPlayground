addCommandHandler("nos", 
	function()
		
		local barrelsShot = tonumber(exports.barrels:getNumberOfBarrelsShot())
		local requiredBarrelsShot = tonumber(getSetting("nosBarrelsShot"))
		
		if(barrelsShot < requiredBarrelsShot) then
		
			exports.display:outputCommandError("This command is locked.")
			
			setTimer(
				function()
					exports.display:showHint("You need to shoot at least " ..requiredBarrelsShot .." barrels before you can add nitro to a car.") -- todo: manage
				end, 1500, 1)
			return 
		end 
	
		if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then
				exports.display:outputCommandError("You must be driving a vehicle")
			return 
		end 
		
		local nosAmount = tonumber(getSetting("nosCost"))
		
		if(getPlayerMoney() < nosAmount) then 
				exports.display:outputCommandError("You don't have enough money. You need $" ..tostring(nosAmount) .." for NOS")
			return 
		end 
		
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		local theType = getVehicleType(theVehicle)
		
		if theType ~= "Automobile" then
			exports.display:outputCommandError("You cannot add nitro to this vehicle.")
			return
		end 
		
		playSFX("genrl", 52, 9, false)
		addVehicleUpgrade(theVehicle, 1010)
		exports.display:addNotification("NOS x10 was added to your "..getVehicleName(theVehicle), "success")
	end
)