local composer = require ("composer")
local sounds = require( "sounds" )

local scene = composer.newScene()

---[[
local function onKeyEvent (event)

	if not (event.device and event.device.descriptor == gamePads[1]) then return end

	local gotoLevel = "none"

	if event.keyName == "buttonB" then
		composer.gotoScene("stage1", {effect = "fade", time = 300})

	elseif event.keyName == "buttonX" then
		levelNumber = 1
		gotoLevel = "testLevel"

	elseif event.keyName == "buttonY" then
		levelNumber = 2
		gotoLevel = "cherryTree"

	elseif event.keyName == "buttonA" then
		levelNumber = 3
		gotoLevel = "deadTree"

	end

	-- if the player is going to one of the game's levels
	if gotoLevel ~= "none" then
		-- stop the current music (the menu music)
		audio.stop(1)
		-- play the intro to the battle music, followed by the main loop of the music
		audio.play( sounds.battle_start, { channel = 1, onComplete = function () 
			audio.play( sounds.battle_end, { loops = -1 } ) end } )
		-- go to the level
		composer.gotoScene( gotoLevel, {effect = "fade", time = 300})
	end

end
--]]

--[[
local function onKeyEvent(event)
	local keyName = event.keyName
	local phase = event.phase
if (not joystickInUse) then
		
	if ("down" == phase) then
		if(keyUp == keyName)then
			display.remove(yellow)
		elseif(keyLeft == keyName)then
			display.remove(yellow)
		elseif(keyRight == keyName)then
			display.remove(yellow)
		end
	elseif("up" == phase)then
		if(keyUp == keyName)then
			yellow = display.newImage("yellow.png")
			yellow.x = display.contentWidth / 2
			yellow.y = display.contentWidth / 5
			Runtime:addEventListener("key", goToLevel1)
			
		elseif(keyLeft == keyName)then
			yellow = display.newImage("yellow.png")
			yellow.x = display.contentWidth / 15
			yellow.y = display.contentWidth / 1.7
			Runtime:addEventListener("key", goToLevel2)
			
		elseif(keyRight == keyName)then
			yellow = display.newImage("yellow.png")
			yellow.x = display.contentWidth / 1.07
			yellow.y = display.contentWidth / 1.7
			Runtime:addEventListener("key", goToLevel3)
			
		end
	end
end
end
--]]
			
	
function scene:create(event)
	local sceneGroup = self.view
	
	local background = display.newImage("backgrounds/levelSelect.png")
	background.anchorX = 0
	background.anchorY = 0
	background.width = 1366
	background.height = 768
	sceneGroup:insert( background )

end

function scene:show(event)
	gameOver = false

	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
	
	elseif(phase == "did") then
		Runtime:addEventListener("key", onKeyEvent)
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then
		Runtime:removeEventListener("key", onKeyEvent)
	
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