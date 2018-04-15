GUIEditor = {
    staticimage = {},
	button = {},
    window = {},
    label = {}
}

local screenX, screenY = guiGetScreenSize()

taxiPaneShowing = false
taxiPaneProgress = 1
taxiPaneProgressMultiplier = 0.002
taxiCancellationPending = false
taxiCancelText = getLocalizedText("taxi.cancel.key")

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        GUIEditor.staticimage[1] = guiCreateStaticImage(0.81, 0.70, 0.17, 0.18, "client/img/taxi.jpg", true)    
		
		local screenW, screenH = guiGetScreenSize()
        
		GUIEditor.window[1] = guiCreateWindow((screenW - 324) / 2, (screenH - 152) / 2, 324, 152, "Kaufman Cabs", false)
        guiWindowSetMovable(GUIEditor.window[1], false)
        guiWindowSetSizable(GUIEditor.window[1], false)

        GUIEditor.label[1] = guiCreateLabel((324 - 210) / 2, (152 - 34) / 2, 210, 34, getLocalizedText("taxi.cancel.confirmation"), false, GUIEditor.window[1])
        GUIEditor.button[1] = guiCreateButton(0.05, 0.58, 0.35, 0.26, getLocalizedText("taxi.cancel.yes"), true, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(0.56, 0.58, 0.35, 0.26, getLocalizedText("taxi.cancel.no"), true, GUIEditor.window[1])    
		
		guiSetVisible(GUIEditor.window[1], false)
		guiSetVisible(GUIEditor.staticimage[1], false)
		
		addEventHandler ( "onClientGUIClick", GUIEditor.button[1], 
			function()
				onPlayerConfirmTaxiCancellationRequest(true)
			end 
		)
		
		addEventHandler ( "onClientGUIClick", GUIEditor.button[2], 
			function()
				onPlayerConfirmTaxiCancellationRequest(false)
			end 
		)
    end
)

addEventHandler("onClientRender", root,
    function()
		if taxiPaneShowing then
		
			-- 1360 x 768
			local startX = (1101/1360) * screenX
			local startY = (685/768) * screenY
			
			local endX = (1333 / 1360) * screenX
			local endY = (685 / 768) * screenY

			dxDrawLine(startX, startY, endX, endY, tocolor(240, 249, 5, 255), 20, false)
			dxDrawLine(startX, startY, startX * taxiPaneProgress, 685, tocolor(105, 119, 11, 255), 20, false)
		
			local textX = startX + (endX - startX) / 4
			local textY = endY - 8
			dxDrawText(taxiCancelText, textX, textY, textX, textY, tocolor(244, 230, 10, 255), 1.00, "default-bold", "left", "top", false, false, true, false, false)

			if startX * taxiPaneProgress < endX - 2  then
				if(taxiCancellationPending == false) then 
					taxiPaneProgress = taxiPaneProgress + taxiPaneProgressMultiplier
				end
			else
				-- METER IS FULL UP
				resetTaxiInterfaceData()
				triggerEvent("onClientTaxiArrive", localPlayer)
			end 
		end 
    end
)

function showTaxiPane(multiplier)

	if not multiplier then multiplier = 0.0005 end 
	
	taxiPaneProgressMultiplier = multiplier
	taxiPaneProgress = 1
	taxiPaneShowing = true
	
	guiSetVisible(GUIEditor.staticimage[1], true)
	bindKey("x", "down", onPlayerRequestTaxiCancellation)
	
end 

function onPlayerRequestTaxiCancellation()

	if guiGetVisible(GUIEditor.window[1]) == true then
		guiSetVisible(GUIEditor.window[1], false)
		taxiCancellationPending = false
		toggleAllControls(true)
		showCursor(false)
		return
	end 
	
	guiSetVisible(GUIEditor.window[1], true)
	taxiCancellationPending = true
	toggleAllControls(false)
	showCursor(true)
end 

function onPlayerConfirmTaxiCancellationRequest(cancelled)

	if not cancelled  then
		guiSetVisible(GUIEditor.window[1], false)
		taxiCancellationPending = false 
		toggleAllControls(true)
		showCursor(false)
		return 
	end 
	
	triggerEvent("onClientCancelTaxi", localPlayer)
	resetTaxiInterfaceData()
end 


function resetTaxiInterfaceData()
	taxiPaneShowing = false
	taxiCancellationPending = false
	taxiPaneProgress = 1 
	taxiPaneProgressMultiplier = 0.002
	
	toggleAllControls(true)
	showCursor(false)
	
	guiSetVisible(GUIEditor.window[1], false)
	guiSetVisible(GUIEditor.staticimage[1], false)
	unbindKey("x", "down", onPlayerRequestTaxiCancellation)
end 
