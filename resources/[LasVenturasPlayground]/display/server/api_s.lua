
function showHint(thePlayer, hint)
	if thePlayer and hint then
		triggerClientEvent(thePlayer, "onServerRequestHintBox", thePlayer, hint)
	end 
end 

function addNotification(player, text, type)
	if (player and text) then
	
		if not type then type = "info" end
	
		triggerClientEvent(player, 'addNotification', player, text, type)
	end
end 


function outputCommandSyntax(thePlayer, theCommand, theSyntax)
	if thePlayer and theCommand and theSyntax then 
		triggerClientEvent(thePlayer, "onServerRequestCommandSyntaxOutput", resourceRoot, theCommand, theSyntax)
	end 
end 


function outputCommandError(thePlayer, theError)
	if thePlayer and theError then
		triggerClientEvent(thePlayer, "onServerRequestCommandErrorOutput", resourceRoot, theError)
	end 
end 