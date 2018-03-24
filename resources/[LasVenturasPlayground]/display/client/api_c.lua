-- Display API by Jay --

function showHint(hint)
	triggerEvent("onServerRequestHintBox", localPlayer, hint)
end 


function showObjectiveText(objectiveText, time)
	showObjective(objectiveText, time)
end 


function hideObjectiveText()
	hideObjective()
end 