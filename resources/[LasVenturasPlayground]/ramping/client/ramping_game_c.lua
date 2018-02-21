-- The ramping "game" challengers players to continue climbing ramps and continuing to a high place 

isPlayerPlayingRampingChallenge = false 
rampsClimbed = 0


addEvent("onClientStartRamping")
addEventHandler("onClientStartRamping", root,
	function()
	
	end 
)

addEvent("onClientEndRamping")
addEventHandler("onClientEndRamping", root,
	function()
		isPlayerPlayingRampingChallenge = false
	end 
)

addEvent("onClientPerformRamping")
addEventHandler("onClientPerformRamping", root, 
	function(numberOfConsecutiveRamps)
	
		rampsClimbed = numberOfConsecutiveRamps
		
		if(numberOfConsecutiveRamps > 1) then -- todo: manage settings
			playSFX("genrl", 52, 18, false)
			isPlayerPlayingRampingChallenge = true
		end 
	end
)

addEventHandler("onClientRender", root,
    function()
		if(isPlayerPlayingRampingChallenge) then 
			dxDrawText("RAMPING CHALLENGE", 512 - 1, 77 - 1, 864 - 1, 139 - 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 + 1, 77 - 1, 864 + 1, 139 - 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 - 1, 77 + 1, 864 - 1, 139 + 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512 + 1, 77 + 1, 864 + 1, 139 + 1, tocolor(0, 0, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText("RAMPING CHALLENGE", 512, 77, 864, 139, tocolor(0, 255, 0, 255), 2.00, "pricedown", "center", "top", false, false, false, false, false)
			dxDrawText(tostring(rampsClimbed) .. " / 250 ramps climbed!", 512, 139, 864, 176, tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "top", false, false, false, false, false)
			dxDrawText("Altitude: "..getAltitudeString(), 649, 176, 730, 190, tocolor(255, 255, 255, 255), 1.00, "default", "center", "top", false, false, false, false, false)
		end 
    end
)

function getAltitudeString()
	local x,y,z = getElementPosition(localPlayer)
	return tostring(x) .. " meters"
end 
