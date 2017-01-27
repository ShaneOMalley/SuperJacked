local levelEntity = require( "levelEntity" )

local levelEntityFloatingDeadIsland = {}

levelEntityFloatingDeadIsland = levelEntity:new()

levelEntityFloatingDeadIsland.type = "terrain"

-- create and return an instance of 'levelEntityFloatingIsland'
function levelEntityFloatingDeadIsland:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	o.img = display.newImage( "images/DeadIsland.png" )
	o.img.anchorX = 0
	o.img.anchorY = 0

	o.bounds = {}

	o.isFloor = true

	return o
end

return levelEntityFloatingDeadIsland