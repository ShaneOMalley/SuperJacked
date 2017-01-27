-- import statements
local composer = require( "composer" )
local player = require( "player" )
local player1Status = require( "player1Status" )
local player2Status = require( "player2Status" )
local splash = require( "splash" )

local levelEntityFloatingIsland = require( "levelEntityFloatingIsland" )
local levelEntityFloat = require( "levelEntityFloat" )

-- initialize this scene
local scene = composer.newScene()
local bgCherryTree = require( "bgCherryTree" )
local bgCherrySky = require( "bgCherrySky" )
local bgCherryClouds = require( "bgCherryClouds" )
local bgLeaves = require("bgLeaves")

-- the respawn points for the players
scene.spawnPoints = {
	{x = 200, y = -300},
	{x = 1166, y = -300},
}

-- a table which will contain all entities, backgroud and foreground
local players = {}
local hudElements = {}
local entities = {}

-- this will be true if the update() function is added to the Runtime event listener
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

	-- update all the entities, if they have an update() function
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
	
	local sky = bgCherrySky:new()
	sky.img.x = 0
	sky.img.y = -sky.img.height + 768
	sceneGroup:insert(sky.img)
	entities[#entities + 1] = sky
	
	local cl1 = bgCherryClouds:new()
	cl1.img.x = 0
	cl1.img.y = 683
	sceneGroup:insert(cl1.img)
	entities[#entities + 1] = cl1
	
	local cl2 = bgCherryClouds:new()
	cl2.img.x = 1150
	cl2.img.y = 450
	sceneGroup:insert(cl2.img)
	entities[#entities + 1] = cl2
	
	local cl3 = bgCherryClouds:new()
	cl3.img.x = 900
	cl3.img.y = 570
	sceneGroup:insert(cl3.img)
	entities[#entities + 1] = cl3
	
	local cl4 = bgCherryClouds:new()
	cl4.img.x = 500
	cl4.img.y = 400
	sceneGroup:insert(cl4.img)
	entities[#entities + 1] = cl4
	
	for i = 1,50 do
		local leaves = bgLeaves:new()
		leaves.spawnX = (math.random() * 683) + 310
		leaves.spawnY = (math.random() * 200) + 200
		leaves:respawn()
		sceneGroup:insert(leaves.img)
		entities[#entities + 1] = leaves
		leaves:update()
	end
	
	local tree = bgCherryTree:new()
	tree.img.x = 670
	tree.img.y = 400
	sceneGroup:insert(tree.img)
	entities[#entities + 1] = tree
	
	
	local fi = levelEntityFloat:new ()
	fi:setPositionAndBounds( {x = 80, y = 450, width = 360, height = 128}, {x = 0, y = 10, width = 360, height = 10} )
	Yscale = -1
	sceneGroup:insert(fi.img)
	entities[#entities + 1] = fi

	local fi1 = levelEntityFloat:new ()
	fi1:setPositionAndBounds( {x = 900, y = 450, width = 360, height = 128}, {x = 0, y = 10, width = 360, height = 10} )
	sceneGroup:insert(fi1.img)
	entities[#entities + 1] = fi1

	local fi2 = levelEntityFloatingIsland:new ()
	fi2:setPositionAndBounds( {x = 140, y = 580, width = 1080, height = 450}, {x = 0, y = 40, width = 1080, height = 10} )
	sceneGroup:insert(fi2.img)
	entities[#entities + 1] = fi2

	local players = {}

	for i,v in ipairs(self.spawnPoints) do
		-- create the player
		local p = player:new({spawnPoint = {x = v.x, y = v.y}, num = i})
		p.num = i
		p:addToDisplayGroup( sceneGroup )
		p.device = gamePads[i]
		entities[#entities + 1] = p
		players[#players + 1] = p
	end

	local ps1 = player1Status:new{ player = players[1], x = 8 }
	ps1:addToDisplayGroup(sceneGroup)
	hudElements[#hudElements + 1] = ps1

	local ps2 = player2Status:new{ player = players[2], x = 1366 - 382 - 8}
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