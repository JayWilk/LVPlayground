-- PirateShip resource version 0.1 by Jay
pedWeaponSlotBeforeEnteringShip = nil

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

				pedWeaponSlotBeforeEnteringShip = getPedWeaponSlot(localPlayer)
			
				-- Workaround for what appears to be a bug with MTA's toggleControl()
				-- function failing to work when applied immediately after setElementPosition
				-- TODO: Report it
				setTimer( function () 
					toggleControl("fire", false)
					toggleControl("aim_weapon", false)
					toggleControl("next_weapon", false)
					toggleControl("previous_weapon", false)
					setPedWeaponSlot(localPlayer, 0)
				end, 50, 1)
									
				timeEnteredShip = getTickCount()

				shipMoneyTimer = setTimer( function() 
					givePlayerMoney(1) -- todo: manage
				end, 15000, 0)

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
		
			exports.display:addNotification("You idled on the PirateShip for " ..tostring( (getTickCount() - timeEnteredShip) / 1000) .." seconds", "info")
			timeEnteredShip = nil
			
			killTimer(shipMoneyTimer)
			shipMoneyTimer = nil
			
			if(pedWeaponSlotBeforeEnteringShip) then
				setPedWeaponSlot(localPlayer, pedWeaponSlotBeforeEnteringShip)
				pedWeaponSlotBeforeEnteringShip = nil
			end 
			
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
			
			exports.display:showHint("The PirateShip on Las Venturas Playground is a safety zone. No weapons, shooting, fighting, deathmatch or any killing is allowed.")
			exports.display:showHint("If you idle on the Pirate Ship, you will earn a small amount of money.")
			exports.display:showHint("You can increase this idle money by completing arcade game challenges such as 2048 by walking up to the Arcade Machine.")
			exports.display:showHint("You can get a taxi to the PirateShip at any time by using the command /taxi 0.")
			
		end 
	end
)