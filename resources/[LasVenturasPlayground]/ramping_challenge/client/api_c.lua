
local playerCompletedRampingChallenge = false


-- Todo: document!
function hasPlayerCompletedRampingChallenge()
	outputDebugString("hasPlayerCompletedRampingChallenge() " ..tostring(playerCompletedRampingChallenge))
	return playerCompletedRampingChallenge
end 



addEventHandler("onClientFinishRampingChallenge", localPlayer, function()
		playerCompletedRampingChallenge = true
	end 
)