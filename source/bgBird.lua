-- the 'templateEntity' moduleself
local  bgBird= {}
local sprites = require( "sprites" )
-- the img associated with the entity
bgBird.img = nil

-- specifies that the entity is a background entity
bgBird.type = "bg"

bgBird.spawnY = 0

-- as long as you add this entite to the level's 'entities' table, this function will
-- be called once per frame
-- Use this function to update the entity's position etc.
bgBird.ticks = 0
local xvelBase = .5
bgBird.yvel = .2
bgBird.xvel = .2
local yvelBase = .5

bgBird.flipFlop = false
function bgBird:update (entities)
	-- all this does so far is move one pixel to the right every,
	self.ticks = self.ticks + 1
	ran = (7.5 + math.random() * 2)
	if self.ticks > 10 * 60 then
		self.xvel = xvelBase * ( 1.95 + math.random() * 0.1 )
		self.yvel = yvelBase * ( 1.95 + math.random() * 0.1 )
		
		if self.img.sequence ~= "fly" then
			self.img:setSequence( "fly" )
			self.img:play()
		end
	
		if self.flipFlop == false then
		self.img.x = self.img.x + self.xvel
		self.img.y = self.img.y - self.yvel
		if self.img.y <= self.spawnY - ran then
		self.flipFlop = true
		end
	end
end	
	
	if self.flipFlop == true then
	self.img.x = self.img.x + self.xvel
	self.img.y = self.img.y + self.yvel
		if self.img.y >= self.spawnY + ran then
		self.flipFlop = false
		end
	end
end

-- this creates an instance of the 'templateEntity' class, initializes it, and returns it
function bgBird:new (o)

	-- create the object
	o = o or {}
	-- set the object to be an instance of 'templateEntity'
	setmetatable(o, self)
	self.__index = self

	-- initialize the instance's variables here
	o.img = display.newSprite( sprites.birdSpriteSheet, sprites.birdSequences )
	o.img.width = o.img.width
	o.img.height = o.img.height
	-- return the instance
	return o
end

-- make sure to have this line at the end, otherwise importing this class will not work
return bgBird