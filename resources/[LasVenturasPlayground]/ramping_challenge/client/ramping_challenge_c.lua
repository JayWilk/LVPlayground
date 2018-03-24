playerInRampingChallenge = false
rampingChallengeRaceCheckpoints = { }
rampingChallengeRaceCheckpointsHit = 1
rampingMusic = nil
rampStartTimeoutTimer = nil
timeToGetInVehicleMissionTimer = nil
timeToFirstRampMissionTimer = nil
timeToCompleteChallengeMissionTimer = nil
numberOfRampsClimbed = 0
rampChallengeStartTime = nil
resourceSettings = {}
playerFinished = nil

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("onClientRequestResourceSettings", resourceRoot)
	end 
)

addEvent("onServerProvideResourceSettings", true)
addEventHandler("onServerProvideResourceSettings", resourceRoot,
	function(theSettings)
		resourceSettings = theSettings
	end
)


addCommandHandler("gotoramp", 
	function()
		setElementPosition(localPlayer, 1520.736328125, 1847.427734375, 10.8203125)
		setElementDimension(localPlayer, 0)
	end
)


addEvent("onClientEnterRampingChallengeSignupMarker", true)
addEventHandler("onClientEnterRampingChallengeSignupMarker", localPlayer, 
	function()
	
		if(getElementDimension(localPlayer)) ~= 0 then
			return
		end
		
		showRampingChallengeSignupDialog()
	end
)

-- triggered when the tutorial passes, and now we need to prepare the environment
-- and the client is instructed to get in the vehicle.
addEvent("onClientPrepareToBeginRampingChallenge")
addEventHandler("onClientPrepareToBeginRampingChallenge", localPlayer, 
	function()
	
		fadeCamera(true, 2)
		
		triggerServerEvent("onClientRequestRampingChallengeEnvironmentInitialise", resourceRoot)
		
		togglePlayerRampingChallengeControlRestrictions(true)
		playerInRampingChallenge = true
		
		rampingMusic = playSound("client/audio/level2.mp3", true)
	
		exports.lvpRadio:toggleStreamRadio(false)
		exports.display:toggleDisplay(false)
		
		toggleControl("enter_exit", true)
		
		local vehicleTimerTime = tonumber(resourceSettings["timeToGetInVehicle"])
		timeToGetInVehicleMissionTimer = exports.missiontimer:createMissionTimer (vehicleTimerTime, true, "Time: %s:%cs", 0.5, 20, true, "default-bold", 1, 255, 255, 255) -- todo: manage text
		exports.missiontimer:setMissionTimerHurryTime(timeToGetInVehicleMissionTimer, math.floor(vehicleTimerTime / 3))
	
	end
)
	
-- Any the challenge if any mission timers elapse
addEventHandler("onClientMissionTimerElapsed", resourceRoot, 
	function()
		triggerEvent("onClientEndRampingChallenge", localPlayer, "times up", true)
	end
)
	
-- check if they get in the ramp vehicle
addEventHandler("onClientVehicleEnter", resourceRoot, 
	function()
	
		local rampingChallengeVehicle = getElementData(localPlayer, "rampingChallengeVehicle")
		
		if(rampingChallengeVehicle and source == rampingChallengeVehicle) then 
		
			fixVehicle(source)
			exports.display:hideObjectiveText()
			triggerServerEvent("onClientRequestRampingChallengeVehicleMarkerAndBlipDestroy", resourceRoot, source)
			triggerEvent("onClientReadyToBeginRampingChallenge", localPlayer)
			exports.ramping:toggleRamping(false)
			
			if(timeToGetInVehicleMissionTimer) then
				destroyElement(timeToGetInVehicleMissionTimer)
				timeToGetInVehicleMissionTimer = nil
			end 
			
			if(rampingChallengeRaceCheckpoints) then 
				if #rampingChallengeRaceCheckpoints > 0 then
				
					local x, y, z, size
					x = getElementData(rampingChallengeRaceCheckpoints[1], "posX")
					y = getElementData(rampingChallengeRaceCheckpoints[1], "posY")
					z = getElementData(rampingChallengeRaceCheckpoints[1], "posZ")
					size = getElementData(rampingChallengeRaceCheckpoints[1], "size")
					
					local marker = createMarker(x, y, z, "checkpoint", size, 255, 0, 0, 0)
					setElementDimension(marker, getElementData(localPlayer, "rampingChallengeDimensionId"))
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
			
			exports.display:showObjectiveText("Press LCTRL to Spawn a ramp!", 3000)
			
			if(timeToFirstRampMissionTimer) then
				destroyElement(timeToFirstRampMissionTimer)
				timeToFirstRampMissionTimer = nil
			end 
			
			-- activate ramping
			exports.ramping:toggleRamping(true)
			
			rampStartTimeoutTimer = setTimer(
				function()
					triggerEvent("onClientEndRampingChallenge", localPlayer, "failed", true)
				end, 
			4000, 1)
			
		else
			local x, y, z, size
			x = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "posX")
			y = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "posY")
			z = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "posZ")
			size = getElementData(rampingChallengeRaceCheckpoints[rampingChallengeRaceCheckpointsHit], "size")
		
			local marker = createMarker(x, y, z, "checkpoint", size, 255, 0, 0, 0)
			setElementDimension(marker, getElementData(localPlayer, "rampingChallengeDimensionId"))
		end 
	
	end 
)


-- Triggered when the client got in the vehicle, and is ready to start
-- Process the countdown 
addEvent("onClientReadyToBeginRampingChallenge")
addEventHandler("onClientReadyToBeginRampingChallenge", localPlayer, 
	function()

		togglePlayerRampingChallengeCountdownControlRestrictions(true)
		toggleControl("enter_exit", false)
		
		-- todo: manage text, and sort out the "LCTRL" reference so it pulls it in from the ramping API
		exports.display:showObjectiveText("Follow the #ff0000checkpoints#FFFFFF to the first ramp at the end of the runway,\n and then press LCTRL to start ramping in mid-air.", 8000)
		
		-- wait 8 seconds for the above instructions to clear then start the countdown!
		setTimer(
			function()
				startRampingChallengeCountdown()
			end,
		8000, 1)
	end
)	
	
addEvent("onClientRampingCountdownFinish")
addEventHandler("onClientRampingCountdownFinish", localPlayer, 
	function()
		triggerEvent("onClientBeginRampingChallenge", localPlayer)
	end 
)	

-- Countdown is done, the player is ready to go!
addEvent("onClientBeginRampingChallenge")
addEventHandler("onClientBeginRampingChallenge", localPlayer,
	function()
		togglePlayerRampingChallengeCountdownControlRestrictions(false)
		
		setPedCanBeKnockedOffBike(localPlayer, false)
		
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		setVehicleDamageProof(theVehicle, true)
		
		local toFirstRampTime = tonumber(resourceSettings["timeToFirstRamp"])
		timeToFirstRampMissionTimer = exports.missiontimer:createMissionTimer (toFirstRampTime, true, "Time to start ramping: %m:%s:%cs", 0.5, 20, true, "default-bold", 1, 255, 255, 255) -- todo: manage text
		exports.missiontimer:setMissionTimerHurryTime(timeToFirstRampMissionTimer, math.floor(toFirstRampTime / 3))
	end
)

addEventHandler("onClientPerformRamping", localPlayer, 
	function(numberOfConsecutiveRamps) 
		numberOfRampsClimbed = numberOfConsecutiveRamps
		
		if tostring(numberOfConsecutiveRamps) == tostring(resourceSettings["level1NumberOfRampsToComplete"]) then
			triggerEvent("onClientFinishRampingChallenge", localPlayer)
		end 
	end
)


-- Called when the client ENDS the ramping challenge (but not finished it)
addEvent("onClientEndRampingChallenge")
addEventHandler("onClientEndRampingChallenge", localPlayer,
	function(reason, tryAgainOption)	
		-- check to kill the timeout first
		if(rampStartTimeoutTimer) then
			killTimer(rampStartTimeoutTimer)
			rampStartTimeoutTimer = nil
		end 
	
		-- if the reason is provided, show it with a nice fade effect		
		if(reason) then

			showRampingChallengeGameText(reason)
			killRampingChallengeMusic()
			killMissionTimers()
			exports.display:hideObjectiveText()
			hideRampingChallengeProgressText()
			
			setGameSpeed(0.4)
			fadeCamera(false)
			
			setTimer(
				function()
		
					hideRampingChallengeGameText()
					
					if(tryAgainOption) then
						showRampingChallengeTryAgainDialog()
					else
						fadeCamera(false)
					end 

					removePlayerFromRampingChallenge()
					cleanupRampingEnvironment()
					spawnPlayerAtRampEndedPos()
					setGameSpeed(1)
				end, 3000, 1)
				
				
		else -- otherwise just remove the player immediately
			removePlayerFromRampingChallenge()
			cleanupRampingEnvironment()
			spawnPlayerAtRampEndedPos()
		end
	end
)


-- Called when the client FINISHES the ramping challenge
addEvent("onClientFinishRampingChallenge")
addEventHandler("onClientFinishRampingChallenge", localPlayer,
	function()
	
		playerFinished = true
	
		setGameSpeed(0.4)
		fadeCamera(false)
		
		killRampingChallengeMusic()
		killMissionTimers()
		hideRampingChallengeProgressText()
		exports.ramping:toggleRamping(false)
		showRampingChallengeGameText("finished")
		
		setTimer(
			function()
				exports.display:hideObjectiveText()
				removePlayerFromRampingChallenge()
				cleanupRampingEnvironment()
				spawnPlayerAtRampEndedPos()
				setGameSpeed(1)
				fadeCamera(true)
				
				setTimer(
					function()
						showRampingChallengeCompleteDialog()
					end, 
				1000, 1)
			end, 
		3000, 1)
	end
)

addEvent("onClientRequestRampingChallengeTryAgain")
addEventHandler("onClientRequestRampingChallengeTryAgain", localPlayer, 
	function(tryAgain)

		if(tryAgain) then
			triggerEvent("onClientPrepareToBeginRampingChallenge", localPlayer)
		else
			fadeCamera(true, 2)
			spawnPlayerAtRampEndedPos()
		end 
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
		if(playerInRampingChallenge and not playerFinished) then
			triggerEvent("onClientEndRampingChallenge", localPlayer, "failed", true)
		end 
	end
)

addEventHandler("onClientStartRamping", localPlayer,
	function()
		if(playerInRampingChallenge) then
			exports.display:showObjectiveText("Goob job - carry on!", 3000)-- todo: sort
			
			setPedCanBeKnockedOffBike(localPlayer, true)
			
			showRampingChallengeProgressText()
			
			local theVehicle = getPedOccupiedVehicle(localPlayer)
			setVehicleDamageProof(theVehicle, false)
			
			if(rampStartTimeoutTimer) then
				killTimer(rampStartTimeoutTimer)
				rampStartTimeoutTimer = nil
			end
			
			toCompleteMissionTime = resourceSettings["timeToCompleteChallenge"]
			timeToCompleteChallengeMissionTimer = exports.missiontimer:createMissionTimer (toCompleteMissionTime, true, "Time to complete challenge: %m:%s:%cs", 0.5, 20, true, "default-bold", 1, 255, 255, 255) -- todo: manage text
			exports.missiontimer:setMissionTimerHurryTime(timeToCompleteChallengeMissionTimer, math.floor(toCompleteMissionTime / 4))
		end
	end 
)

addEvent("onServerProvideVehicleInformation", true)
addEventHandler("onServerProvideVehicleInformation", localPlayer,
	function(theVehicle)
		exports.display:showObjectiveText("Get in the #ff0000" ..getVehicleName(theVehicle) .."#FFFFFF!") -- todo: localize
	end 
)

addEvent("onServerProvideRampingChallengeMarkers", true)
addEventHandler("onServerProvideRampingChallengeMarkers", localPlayer,
	function(theElements)
		rampingChallengeRaceCheckpoints = theElements
	end 
)

-- prevent any damage inflict 
addEventHandler("onClientPedDamage", root, 
	function()
		if(source == localPlayer and playerInRampingChallenge) then 
			cancelEvent()
		end 
	end 
)


function getNumberOfRampsClimbed()
	return numberOfRampsClimbed
end 

function cleanupRampingEnvironment()
	triggerServerEvent("onClientRequestRampingChallengeVehicleDestroy", resourceRoot, getElementData(localPlayer, "rampingChallengeVehicle"))
	triggerServerEvent("onClientRequestRampingChallengeDimensionDestroy", resourceRoot, getElementData(localPlayer, "rampingChallengeDimensionId"))
	triggerServerEvent("onClientRequestRampingChallengeObjectsDestroy", resourceRoot)
end 


function removePlayerFromRampingChallenge()

	playerInRampingChallenge = false
	rampingChallengeRaceCheckpointsHit = 1
	exports.display:hideObjectiveText()
	exports.lvpRadio:toggleStreamRadio(true)
	exports.display:toggleDisplay(true)
	
	toggleControl("enter_exit", true)
	setPedCanBeKnockedOffBike(localPlayer, true)
	
	killRampingChallengeMusic()
	killMissionTimers()
	
	for theKey, theElement in ipairs(rampingChallengeRaceCheckpoints) do 
		if isElement(theElement) then
			destroyElement(theElement)
		end
	end 
	
	rampingChallengeRaceCheckpoints = {}
	numberOfRampsClimbed = 0
	rampChallengeStartTime = nil
	playerFinished = nil
	exports.ramping:toggleRamping(true)
	togglePlayerRampingChallengeControlRestrictions(false)
	showRampingChallengeGameText(false)

	if(rampStartTimeoutTimer) then
		killTimer(rampStartTimeoutTimer)
		rampStartTimeoutTimer = nil
	end 
	
	-- update dimension ids both server and client side
	triggerServerEvent("onClientRequestDimensionRestore", resourceRoot)
	setElementDimension(localPlayer, 0 )
end 

function spawnPlayerAtRampEndedPos()
	triggerServerEvent("onClientRequestSpawnAtRampingEndedPos", resourceRoot)
end 


function killRampingChallengeMusic()
	if(rampingMusic) then
		stopSound(rampingMusic)
		rampingMusic = nil
	end
end 

function killMissionTimers()

	if(timeToFirstRampMissionTimer) then
		destroyElement(timeToFirstRampMissionTimer)
		timeToFirstRampMissionTimer = nil
	end 
	
	if(timeToGetInVehicleMissionTimer) then
		destroyElement(timeToGetInVehicleMissionTimer)
		timeToGetInVehicleMissionTimer = nil
	end 
	
	if(timeToCompleteChallengeMissionTimer) then	
		destroyElement(timeToCompleteChallengeMissionTimer)
		timeToCompleteChallengeMissionTimer = nil
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


