local sprites = require( "sprites" )

local bgCherrySky = {}

bgCherrySky.img = nil


function bgCherrySky:update (entities)

end

function bgCherrySky:new (o)
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	o.img = display.newImage( sprites.bgCherrySkyPath )
	o.img.anchorX = 0
	o.img.anchorY = 0
	
	print("w : " .. o.img.width .. ",h: " .. o.img.height)
	print(o.img.yScale)

	return o
end

return bgCherrySky