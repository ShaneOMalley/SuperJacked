local composer = require( "composer" )
local sounds = require( "sounds" )
local celebratingPlayer = require( "celebratingPlayer" )

local scene = composer.newScene()

local player

local function update ()

	for k,v in pairs(player) do print(k, v) end

	if player.update then
		player:update ()
	end

	print("ss")
end

local function onKeyEvent (event)
	if event.device and event.device.descriptor == gamePads[1] then
		if event.phase == "down" then

			if event.keyName == "buttonB" then
				-- stop the battle music
				audio.stop(1)
				-- play the menu music
				audio.play( sounds.menu, {channel = 1, loops = -1} )
				-- go to the stage select screen
				composer.gotoScene( "stage1", {effect = "fade", time = 300} )

			elseif event.keyName == "buttonY" then
				-- stop the battle music
				audio.stop(1)
				-- play the battle music again from the beginning
				audio.play( sounds.battle_start, { channel = 1, onComplete = function () 
					audio.play( sounds.battle_end, { loops = -1 } ) end } )
				-- replay the current level
				if levelNumber == 1 then
					composer.gotoScene( "testLevel", {effect = "fade", time = 300} )
				elseif levelNumber == 2 then
					composer.gotoScene( "cherryTree", {effect = "fade", time = 300} )
				elseif levelNumber == 3 then
					composer.gotoScene( "deadTree", {effect = "fade", time = 300})
				end
			end

		end
	end
end

function scene:create (event)
	
	local sceneGroup = self.view
	
	local background = display.newImage( "backgrounds/congratulations.png")
	background.anchorX = 0
	background.anchorY = 0
	background.width = 1366
	background.height = 768
	sceneGroup:insert( background )

end

function scene:show (event)
	
	local sceneGroup = self.view

	if event.phase == "will" then
		player = celebratingPlayer:new()
		player.img.x = 1366 * 0.5
		player.img.y = 768 * 0.5
		sceneGroup:insert( player.img )

	elseif event.phase == "did" then
		Runtime:addEventListener( "key", onKeyEvent )
		Runtime:addEventListener( "enterFrame", update )
	end
end

function scene:hide (event)

	local sceneGroup = self.view

	if event.phase == "will" then
		Runtime:removeEventListener( "key", onKeyEvent )
		Runtime:removeEventListener( "enterFrame", update )
	elseif event.phase == "did" then
		sceneGroup:remove( player.img )
	end
end

function scene:destroy (event)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene