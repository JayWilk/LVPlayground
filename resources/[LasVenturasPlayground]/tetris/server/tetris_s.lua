
addEvent("onClientRequestTetrisGameMachineElements", true)
addEventHandler("onClientRequestTetrisGameMachineElements", resourceRoot,
	function()		
		local gameMachines = getElementsByType("tetrisGameMachine")
		triggerClientEvent(client, "onServerProvideTetrisGameMachineElements", resourceRoot, gameMachines)
	end 
)
