local sprites = require( "sprites" )

local celebratingPlayer = {}

celebratingPlayer.img = nil

celebratingPlayer.directionChangeCoolDownMax = 1000
celebratingPlayer.directionChangeCoolDown = celebratingPlayer.directionChangeCoolDownMax

function celebratingPlayer:update ()

	print("updating")

	self.directionChangeCoolDown = self.directionChangeCoolDown - 16

	if self.directionChangeCoolDown <= 0 then
		self.directionChangeCoolDown = self.directionChangeCoolDownMax
		if self.img.xScale then		
			self.img.xScale = -self.img.xScale
		end
	end

end

function celebratingPlayer:new (o)
	o = o or {}
	setmetatable(o, {__index = self})
--	o.__index = self
	
	print("winner is " .. winner)

	-- if p1 is the winner, set the sprite to look like him
	if winner == 1 then
		o.img = display.newSprite( sprites.player1SpriteSheet, sprites.player1Sequences )
		if not p1IsJacked then
			o.img:setSequence( "kickLoop" )
			o.img:play()
		else
			o.img:setSequence( "kickLoopJacked" )
			o.img:play()
		end

	-- if p2 is the winner, set the sprite to look like him
	elseif winner == 2 then
		o.img = display.newSprite( sprites.player2SpriteSheet, sprites.player1Sequences )
		if not p2IsJacked then
			o.img:setSequence( "kickLoop" )
			o.img:play()
		else
			o.img:setSequence( "kickLoopJacked" )
			o.img:play()
		end
	end

	o.img.xScale = 4
	o.img.yScale = 4
	o.img.anchorX = (19 / 42)

	return o
end

return celebratingPlayer