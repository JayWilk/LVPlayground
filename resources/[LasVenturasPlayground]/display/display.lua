
function configureDisplay()
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
	
	guiCreateStaticImage(0.05, 0.55, 0.19, 0.12, "img/lvp_logo.png", true)  
end

addEventHandler("onClientResourceStart", resourceRoot,configureDisplay)
addEventHandler ( "onPlayerJoin", resourceRoot, configureDisplay)
