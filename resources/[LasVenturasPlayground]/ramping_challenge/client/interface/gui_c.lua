GUIEditor = {
    button = {},
    window = {},
    staticimage = {},
    label = {}
}

instructionTextShowing = false
instructionText = nil
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
		
		
		guiSetInputMode("allow_binds")
		
		guiSetVisible(GUIEditor.window[1], false)
		guiSetVisible(GUIEditor.window[2], false)
		guiSetVisible(GUIEditor.window[3], false)
		
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
		
	end 
)

addEventHandler("onClientRender", root, 
	function()
		if(instructionTextShowing) then 
			local g_screenX,g_screenY = guiGetScreenSize()
			local shadowColor = tocolor(0,0,0)
			local color = tocolor(255,255,255)
		
			--dxDrawText ( instructionText, 0 + 3, g_screenY * 0.75 + 3, g_screenX, g_screenY, shadowColor, 2, "default", "center", "top", false, true, false, true )
			dxDrawText ( instructionText, 0, g_screenY*0.75, g_screenX, g_screenY, color, 2, "default", "center", "top", false, true, false, true )
		end 
		
		if(rampingChallengeGameText) then
			local screenW, screenH = guiGetScreenSize()
			dxDrawText(rampingChallengeGameText, (screenW - 408) / 2, (screenH - 92) / 2, ((screenW - 408) / 2) + 408, ( (screenH - 92) / 2) + 92, tocolor(255, 255, 255, 255), 4.00, "pricedown", "center", "center", true, false, false, false, false)
		end 
		
		
		if(rampingChallengeProgressText) then
			dxDrawText("RAMPING CHALLENGE", 512 - 1, 77 - 1, 864 - 1, 139 - 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 + 1, 77 - 1, 864 + 1, 139 - 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 - 1, 77 + 1, 864 - 1, 139 + 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 + 1, 77 + 1, 864 + 1, 139 + 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512, 77, 864, 139, tocolor(0, 255, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText(tostring(getNumberOfRampsClimbed()) .. " / 250 ramps climbed!", 512, 139, 864, 176, tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "top", false, false, false, false, false)
			dxDrawText("Altitude: "..getAltitudeString(), 649, 176, 730, 190, tocolor(255, 255, 255, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		end
		
	end 
)

function getAltitudeString()
	local x, y z = getElementPosition(localPlayer)
	return tostring(z)
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
	playSFX("genrl", 52, 18, false)
end 

function hideRampingChallengeTryAgainDialog()
	guiSetInputMode("allow_binds")
	guiSetVisible(GUIEditor.window[3], false)
	showCursor(false)
end 

function showRampingChallengeInstructions(text, time)
	instructionTextShowing = true
	instructionText = text
	
	if(time) then 
		setTimer(hideRampingChallengeInstructions, time, 1)
	end
	
end 

function hideRampingChallengeInstructions()
	instructionText = nil
	instructionTextShowing = false
end 

function showRampingChallengeGameText(text)
	rampingChallengeGameText = text 
end 

function hideRampingChallengeGameText()
	rampingChallengeGameText = nil
end 






