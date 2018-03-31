addEvent("onClientRequestRedBarrelElements", true)
addEventHandler("onClientRequestRedBarrelElements", resourceRoot,
	function()		
		triggerClientEvent(client, "onServerProvideRedBarrelElements", resourceRoot, getElementsByType("redBarrel"))
	end 
)

addEvent("onClientRequestYellowBarrelElements", true)
addEventHandler("onClientRequestYellowBarrelElements", resourceRoot,
	function()		
		triggerClientEvent(client, "onServerProvideYellowBarrelElements", resourceRoot, getElementsByType("yellowBarrel"))
	end 
)




