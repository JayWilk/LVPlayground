function provideClientWithSettings()

	if not client then 
		client = root 
	end 

	local resName = getResourceName(resource)
	triggerClientEvent(root, "onServerProvideResourceSettings", resourceRoot, get(resName .. "."))	
end 

addEvent("onClientRequestResourceSettings", true)
addEventHandler("onClientRequestResourceSettings", resourceRoot, provideClientWithSettings)
addEventHandler("onSettingChange", resourceRoot, provideClientWithSettings)
