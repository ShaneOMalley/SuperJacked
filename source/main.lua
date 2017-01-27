-- the main module
-- import statements
-- turn on nearest neighbour filtering before loading images
display.setDefault( "magTextureFilter", "nearest" )

-- import statements
local composer = require( "composer" )
local input = require( "input" )
local sprites = require( "sprites" )
local player = require( "player" )
local audio = require( "audio" )
local sounds = require( "sounds" )

-- set the app to be full screen
native.setProperty("windowMode", "fullscreen")

-- global variables
-- set this to true when you want to reset the scene
resetScene = false

-- set this to true when the game is over
gameOverStart = false
gameOver = false

-- set this to the number of the player who won
winner = -1

-- these booleans will represent whether each player is jacked or not (use this for the congrats screen)
p1IsJacked = false
p2IsJacked = false

-- this is the level number currently being played
levelNumber = -1

-- this will hold the gamepads in use
gamePads = {}

local function arrayContains (ar, v)
	for i = 1,#ar do
		if ar[i] == v then return true end
	end
	return false
end

local function onInput (event)

	if not event.device then return end

	if string.sub(event.device.descriptor, 1, 7) then
		if not arrayContains(gamePads, event.device.descriptor) then
			gamePads[#gamePads + 1] = event.device.descriptor
		end
	end

end

Runtime:addEventListener( "key", onInput )
Runtime:addEventListener( "axis", onInput )

-- function which handles key events and stores whether the key is down
-- in input.keyState for later polling
local function onKeyEvent (event)
	
	if event.keyName == "p" and event.phase == "down" then
		resetScene = true
	end

	-- set the device's name
	local device
	if event.device then device = event.device.descriptor
	else device = "none" end

	-- display which key has been pressed, and on which device
	if event.phase == "down" then
		print(event.keyName .. " pressed on device: <" .. device .. ">")
	end

	-- set up the table for the device if nil
	if not input.keyState[ device ] then
		input.keyState[ device ] = {}
	end

	-- set the key to be either down or up
	-- if the key is pressed
	if event.phase == "down" then
		if device then
			input.keyState[ device ][ event.keyName ] = true
		end
	-- if the key is de-pressed
	elseif event.phase == "up" then
		if device then
			input.keyState[ device ][ event.keyName ] = false
		end
	end

end
-- add 'onKeyEvent' as an event listener
Runtime:addEventListener("key", onKeyEvent)

-- this function will handle axisEvents, and 
-- turn analog axis values into "on or off"  keypresses
local function onAxisEvent( event )

	-- if a table for the device has not been set up yet, set it up
	if not input.keyState[ event.device.descriptor ] then
		input.keyState[ event.device.descriptor ] = {}
	end

	-- a string which represents the device
	local device = event.device.descriptor

	-- the value of the axis in the range [-1.0, 1.0]
	local value = event.normalizedValue

	-- a string which will represent the axis
	local axis = "axis" .. tostring(event.axis.number)

	-- set the states of the axis as 'keys' for both positive and negative
	if event.normalizedValue > 0.4 then
		input.keyState[ device ][ axis .. "positive" ] = true
		input.keyState[ device ][ axis .. "negative" ] = false
	elseif event.normalizedValue < -0.4 then
		input.keyState[ device ][ axis .. "positive" ] = false
		input.keyState[ device ][ axis .. "negative" ] = true		
	else
		input.keyState[ device ][ axis .. "positive" ] = false
		input.keyState[ device ][ axis .. "negative" ] = false
	end

end
-- add 'onAxisEvent' as an event listener
Runtime:addEventListener("axis", onAxisEvent)

-- start by going to the menu screen
composer.gotoScene( "stage1" )

-- play the menu music and set the volume
audio.play( sounds.menu, {channel = 1, loops = -1} )
audio.setVolume( 0.3, {channel = 1} )