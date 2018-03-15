local sx,sy = guiGetScreenSize( )

hintBox = { }

function createHintBoxClient( x, y, text, time, textColour, boxColour, scale, font, border )
	if x and y then
		playSFX("genrl", 52, 14, false)
		if hintBox.timer and isTimer( hintBox.timer ) then
			killTimer( hintBox.timer )
		end
		hintBox = { }   
		if not text then text = "" end
		if not scale then scale = 2 end
		if not time then time = 8000 end
		if not font then font = "default-bold" end
		if not textColour then textColour = {r = 170, g = 168, b = 162, a = 230} end
		if not boxColour then boxColour = {r = 0, g = 0, b = 0, a = 180} end
		if not border then border = 5 end       
		text = text:gsub("  "," ")
		text = text:gsub(" ","  ")
		text = text:gsub("\\n","\n")
		text = text:gsub("\n","  ")
		text = text:gsub("\r","")
		hintBox.text = escape(text)
		if text:find('<p>',1,true) then
			local s,e = text:find('<p>',1,true)
			hintBox.pages = text:sub(e+1)
			hintBox.text = text:sub(1,s-1)
		end		
		hintBox.width = 250      
		local lines = {}   
		if type(x) == "string" then
			local calculation = tostring(string.gsub(x,"sx",tostring(sx)))
			_,x = pcall(loadstring("return "..calculation))
		end      
		if type(y) == "string" then
			local calculation = tostring(string.gsub(y,"sy",tostring(sy)))
			_,y = pcall(loadstring("return "..calculation))        
		end
		hintBox.border = border
		hintBox.height, lines = dxGetTextHeight(250,hintBox.text,scale,font,true)
		hintBox.x = x
		hintBox.y = y
		hintBox.textColour = textColour
		hintBox.boxColour = boxColour
		hintBox.scale = scale
		hintBox.font = font
		hintBox.time = time
		hintBox.text = ""
		for i,v in pairs(lines) do
			hintBox.text = hintBox.text .. v .. "\n"
		end    

		hintBox.timer = setTimer(
			function() 
				if hintBox.pages then
					createHintBoxClient( hintBox.x, hintBox.y, hintBox.pages, hintBox.time, hintBox.textColour, hintBox.boxColour, hintBox.scale, hintBox.font, hintBox.border )
				else
					hintBox = {} 
				end
			end, 
		time, 1)
	end
end
addEvent( "createHintBoxClient", true )
addEventHandler( "createHintBoxClient", root, createHintBoxClient )

addEvent( 'clientHintBox', true )
addEventHandler( 'clientHintBox', localPlayer,
    function( ... )
	    createHintBoxClient(20,"(sy/6)*2",table.concat({...}," "),7000)	
	end
)


addEventHandler( "onClientRender", root, 
    function( )
		if hintBox.x then
			dxDrawRectangle(hintBox.x-hintBox.border,hintBox.y-hintBox.border,hintBox.width+(hintBox.border*2),hintBox.height+(hintBox.border*2),tocolor(hintBox.boxColour.r,hintBox.boxColour.g,hintBox.boxColour.b,hintBox.boxColour.a),true,false)
			dxDrawText(hintBox.text,hintBox.x,hintBox.y,hintBox.x+hintBox.width,hintBox.y+hintBox.height,tocolor(hintBox.textColour.r,hintBox.textColour.g,hintBox.textColour.b,hintBox.textColour.a),hintBox.scale,hintBox.font,"left","top",false,false,true)
		end
	end
)

function escape(text)
	text = text:gsub("%%","%%%%")
	return text
end

function dxGetTextHeight(width,text,scale,font,doubleSpaced)
	local textTable = split(text,string.byte(' '))
	local breaks = {}
	local length = 0
	local line = ""
	local space = doubleSpaced and '  ' or ' '
	for i = #textTable, 1, -1 do
		if textTable[i] == '' then table.remove(textTable,i) end
	end
	for i,word in pairs(textTable) do
		if i ~= #textTable then
			textTable[i] = word .. space
		end
	end
	for index,word in pairs(textTable) do
		if word ~= "." then
			local s,e = word:find(".",0,true)
			if s and e then
				textTable[index] = word:sub(0,s-1)
				table.insert(textTable,index+1,".")
				table.insert(textTable,index+2,word:sub(e+1))
			end
		end
	end	
	for index,word in pairs(textTable) do
		if word ~= "," then
			local s,e = word:find(",",0,true)
			if s and e then
				textTable[index] = word:sub(0,s-1)
				table.insert(textTable,index+1,",")
				table.insert(textTable,index+2,word:sub(e+1))
			end
		end
	end	
	
	for index,word in pairs(textTable) do
		if word ~= "-" then
			local s,e = word:find("-",0,true)
			if s and e then
				textTable[index] = word:sub(0,s-1)
				table.insert(textTable,index+1,"-")
				table.insert(textTable,index+2,word:sub(e+1))
			end
		end
	end
	for index,word in pairs(textTable) do
		if word ~= "|" then
			local s,e = word:find("|",0,true)
			if s and e then
				textTable[index] = word:sub(0,s-1)
				table.insert(textTable,index+1,"|")
				table.insert(textTable,index+2,word:sub(e+1))
			end
		end
	end	
	local index = 1
	while textTable[index] do
		local word = textTable[index]
		length = length + dxGetTextWidth(word,scale,font)
		if length > width then		
			if dxGetTextWidth(word,scale,font) > width then
				local currentLength = length - dxGetTextWidth(word,scale,font)
				local count = 0
				repeat
					count = count + 1
					length = currentLength + dxGetTextWidth(word:sub(0,-count),scale,font)
				until length < width
				local wordsection = word:sub(0,-count)
				textTable[index] = wordsection
				table.insert(textTable,index+1,word:sub(-count+1))
				table.insert(breaks,index)
				length = 0	
			else
				table.insert(breaks,index-1)
				length = dxGetTextWidth(word,scale,font)
			end
		end
		if index == #textTable then
			table.insert(breaks,index)
		end
		index = index + 1
	end
	local lines = {}
	for index,breakpoint in pairs(breaks) do
		lines[index] = ""
		for i = (index == 1 and 1 or breaks[index-1]+1), breakpoint do
			lines[index] = lines[index] .. textTable[i] --[[.. "@"]]
		end
		lines[index] = lines[index]:gsub("^[%s]*","")
	end
	local height = (dxGetFontHeight(scale,font) * #breaks) --[[+ (8 * #breaks-1)]]
	return height,lines
end