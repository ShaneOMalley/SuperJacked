local sprites = require( "sprites" )

local bgDeadSky = {}

bgDeadSky.img = nil


function bgDeadSky:update (entities)

end

function bgDeadSky:new (o)
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	o.img = display.newImage( sprites.bgDeadSkyPath )
	o.img.anchorX = 0
	o.img.anchorY = 0

	return o
end

return bgDeadSky