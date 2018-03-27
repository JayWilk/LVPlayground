resourceSettings = {}

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("onClientRequestResourceSettings", resourceRoot)
	end 
)

addEvent("onServerProvideResourceSettings", true)
addEventHandler("onServerProvideResourceSettings", resourceRoot,
	function(theSettings)

		for theKey, theValue in pairs(theSettings) do
			-- Strip out the resource access modifier 
			resourceSettings[theKey:sub(2)] = theValue
		end 
		
		-- We don't pass the settings table as a parameter because that will discourage
		-- the use of getSetting() which checks for settings modified during runtime
		triggerEvent("onClientSettingsUpdate", localPlayer)
	end
)

function getSetting(theSettingName)

	for theKey, theValue in pairs(resourceSettings) do
		
		-- first of all check for any resource settings that may have been changed
		-- during runtime (defined in the settings xml, in the server root dir). 
		-- These are prefixed with the resource name and take precedence
		if theKey == getResourceName(resource) .. "." ..theSettingName then
			return theValue 
		end
		
		-- Else check for any meta.xml settings in the registry
		if theKey == theSettingName then
			return theValue
		end 
	end 

	return false
end 

