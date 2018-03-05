countdownGuiImages = {}
countdownTimer = nil


addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		local screenWidth, screenHeight = guiGetScreenSize()
		i = 0
		
		while(i ~= 4) do
		
			countdownGuiImages[i] = guiCreateStaticImage(
				math.floor(screenWidth / 2 - 237),
				math.floor(screenHeight / 2 - 102),
				474,
				204,
				"client/img/countdown_" ..tostring(i) ..".png",
				false)
			
			guiSetVisible(countdownGuiImages[i], false)
			i = i + 1
		end 
	end 
)


function startRampingChallengeCountdown()

	local countdown = 3 -- todo: manage
	
	setTimer(
		function()
		
			if(countdown ~= 3) then 
				guiSetVisible(countdownGuiImages[countdown + 1], false)
			end 	
			
			if(countdown >= 0) then 
				guiSetVisible(countdownGuiImages[countdown], true)
			end
			
			if(countdown > 1) then
			
				playSFX("script", 16, 5, false)
				
			elseif (countdown == 1) then
			
				playSFX("script", 16, 1, false)
				
			elseif(countdown == 0) then
			
				playSFX("script", 6, 1, false)
				iprint("triggering event!")
				triggerEvent("onClientRampingCountdownFinish", localPlayer)
			end
		
			countdown = countdown - 1
		end, 
	1000, 5)
end 


