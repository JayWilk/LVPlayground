addEvent("onClientRequestTaxiLocations", true)
addEventHandler("onClientRequestTaxiLocations", resourceRoot,
	function()
		triggerClientEvent(client, "onServerProvideTaxiLocationData", client, getElementsByType("taxiLocation"))
	end 
)
	