local tutorialDimension = 0 -- todo: manage settings


addEvent("onClientRequestStartRampingSchoolChallengeTutorial")
addEventHandler("onClientRequestStartRampingSchoolChallengeTutorial", localPlayer,
	function()
		fadeCamera(false)
		

		
		
		setTimer(function()
			showRampingChallengeTutorialSkipDialog()
		end, 2000, 1)
	end 
)

addEvent("onClientStartRampingSchoolChallengeTutorial")
addEventHandler("onClientStartRampingSchoolChallengeTutorial", localPlayer,
	function()
		iprint("tutorial starting!")
		fadeCamera(true)
		setElementDimension(localPlayer, tutorialDimension)
	end 
)



addEvent("onClientFinishRampingSchoolChallengeTutorial")
addEventHandler("onClientFinishRampingSchoolChallengeTutorial", localPlayer,
	function()
		iprint("tutorial finished!")
		fadeCamera(true)
		triggerEvent("onClientPrepareToBeginRampingChallenge", localPlayer)
	end 
)

addEvent("onClientSkipRampingSchoolChallengeTutorial")
addEventHandler("onClientSkipRampingSchoolChallengeTutorial", localPlayer,
	function()
		hideRampingChallengeTutorialSkipDialog()
		iprint("tutorial skipped!")	
		fadeCamera(true)
		triggerEvent("onClientPrepareToBeginRampingChallenge", localPlayer)
	end 
)


