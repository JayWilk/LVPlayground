

function showHint(thePlayer, hint)
	if thePlayer and hint then
		triggerClientEvent(thePlayer, "onServerRequestHintBox", thePlayer, hint)
	end 
end 
