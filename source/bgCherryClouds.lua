local sprites = require("sprites")

local bgCherryClouds = {}


bgCherryClouds.img = nil
bgCherryClouds.xvel = .2


bgCherryClouds.type = "bg"
local xvelBase = .2
respawnLine = -700

function bgCherryClouds:update (entities)
	self.img.x = self.img.x - self.xvel
	if self.img.x < respawnLine then
		self:respawn()
	end
end

function bgCherryClouds:respawn ()
	self.xvel = xvelBase * ( 0.95 + math.random() * 0.1 )
end

function bgCherryClouds:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	
	o.img = display.newImage( "images/cherryClouds.png" )
	o.img.width = o.img.width * 2
	o.img.height = o.img.height * 2
	return o
end

return bgCherryClouds