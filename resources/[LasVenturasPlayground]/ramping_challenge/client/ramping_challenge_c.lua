playerInRampingChallenge = false
rampingChallengeRaceCheckpoints = { }
rampingChallengeRaceCheckpointsHit = 1
rampingMusic = nil

rampSignupPosX = nil
rampSignupPosY = nil
rampSignupPosZ = nil

rampStartTimeoutTimer = nil

addEvent("onClientEnterRampingChallengeSignupMarker", true)
addEventHandler("onClientEnterRampingChallengeSignupMarker", localPlayer, 
	function()
	
		if(getElementDimension(localPlayer)) ~= 0 then
			return
		end
		
		rampSignupPosX, rampSignupPosY, rampSignupPosZ = getElementPosition(localPlayer)
		
		
		showRampingChallengeSignupDialog()
		playSFX("genrl", 52, 18, false)
	end
)

-- triggered when the tutorial passes, and now we need to prepare the environment
-- and the client is instructed to get in the vehicle.
addEvent("onClientPrepareToBeginRampingChallenge")
addEventHandler("onClientPrepareToBeginRampingChallenge", localPlayer, 
	function()
		togglePlayerRampingChallengeControlRestrictions(true)
		showRampingChallengeInstructions("Get in the #ff0000FCR-900#FFFFFF!")
		playerInRampingChallenge = true
		triggerServerEvent("onClientRequestRampingChallengeEnvironmentInitialise", resourceRoot)
		-- Disable stream radio
		exports.lvpRadio:toggleStreamRadio(false)
	end
)
	
-- check if they get in the ramp vehicle
addEventHandler("onClientVehicleEnter", resourceRoot, 
	function()
	
		local rampingChallengeVehicle = getElementData(localPlayer, "rampingChallengeVehicle")
		
		if(rampingChallengeVehicle and source == rampingChallengeVehicle) then 
		
			fixVehicle(source)
			hideRampingChallengeInstructions()
			triggerServerEvent("onClientRequestRampingChallengeVehicleMarkerAndBlipDestroy", resourceRoot, source)
			triggerEvent("onClientReadyToBeginRampingChallenge", localPlayer)

			
			if(rampingChallengeRaceCheckpoints) then 
				if #rampingChallengeRaceCheckpoints > 0 then
				
					local x, y, z, size
					x = getElementData(rampingChallengeRaceCheckpoints[1], "posX")
					y = getElementData(rampingChallengeRaceCheckpoints[1], "posY")
					z = getElementData(rampingChallengeRaceCheckpoints[1], "posZ")
					size = getElementData(rampingChallengeRaceCheckpoints[1], "size")
					
					createMarker(x, y, z, "checkpoint", size, 255, 0, 0, 0)
				end
			end
			
		end
	end 
)

addEventHandler("onClientMarkerHit", resourceRoot, 
	function()
	
		if not playerInRampingChallenge then
			return
		end
		playSFX("genrl", 52, 18, false)
		destroyElement(source)
		
		rampingChallengeRaceCheckpointsHit = rampingChallengeRaceCheckpointsHit + 1
		
		-- is this the last marker? 
		if(rampingChallengeRaceCheckpointsHit == #rampingChallengeRaceCheckpoints + 1) then
			showRampingChallengeInstructions("Press LCTRL to Spawn a ramp!", 3000) -- todo: manage!
			
			-- todo: improve! slow game speed etc
			rampStartTimeoutTimer = setTimer(
				function()
					showRampingChallengeInstructions("You didn't reach a ramp in time!!")
					setGameSpeed(0.5)
					
					setTimer(
						function()
							setGameSpeed(1.0)
							triggerEvent("onClientEndRampingChallenge", localPlayer)
						end,
					8000, 1)
					
				end, 8000, 1)
			
		else
			local x, y, z, size
			x = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "posX")
			y = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "posY")
			z = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "posZ")
			size = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "size")
		
			createMarker(x, y, z, "checkpoint", size, 255, 0, 0, 0)
		end 
	
	end 
)


-- Triggered when the client got in the vehicle, and is ready to start
-- Process the countdown 
addEvent("onClientReadyToBeginRampingChallenge")
addEventHandler("onClientReadyToBeginRampingChallenge", localPlayer, 
	function()

		togglePlayerRampingChallengeCountdownControlRestrictions(true)
		outputChatBox("get ready!")
		
		--toggleControl("enter_exit", false)
		
		-- todo: manage text, and sort out the "LCTRL" reference so it pulls it in from the ramping API
		showRampingChallengeInstructions("Follow the #ff0000checkpoints#FFFFFF to the first ramp at the end of the runway,\n and then press LCTRL to start ramping in mid-air.", 8000)
		
		-- wait 2 seconds before starting the countdown!
		setTimer(
			function()
				local countdown = 5
				setTimer(
					function()
						outputChatBox(tostring(countdown))

						if(countdown == 0) then
							triggerEvent("onClientBeginRampingChallenge", localPlayer)
						end
						
						countdown = countdown - 1
					end, 
				1000, 6)
			end, 
		8000, 1)
	end
)	
	
-- Countdown is done, the player is ready to go!
addEvent("onClientBeginRampingChallenge")
addEventHandler("onClientBeginRampingChallenge", localPlayer,
	function()
		togglePlayerRampingChallengeCountdownControlRestrictions(false)
		outputChatBox("******** GO GO GO *********", 255, 0, 0)
		
		rampingMusic = playSound("client/audio/level1.mp3", true)
	end
)
	
-- Called when the client ENDS the ramping challenge (but not finished it)
addEvent("onClientEndRampingChallenge")
addEventHandler("onClientEndRampingChallenge", localPlayer,
	function()	
		outputChatBox("You ended ramping without finishing. Awwh.")
		removePlayerFromRampingChallenge()
		cleanupRampingEnvironment()
	end
)

-- Called when the client FINISHES the ramping challenge
addEvent("onClientFinishRampingChallenge")
addEventHandler("onClientFinishRampingChallenge", localPlayer,
	function()
		outputChatBox("You finished ramping, wooo")
		
		removePlayerFromRampingChallenge()
		cleanupRampingEnvironment()
	end
)

addEventHandler("onClientPlayerWasted", localPlayer,
	function()
		if(playerInRampingChallenge) then 
			triggerEvent("onClientEndRampingChallenge", localPlayer)
		end
	end 
)

addEventHandler("onClientEndRamping", localPlayer,
	function()
		if(playerInRampingChallenge) then
		
			-- todo: improve
			outputChatBox("******* FAIL! *********", 255, 0, 0)
			showRampingChallengeInstructions("#FF0000FAIL!", 15000) 
			
			if(rampingMusic) then
				stopSound(rampingMusic)
				rampingMusic = nil
			end
			
			setGameSpeed(0.4)
			fadeCamera(false, 1)
			
			setTimer(
				function()
					setGameSpeed(1)
					triggerEvent("onClientEndRampingChallenge", localPlayer)
					fadeCamera(true)
				end, 
			6000, 1)
			
		end 
	end
)

addEventHandler("onClientStartRamping", localPlayer,
	function()
		if(playerInRampingChallenge) then
			showRampingChallengeInstructions("#00FF00Good job!", 3000)
			
			if(rampStartTimeoutTimer) then
				killTimer(rampStartTimeoutTimer)
				rampStartTimeoutTimer = nil
			end
		end
	end 
)


-- give the client the markers \o
addEvent("onServerProvideRampingChallengeMarkers", true)
addEventHandler("onServerProvideRampingChallengeMarkers", localPlayer,
	function(theElements)
		rampingChallengeRaceCheckpoints = theElements
	end 
)

-- prevent any damage inflict 
addEventHandler("onClientPedDamage", localPlayer, 
	function()
		if(source == localPlayer and playerInRampingChallenge) then 
			cancelEvent()
		end 
	end 
)


function cleanupRampingEnvironment()
	triggerServerEvent("onClientRequestRampingChallengeVehicleDestroy", resourceRoot, getElementData(localPlayer, "rampingChallengeVehicle"))
	triggerServerEvent("onClientRequestRampingChallengeDimensionDestroy", resourceRoot, getElementData(localPlayer, "rampingChallengeDimensionId"))
	triggerServerEvent("onClientRequestRampingChallengeObjectsDestroy", resourceRoot)
	hideRampingChallengeSignupDialog()
end 


function removePlayerFromRampingChallenge()

	playerInRampingChallenge = false
	rampingChallengeRaceCheckpointsHit = 1
	hideRampingChallengeInstructions()
	exports.lvpRadio:toggleStreamRadio(true)
	
	if(rampingMusic) then
		stopSound(rampingMusic)
		rampingMusic = nil
	end
	
	for theKey, theElement in ipairs(rampingChallengeRaceCheckpoints) do 
		if isElement(theElement) then
			destroyElement(theElement)
		end
	end 
	
	rampingChallengeRaceCheckpoints = {}
	
	togglePlayerRampingChallengeControlRestrictions(false)

	setElementDimension(localPlayer, 0)
	
	if(rampSignupPosX) then
		setElementPosition(localPlayer, rampSignupPosX, rampSignupPosY, rampSignupPosZ)
		rampSignupPosX, rampSignupPosY, rampSignupPosZ = nil
	end 
end 


function togglePlayerRampingChallengeControlRestrictions(enable)
	setPedWeaponSlot(localPlayer, 0)
	toggleControl("fire", not enable)
	toggleControl("aim_weapon", not enable)
	toggleControl("next_weapon", not enable)
	toggleControl("previous_weapon", not enable)
	toggleControl("vehicle_fire", not enable)
	toggleControl("vehicle_secondary_fire", not enable)
	toggleControl("enter_passenger", not enable)
end


function togglePlayerRampingChallengeCountdownControlRestrictions(enable)
	toggleControl("accelerate", not enable)
	toggleControl("brake_reverse", not enable)
end


