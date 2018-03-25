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

function outputCommandSyntax(theCommand, theSyntax)
	showCommandSyntax(theCommand, theSyntax)
end 

function outputCommandError(theError)
	showCommandError(theError)
end 