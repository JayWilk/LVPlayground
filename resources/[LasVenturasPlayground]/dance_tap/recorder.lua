local initialTick
local record = {}

addCommandHandler ( "record",
	function ( cmd, timeMS )
		timeMS = math.max(math.ceil(timeMS),1000)
		outputChatBox "Prepare to record..."
		setTimer ( prepareRecord, 1000, 1, timeMS )
	end
)

function prepareRecord ( timeMS )
	timeMS = timeMS - 1000
	if timeMS == 0 then
		outputChatBox "GO"
		startRecorder()
	else
		outputChatBox ( "Countdown: "..tostring(timeMS) )
		setTimer ( prepareRecord, 1000, 1, timeMS )
	end
end

function startRecorder()
	initialTick = getTickCount()
	record = {}
	bindKey ( "forwards", "down", keyPress )
	bindKey ( "backwards", "down", keyPress )
	bindKey ( "left", "down", keyPress )
	bindKey ( "right", "down", keyPress )
end


function keyPress ( key )
	table.insert ( record, { key=key, tick=(getTickCount() - initialTick) } )
end

addCommandHandler ( "stoprec",
	function ()
		unbindKey ( "forwards", "down", keyPress )
		unbindKey ( "backwards", "down", keyPress )
		unbindKey ( "left", "down", keyPress )
		unbindKey ( "right", "down", keyPress )
		outputChatBox "Stopping record"
		--Dump to xml
		local xml = xmlCreateFile ( "record.xml", "record" )
		for i,pressInfo in pairs(record) do
			outputChatBox ( "Adding "..tostring(pressInfo.tick)..", "..tostring(pressInfo.key) )
			local press = xmlCreateChild ( xml, "press" )
			xmlNodeSetAttribute ( press, "key", pressInfo.key )
			xmlNodeSetAttribute ( press, "tick", pressInfo.tick )
		end
		outputChatBox(tostring(xmlSaveFile ( xml )))
	end
)