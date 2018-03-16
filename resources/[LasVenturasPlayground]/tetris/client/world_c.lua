-- tetris world
-- Used to construct the game machines client side,
-- and display the GUI

gameMachineRootElement = createElement("tetrisGameMachineRoot")
isPlayingTetris = false


addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("onClientRequestTetrisGameMachineElements", resourceRoot)
	end 
)

addEvent("onServerProvideTetrisGameMachineElements", true)
addEventHandler("onServerProvideTetrisGameMachineElements", resourceRoot,
	function(theElements)
		iprint("server provided wee")
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
	end
)

addEventHandler("onClientColShapeLeave", gameMachineRootElement, 
	function(theElement)
	
		if(getElementType(theElement) ~= "player") then
			return
		end
		
		unbindKey("enter", "down", startTetris)
		toggleControl("enter_exit", true)
	end
)


addEventHandler("onClientRender", root,
	function()
		
		if isPlayingTetris then
			return
		end 
			
		gameMachineCols = getElementChildren(gameMachineRootElement, "colshape")
		
		for i, colShape in ipairs(gameMachineCols) do
			if isElementWithinColShape(localPlayer, colShape) then
				dxDrawText("Press Enter to play Tetris", 512, 631, 854, 667, tocolor(0, 253, 0, 255), 1.20, "pricedown", "left", "top", false, false, false, false, false)
			end
		end 
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
