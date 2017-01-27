local levelEntity = require( "levelEntity" )

local levelEntityDeadFloat = {}

levelEntityDeadFloat = levelEntity:new()

levelEntityDeadFloat.type = "terrain"

-- create and return an instance of 'levelEntityFloatingIsland'
function levelEntityDeadFloat:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	o.img = display.newImage( "images/DeadFloat.png" )
	o.img.anchorX = 0
	o.img.anchorY = 0

	o.bounds = {}

	o.isFloor = true

	return o
end

return levelEntityDeadFloat