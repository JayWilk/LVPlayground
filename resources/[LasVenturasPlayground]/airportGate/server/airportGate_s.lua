



addEventHandler("onResourceStart", resourceRoot,
	function()

		for i, element in ipairs(getElementsByType("airportGate", resourceRoot)) do
		
			local x = getElementData(element, "posX")
			local y = getElementData(element, "posY")
			local z = getElementData(element, "posZ")
			local rx = getElementData(element, "rotX")
			local ry = getElementData(element, "rotY")
			local rz = getElementData(element, "rotZ")
			local pedX = getElementData(element, "pedX")
			local pedY = getElementData(element, "pedY")
			local pedZ = getElementData(element, "pedZ")
			local pedRotZ = getElementData(element, "pedRotZ")
		
			local col = createColCircle(x, y, z, 20)
			local ped = createPed(71, pedX, pedY, pedZ, pedRotZ)
			local object = createObject(980, x, y, z, rx, ry, rz)
			
			setElementParent(ped, element)
			setElementParent(col, element)
			setElementParent(object, element)
			setElementParent(element, element)
		end 
	end 
)


addEventHandler("onColShapeHit", resourceRoot, 
	function(hitElement)
		
		if not hitElement or getElementType(hitElement) ~= "player" then
			return
		end 
		
		local parentElement = getElementParent(source)
		
		if not parentElement then
			return
		end 
		
		
		--playSFX("script", 41, math.random(4, 6), false)
		
		-- Security guard sound 
		
		-- "This area is restricted to pilots only"
		--playSFX("script", 74, 0, false)
		--playSFX("script", 74, 1, false)
		
		-- "Pilots are getting younger these days!"
		--playSFX("script", 74, 2, false)
		--playSFX("script", 74, 3, false)
		
		
		-- GATE OPEN SOUND
		-- playSFX("genrl", 32, 70, false)
		
		-- PLAY THIS ON LOOP
		-- playSFX("genrl", 44, 0, true)
		-- THEN STOP WITH THIS
		-- playSFX("genrl", 44, 2, false)
		
		
		if getElementType(parentElement) == "airportGate" then 
			
			local moveX = getElementData(parentElement, "moveX")
			local moveY = getElementData(parentElement, "moveY")
			local moveZ = getElementData(parentElement, "moveZ")
			
			local objects = getElementChildren(parentElement, "object")
			
			moveObject(objects[1], 3000, moveX, moveY, moveZ)
			
		end 

	end 
)

addEventHandler("onColShapeLeave", resourceRoot,
	function(hitElement)
	
		if not hitElement or getElementType(hitElement) ~= "player" then
			return
		end 
		
		local parentElement = getElementParent(source)
		
		if not parentElement then
			return
		end 
		
		if getElementType(parentElement) == "airportGate" then 
		
			local moveX = getElementData(parentElement, "posX")
			local moveY = getElementData(parentElement, "posY")
			local moveZ = getElementData(parentElement, "posZ")
			
			local objects = getElementChildren(parentElement, "object")
			
			moveObject(objects[1], 2000, moveX, moveY, moveZ)
			
		end 
		
	end 
)
