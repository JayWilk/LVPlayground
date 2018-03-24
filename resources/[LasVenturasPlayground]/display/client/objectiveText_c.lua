objectiveText = nil
local g_screenX,g_screenY = guiGetScreenSize()


addEventHandler("onClientRender", root,
	function()
		if(objectiveText) then 
		
			local shadowColor = tocolor(0,0,0)
			local color = tocolor(255,255,255)
		
			dxDrawText ( objectiveText, 0, g_screenY*0.75, g_screenX, g_screenY, color, 2, "default", "center", "top", false, true, false, true )
		end 
	
	end
)

function showObjective(text, time)
	objectiveText = text
	
	if(time) then 
		setTimer(hideObjectiveText, time, 1)
	end
	
end 

function hideObjective()
	objectiveText = nil
end 