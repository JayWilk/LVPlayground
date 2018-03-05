
local playerCompletedRampingChallenge = false


-- Todo: document
function hasPlayerCompletedRampingChallenge()
	return playerCompletedRampingChallenge
end 



addEventHandler("onClientFinishRampingChallenge", localPlayer, function()
		playerCompletedRampingChallenge = true
	end 
)