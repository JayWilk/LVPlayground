local redBarrelRootElement = createElement("redBarrelParent")
local numberOfBarrels = 0
local numberOfBarrelsShot = 0
local shotMessage = nil



addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("onClientRequestRedBarrelElements", resourceRoot)
		
		local x, y = guiGetScreenSize()
		
		shotMessage = dxText:create("", 0.5, 0.35, true )
		shotMessage:font("bankgothic")
		shotMessage:scale(x / 600)
		shotMessage:type("border",2,0,0,0)
		shotMessage:color(190,190,190,255)
		shotMessage:visible(false)
		
	end 
)

addEvent("onServerProvideRedBarrelElements", true)
addEventHandler("onServerProvideRedBarrelElements", resourceRoot,
	function(theElements)
		for i, theElement in ipairs(theElements) do
		
			local x, y, z = 
				getElementData(theElement, "posX"), 
				getElementData(theElement, "posY"), 
				getElementData(theElement, "posZ")
		
			local object = createObject(1225, x, y, z, 0, 0, 0)
			local marker = createBlip(x, y, z, 0, 1, 255, 0, 0, 150, 0, 400)
			
			setObjectBreakable(object, false)
			
			setElementParent(object, redBarrelRootElement)
			setElementParent(marker, object)
			
			numberOfBarrels = numberOfBarrels + 1
		end 
	end 
)


addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
		
		if hitElement and getElementType(getElementParent(hitElement)) ==  "redBarrelParent" then
		
			destroyElement(hitElement)
			createExplosion(hitX, hitY, hitZ, 9)
			
			numberOfBarrelsShot = numberOfBarrelsShot + 1
			
			
			shotMessage:text(numberOfBarrelsShot .."/"..numberOfBarrels.. " red barrels shot")
			shotMessage:visible(true)
			
			setTimer(
				function()
					shotMessage:text("")
					shotMessage:visible(false)
				end,
			3000, 1)
		end 
	end 
)
