local composer = require ("composer")
local scene = composer.newScene()

local function changeScenes(event)
--	event.device.descriptor
	if event.keyName == "b" then
		composer.gotoScene("quit", {effect = "fade", time = 300})
	elseif event.keyName == "x" then
		composer.gotoScene("controls", {effect = "fade", time = 300})
	elseif event.keyName == "a" then
		composer.gotoScene("stageSelect", {effect = "fade", time = 300})
	end
end

local title
local buck
local finn
local controlsButton
local quitButton
local playButton

function scene:create(event)
	local sceneGroup = self.view
	
	local background = display.newImage("backgrounds/credits.png")
	background.anchorX = 0
	background.anchorY = 0
	background.width = 1366
	background.height = 768
	sceneGroup:insert( background )
end

function scene:show(event)
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
	local sceneGroup = self.view

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )



return scene