local levelEntity = require( "levelEntity" )

local levelEntityFloat = {}

levelEntityFloat = levelEntity:new()

levelEntityFloat.type = "terrain"

-- create and return an instance of 'levelEntityFloatingIsland'
function levelEntityFloat:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	o.img = display.newImage( "images/Float.png" )
	o.img.anchorX = 0
	o.img.anchorY = 0

	o.bounds = {}

	o.isFloor = true

	return o
end

return levelEntityFloat