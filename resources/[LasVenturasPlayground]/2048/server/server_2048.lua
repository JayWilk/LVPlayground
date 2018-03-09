-- 2048 in MTA by Ali Digitali
-- the original game can be found at: http://gabrielecirulli.github.io/2048/
-- anyone reading this has permission to copy parts of this script

gameMarkerRootElement = createElement("gameMarkerRoot")

function winMessage ()
    outputChatBox (getPlayerName(client).."#00FF00 has reached 2048!", getRootElement(),0,255,0,true)
end
addEvent( "on2048win", true )
addEventHandler( "on2048win", root, winMessage )

addEventHandler("onResourceStart", resourceRoot,
	function()

		for i, theElement in ipairs(getElementsByType("gameCheckpoint")) do
			local marker = createMarker(getElementData(theElement, "posX"), getElementData(theElement, "posY"), getElementData(theElement, "posZ"),
				"cylinder", 1.5,  255, 0, 0, 100)
				
			setElementParent(marker, gameMarkerRootElement)
				
		end 
	end 
)

addEventHandler("onMarkerHit", gameMarkerRootElement, 
	function(theElement)
	
		if(getElementType(theElement) ~= "player") then
			return
		end
			
		triggerClientEvent(theElement, "onServerRequest2048Start", theElement)
		

	end
)



