local sprites = require( "sprites" )

local splash = {}

-- img for rendering the hud element
splash.img = nil

-- add this listener to the player's sprite
local function spriteListener (event)

	if event.phase == "ended" then
		event.target:setFillColor( 1, 1, 1, 0 )
	else
		event.target:setFillColor( 1, 1, 1, 1 )
	end

end

-- create and return an instance of splash
function splash:new (o)

	-- create a new instance of splash by seting 'o's metatable
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	o.img = display.newSprite( sprites.splashSpriteSheet, sprites.splashSequences );
	o.img:addEventListener( "sprite", spriteListener )

	o.img:setSequence( "fight" );
	o.img:play();

	o.img.x = 1366 / 2;
	o.img.y = 768 / 2;

	-- return the instance
	return o
end

-- add all the img's to the argument displayGroup
function splash:addToDisplayGroup (group)

	group:insert( self.img )

end

-- remove all the img's from the argument displayGroup
function splash:removeFromDisplayGroup (group)

	group:remove( self.img )

end

function splash:update ()

	if gameOver then
		self.img:setSequence( "p" .. winner .. "Wins" )
		self.img:play()

	else
--		self.img:setSequence( "blank" )
	end

end

function splash:reset ()
	self.img:setSequence( "fight" )
	self.img:play()
end

return splash