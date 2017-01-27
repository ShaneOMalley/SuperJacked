-- import statements
local composer = require( "composer" )
local player = require( "player" )
local player1Status = require( "player1Status" )
local player2Status = require( "player2Status" )
local splash = require( "splash" )
local levelEntityDeadFloat = require( "levelEntityDeadFloat" )

-- initialize this scene
local scene = composer.newScene()
local bgDeadTree = require( "bgDeadTree" )
local bgDeadSky = require( "bgDeadSky" )
local bgBird = require( "bgBird" )

-- tables to store players, hud elements and entities
local players = {}
local hudElements = {}
local entities = {}

local birdPositions = {
	{x = 870, y = 184},{x = 830, y = 184},{x = 900, y = 84},{x = 956, y = 122},{x = 838, y = 68},{x = 925, y = 200},{x = 815, y = 270},{x = 838, y = 68},{x = 925, y = 200},{x = 790, y = 200},{x = 790, y = 30},{x = 735, y = 165}
	,{x = 460, y = 174},{x = 510, y = 168},{x = 550, y = 174},{x = 590, y = 174},{x = 585, y = 50},{x = 515, y = 50},{x = 490, y = 65},{x = 485, y = 100},{x = 620, y = 35},{x = 655, y = 20},{x = 690, y = 35},{x = 730, y = 35},{x = 600, y = 230},{x = 630, y = 330},{x = 590, y = 320},{x = 550, y = 310},{x = 510, y = 280},{x = 470, y = 290},{x = 450, y = 255},{x = 440, y = 310},{x = 490, y = 250},{x = 490, y = 170},{x = 570, y = 170},{x = 520, y = 170},{x = 535, y = 170},{x = 535, y = 100},{x = 555, y = 75},{x = 550, y = 25},{x = 600, y = 125},{x = 630, y = 125},
}

-- the respawn points for the players
scene.spawnPoints = {
	{x = 200, y = -300},
	{x = 1166, y = -300},
}

-- this will be true if the updae() function is added to the Runtime event listener
local udpating = false

-- use this function to reset the scene to its original stata
local function reset ()

	for _, entity in ipairs(entities) do
		if entity.reset then entity:reset() end
	end

	for _, hudElement in ipairs(hudElements) do
		if hudElement.reset then hudElement:reset() end
	end

	-- reset global variables
	gameOver = false
	gameOverStart = false
	winner = -1

	p1IsJacked = false
	p2IsJacked = false

	resetScene = false

end

-- call this funtion every frame, use it to update entities
local function update ()

	-- if it is game over, go to next scene after some time
	if gameOverStart then
		timer.performWithDelay( 1000, function () 
			composer.gotoScene( "congratulations", {effect = "fade", time = 300} ) 
			resetScene = true
--			gameOver = true
			end )
		gameOverStart = false
	end

	if resetScene then
		reset()
	end

	if not updating then return end

	-- update all the hud elements
	for i = 1,#hudElements do
		if hudElements[i].update then
			hudElements[i]:update()
		end
	end

	-- update all the entities
	for i = 1,#entities do
		if entities[i].update then
			entities[i]:update(entities)
		end
	end

end

-- this will be called when the scene is created
function scene:create (event)

	local sceneGroup = self.view

	-- initialize a template entity, add its 'img' to the sceneGroup,
	-- and add it to the level's 'entities' table
	
	local sky = bgDeadSky:new()
	sky.img.x = 0
	sky.img.y = -sky.img.height + 768
	sceneGroup:insert(sky.img)
	entities[#entities + 1] = sky
	
	local tree = bgDeadTree:new()
	tree.img.x = 722
	tree.img.y = 220
	sceneGroup:insert(tree.img)
	entities[#entities + 1] = tree
	

	for _, pos in ipairs(birdPositions) do
		local bird = bgBird:new()
		bird.spawnY = pos.y
		bird.img.x = pos.x
		bird.img.y = pos.y
		sceneGroup:insert(bird.img)
		entities[#entities + 1] = bird	
	end
	
	local fi = levelEntityDeadFloat:new ()
	fi:setPositionAndBounds( {x = 80, y = 350, width = 360, height = 128}, {x = 0, y = 10, width = 360, height = 10} )
	sceneGroup:insert(fi.img)
	entities[#entities + 1] = fi

	local fi1 = levelEntityDeadFloat:new ()
	fi1:setPositionAndBounds( {x = 900, y = 350, width = 360, height = 128}, {x = 0, y = 10, width = 360, height = 10} )
	sceneGroup:insert(fi1.img)
	entities[#entities + 1] = fi1

	local fi2 = levelEntityDeadFloat:new ()
	fi2:setPositionAndBounds( {x = 140, y = 480, width = 1080, height = 384}, {x = 0, y = 40, width = 1080, height = 10} )
	sceneGroup:insert(fi2.img)
	entities[#entities + 1] = fi2

	-- spawn players
	for i,v in ipairs(self.spawnPoints) do
		-- create the player
		local p = player:new({spawnPoint = {x = v.x, y = v.y}, num = i})
		p.num = i
		p:addToDisplayGroup( sceneGroup )
		p.device = gamePads[i]
--		if i == 1 then p.isJacked = true end
		entities[#entities + 1] = p
		players[#players + 1] = p
	end

	-- create a playerStatus gui elements for each of the players
	local ps1 = player1Status:new{ player = players[1], x = 8 }
	ps1:addToDisplayGroup(sceneGroup)
	hudElements[#hudElements + 1] = ps1

	local ps2 = player2Status:new{ player = players[2], x = 1366 - 382 - 8 }
	ps2:addToDisplayGroup(sceneGroup)
	hudElements[#hudElements + 1] = ps2

	local sp = splash:new();
	sp:addToDisplayGroup( sceneGroup )
	entities[#entities + 1] = sp

	reset()

end

-- this will be called when the scene is shown
function scene:show (event)

	if event.phase == "will" then

	elseif event.phase == "did" then
		if not updating then
			Runtime:addEventListener( "enterFrame", update )
			updating = true
		end
	end

end

-- this will be called when the scene is hidden
function scene:hide (event)
	
	if event.phase == "will" then
		if updating then
			Runtime:removeEventListener( "enterFrame", update )
			updating = false
		end
	elseif event.phase == "did" then

	end

end	

-- this will be called when the scene is destroyed
function scene:destroy (event)

	local sceneGroup = self.view

	for i = 1,#entities do
		entities[i]:removeFromDisplayGroup(sceneGroup)
	end

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene