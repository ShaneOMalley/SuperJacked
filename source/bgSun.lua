local sprites = require("sprites")

local bgSun = {}

bgSun.img = nil
bgSun.r = 1
bgSun.g = 1
bgSun.b = 1

bgSun.type = "bg"

local cx = 1200 + 300
local cy = 600
local ang = 30
local dist = 1000

function bgSun:reset ()
	ang = 30
end

function bgSun:update (entities)

--	self.img.y = self.img.y + 0.1
	self.img.x = cx - math.cos(ang * (math.pi / 180)) * dist
	self.img.y = cy - math.sin(ang * (math.pi / 180)) * dist

	ang = ang - .02
	if ang < -30 then ang = -30 end
	
	self.g = math.max(self.g - 0.0002, 0.6)
	self.b = math.max(self.b - 0.0002, 0.6)

	self.img:setFillColor( self.r, self.g, self.b )

end

function bgSun:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	o.img = display.newImage( sprites.bgSunPath )
	o.img.width = o.img.width * 2 * 2
	o.img.height = o.img.height * 2 * 2
	
	return o
end

return bgSun