-- Command feedback messages

function showCommandSyntax(theCommand, syntax)
	outputChatBox("Syntax: /" ..theCommand .." [" ..syntax .."]", 200, 0, 0)
end 

function showCommandError(theError)
	outputChatBox("Error: " ..theError, 255, 0, 0)
end 

addEvent("onServerRequestCommandErrorOutput", true)
addEventHandler("onServerRequestCommandErrorOutput", resourceRoot,
	function(theError)
		if theError then
			showCommandError(theError)
		end 
	end 
)

addEvent("onServerRequestCommandSyntaxOutput", true)
addEventHandler("onServerRequestCommandSyntaxOutput", resourceRoot,
	function(theCommand, syntax)
		if theCommand and syntax then
			showCommandSyntax(theCommand, syntax)
		end 
	end 
)