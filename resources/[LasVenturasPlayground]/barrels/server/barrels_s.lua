addEvent("onClientRequestRedBarrelElements", true)
addEventHandler("onClientRequestRedBarrelElements", resourceRoot,
	function()		
		triggerClientEvent(client, "onServerProvideRedBarrelElements", resourceRoot, getElementsByType("redBarrel"))
	end 
)





