bRadioEnabled = true

function toggleStreamRadio(enable)
	bRadioEnabled = enable 
	
	if(not enable) then 
		stopStreamRadio()
	end
	
end 

function isStreamRadioEnabled()
	return bRadioEnabled
end 