-- This file adds a queuing feature to Hint Boxes, so they will display one after the other
-- after a period of time
-- Jay

hintBoxQueue = {}

addEvent("onServerRequestHintBox", true)
addEventHandler("onServerRequestHintBox", localPlayer,
	function( hint )
	
		if not hint then 
			return
		end
		
		table.insert(hintBoxQueue, hint)
		
		if #hintBoxQueue == 1 then
			displayNextHintBox()
		end 
	
	end 
)


addEventHandler("onHintBoxExpire", localPlayer, 
	function()
		table.remove(hintBoxQueue, 1)
		displayNextHintBox()
	end 
)

function displayNextHintBox()
	if #hintBoxQueue > 0 then
		setTimer(
			function()
				triggerEvent("clientHintBox", localPlayer, hintBoxQueue[1])
			end,
		200, 1)
	end 
end 