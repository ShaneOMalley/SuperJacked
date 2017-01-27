local sprites = require( "sprites" )

local bgSky = {}

bgSky.img = nil
bgSky.r = 1
bgSky.g = 1
bgSky.b = 1

function bgSky:reset()
	self.img.y = -self.img.height + 768
end

function bgSky:update (entities)
	
	--[[
	self.g = math.max(self.g - 0.001, 0.4)
	self.b = math.max(self.b + 0.4, 0.1)
	self.r = math.max(self.r - 0.001, 0.7)
	self.img:setFillColor( self.r, self.g, self.b )
	--]]
	self.img.y = self.img.y + 0.3
	if self.img.y > 0 then
		self.img.y = 0
	end

end

function bgSky:new (o)
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	o.img = display.newImage( sprites.bgSkyPath )
	o.img.anchorX = 0
	o.img.anchorY = 0
	
	print("w : " .. o.img.width .. ",h: " .. o.img.height)
	print(o.img.yScale)

	return o
end

return bgSky