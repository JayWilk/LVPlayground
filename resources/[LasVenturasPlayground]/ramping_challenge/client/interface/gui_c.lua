GUIEditor = {
    button = {},
    window = {},
    staticimage = {},
    label = {}
}

rampingChallengeGameText = nil
rampingChallengeProgressText = nil

-- TODO: Sort, localise the text
addEventHandler("onClientResourceStart", resourceRoot, 

	function()
	
		local screenW, screenH = guiGetScreenSize()
	
		-- Ramping school signup dialog
		GUIEditor.window[1] = guiCreateWindow(0.30, 0.27, 0.41, 0.47, "Ramping School", true)
		guiWindowSetMovable(GUIEditor.window[1], false)
		guiWindowSetSizable(GUIEditor.window[1], false)

		GUIEditor.staticimage[1] = guiCreateStaticImage(10, 52, 197, 165, "client/img/ramp_challenge.png", false, GUIEditor.window[1])
		GUIEditor.label[1] = guiCreateLabel(0.35, 0.07, 0.31, 0.04, "Ramping School Challenge 0.1", true, GUIEditor.window[1])
		guiSetFont(GUIEditor.label[1], "default-bold-small")
		guiLabelSetColor(GUIEditor.label[1], 24, 248, 7)
		guiLabelSetHorizontalAlign(GUIEditor.label[1], "center", false)
		GUIEditor.label[2] = guiCreateLabel(227, 89, 318, 128, "The LVP Ramping School Challenge\n\nThere are three levels. If you pass the Ramping School, you can purchase a Ramping License which lets you:\n\n- Spawn ramps anywhere\n- No restrictions on the number of ramps you can spawn\n- Ramp spawning is FREE!", false, GUIEditor.window[1])
		guiLabelSetHorizontalAlign(GUIEditor.label[2], "left", true)
		GUIEditor.button[1] = guiCreateButton(73, 295, 174, 42, "YES", false, GUIEditor.window[1])
		guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FFFFFEFE")
		GUIEditor.button[2] = guiCreateButton(342, 295, 174, 42, "NO", false, GUIEditor.window[1])
		guiSetProperty(GUIEditor.button[2], "NormalTextColour", "FFFFFEFE")
		GUIEditor.label[3] = guiCreateLabel(121, 246, 373, 16, "Would you like to take part in the LVP Ramping School Challenge?", false, GUIEditor.window[1])
		guiSetFont(GUIEditor.label[3], "default-bold-small")    
		

		
		-- Tutorial confirmation dialog
		 GUIEditor.window[2] = guiCreateWindow((screenW - 365) / 2, (screenH - 155) / 2, 365, 155, "LVP Ramping Challenge", false)
        guiWindowSetSizable(GUIEditor.window[2], false)

        GUIEditor.label[4] = guiCreateLabel(75, 37, 207, 27, "Would you like to play the Tutorial?", false, GUIEditor.window[2])
        guiSetFont(GUIEditor.label[4], "default-bold-small")
        guiLabelSetHorizontalAlign(GUIEditor.label[4], "center", false)
        guiLabelSetVerticalAlign(GUIEditor.label[4], "center")
        GUIEditor.button[3] = guiCreateButton(41, 90, 112, 38, "Yes", false, GUIEditor.window[2])
        GUIEditor.button[4] = guiCreateButton(201, 90, 112, 38, "No", false, GUIEditor.window[2])    
		
		
		-- try again dialog
		 GUIEditor.window[3] = guiCreateWindow((screenW - 319) / 2, (screenH - 130) / 2, 319, 130, "Ramping Challenge", false)
        guiWindowSetMovable(GUIEditor.window[3], false)
        guiWindowSetSizable(GUIEditor.window[3], false)
        GUIEditor.label[5] = guiCreateLabel(55, 37, 218, 33, "Would you like to try again?", false, GUIEditor.window[3])
        guiLabelSetHorizontalAlign(GUIEditor.label[5], "center", true)
        guiLabelSetVerticalAlign(GUIEditor.label[5], "center")
        GUIEditor.button[5] = guiCreateButton(0.05, 0.62, 0.37, 0.19, "Yes", true, GUIEditor.window[3])
        GUIEditor.button[6] = guiCreateButton(192, 80, 117, 25, "No", false, GUIEditor.window[3])    
		
		-- finished dialog
		GUIEditor.window[4] = guiCreateWindow((screenW - 600) / 2, (screenH - 359) / 2, 600, 359, "Ramping Challenge", false)
        guiWindowSetMovable(GUIEditor.window[4], false)
        guiWindowSetSizable(GUIEditor.window[4], false)

        GUIEditor.staticimage[2] = guiCreateStaticImage(10, (359 - 278) / 2, 171, 278, ":ramping_challenge/client/img/ramp_finished.png", false, GUIEditor.window[4])
        GUIEditor.label[6] = guiCreateLabel(203, 118, 347, 127, "Congratulations for passing the Ramping Challenge. \n\n\nKeep an eye out around Las Venturas and Bone County Desert, as there may be more.\n\nRemember: you need to complete all ramping challenges to unlock the Ramping License feature.", false, GUIEditor.window[4])
        guiLabelSetHorizontalAlign(GUIEditor.label[6], "left", true)
        GUIEditor.button[7] = guiCreateButton(201, 277, 350, 49, "Close", false, GUIEditor.window[4])
        GUIEditor.staticimage[3] = guiCreateStaticImage(213, 42, 333, 45, ":ramping_challenge/client/img/smashedit.png", false, GUIEditor.window[4])    

		
		
		
		guiSetInputMode("allow_binds")
		
		guiSetVisible(GUIEditor.window[1], false)
		guiSetVisible(GUIEditor.window[2], false)
		guiSetVisible(GUIEditor.window[3], false)
		guiSetVisible(GUIEditor.window[4], false)
		
		-- EVENT HANDLERS - button click 
		addEventHandler("onClientGUIClick", GUIEditor.button[2], 
			function()
				hideRampingChallengeSignupDialog()
				playSFX("genrl", 53, 1, false)
			end,
		false)
		
		addEventHandler("onClientGUIClick", GUIEditor.button[1], 
			function() 
				hideRampingChallengeSignupDialog()
				playSFX("genrl", 53, 6, false)
				triggerEvent("onClientRequestStartRampingSchoolChallengeTutorial", localPlayer)
			end, 
		false)
		
		-- tutorial start
		addEventHandler("onClientGUIClick", GUIEditor.button[3], 
			function()
				playSFX("genrl", 53, 6, false)
				triggerEvent("onClientStartRampingSchoolChallengeTutorial", localPlayer)
			end
		)
		
		-- tutorial skip
		addEventHandler("onClientGUIClick", GUIEditor.button[4], 
			function()
				playSFX("genrl", 53, 1, false)
				triggerEvent("onClientSkipRampingSchoolChallengeTutorial", localPlayer)
			end
		)
		
		-- try again - yes 
		addEventHandler("onClientGUIClick", GUIEditor.button[5], 
			function()
				playSFX("genrl", 53, 6, false)
				hideRampingChallengeTryAgainDialog()
				triggerEvent("onClientRequestRampingChallengeTryAgain", localPlayer, true)
			end, 
		false)
		
		-- try again - no
		addEventHandler("onClientGUIClick", GUIEditor.button[6], 
			function()
				playSFX("genrl", 53, 1, false)
				hideRampingChallengeTryAgainDialog()
				triggerEvent("onClientRequestRampingChallengeTryAgain", localPlayer, false)
			end, 
		false)
		
		-- complete dialog 
		addEventHandler("onClientGUIClick", GUIEditor.button[7], 
			function()
				hideRampingChallengeCompleteDialog()
				setTimer(
					function()
						exports.display:showHint("You can revist the ramping challenge office at any time and try and beat your record!")
					end,
				4000, 1)
			end,
		false)
		
	end 
)

addEventHandler("onClientRender", root, 
	function()
		
		if(rampingChallengeGameText) then
			local screenW, screenH = guiGetScreenSize()
			dxDrawText(rampingChallengeGameText, (screenW - 408) / 2, (screenH - 92) / 2, ((screenW - 408) / 2) + 408, ( (screenH - 92) / 2) + 92, tocolor(255, 255, 255, 255), 4.00, "pricedown", "center", "center", true, false, false, false, false)
		end 
		
		
		if(rampingChallengeProgressText) then
		
			local rampsToClimb = resourceSettings["level1NumberOfRampsToComplete"]
		
			dxDrawText("RAMPING CHALLENGE", 512 - 1, 77 - 1, 864 - 1, 139 - 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 + 1, 77 - 1, 864 + 1, 139 - 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 - 1, 77 + 1, 864 - 1, 139 + 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 + 1, 77 + 1, 864 + 1, 139 + 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512, 77, 864, 139, tocolor(0, 255, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText(tostring(getNumberOfRampsClimbed()) .. " / " ..rampsToClimb .." ramps climbed", 512, 139, 864, 176, tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "top", false, false, false, false, false)
			dxDrawText("Altitude: "..getAltitudeString(), 649, 176, 730, 190, tocolor(255, 255, 255, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		end
		
	end 
)

function getAltitudeString()
	local x, y z = getElementPosition(localPlayer)
	local feet = math.floor(z / 3.28084)
	return tostring(feet)
end 


function showRampingChallengeProgressText()
	rampingChallengeProgressText = true
end 

function hideRampingChallengeProgressText()
	rampingChallengeProgressText = false
end 

function showRampingChallengeSignupDialog()
	guiSetInputMode("no_binds")
	guiSetVisible(GUIEditor.window[1], true)
	playSFX("genrl", 52, 18, false)
end

function hideRampingChallengeSignupDialog()
	guiSetInputMode("allow_binds")
	guiSetVisible(GUIEditor.window[1], false)
end 

function showRampingChallengeTutorialSkipDialog()
	guiSetInputMode("no_binds")
	guiSetVisible(GUIEditor.window[2], true)
end 

function hideRampingChallengeTutorialSkipDialog()
	guiSetInputMode("allow_binds")
	guiSetVisible(GUIEditor.window[2], false)
end 

function showRampingChallengeTryAgainDialog()
	guiSetInputMode("no_binds")
	guiSetVisible(GUIEditor.window[3], true)
	showCursor(true)
end 

function hideRampingChallengeTryAgainDialog()
	guiSetInputMode("allow_binds")
	guiSetVisible(GUIEditor.window[3], false)
	showCursor(false)
end 

function showRampingChallengeCompleteDialog()
	guiSetVisible(GUIEditor.window[4], true)
	guiSetInputMode("no_binds")
	showCursor(true)
end 

function hideRampingChallengeCompleteDialog()
	guiSetVisible(GUIEditor.window[4], false)
	guiSetInputMode("allow_binds")
	showCursor(false)
end 



function showRampingChallengeGameText(text)
	rampingChallengeGameText = text 
end 

function hideRampingChallengeGameText()
	rampingChallengeGameText = nil
end 






