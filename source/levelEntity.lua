local levelEntity = {}

levelEntity.type = "levelEntity"

levelEntity.img = nil
levelEntity.bounds = {x = 0, y = 0, width = 0, height = 0}
levelEntity.isFloor = false

-- create and return an instance of 'levelEntity'
function levelEntity:new (o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


function levelEntity:setPositionAndBounds (position, bounds)

	self.img.x = position.x
	self.img.y = position.y
	self.img.width = position.width
	self.img.height = position.height

	---[[
	self.bounds.x = bounds.x + position.x
	self.bounds.y = bounds.y + position.y
	self.bounds.width = bounds.width
	self.bounds.height = bounds.height
	--]]

	--[[
	self.bounds.x = bounds.x
	self.bounds.y = bounds.y
	self.bounds.width = bounds.width
	self.bounds.height = bounds.height
	--]]

end

return levelEntity