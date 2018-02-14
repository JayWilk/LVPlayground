local screenW, screenH = guiGetScreenSize()
local radioPlaying = false
local radioUrl = nil
local radioStreamName = nil
setRadioChannel(0) 


addEventHandler("onClientPlayerRadioSwitch", localPlayer, 
	function()
		if( radioPlaying ) then 
			cancelEvent()
		end
	end
) 

function startLVPRadio()
	if(radioUrl and sound == nil) then
		sound = playSound(radioUrl)
		radioPlaying = true
		setRadioChannel(0) 
	end 
end

function stopLVPRadio()
	if  sound then 
		stopSound(sound)
		sound = nil
	end
	radioPlaying = false
end


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

addEventHandler("onClientPlayerVehicleEnter",getRootElement(), startLVPRadio)
addEventHandler("onClientVehicleStartExit", getRootElement(), stopLVPRadio)
addEventHandler("onClientVehicleExit", getRootElement(), stopLVPRadio)
addEventHandler("onClientPlayerDeath", localPlayer, stopLVPRadio)
addEventHandler("onClientPlayerWasted", localPlayer, stopLVPRadio)
addEventHandler("onClientPlayerSpawn", localPlayer, stopLVPRadio)

function updateRadioStreamUrlHandler(url)
	outputDebugString("updateRadioStreamUrl(): " ..url)
	radioUrl = url
end

function updateRadioStreamNameHandler(streamName)
	outputDebugString("updateRadioStreamName(): " ..streamName)
	radioStreamName = streamName
end

addEvent("updateRadioStreamUrl", true)
addEventHandler("updateRadioStreamUrl", resourceRoot, updateRadioStreamUrlHandler )

addEvent("updateRadioStreamName", true)
addEventHandler("updateRadioStreamName", resourceRoot, updateRadioStreamNameHandler )