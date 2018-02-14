function SwatRope()
    local myVehicle = getPedOccupiedVehicle(localPlayer)
    if myVehicle and getVehicleName(myVehicle) == "Police Maverick" then
        local x,y,z = getElementPosition(myVehicle)
        createSWATRope(x, y, z, 11111)  
    end
end
addCommandHandler("createrope", SwatRope)


addEventHandler("onClientResourceStart", resourceRoot, function()
		setWeather(10)
		setTime(12, 0)
		setPlayerHudComponentVisible (  "radar", true ) 
		setFogDistance(90);
	end 
)



function lolvc()
	outputChatbox("lolffs")
	
		
end
addCommandHandler ( "setpos", lolvc  )

addCommandHandler("omg", function()

		outputChatBox("omg")
		setElementPosition(localPlayer, -669.6416015625, 916.2568359375, 712.110098838806)
	end 
)