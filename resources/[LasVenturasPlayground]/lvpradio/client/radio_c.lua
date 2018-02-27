local screenW, screenH = guiGetScreenSize()
local radioPlaying = false
local radioUrl = nil
local radioStreamName = nil
setRadioChannel(0) 


addEventHandler("onClientPlayerRadioSwitch", root, 
	function()
		if( radioPlaying ) then 
			cancelEvent()
		end
	end
) 

addEventHandler("onClientRender", root,
    function()
		if(radioPlaying) then
			dxDrawText(radioStreamName, 588 - 1, 22 - 1, 771 - 1, 63 - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			dxDrawText(radioStreamName, 588 + 1, 22 - 1, 771 + 1, 63 - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			dxDrawText(radioStreamName, 588 - 1, 22 + 1, 771 - 1, 63 + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			dxDrawText(radioStreamName, 588 + 1, 22 + 1, 771 + 1, 63 + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			dxDrawText(radioStreamName, 588, 22, 771, 63, tocolor(163, 121, 16, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
		end
	end
)

addEvent("onClientReceiveRadioStreamUrlInformation", true)
addEventHandler("onClientReceiveRadioStreamUrlInformation", localPlayer,  
	function(theUrl)
		radioUrl = theUrl
		if(radioPlaying) then 
			stopStreamRadio()
			startStreamRadio()
		end 
	end 
)

addEvent("onClientReceiveRadioStreamTitleInformation", true)
addEventHandler("onClientReceiveRadioStreamTitleInformation", localPlayer,
	function(theName)
		radioStreamName = theName
	end
)

addEventHandler("onClientResourceStart", root,
	function(theResource)
		if(theResource == resource) then 
			triggerServerEvent("onClientRequestRadioStreamInformation", resourceRoot)
		end 
	end 
)


function startStreamRadio()
	if(radioUrl and sound == nil) then
		sound = playSound(radioUrl)
		radioPlaying = true
		setRadioChannel(0) 
	end 
end

function stopStreamRadio()
	if  sound then 
		stopSound(sound)
		sound = nil
	end
	radioPlaying = false
end


addEventHandler("onClientPlayerVehicleEnter", root,
	function()
		if(isStreamRadioEnabled()) then
			startStreamRadio()
		end 
	end 

)
addEventHandler("onClientVehicleStartExit", root, stopStreamRadio)
addEventHandler("onClientVehicleExit", root, stopStreamRadio)
addEventHandler("onClientPlayerDeath", root, stopStreamRadio)
addEventHandler("onClientPlayerWasted", root, stopStreamRadio)
addEventHandler("onClientPlayerSpawn", root, stopStreamRadio)