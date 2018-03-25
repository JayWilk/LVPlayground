local radioPlaying = false
local radioUrl = nil
local radioStreamName = nil
local radioText = nil

setRadioChannel(0) 


addEventHandler("onClientPlayerRadioSwitch", root, 
	function()
		if( radioPlaying ) then 
			cancelEvent()
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
		constructRadioGui()
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function() 
		triggerServerEvent("onClientRequestRadioStreamInformation", resourceRoot)
	end 
)

function constructRadioGui()

	if radioText then
		radioText:destroy()
	end 

	local x,y = guiGetScreenSize() 

	radioText = dxText:create(radioStreamName, 0.5, 0.06)
	radioText:font("bankgothic")
	radioText:scale(x / 1280)
	radioText:type("border", 5, 0, 0, 0)
	radioText:color(163, 161, 16, 0)
	radioText:visible(false)
end 


function startStreamRadio()

	if(radioUrl and sound == nil) then
	
		sound = playSound(radioUrl)
		radioPlaying = true
		setRadioChannel(0) 

		radioText:visible(true)
		Animation.createAndPlay(radioText, Animation.presets.dxTextFadeIn(1000))
	end 
end

function stopStreamRadio()
	if  sound then 
		stopSound(sound)
		sound = nil
	end
	
	radioPlaying = false
	
	if radioText then
		radioText:visible(false)
		radioText:color(163, 161, 16, 0)
	end
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