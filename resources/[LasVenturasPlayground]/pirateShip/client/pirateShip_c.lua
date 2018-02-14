-- PirateShip resource version 0.1 by Jay

addEventHandler("onClientResourceStart", root, 
	function(startedResource)
		if(startedResource == resource) then
			setWaterLevel(1963, 1503, 7, -5) -- disables the water at the back of the pirate ship
			shipPickup = createPickup(2017.150390625, 1545.4384765625, 10.830858230591, 3, 1239)
			shipRamp = createColCuboid(2004.046875, 1540.5831298828, 9.8531608581543, 20.5, 10, 7.5)
			shipDeck = createColCuboid(1995.3321533203, 1516.5081787109, 11.869184494019, 10.8, 53.300000000001, 31.2)
		end 
	end
)

addEventHandler("onClientElementColShapeHit", root,
	function(theShape)
		if (theShape == shipRamp and not isElementWithinColShape(source, shipDeck)) or (theShape == shipDeck and not isElementWithinColShape(source, shipRamp)) then
			if getElementType(source) == "player" and source == localPlayer then
			
				toggleControl("fire", false)
				toggleControl("aim_weapon", false)
				toggleControl("next_weapon", false)
				toggleControl("previous_weapon", false)
				setPedWeaponSlot(source, 0)
				
				timeEnteredShip = getTickCount()
				
				outputDebugString("Player " ..getPlayerName(source) .. " entered the pirate ship collision area")
				
				shipMoneyTimer = setTimer( function() 
					givePlayerMoney(1)
				end, 5000, 0)
				

			elseif(getElementType(source) == "vehicle") then
				blowVehicle(source)
			end 
		end 
	end
)

addEventHandler("onClientElementColShapeLeave", root,
	function(theShape)
		if getElementType(source) == "player" and source == localPlayer and ((theShape == shipRamp and not isElementWithinColShape(source, shipDeck)) or (theShape == shipDeck and not isElementWithinColShape(source, shipRamp))) then
			
			toggleControl("fire", true)
			toggleControl("aim_weapon", true)
			toggleControl("next_weapon", true)
			toggleControl("previous_weapon", true)
			
			outputChatBox("You idled on the ship for " ..tostring( (getTickCount() - timeEnteredShip) / 1000) .." seconds")
			timeEnteredShip = nil
			
			killTimer(shipMoneyTimer)
			shipMoneyTimer = nil
			
			outputDebugString("Player " ..getPlayerName(source) .." left the pirate collision area")
		end 
	end
)

addEventHandler("onClientPlayerDamage", localPlayer, 
	function()
		if isElementWithinColShape(source, shipRamp) or isElementWithinColShape(source, shipDeck) then
			cancelEvent()
		end 
	end
)

addEventHandler("onClientPlayerPickupHit", localPlayer, 
	function(thePickup)
		if getElementType(source) == "player" and thePickup == shipPickup then
		
			destroyElement(shipPickup)
			playSoundFrontEnd(101)
			
			setTimer ( function()
				shipPickup = createPickup(2017.150390625, 1545.4384765625, 10.830858230591, 3, 1239)
			end, 60000, 1 )
			
			-- todo: improve!
			outputChatBox("* The PirateShip on Las Venturas Playground is a safety zone.", 255, 255, 0)
			outputChatBox("* No shooting, deathmatch or killing is allowed.", 255, 255, 0)
			outputChatBox("* If you idle here, you will earn money.", 255, 255, 0)
			
		end 
	end
)