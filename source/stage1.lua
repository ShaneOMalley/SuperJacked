local composer = require ("composer")
local scene = composer.newScene()

local function changeScenes(event)

	-- exit the game if the escape key is pressed
	if event.keyName == "escape" then os.exit() end
	
	-- only handle inputs from player 1
	if not (event.device and event.device.descriptor == gamePads[1]) then return end

	if event.keyName == "buttonX" then
		composer.gotoScene("controls", {effect = "fade", time = 300})

	elseif event.keyName == "buttonA" then
		composer.gotoScene("stageSelect", {effect = "fade", time = 300})

	elseif event.keyName == "buttonY" then
		composer.gotoScene("credits", {effect = "fade", time = 300})

	end
end

function scene:create(event)
	local sceneGroup = self.view
	
	local background = display.newImage("backgrounds/menu.png")
	background.anchorX = 0
	background.anchorY = 0
	background.width = 1366
	background.height = 768
	sceneGroup:insert( background )
	
end

function scene:show(event)
	print("shown")
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
	
	elseif(phase == "did") then
		Runtime:addEventListener("key", changeScenes)
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		Runtime:removeEventListener("key", changeScenes)
	
	elseif (phase == "did") then
	
	end			
end

function scene:destroy(event)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene