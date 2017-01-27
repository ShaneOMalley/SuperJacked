local sprites = require( "sprites" )

-- the 'templateEntity' module
local bgStar = {}

-- the img associated with the entity
bgStar.img = nil

-- The current vertical velocity

-- specifies that the entity is a background entity
bgStar.type = "bg"

-- as long as you add this entite to the level's 'entities' table, this function will
-- be called once per frame
-- Use this function to update the entity's position etc.
bgStar.ticks = 0
bgStar.fadeFactor = 0
bgStar.fadeStart = 0

function bgStar:reset()
	self.ticks = 0
end

function bgStar:update (entities)

	local a = math.min( math.max( self.fadeFactor * (self.ticks - self.fadeStart), 0), 1)
	self.img:setFillColor( 1, 1, 1, a )
	-- all this does so far is move one pixel to the right every, frame
	
	self.ticks = self.ticks + 1
end

-- this creates an instance of the 'templateEntity' class, initializes it, and returns it
function bgStar:new (o)

	-- create the object
	o = o or {}
	-- set the object to be an instance of 'templateEntity'
	setmetatable(o, self)
	self.__index = self
	o.img = display.newSprite( sprites.starSpriteSheet, sprites.starSequences )
	local scale = math.random(1, 3)
	o.img.xScale = scale
	o.img.yScale = scale
	
	o.img:setSequence("twinkle")

	o.img.timeScale = math.random() * 0.4 + 0.8
	o.img:play()
	o.img.width = o.img.width * 2
	o.img.height = o.img.height * 2
	
--	o.fadeFactor = 0.016 / ( 7 + 13 * math.random() )
	o.fadeFactor = 0.016 / 13
	o.fadeStart = 50*60 + 13*60 * math.random()
	
	print(o.fadeFactor)
	
	return o
end

-- make sure to have this line at the end, otherwise importing this class will not work
return bgStar