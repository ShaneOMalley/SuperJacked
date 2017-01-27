local composer = require ("composer")
local scene = composer.newScene()

local function changeScenes(event)

	-- only handle inputs from player 1
	if not (event.device and event.device.descriptor == gamePads[1]) then return end

	if event.keyName == "buttonB" then
		composer.gotoScene("stage1", {effect = "fade", time = 300})
	end
end

function scene:create(event)
	
	local sceneGroup = self.view
	
	local background = display.newImage("backgrounds/controls.png")
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