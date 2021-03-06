local sprites = require( "sprites" )

local player2Status = {}

-- location of the hud element
player2Status.x = 0
player2Status.y = 0

-- the player associated with this playerStatus
player2Status.player = nil

-- img for rendering the hud element
player2Status.img = nil

player2Status.stunMeter = nil
player2Status.jackedMeter = nil

player2Status.stocks = {}

-- create and return an instance of playerStatus
function player2Status:new (o)
	-- create a new instance of playerStatus by seting 'o's metatable
	o = o or {}
	setmetatable(o, self)
	self.__index = self

	-- load the img and the img's for the meters
	o.img = display.newImage( sprites.player2StatusPath )
	o.stunMeter = display.newImage( sprites.stunMeterPath )
	o.jackedMeter = display.newImage( sprites.jackedMeterPath )

	-- anchor the playerStatus at (0,0) and set the position
	o.img.anchorX = 0
	o.img.anchorY = 0
	o.img.x = o.x
	o.img.y = o.y

	-- anchor the stun meter at (0,0) and set the position
	o.stunMeter.anchorX = 0
	o.stunMeter.anchorY = 0
	o.stunMeter.x = o.x + 287
	o.stunMeter.y = o.y + 26

	-- anchor the jacked meter at (0,0) and set the position
	o.jackedMeter.anchorX = 0
	o.jackedMeter.anchorY = 0
	o.jackedMeter.x = o.x + 327
	o.jackedMeter.y = o.y + 736

	o.stocks = {}

	for i = 1, o.player.stocks do
		local stock = display.newImage( sprites.stockPath )
		stock.x = o.x + 162 - 8 - (i) * (32 + 4)
		stock.y = o.y + 86
		stock.anchorX = 0
		stock.anchorY = 0
		o.stocks[#o.stocks + 1] = stock
	end

	-- return the instance
	return o
end

-- add all the img's to the argument displayGroup
function player2Status:addToDisplayGroup (group)

	group:insert( self.img )
	group:insert( self.stunMeter )
	group:insert( self.jackedMeter )

	for i,v in pairs(self.stocks) do
		group:insert( v )
	end

end

-- remove all the img's from the argument displayGroup
function player2Status:removeFromDisplayGroup (group)

	group:remove( self.img )
	group:remove( self.stunMeter )
	group:remove( self.jackedMeter )

	for i,v in pairs(self.stocks) do
		group:remove( v )
	end

end

-- call this method once per frame. updates the lengths of the stun meters
function player2Status:update ()

	---[[
	self.stunMeter.width = 286 * math.min(1, (self.player.stun / self.player.stunMax))
	self.jackedMeter.width = 118 * math.min(1, (self.player.jacked / self.player.jackedMax))
	self.stunMeter.x = self.x + 287 - self.stunMeter.width
	self.jackedMeter.x = self.x + 327 - self.jackedMeter.width
	--]]

	--update the visibility of the stocks
	for i = 1, self.player.stocksMax do
		if i <= self.player.stocks then
			self.stocks[i]:setFillColor(1, 1, 1, 1)
		else
			self.stocks[i]:setFillColor(1, 1, 1, 0)			
		end
	end
end

return player2Status