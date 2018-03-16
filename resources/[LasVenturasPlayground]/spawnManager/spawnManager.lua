-- SpawnManager 0.1 by Jay --

addEventHandler("onPlayerJoin", getRootElement(), 
	function()
		spawnPlayerAtRandomPosition(source)
		setPlayerDefaultSpawnSkin(source)
		givePlayerDefaultSpawnWeapons(source)
	end
);

addEventHandler("onPlayerWasted", getRootElement(), 
	function()
		setTimer( function(thePlayer) 
			fadeCamera(thePlayer, false)
		end, 3000, 1, source )

		setTimer(function(thePlayer)
			spawnPlayerAtRandomPosition(thePlayer)
			setPlayerDefaultSpawnSkin(thePlayer)
			givePlayerDefaultSpawnWeapons(thePlayer)
		end, 5000, 1, source)
	end
)
addEventHandler("onResourceStart", resourceRoot, 
	function()
		for id, thePlayer in ipairs(getElementsByType("player")) do 
			spawnPlayerAtRandomPosition(thePlayer)
			setPlayerDefaultSpawnSkin(thePlayer)
			givePlayerDefaultSpawnWeapons(thePlayer)
		end 
	end 
)

function spawnPlayerAtRandomPosition(thePlayer)

	local spawns = {}

	for theKey, theSpawnPos in ipairs(getElementsByType("spawnpoint")) do 
		spawns[theKey] = { }
		spawns[theKey].x = getElementData(theSpawnPos, "posX")
		spawns[theKey].y = getElementData(theSpawnPos, "posY")
		spawns[theKey].z = getElementData(theSpawnPos, "posZ")
		spawns[theKey].r = getElementData(theSpawnPos, "rot")
	end

	rnd = math.random( 1, #spawns )
	spawnPlayer( thePlayer, spawns[rnd].x, spawns[rnd].y, spawns[rnd].z, math.floor(spawns[rnd].r))

	fadeCamera(thePlayer, true)
	
	setTimer(setCameraTarget, 100, 1, thePlayer, thePlayer)
end


function setPlayerDefaultSpawnSkin(thePlayer)

	addPedClothes(thePlayer, "tshirterisorn", "tshirt", 0)
	addPedClothes(thePlayer, "highafro", "highafro", 1)
	addPedClothes(thePlayer, "worktrcamogrn", "worktr", 2)
	addPedClothes(thePlayer, "bask2semi", "bask1", 3)
	
	setPedStat(thePlayer, 23, 1000)
	setPedStat(thePlayer, 75, 1000)
	setPedStat(thePlayer, 73, 1000)
end


function givePlayerDefaultSpawnWeapons(thePlayer)
	giveWeapon(thePlayer, 26, 150)
	giveWeapon(thePlayer, 32, 500)
end
