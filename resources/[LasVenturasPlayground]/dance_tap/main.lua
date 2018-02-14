local g_screenX,g_screenY = guiGetScreenSize()
local g_localPlayer = getLocalPlayer()
local g_root = getRootElement()
local g_resourceRoot = getResourceRootElement(getThisResource())
local g_currentIndex,g_currentTick,g_initialTick,g_score,g_trackList,g_soundFile,g_speed,g_threshold
local trackFiles = {}
local trackCache = {}
local pressColours = {}
local trackProgress = {}
local lastAnim = {}

local TARGET_SIZE = 40
local KEY_SIZE = 36

local DEFAULT_SPEED = 10000 --Time it takes to get from one side of the screen to the other

local rotations = {
	up = 0,
	down = 180,
	left = 270,
	right = 90
}

local controls = { "forwards","backwards","left","right" }
local animations = { forwards = "DAN_Up_A", backwards = "DAN_Down_A", left = "DAN_Left_A", right = "DAN_Right_A" }
local goodText = { "You're the master!", "Nice!", "Great timing!", "Synchronized", "Okay", "Not Bad" }
local badText = { "You suck!", "Missed it", "Get out of here!", "Out of sync", "Awful" }

local TICK_THRESHOLD = 100 --Hit within this time to get a good score
----Hit points


addEventHandler("onClientResourceStart", g_resourceRoot,
	function()
		g_trackList = xmlLoadFile("music.xml")
		--Create our initial gui
		infoText = dxText:create( "", 0.5, 0.25, true )
		infoText:font("pricedown")
		infoText:scale(3)
		infoText:type("border",3,0,0,0)
		--Track text
		trackName = dxText:create( "", 0.01, 0.4, true )
		trackName:font("arial")
		trackName:align("left","center")
		trackName:scale(1)
		trackName:type("border",2,0,0,0)
		trackName:color(255,0,0,0)
		--Score
		score = dxText:create( "Score: 0", 0.95, 0.4, true )
		score:font("bankgothic")
		score:align("right","center")
		score:scale(1)
		score:type("border",2,0,0,0)
		score:color(190,190,190,0)
		--Comments
		comments = dxText:create( "", 0.5, 0.35, true )
		comments:font("bankgothic")
		comments:scale(1.4)
		comments:type("border",2,0,0,0)
		comments:color(190,190,190,255)
	end
)



function dance(trackNo)
	if g_currentIndex then
		outputDebugString ( "dance: Dance already in progress", 0, 255, 255, 0 )
		return false
	end
	trackNo = tonumber(trackNo)
	if not trackNo then
		outputDebugString ( "dance: Bad track number specified", 0, 255, 255, 0 )
		return false
	end
	--Read our track if it hasnt been cached already
	if not trackCache[trackNo] then
		local definitionTag = xmlFindChild( g_trackList, "music", trackNo - 1 )
		if not definitionTag then
			outputDebugString ( "dance: Bad track number specified", 0, 255, 255, 0 )
			return false
		end
		local definitionDir = xmlNodeGetAttribute(definitionTag,"definition")
		local definition = xmlLoadFile ( definitionDir )
		local name = xmlNodeGetAttribute(definition,"name")
		local file = xmlNodeGetAttribute(definition,"file")
		local speed = xmlNodeGetAttribute(definition,"speed")
		g_speed = DEFAULT_SPEED/speed
		g_threshold = TICK_THRESHOLD/speed
		trackFiles[trackNo] = file
		trackName:text(name)
		--Store the rest of the track
		trackCache[trackNo] = {}
		for i,node in ipairs(xmlNodeGetChildren(definition)) do
			if xmlNodeGetName(node) == "press" then
				local tick,key = tonumber(xmlNodeGetAttribute(node,"tick")),xmlNodeGetAttribute(node,"key")
				g_currentTick = g_currentTick or tick
				table.insert ( 	trackCache[trackNo], { 	tick = tick, key = key, } )
				pressColours[tick] = tocolor(255,255,255,180)
			end
		end
	end
	trackProgress = trackCache[trackNo]
	Animation.createAndPlay(trackName, Animation.presets.dxTextFadeIn(1000))
	Animation.createAndPlay(score, Animation.presets.dxTextFadeIn(1000))
	setTimer ( function()
					Animation.createAndPlay(trackName, Animation.presets.dxTextFadeOut(3000))
				end,
				7000,
				1
			)
	g_initialTick = getTickCount()
	g_currentIndex = 1
	g_score = 0
	for i,control in ipairs(controls) do
		bindKey(control,"down",pressKey)
	end
	g_soundFile = playSound ( trackFiles[trackNo], false )
	setSoundVolume(g_soundFile, 1.0)
	setPedNewAnimation ( g_localPlayer, "DANCING", "dance_loop", -1, true, true, false )
	return addEventHandler ( "onClientRender", g_root, doTrack )
end
addCommandHandler ( "dance",function(cmd,arg) dance(arg) end )

function reddenImage ( tick, alpha )
	pressColours[tick] = tocolor(255,0,0,255 - alpha )
end

function greenImage ( tick, alpha )
	pressColours[tick] = tocolor(0,255,0,255 - alpha )
end

function restoreImage ( tick )
	pressColours[tick] = tocolor(255,255,255,180)
end

function doTrack ()
	--Draw the main target circle
	for i,pressInfo in ipairs(trackProgress) do
		local currentTick = getTickCount() - g_initialTick
		local maxX = pressInfo.tick + g_speed/2
		local minX = pressInfo.tick - g_speed/2
		local progress = ( ( pressInfo.tick - currentTick ) / g_speed ) +	 0.5
		local draw = progress*g_screenX
		-- if i == 1 then
		-- outputChatBox (tostring(progress)) end
		if progress > -0.1 and progress < 1 then
			dxDrawImage ( draw, (0.8*g_screenY)-KEY_SIZE/2, KEY_SIZE, KEY_SIZE, "arrow.png", rotations[pressInfo.key],0,0,pressColours[pressInfo.tick] )
		end
		if draw-KEY_SIZE/2 < 0.5*g_screenX and g_currentTick < pressInfo.tick then
			updateIndex ( pressInfo.tick )
		end
	end
	dxDrawImage ( (0.5*g_screenX)-TARGET_SIZE/2, (0.8*g_screenY)-TARGET_SIZE/2, TARGET_SIZE, TARGET_SIZE, "centre.png" )
end

function pressKey(keyPress)
	local tick = trackProgress[g_currentIndex].tick
	local key = trackProgress[g_currentIndex].key
	if math.abs(tick - (getTickCount() - g_initialTick)) < g_threshold and key == keyPress then
		infoText:text"good!"
		infoText:color(0,255,0)
		Animation.createAndPlay(
			tick,
			{{ from = 0, to = 255, time = 500, fn = greenImage }}
		)
		setTimer ( restoreImage, 600, 1, tick )
		--Pick a random comment
		comments:text(goodText[math.random ( 1, #goodText )])
		g_score = g_score + 10
		updateIndex ( trackProgress[g_currentIndex+1].tick )
		updateScore()
	else
		infoText:text"bad!"
		infoText:color(255,0,0)	
		Animation.createAndPlay(
			tick,
			{{ from = 0, to = 255, time = 500, fn = reddenImage }}
		)
		setTimer ( restoreImage, 600, 1, tick )
		comments:text(badText[math.random ( 1, #badText )])
		g_score = g_score - 10
		updateScore()
	end
	setPedAnimation ( g_localPlayer, "DANCING", animations[keyPress], -1, true, true, false )
end

function updateScore()
	score:text ( "Score: "..tostring(g_score) )
	if g_score < 0 then
		score:color(255,0,0)
	else
		score:color(190,190,190)
	end
end

function updateIndex(tick)
	g_currentIndex = g_currentIndex + 1
	g_currentTick = tick
	if not trackProgress[g_currentIndex] then
		outputChatBox "FINISH"
		removeEventHandler ( "onClientRender", root, doTrack )
		for i,control in ipairs(controls) do
			unbindKey(control,"down",pressKey)
		end
		infoText:text("")
		comments:text("")
		Animation.createAndPlay(score, Animation.presets.dxTextFadeOut(1000))
		setPedAnimation ( localPlayer, nil )
		destroyElement ( g_soundFile )
		g_currentIndex,g_currentTick,g_initialTick,g_score,g_trackList,g_soundFile = nil,nil,nil,nil,nil,nil
	end
end

function setPedNewAnimation ( ped, animgroup, animname, ... )
	if animname ~= lastAnim[ped] then
		lastAnim[ped] = animname
		return setPedAnimation ( ped, animgroup, animname, ... )
	end
	return true
end