local tutorialDimension = 0 -- todo: manage settings


-- Client is requesting a tutorial, see if they wish to skip first
addEvent("onClientRequestStartRampingSchoolChallengeTutorial")
addEventHandler("onClientRequestStartRampingSchoolChallengeTutorial", localPlayer,
	function()
		fadeCamera(false)
		setTimer(function()
			showRampingChallengeTutorialSkipDialog()
		end, 2000, 1)
	end 
)

-- Client wishes to skip the tutorial - proceed to begin the ramping challenge
addEvent("onClientSkipRampingSchoolChallengeTutorial")
addEventHandler("onClientSkipRampingSchoolChallengeTutorial", localPlayer,
	function()
		hideRampingChallengeTutorialSkipDialog()
		fadeCamera(true)
		triggerEvent("onClientPrepareToBeginRampingChallenge", localPlayer)
	end 
)



addEvent("onClientStartRampingSchoolChallengeTutorial")
addEventHandler("onClientStartRampingSchoolChallengeTutorial", localPlayer,
	function()
		iprint("tutorial starting!")
		fadeCamera(true)
		setElementDimension(localPlayer, tutorialDimension)
		
		-- todo: tutorial
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


