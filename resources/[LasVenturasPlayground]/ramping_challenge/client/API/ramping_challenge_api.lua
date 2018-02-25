
local playerCompletedRampingChallenge = false


-- Todo: document!
function hasPlayerCompletedRampingChallenge(thePlayer)
	return playerPassedRampingChallenge
end 



addEventHandler("onClientFinishRampingChallenge", localPlayer, function()
		playerCompletedRampingChallenge = true
	end 
)