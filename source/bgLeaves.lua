local sprites = require( "sprites" )

-- the 'templateEntity' module
local bgLeaves = {}

-- the img associated with the entity
bgLeaves.img = nil
bgLeaves.spawnX = 0
bgLeaves.spawnY = 0
bgLeaves.xvel = 0
bgLeaves.yvel = 0

-- The current vertical velocity

-- specifies that the entity is a background entity
bgLeaves.type = "bg"

-- as long as you add this entite to the level's 'entities' table, this function will
-- be called once per frame
-- Use this function to update the entity's position etc.

local respawnLine = 500
local yvelBase = 0.25
local xvelBase = -0.1

function bgLeaves:respawn ()
	self.img.x = self.spawnX
	self.img.y = self.spawnY
	
	self.xvel = xvelBase * ( 0.95 + math.random() * 0.1 )
	self.yvel = yvelBase * ( 0.95 + math.random() * 0.1 )
end

function bgLeaves:update (entities)

	self.img.x = self.img.x + self.xvel
	self.img.y = self.img.y + self.yvel
	
	if self.img.y > respawnLine then
		self:respawn()
	end

end

-- this creates an instance of the 'templateEntity' class, initializes it, and returns it
function bgLeaves:new (o)

	-- create the object
	o = o or {}
	-- set the object to be an instance of 'templateEntity'
	setmetatable(o, self)
	self.__index = self
	o.img = display.newSprite( sprites.leavesSpriteSheet, sprites.leavesSequences )
--	local scale = math.random(1, 3)
	o.img.xScale = scale
	o.img.yScale = scale
	
	o.img:setSequence("leaves")

	o.img.timeScale = math.random() * 0.4 + 0.8
	o.img:play()
	o.img.width = o.img.width
	o.img.height = o.img.height
	
	return o
end

-- make sure to have this line at the end, otherwise importing this class will not work
return bgLeaves