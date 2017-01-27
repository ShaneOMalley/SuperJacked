-- import statements
local composer = require( "composer" )
local player = require( "player" )
local player1Status = require( "player1Status" )
local player2Status = require( "player2Status" )
local splash = require( "splash" )

--local levelEntityFloatingIsland = require( "levelEntityFloatingIsland" )
local levelEntityFloat = require( "levelEntityFloat" )

local bgSun = require( "bgSun" )
local bgHills = require( "bgHills" )
local bgSky = require( "bgSky" )
local bgStar = require( "bgStar" )
local bgTree = require( "bgTree" )

local scene = composer.newScene()

local name = "testLevel"

-- the respawn points for the players
scene.spawnPoints = {
	{x = 200, y = -300},
	{x = 1166, y = -300},
}

local players = {}
local hudElements = {}
local entities = {}

-- this will be true it the update() function is added to the Runtime event listener
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

	-- update all the players
	--[[
	for i=1,#players do
		players[i]:update(entities)
	end
	--]]

	---[[

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

	--]]

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

function scene:create (event)

	-- the displayGroup to add images into
	local sceneGroup = self.view
	local sky = bgSky:new()
	sky.img.x = 0
	sky.img.y = -sky.img.height + 768
	sceneGroup:insert(sky.img)
	entities[#entities + 1] = sky
	
	for i = 1,150 do
		local star = bgStar:new()
		star.img.x = math.random() * 1366
		star.img.y =  math.random() * 768
		sceneGroup:insert(star.img)
		entities[#entities + 1] = star
	end
	
	local sun = bgSun:new()
	sun.img.x = 300
	sun.img.y = 100
	sceneGroup:insert(sun.img)
	entities[#entities + 1] = sun
	
	local hills = bgHills:new()
	hills.img.x = 0
	hills.img.y = 0
	sceneGroup:insert(hills.img)
	entities[#entities + 1] = hills
	--[
	local tree = bgTree:new()
	tree.img.x = 670
	tree.img.y = 400
	sceneGroup:insert(tree.img)
	entities[#entities + 1] = tree
	--]]

	-- add terrain to the scene

	local fi = levelEntityFloat:new ()
	fi:setPositionAndBounds( {x = 80, y = 450, width = 360, height = 128}, {x = 0, y = 10, width = 360, height = 10} )
	sceneGroup:insert(fi.img)
	entities[#entities + 1] = fi

	local fi1 = levelEntityFloat:new ()
	fi1:setPositionAndBounds( {x = 900, y = 450, width = 360, height = 128}, {x = 0, y = 10, width = 360, height = 10} )
	sceneGroup:insert(fi1.img)
	entities[#entities + 1] = fi1

	local fi2 = levelEntityFloat:new ()
	fi2:setPositionAndBounds( {x = 140, y = 580, width = 1080, height = 384}, {x = 0, y = 40, width = 1080, height = 10} )
	sceneGroup:insert(fi2.img)
	entities[#entities + 1] = fi2

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

	--[[
	for i = 1,#players do
		-- create a playerStatus gui element
		local ps = player1Status:new{ player = players[i], x = ( i - 1 ) * ( 1366 - 400 ) }
		ps:addToDisplayGroup(sceneGroup)
		hudElements[#hudElements + 1] = ps
	end
	--]]

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

function scene:show (event)

	if event.phase == "will" then

	elseif event.phase == "did" then
		if not updating then
			Runtime:addEventListener( "enterFrame", update )
			updating = true
		end
	end

end

function scene:hide (event)
	
	if event.phase == "will" then
		if updating then
			Runtime:removeEventListener( "enterFrame", update )
			updating = false
		end
	elseif event.phase == "did" then

	end

end	

function scene:destroy (event)

	local sceneGroup = self.view

	for i = 1,#hudElements do
		hudElements[i]:removeFromDisplayGroup(sceneGroup)
	end

	for i = 1,#entities do
		entities[i]:removeFromDisplayGroup(sceneGroup)
	end

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene