local levelEntity = require( "levelEntity" )

local levelEntityFloatingIsland = {}

levelEntityFloatingIsland = levelEntity:new()

levelEntityFloatingIsland.type = "terrain"

-- create and return an instance of 'levelEntityFloatingIsland'
function levelEntityFloatingIsland:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	o.img = display.newImage( "images/island2.png" )
	o.img.anchorX = 0
	o.img.anchorY = 0

	o.bounds = {}

	o.isFloor = true

	return o
end

return levelEntityFloatingIsland