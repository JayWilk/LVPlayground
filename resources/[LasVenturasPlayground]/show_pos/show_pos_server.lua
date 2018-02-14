local eof = nil

function saveCoords( x, y, z, rot, comment )
    local fhnd = nil
    if fileOpen( "saved_coords.txt" ) then
        fhnd = fileOpen( "saved_coords.txt" )
        eof = fileGetSize( fhnd )
        fileSetPos( fhnd, eof )
    else
        fhnd = fileCreate( "saved_coords.txt" )
    end
    local str = tostring( x ) .. ", " .. tostring( y ) .. ", " .. tostring( z ) .. ", " .. tostring( rot ) .. " ";
    if string.len( comment ) > 0 then
        str = str .. "// ".. comment
    end
    str = str .. "\r\n"
    eof = fileWrite( fhnd, str )
    fileSetPos( fhnd, eof )
    fileClose( fhnd )
    outputChatBox( "Position saved...", source )
end

function savePos( player, command, ... )
	outputChatBox("Saved.", player)
    local _x, _y, _z = getElementPosition( player )
    local _rot = getElementRotation( player )
    local comment = table.concat( arg, " " )
    saveCoords( _x, _y, _z, _rot, comment )
end
addCommandHandler( "save", savePos )

-- Define our function that will handle this command
function consoleCreateMarker ( playerSource )
	-- If a player triggered it (rather than the admin) then
	if ( playerSource ) then
		-- Get that player's position
		local x, y, z = getElementPosition ( playerSource )
		-- Create a size 2, red checkpoint marker at their position
		createMarker ( x, y, z, "checkpoint", 2, 255, 0, 0, 255 )
		-- Output it in his chat box
		outputChatBox ( "You got a red marker", playerSource )
	end
end
-- Attach the 'consoleCreateMarker' function to the "createmarker" command
addCommandHandler ( "createmarker", consoleCreateMarker )


function displayLoadedRes ( res )
	outputChatBox ( "Resource " .. getResourceName(res) .. " loaded", getRootElement(), 255, 255, 255 )
end
addEventHandler ( "onResourceStart", getRootElement(), displayLoadedRes )