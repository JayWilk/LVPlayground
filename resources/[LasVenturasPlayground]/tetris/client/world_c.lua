-- tetris world
-- Used to construct the game machines client side,
-- and display the GUI

gameMachineRootElement = createElement("tetrisGameMachineRoot")
isPlayingTetris = false
gameText = nil

addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("onClientRequestTetrisGameMachineElements", resourceRoot)
		
		local x, y = guiGetScreenSize()
		gameText = dxText:create("Press enter to play Tetris", 0.5, 0.85)
		gameText:font("pricedown")
		gameText:scale(x / 1200)
		gameText:type("border", 5, 0, 0, 0)
		gameText:color(0, 255, 0, 255)
		gameText:visible(false)
	end 
)

addEvent("onServerProvideTetrisGameMachineElements", true)
addEventHandler("onServerProvideTetrisGameMachineElements", resourceRoot,
	function(theElements)
		for i, theElement in ipairs(theElements) do
		
			local x, y, z, rz = 
				getElementData(theElement, "posX"), 
				getElementData(theElement, "posY"), 
				getElementData(theElement, "posZ"), 
				getElementData(theElement, "rotZ")
		
			local rotation = rz / 90 * math.pi
			local markerX = x - ( math.sin(rotation) * 0.8 ) 
			local markerY = y + ( math.cos(rotation) * 0.8 ) 
		
			local object = createObject(2778, x, y, z, 0, 0, rz)
			local colShape = createColSphere(markerX, markerY, z, 1.5)

			setElementParent(colShape, gameMachineRootElement)
			setElementParent(object, gameMachineRootElement)
			
			attachElements(colShape, object)
		end 
	end 
)

addEventHandler("onClientColShapeHit", gameMachineRootElement, 
	function(theElement)
	
		if(getElementType(theElement) ~= "player") then
			return
		end
		
		playSFX("script", 144, 0, false)
		bindKey("enter", "down", startTetris)
		toggleControl("enter_exit", false)
		gameText:visible(true)
	end
)

addEventHandler("onClientColShapeLeave", gameMachineRootElement, 
	function(theElement)
	
		if(getElementType(theElement) ~= "player") then
			return
		end
		
		unbindKey("enter", "down", startTetris)
		toggleControl("enter_exit", true)
		gameText:visible(false)
	end
)


addEvent("onClientStopPlayingTetris", true)
addEventHandler("onClientStopPlayingTetris", localPlayer,
	function()
		isPlayingTetris = false
	end
)


function startTetris()

	if(isPlayingTetris) then
		return
	end
	
	playSFX("script", 146, 5, false)
	
	triggerEvent("onClientRequestTetrisStart", localPlayer)
	isPlayingTetris = true
end 
