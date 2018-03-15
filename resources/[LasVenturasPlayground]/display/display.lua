local lvpLogo = guiCreateStaticImage(0.05, 0.55, 0.19, 0.12, "img/lvp_logo.png", true)  


function toggleDisplay(show)

	if show then
	
		guiSetVisible(lvpLogo, true)
		showChat(true)
		setPlayerHudComponentVisible("all", true)
		
		setPlayerHudComponentVisible ( "area_name", false )  
		setPlayerHudComponentVisible (  "vehicle_name", false ) 
		setPlayerHudComponentVisible (  "clock", false ) 
		
		setAmbientSoundEnabled( "general", false )
		setAmbientSoundEnabled( "gunfire", false )
		
		setBirdsEnabled( false )
		setCloudsEnabled( false )
		
		--setHeatHaze( 0 )
		--setBlurLevel( 0 )
		
		setWorldSpecialPropertyEnabled ( "randomfoliage", false )
		
	else
	
		guiSetVisible(lvpLogo, false)
		showChat(false)
		setPlayerHudComponentVisible("all", false)

	end 

end 


addEventHandler("onClientResourceStart", resourceRoot,
	function()
		toggleDisplay(true)
	end
)




