
addEvent("onClientRequestTetrisGameMachineElements", true)
addEventHandler("onClientRequestTetrisGameMachineElements", resourceRoot,
	function()		
		iprint("providing client with tetris game machien elements...")
		local gameMachines = getElementsByType("tetrisGameMachine")
		triggerClientEvent(client, "onServerProvideTetrisGameMachineElements", resourceRoot, gameMachines)
	end 
)
