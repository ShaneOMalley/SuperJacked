-- the 'templateEntity' module
local  bgTree= {}

-- the img associated with the entity
bgTree.img = nil

-- specifies that the entity is a background entity
bgTree.type = "bg"

-- as long as you add this entite to the level's 'entities' table, this function will
-- be called once per frame
-- Use this function to update the entity's position etc.
function bgTree:update (entities)

	-- all this does so far is move one pixel to the right every, frame
	self.img.x = self.img.x
	
	end

-- this creates an instance of the 'templateEntity' class, initializes it, and returns it
function bgTree:new (o)

	-- create the object
	o = o or {}
	-- set the object to be an instance of 'templateEntity'
	setmetatable(o, self)
	self.__index = self

	-- initialize the instance's variables here
	o.img = display.newImage( "images/liveTree.png" )
	o.img.width = o.img.width * 1.5
	o.img.height = o.img.height * 2
	-- return the instance
	return o
end

-- make sure to have this line at the end, otherwise importing this class will not work
return bgTree