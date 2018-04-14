local redBarrelRootElement = createElement("redBarrelParent")
local yellowBarrelRootElement = createElement("yellowBarrelParent")

local numerOfRedBarrels = 0
local numerOfRedBarrelsShot = 0

local numerOfYellowBarrels = 0
local numerOfYellowBarrelsShot = 0

local shotMessage = nil


addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		triggerServerEvent("onClientRequestRedBarrelElements", resourceRoot)
		triggerServerEvent("onClientRequestYellowBarrelElements", resourceRoot)
		
		local x, y = guiGetScreenSize()
		
		shotMessage = dxText:create("", 0.5, 0.35, true )
		shotMessage:font("bankgothic")
		shotMessage:scale(x / 1200)
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
			local marker = createBlip(x, y, z, 0, 1, 255, 0, 0, 150, 0, 150)
			
			setObjectBreakable(object, false)
			
			setElementParent(object, redBarrelRootElement)
			setElementParent(marker, object)
			
			numerOfRedBarrels = numerOfRedBarrels + 1
		end 
	end 
)

addEvent("onServerProvideYellowBarrelElements", true)
addEventHandler("onServerProvideYellowBarrelElements", resourceRoot,
	function(theElements)
		for i, theElement in ipairs(theElements) do
		
			local x, y, z = 
				getElementData(theElement, "posX"), 
				getElementData(theElement, "posY"), 
				getElementData(theElement, "posZ")
		
			local object = createObject(1218, x, y, z, 0, 0, 0)
			local marker = createBlip(x, y, z, 0, 1, 255, 255, 0, 150, 0, 150)
			
			setObjectBreakable(object, false)
			
			setElementParent(object, yellowBarrelRootElement)
			setElementParent(marker, object)
			
			numerOfYellowBarrels = numerOfYellowBarrels + 1
		end 
	end 
)


addEventHandler("onClientPlayerWeaponFire", localPlayer,
	function(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
		
		
		if not hitElement then
			return
		end
		
		local parentElementType = getElementType(getElementParent(hitElement))
		
		if parentElementType ==  "redBarrelParent" or parentElementType ==  "yellowBarrelParent" then
		
			destroyElement(hitElement)
			createExplosion(hitX, hitY, hitZ, 0)
		
			if(parentElementType == "redBarrelParent") then
			
				numerOfRedBarrelsShot = numerOfRedBarrelsShot + 1
				shotMessage:text(numerOfRedBarrelsShot .."/"..numerOfRedBarrels.. " red barrels shot")
			
			elseif parentElementType == "yellowBarrelParent" then
			
				numerOfYellowBarrelsShot = numerOfYellowBarrelsShot + 1
				shotMessage:text(numerOfYellowBarrelsShot .."/"..numerOfYellowBarrels.. " yellow barrels shot")
				
				-- the yellow barrels are slightly more deadly ;)
				createEffect("riot_smoke", hitX, hitY, hitZ)
				
				setTimer(
					function()
						createExplosion(hitX, hitY, hitZ, 1)
						setTimer(
							function()
								createExplosion(hitX, hitY, hitZ, 0)
							end,
						math.random(200, 700), 1)
					end,
				500, 5)
			

			end 
			
			
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

function getnumerOfRedBarrelsShot()
	return tonumber(numerOfRedBarrelsShot)
end

function getnumerOfYellowBarrelsShot()
	return tonumber(numerOfYellowBarrelsShot)
end

