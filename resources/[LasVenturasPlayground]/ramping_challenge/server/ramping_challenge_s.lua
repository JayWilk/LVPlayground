addEventHandler("onMarkerHit", resourceRoot, 
	function(hitElement)
	
		if(getElementType(hitElement) ~= "player") then
			return
		end
	
		if(getElementID(source) == "rampChallengeSignupMarker") then
		
			triggerClientEvent(hitElement, "onClientEnterRampingChallengeSignupMarker", hitElement)
		
			-- workaround for an issue with setElementVisibleTo()
			-- we need to set the visible flag to true before the hide flag will work
			setElementVisibleTo(source, hitElement, true)
			setElementVisibleTo(source, hitElement, false)

		end 
	end 
)

addEventHandler("onMarkerLeave", resourceRoot,
	function(leftElement)
		if(getElementType(leftElement) ~= "player") then
			return
		end

		-- reshow the marker if the player leaves it
		if(getElementID(source) == "rampChallengeSignupMarker") then
			setElementVisibleTo(source, leftElement, true)
		end 
	end
	
)


addEvent("onClientRequestRampingChallengeVehicleInformation", true)
addEventHandler("onClientRequestRampingChallengeVehicleInformation", resourceRoot,
	function(dimensionId, mapname)

		local vehicle = getElementByIndex("rampChallengeVehicle", 1)
		triggerClientEvent(client, "onServerRequestRampingChallengeVehicleSpawn", client, getAllElementData(vehicle))
		
	end 
)

addEvent("onClientRequestRampingChallengeDimension", true)
addEventHandler("onClientRequestRampingChallengeDimension", resourceRoot,
	function()
		iprint("onClientRequestRampingChallengeDimension - server receivin!")
		-- TODO: Logic to calculate a relevant dimension Id,
		-- Based on any available slots (taking into consideration other players on the challenge)
		local dimensionId = 1
		
		triggerClientEvent(client, "onServerProvideRampingChallengeDimension", client, dimensionId)
	end
)