--[[
	--The ramping challenge--
	
	Lots to document here, so popping some notes in the header for now.
	
	TODO:
	- Sort out documentation as a whole
	- Look into LUA docs? 
	- Put a process in place and streamline documentation policies across resources for consistency 
	
	
	events:
	
	onClientEnterRampingChallengeSignupMarker
		--showRampingChallengeSignupDialog
		--hideRampingChallengeSignupDialog
		
	onClientStartRampingChallengeTutorial
	onClientSkipRampingChallengeTutorial
	onClientFinishRampingChallengeTutorial
	
	onClientPrepareToBeginRampingChallenge - this occurs after the tutorial, when the player is instructed to go and get on the bike 
	onClientReadyToBeginRampingChallenge - when the client has got on the bike, and all is ready. 
	onClientBeginRampingChallenge - this occurs after the countdown has finished, and the challenge begins
	
	
	-- Need to think about better naming conventions here, as it's not clear. 
	
	onClientStartRampingChallenge - the difference between this, and the begin() event, is that this is triggered when the client starts the actual ramping 
	onClientFailRampingChallenge  - the client has failed the ramping challenge 
	onClientCompleteRampingChallenge - the client has finished the challenge. 
	
	
	
]]

rampChallengeDimensionId = nil
rampChallengeVehicle = nil
vehicleMarker = nil 

addEvent("onClientEnterRampingChallengeSignupMarker", true)
addEventHandler("onClientEnterRampingChallengeSignupMarker", localPlayer, 
	function()
	
		if(getElementDimension(localPlayer)) ~= 0 then
			return
		end
		
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
		
		-- Todo: improve
		outputChatBox("Get in the vehicle with the marker above it")

		
		outputDebugString("onClientPrepareToBeginRampingChallenge - sending requests to server")
		-- Tell the server to give us our dimension and vehicle information!
		triggerServerEvent("onClientRequestRampingChallengeDimension", resourceRoot)
		triggerServerEvent("onClientRequestRampingChallengeVehicleInformation", resourceRoot)

	end
)
	
-- check if they get in the ramp vehicle
addEventHandler("onClientPlayerVehicleEnter", resourceRoot, 
	function(theVehicle)
	
		fixVehicle(source)
		destroyElement(vehicleMarker)
		vehicleMarker = nil
	
		triggerEvent("onClientReadyToBeginRampingChallenge", localPlayer)
	end 
)


-- Triggered when the client got in the vehicle, and is ready to start
-- Process the countdown 

addEvent("onClientReadyToBeginRampingChallenge")
addEventHandler("onClientReadyToBeginRampingChallenge", localPlayer, 
	function()

		togglePlayerRampingChallengeCountdownControlRestrictions(true)
		outputChatBox("get ready!")
		
		local countdown = 5
		setTimer(
			function()
				outputChatBox(tostring(countdown))
				countdown = countdown - 1
				
				if(countdown == 0) then
					triggerEvent("onClientBeginRampingChallenge", localPlayer)
				end
				
			end, 
		1000, 5)
	end
)	
	
-- Countdown is done, the player is ready to go!
addEvent("onClientBeginRampingChallenge")
addEventHandler("onClientBeginRampingChallenge", localPlayer,
	function()
		togglePlayerRampingChallengeCountdownControlRestrictions(false)
		outputChatBox("******** GO GO GO *********", 255, 0, 0)
		
		-- TODO: Call the server side function to render the checkpoints
	end
)
	
	
-- Called when the client ENDS the ramping challenge (NOT finished it!)
addEvent("onClientEndRampingChallenge")
addEventHandler("onClientEndRampingChallenge", localPlayer,
	function()	
		outputChatBox("You ended ramping without finishing. Awwh.")
	end
)

-- Called when the client FINISHES the ramping challenge, woo
addEvent("onClientFinishRampingChallenge")
addEventHandler("onClientFinishRampingChallenge", localPlayer,
	function()
		outputChatBox("You finished ramping, wooo")
	end
)

addEvent("onServerProvideRampingChallengeDimension", true)
addEventHandler("onServerProvideRampingChallengeDimension", localPlayer,
	function(dimensionId)
		iprint("onServerProvideRampingChallengeDimension - client receiving dimension id: "..tostring(dimensionId))
		rampChallengeDimensionId = dimensionId
		setElementDimension(localPlayer, dimensionId)
	end 
)

addEvent("onServerRequestRampingChallengeVehicleSpawn", true)
addEventHandler("onServerRequestRampingChallengeVehicleSpawn", localPlayer, 
	function(vehicleInformation)
	
		iprint("Returned server information about the vehicle: ", vehicleInformation)

		local model, posX, posY, posZ, rotZ
		model = vehData[1].model
		posX = vehData[1].posX
		posY = vehData[1].posY
		posZ = vehData[1].posZ
		rotZ = vehData[1].rotZ
			
			
		rampChallengeVehicle = createVehicle(model, posX, posY, posZ, 0, 0, rotZ, "R3MP-ME")
		vehicleMarker = createMarker(posX, posY, posZ + 6, "arrow", 1.0, 255, 0, 0, 150)
		
		setElementParent(vehicleMarker, rampChallengeVehicle)
		
		setElementDimension(rampChallengeVehicle, rampChallengeDimensionId)
		setElementDimension(vehicleMarker, rampChallengeDimensionId)
		
		attachElements(vehicleMarker, rampChallengeVehicle, 0, 0, 4)
	end
)


function togglePlayerRampingChallengeControlRestrictions(enable)
	outputDebugString("togglePlayerRampingChallengeControlRestrictions(): ", tostring(enable))
	setPedWeaponSlot(localPlayer, 0)
	toggleControl("fire", enable)
	toggleControl("aim_weapon", enable)
	toggleControl("next_weapon", enable)
	toggleControl("previous_weapon", enable)
	toggleControl("vehicle_fire", enable)
	toggleControl("vehicle_secondary_fire", enable)
	toggleControl("enter_passenger", enable)
end

function togglePlayerRampingChallengeCountdownControlRestrictions(enable)
	outputDebugString("togglePlayerRampingChallengeCountdownControlRestrictions() ")
	toggleControl("enter_exit", enable)
	toggleControl("accelerate", enable)
	toggleControl("brake_reverse", enable)
end

