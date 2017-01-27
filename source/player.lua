local input = require "input"
local images = require "sprites"
local collision = require "collision"
local sounds = require "sounds"
local audio = require "audio"

-- the `Player' module
local Player = {}

-- Create the `Player' class
Player = {}

-- the type of entity this is
Player.type = "player"

-- the player's number - should be 1 or 2
Player.num = -1

-- player position variables
Player.x = 0;		Player.y = 0			-- the player's x and y position
Player.width = 42*3;	Player.height = 45*3 	-- the player's dimensions

-- player speed variables
Player.xvel = 0;	Player.yvel = 0

Player.accMax = 0.35 * 0.75
Player.acc = Player.accMax

Player.decMax = 0.8
Player.dec = Player.decMax

Player.topSpeedAttacking = 2
Player.topSpeedNormal = 10 * 0.8
Player.top = Player.topSpeedNormal

-- player stun variables
Player.stunMax = 100 * 0.75
Player.stun = 0
Player.stunDecreaseRate = 0.1
Player.stunDecreaseRateStunned = 0.125
Player.stunDecreaseDelayMax = 1000
Player.stunDecreaseDelay = 0
Player.isStunned = false

-- player jacked variables
Player.jackedMax = 100
Player.jacked = 0
Player.isJacked = false
Player.jackedDecreaseRateJacked = 0.1

-- 'shock': amount of time left where the player cannot move (after being hit)
Player.shock = 0

-- invincibility
Player.invincibility = 0

-- the direction the player is facing
Player.direction = "right"

-- images corresponding to the player
Player.img = nil
Player.stunImg = nil

-- the input device corresponding with this player
Player.device = ""

-- the keys which correspond to player movement
Player.inputs = {
	left = "axis1negative", right = "axis1positive", jump = "buttonA",
	attackLight = "buttonX", attackHeavy = "buttonY",
	kick = "buttonB", 
	parry1 = "leftShoulderButton1", parry2 = "rightShoulderButton1",
}

-- use these to ckeck for input
Player.keyDown = {}
Player.keyDownPrevious = {}

-- the max speed that the player can fall
Player.tvel = 5

-- player jump variables
Player.jumpMaxTop = 14 * 0.91
Player.jumpMinTop = 6 * 0.91
Player.jumpMax = Player.jumpMaxTop
Player.jumpMin = Player.jumpMinTop
Player.maxJumps = 3
Player.jumps = Player.maxJumps

-- the amount of stocks (lives) the player has left
Player.stocksMax = 3
Player.stocks = Player.stocksMax

-- the position for the player to respawn
Player.spawnPoint = {x = 0, y = 0}

-- true if the player is falling down after spawning
Player.isSpawning = true

-- true if the player is touching the ground (used for jumping code)
Player.grounded = false

-- bounding boxes and "hitBoxes"
Player.bounds = {x = 0, y = 0, width = 0, height = 0}
Player.boundsWidth = 0
Player.hitBox = {x = 0, y = 0, width = 0, height = 0}
Player.attackHeavyHitBox = {x = 0, y = 0, width = 0, height = 0}
Player.attackLightHitBox = {x = 0, y = 0, width = 0, height = 0}
Player.kickHitBox = {x = 0, y = 0, width = 0, height = 0}

-- frames of the attack animations which will hit players
Player.attackHeavyHitFrames = {15, 16, 17}
Player.attackLightHitFrames = {3, 4}
Player.kickHitFrames = {3, 4}
Player.parryHitFrames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

local deathLine = 1000

-- the frame where the sound is played
local attackHeavySoundFrame = 11
local attackLightSoundFrame = 3
local kickSoundFrame = 2
local parrySoundFrame = 1

-- the knockback and stun time for each attack
local attackHeavyStats = {swingSound = sounds.swingHeavy, hitSound = sounds.hitHeavy, knockback = 20, stun = 35, shock = 350, invuln = 200, jacked = 10}
local attackLightStats = {swingSound = sounds.swingLight, hitSound = sounds.hitLight, knockback = 10, stun = 10, shock = 250, invuln = 80, jacked = 4}
local kickStats = {swingSound = sounds.swingLight, hitSound = sounds.hitLight, knockback = 12, stun = 2, shock = 250, invuln = 80, jacked = 1}
local parryStats = {swingSound = nil, hitSound = sounds.parrySuccess, knockback = 12, stun = 20, shock = 500, invuln = 80}
local jackedTransitionStats = {swingSound = nil, hitSound = nil, knockback = 0, stun = 0, shock = 0, invuln = 0}
local normalTransitionStats = {swingSound = nil, hitSound = nil, knockback = 0, stun = 0, shock = 0, invuln = 0}

-- the amount to accelerate the player downwards
local gravity = 0.75

-- the amount to decelerate the player by if they are in the air
local airFriction = 0.1

-- returns true if the array 'a' contains the value 'v'
local function arrayContains (a, v)
	for i = 1,#a do
		if a[i] == v then 
			return true 
		end
	end
	return false
end

---[[
function Player:reset ()

	self.x = self.spawnPoint.x
	self.y = self.spawnPoint.y
	self.xvel = 0
	self.yvel = 0
	self.jumps = self.jumpsMax

	self.stocks = self.stockMax
	self.stun = 0
	self.jacked = 0
	self.isJacked = false
	self.isStunned = false

	self.img:setSequence( "idle" )
	self.img:play()

end
--]]

-- add the player's various images to the argument display group
function Player:addToDisplayGroup (group)

	group:insert( self.img )
	group:insert( self.stunImg )

end

function Player:removeFromDisplayGroup (group)

	group:remove( self.img )
	group:remove( self.stunImg )

end

-- function to update the img's position and dimensions based on the player
function Player:updateImg ()

	-- update the input device for the player
	self.device = gamePads[self.num]

	-- set the stun indicator to be visible if stunned, invisible if not
	---[[
	if self.isStunned then
		self.stunImg:setFillColor( 1, 1, 1, 1 )
	else
		self.stunImg:setFillColor( 1, 1, 1, 0 )
	end
	--]]

	-- update the color of the image
	if self.shock > 0 then
		self.img:setFillColor( 1, 0.6, 0.6 )
	elseif self.isStunned then
		self.img:setFillColor( 1, 1, 0.5 )
	else
		self.img:setFillColor( 1, 1, 1 )
	end

	self.img.x = self.x
	self.img.y = self.y
	self.img.xScale = self.width / self.img.width
	self.img.yScale = self.height / self.img.height

	-- flip the player horizontally if he is facing left
	if self.direction == "left" then
		self.img.xScale = self.img.xScale * -1
	end

	self.stunImg.x = self.x
	self.stunImg.y = self.y
end

-- store whether keys are pressed in the table given as argument
function Player:checkKeyDown (t)

	t = {}

	if not self.inputs then return end

	for control,button in pairs(self.inputs) do
		t[control] = input.keyState[self.device][button]
	end

	return t

end

-- this gets called when the player gets hit
function Player:hit (params)

	self.yvel = 0
	self.xvel = 0

	audio.play( params.hitSound )

	-- increase knockback if the player is stunned
	if self.isStunned then
		params.knockback = params.knockback * 1.0
	end

	-- knock the player back
	self.xvel = self.xvel + math.cos( params.angle * (math.pi / 180) ) * params.knockback	
	self.yvel = self.yvel + math.sin( params.angle * (math.pi / 180) ) * params.knockback

	self.shock = params.shock
	self.invincibility = params.invuln

	if not self.isStunned then
		self.stun = self.stun + params.stun
		self.stunDecreaseDelay = self.stunDecreaseDelayMax
	end	

	if self.img.sequence ~= "shocked" .. ( self.isJacked and "Jacked" or "" ) then
		self.img:setSequence( "shocked" .. ( self.isJacked and "Jacked" or "" ) )
		self.img:play()
	end

end

function Player:kill ()

	self.stocks = self.stocks - 1
	
	-- if the player is not dead yet
	if self.stocks > 0 then

		self.x, self.y = self.spawnPoint.x, self.spawnPoint.y
		self.xvel = 0
		self.yvel = 0

		self.stun = 0
		self.shock = 0
		self.img:setSequence( "idle" .. ( self.isJacked and "Jacked" or "" ) )
		self.img:play()

		self.isSpawning = true

		self.jacked = 0
		self.isJacked = false
	
	-- if the player is dead
	else
		if not gameOver then
			gameOverStart = true
			gameOver = true
		end

		if self.num == 1 then winner = 2
		else winner = 1 end

	end

end

-- updates the positions and dimensions of the player's bounding boxes based on the player's position
function Player:updateBoundsWithPosition ()

	-- the width of the bounding box
--	local w = self.width * (8 / 28)
	self.boundsWidth = self.width * (8 / 42)

	-- set the position and dimensions of the player's bounding box
	self.bounds = {
		x = self.x - self.boundsWidth / 2,
		y = self.y + self.height * (9 / 45),
		width = self.boundsWidth,
		height = self.height - self.height * (9 / 45),
	}

	local hitW = (14 / 42) * self.width

	self.hitBox = {
		x = self.x - hitW / 2,
		y = self.y,
		width = hitW,
		height = self.height,
	}

	self.attackHeavyHitBox = {
		y = self.y + self.height * (15 / 45),
		width = self.width * (18 / 42),
		height = self.height * (21 / 45),
	}

	-- attackLight
	self.attackLightHitBox = {
		y = self.y + self.height * (29 / 45),
		width = self.width * (13 / 42),
		height = self.height * (10 / 45),
	}

	-- kicking
	self.kickHitBox = {
		y = self.y + self.height * (29 / 45),
		width = self.width * (8 / 42),
		height = self.height * (8 / 45),
	}

	-- the hitboxes
	-- if the player is facing right
	if self.direction == "right" then
		self.attackHeavyHitBox.x = self.x + self.width * (4 / 42)
		self.attackLightHitBox.x = self.x + self.width * (4 / 42)
		self.kickHitBox.x = self.x + self.width * (4 / 42)

	-- if the player is facing left
	else
		self.attackHeavyHitBox.x = self.x - self.width * (4 / 42) - self.width * (18 / 42)
		self.attackLightHitBox.x = self.x - self.width * (4 / 42) - self.width * (13 / 42)
		self.kickHitBox.x = self.x - self.width * (4 / 42) - self.width * (8 / 42)

	end

end

-- update the player's position based on the position of his bounding box, call this after collision detection
function Player:updatePositionWithBounds ()

--	local w = self.width * 0.26

--	self.x = self.bounds.x + ( w / 2 )
	self.x = self.bounds.x + self.boundsWidth / 2
	self.y = self.bounds.y - self.height * ( 9 / 45 )

end

-- boolean to make sure a player is only updated once per frame
Player.updated = false

-- function to update the player
function Player:update (entities)

	-- kill the player if they are below the "death line"
	if self.y >= deathLine then
		if not gameOver then
			self:kill()
		end
		return
	end

	-- adjust acc, dec and top speed if the player is stunned
	if self.isStunned then
		self.top = self.topSpeedNormal * 0.5
		self.acc = self.accMax * 0.5
		self.dec = self.decMax * 0.5

		self.jumpMax = self.jumpMaxTop * 0.75
		self.jumpMin = self.jumpMinTop * 0.75
	else
		self.top = self.topSpeedNormal
		self.acc = self.accMax
		self.dec = self.decMax

		self.jumpMax = self.jumpMaxTop
		self.jumpMin = self.jumpMinTop
	end

	-- decrease invincibility cooldown
	self.invincibility = self.invincibility - 16

	-- check if the player is stunned
	if not self.isStunned and self.stun >= self.stunMax then
		self.stun = self.stunMax
		self.isStunned = true
	end

	-- if player is stunned
	if self.isStunned then
		-- decrease their stun meter
		self.stun = self.stun - self.stunDecreaseRateStunned
		-- check if they are still stunned
		if self.stun <= 0 then
			self.isStunned = false
			self.stun = 0
		end
	
	-- if player is not stunned
	else	
		-- decrease stun decrease cooldown
		if self.stunDecreaseDelay > 0 then
			self.stunDecreaseDelay = self.stunDecreaseDelay - 16
		end

		-- decrease stun if cooldown is <= 0
		if self.stunDecreaseDelay <= 0 then
			stunDecreaseDelay = 0
			self.stun = self.stun - self.stunDecreaseRate
			-- cap lower limit of stun to 0
			if self.stun < 0 then
				self.stun = 0
			end
		end
	end

	-- check if the player is jacked
	if not self.isJacked and self.jacked >= self.jackedMax then
		self.jacked = self.jackedMax
		self.isJacked = true

		-- play the jacked transition animation
		self.img:setSequence( "jackedTransition" )
		self.img:play()

		audio.play( sounds.jacked )

		if self.num == 1 then
			p1IsJacked = true
		elseif self.num == 2 then
			p2IsJacked = true
		end
	end

	-- if the player is jacked
	if self.isJacked then

		self.jacked = self.jacked - self.jackedDecreaseRateJacked
		if self.jacked <= 0 then
			self.jacked = 0
			self.isJacked = false

			self.img:setSequence( "normalTransition" )
			self.img:play()

			audio.play( sounds.normal )

			if self.num == 1 then
				p1IsJacked = false
			elseif self.num == 2 then
				p2IsJacked = false
			end
		end

	end

	local movingVertical = false
	local movingHorizontal = false
	local opposingMotion = false
	local opposingMotionVertical = false
	local opposingMotionHorizontal = false

	-- the direction the player intends to walk, not necessarily the direction the
	-- player's body is moving: can be "none", "right" or "left"
	local walkingDirection = "none"

	-- only check for input if the player is not 'shocked' or 'parrying'
	if self.shock <= 0 and not attacking and 
		self.img.sequence ~= "parry" .. ( self.isJacked and "Jacked" or "" ) and
		self.img.sequence ~= "jackedTransition" and
		self.img.sequence ~= "normalTransition" 
		and not self.isSpawning then

		-- check if the player is currently attacking
		local attacking = ( self.img.sequence == "attackHeavy" .. ( self.isJacked and "Jacked" or "" ) 
			or self.img.sequence == "attackLight" .. ( self.isJacked and "Jacked" or "" ) 
			or self.img.sequence == "kick" .. ( self.isJacked and "Jacked" or "" ) 
			or self.img.sequence == "parry" .. ( self.isJacked and "Jacked" or "" )
			or self.img.sequence == "jackedTransition"
			or self.img.sequence == "normalTransition" )

		-- only check for input if keys have been pressed on the device
		if input.keyState[self.device] then

			-- store the current state of keypresses in 'keyDown', and in 'keyDownPrevious' if it is nil
			self.keyDown = self:checkKeyDown (self.keyDown)

			-- if the player wants to go left
			if self.keyDown.left and not self.keyDown.right then
				walkingDirection = "left"
				-- if already going left
				if self.xvel <= 0 then
					self.xvel = math.max( self.xvel - self.acc, -self.top )
					movingHorizontal = true
				else
					self.xvel = self.xvel - self.dec
					opposingMotionHorizontal = true
				end
			end

			-- if the player wants to go right
			if self.keyDown.right and not self.keyDown.left then
				walkingDirection = "right"
				-- if already going right
				if self.xvel >= 0 then
					self.xvel = math.min( self.xvel + self.acc, self.top )
					movingHorizontal = true

				else
					self.xvel = self.xvel + self.dec
					opposingMotionHorizontal = true
				end
			end

			--jumping
			-- take away one of the player's jumps if the moved off the edge
			if self.jumps == self.maxJumps and not self.grounded then
				self.jumps = self.maxJumps - 1
			end

			if self.jumps > 0 and self.keyDown.jump and not self.keyDownPrevious.jump then
				self.jumps = self.jumps - 1
				self.yvel = -self.jumpMax
			end

			-- variable jump height
			if self.yvel < -self.jumpMin and not self.keyDown.jump then
				self.yvel = -self.jumpMin
			end

			-- attacks
			-- ignore if already parrying
			if self.img.sequence ~= "parry" .. ( self.isJacked and "Jacked" or "" ) and not attacking then

				-- heavy attack
				if self.img.sequence ~= "attackHeavy" .. ( self.isJacked and "Jacked" or "" ) and self.keyDown.attackHeavy and not self.keyDownPrevious.attackHeavy then
					self.img:setSequence( "attackHeavy" .. ( self.isJacked and "Jacked" or "" ) )
					self.img:play()
				-- light attack
				elseif self.img.sequence ~= "attackLight" .. ( self.isJacked and "Jacked" or "" ) and self.keyDown.attackLight and not self.keyDownPrevious.attackLight then
					self.img:setSequence( "attackLight" .. ( self.isJacked and "Jacked" or "" ) )
					self.img:play()
				-- kick
				elseif self.img.sequence ~= "kick" .. ( self.isJacked and "Jacked" or "" ) and self.keyDown.kick and not self.keyDownPrevious.kick then
					self.img:setSequence( "kick" .. ( self.isJacked and "Jacked" or "" ) )
					self.img:play()
				-- parry
				elseif self.img.sequence ~= "parry" .. ( self.isJacked and "Jacked" or "" ) and 
					( ( self.keyDown.parry1 and not self.keyDownPrevious.parry1 ) or (self.keyDown.parry2 
						and not self.keyDownPrevious.parry2) and not attacking ) then
					self.img:setSequence( "parry" .. ( self.isJacked and "Jacked" or "" ) )
					self.img:play()
				end

			end

			-- store the current state of keypresses in 'keyDownPrevious'
			self.keyDownPrevious = self:checkKeyDown(self.keyDownPrevious)

		end 

	-- if the player is 'shocked'
	else 
		-- decrease their shock timer
		self.shock = self.shock - 16

	end

	-- check if the player is currently attacking
	local attacking = ( self.img.sequence == "attackHeavy" .. ( self.isJacked and "Jacked" or "" ) 
		or self.img.sequence == "attackLight" .. ( self.isJacked and "Jacked" or "" ) 
		or self.img.sequence == "kick" .. ( self.isJacked and "Jacked" or "" ) 
		or self.img.sequence == "parry" .. ( self.isJacked and "Jacked" or "" )
		or self.img.sequence == "jackedTransition"
		or self.img.sequence == "normalTransition" )

	-- if the player is not actively moving horizontally, or if they are attacking, decelerate them
	if walkingDirection == "none" or attacking then
		-- if they are on the ground, apply normal deceration
		if self.grounded then
			-- decelerate them when they are going right
			if self.xvel > 0 then
				self.xvel = self.xvel - math.min(self.xvel, self.dec)
			-- decelerate them when they are going left
			else
				self.xvel = self.xvel + math.min(math.abs(self.xvel), self.dec)
			end

		-- if they are in the air, apply air friction
		else
			-- decelerate them when they are going right
			if self.xvel > 0 then
				self.xvel = self.xvel - math.min(self.xvel, airFriction)
			-- decelerate them when they are going left
			else
				self.xvel = self.xvel + math.min(math.abs(self.xvel), airFriction)
			end
		end
	end

	-- if the player is not actively moving vertically, develerate them
	---[[
	if not movingVertical then
		if self.yvel > 0 then
			self.yvel = self.yvel - math.min(self.yvel, airFriction)
		else
			self.yvel = self.yvel + math.min(math.abs(self.yvel), airFriction)
		end
	end
	--]]

	-- apply gravity to the player
	self.yvel = self.yvel + gravity
	
	-- update the player's current bounding box
	self:updateBoundsWithPosition()

	local newX = self.bounds.x + self.xvel
	local newY = self.bounds.y + self.yvel

	local dx = self.bounds.x - self.hitBox.x
	local dy = self.bounds.y - self.hitBox.y

	-- collision detection with floors
	self.grounded = false	-- assume the player is not grounded until we find a collision

	for i,v in ipairs(entities) do

		local newBounds = { x = newX, y = newY, width = self.bounds.width, height = self.bounds.height }
		local newHitBox = { x = newX - dx, y = newY - dy, width = self.hitBox.width, height = self.hitBox.height }

		-- ignore detection if the entity is the player itself
		if v ~= self then

			-- if colliding with floor
			if v.bounds and v.type == "terrain" then
				if collision.intersecting(newBounds, v.bounds) then

					-- convert y velocity to x velocity upon hitting floor, but only if stunned, and yvel is signifigant
					if self.shock > 0 and self.yvel >= 1 then

						local vel = math.sqrt( (self.xvel * self.xvel) + (self.yvel * self.yvel) ) * 0.75

						if self.xvel < 0 then
							self.xvel = -vel
						elseif self.xvel > 0 then
							self.xvel = vel
						end
					end

					if self.y + self.height <= v.bounds.y and self.yvel >= 0 then
						self.yvel = 0
						newY = v.bounds.y - self.bounds.height
						self.jumps = self.jumpsMax
						self.grounded = true
						self.isSpawning = false
					end
				end
			end

			-- if colliding with another player
			if v.type == "player" then

				-- only "bump off" players if you are not stunned
				if collision.intersecting(newBounds, v.bounds) and self.shock <= 0 then

					-- if you hit it from its right
					if self.x > v.x  then
						local center = (newBounds.x + (v.bounds.x + v.bounds.width)) / 2 
						newX = center + 0.75
						v.bounds.x = center - v.bounds.width - 0.75
						
					-- if you hit it from its left
					elseif self.x < v.x then
						local center = ((newBounds.x + self.bounds.width) + v.bounds.x) / 2
						newX = center - self.bounds.width - 0.75
						v.bounds.x = center + 0.75

					end
					v:updatePositionWithBounds()
				end
			end

			-- collision detection when attacking other players
			if v.type == "player" then

				-- the animation sequence of the enemy's sprite
				local enemySequence = v.img.sequence

				-- is the enemy currently attacking, and are his hit frames playing
				local enemyAttacking = ( enemySequence == "attackHeavy" .. ( v.isJacked and "Jacked" or "" ) and arrayContains(v.attackHeavyHitFrames, v.img.frame) ) or
					( enemySequence == "attackLight" .. ( v.isJacked and "Jacked" or "" ) and arrayContains(v.attackLightHitFrames, v.img.frame) or
					  enemySequence == "kick" .. ( v.isJacked and "Jacked" or "" ) and arrayContains(v.kickHitFrames, v.img.frame ) )

				-- if doing a heavy attack
				if self.img.sequence == "attackHeavy" .. ( self.isJacked and "Jacked" or "" ) and arrayContains(self.attackHeavyHitFrames, self.img.frame) then

					-- initialize the parameters for the hit
					local params = {}
					params.angle = math.atan2( (v.y - self.y), (v.x - self.x) ) * (180 / math.pi) 
					params.knockback = attackHeavyStats.knockback * (self.isJacked and 1.2 or 1.0)
					params.stun = attackHeavyStats.stun * (self.isJacked and 1.2 or 1.0)
					params.shock = attackHeavyStats.shock
					params.invuln = attackHeavyStats.invuln
					params.hitSound = attackHeavyStats.hitSound

					-- collide with the enemy's attack if enemy is doing same attack
					if enemySequence == "attackHeavy" .. ( v.isJacked and "Jacked" or "" ) and enemyAttacking and ( collision.intersecting( self.attackHeavyHitBox, v.attackHeavyHitBox, v.hitBox ) ) and v.direction ~= self.direction then
						-- halve the stun damage and knockback of the attack
						params.knockback = params.knockback * 0.5 * (self.isJacked and 1.2 or 1.0)
						params.stun = params.stun * 0.5 * (self.isJacked and 1.2 or 1.0)

						-- only affect the other player if they are not invulnerable
						if v.invincibility <= 0 then
							-- make the enemy face in the opposite direction
							v.direction = ( self.direction == "right" and "left" or "right" )
							v:hit(params)
						end
						-- change the angle, and affect the player with the hit
						params.angle = params.angle + 180
						params.knockback = params.knockback / (self.isJacked and 1.2 or 1.0)
						params.stun = params.stun / (self.isJacked and 1.2 or 1.0)
						self:hit(params)

					-- otherwise, attack the enemy normally
					elseif collision.intersecting( self.attackHeavyHitBox, v.hitBox ) then

						-- if the enemy parries
						if enemySequence == "parry" .. ( v.isJacked and "Jacked" or "" ) and arrayContains( v.parryHitFrames, v.img.frame ) then
							-- stop the enemy's parry animation
							v.img:setSequence( "idle" .. ( v.isJacked and "Jacked" or "" ) )
							-- adjust the stats and hit self with parry knockback
							params.angle = params.angle + 180
							params.knockback = parryStats.knockback * (self.isJacked and 1.2 or 1.0)
							params.stun = parryStats.stun * (self.isJacked and 1.2 or 1.0)
							params.shock = parryStats.shock
							params.invuln = parryStats.invuln
							params.hitSound = parryStats.hitSound
							self:hit(params)
							-- add to the enemys jacked meter
							v.jacked = math.min( v.jacked + 25, v.jackedMax )


						elseif v.invincibility <= 0 then
							-- make the enemy face in the opposite direction
							v.direction = ( self.direction == "right" and "left" or "right" )
							v:hit(params)
							if not self.isJacked then
								self.jacked = self.jacked + attackHeavyStats.jacked
							end
						end
					end
				
				-- if doing a light attack
				elseif self.img.sequence == "attackLight" .. ( self.isJacked and "Jacked" or "" ) and arrayContains( self.attackLightHitFrames, self.img.frame ) then

					-- initialize the parameters for the hit
					local params = {}
					params.angle = math.atan2( (v.y - self.y) , (v.x - self.x) ) * (180 / math.pi) 
					params.knockback = attackLightStats.knockback * (self.isJacked and 1.2 or 1.0)
					params.stun = attackLightStats.stun * (self.isJacked and 1.2 or 1.0)
					params.shock = attackLightStats.shock
					params.invuln = attackLightStats.invuln
					params.hitSound = attackLightStats.hitSound

					-- collide with the enemy's attack if enemy is doing same attack
					if enemySequence == "attackLight" .. ( v.isJacked and "Jacked" or "" ) and enemyAttacking and ( collision.intersecting( self.attackLightHitBox, v.attackHeavyHitBox, v.hitBox ) ) and v.direction ~= self.direction then
						-- halve the power of the attack
						params.knockback = params.knockback * 0.5  * (self.isJacked and 1.2 or 1.0)
						params.stun = params.stun * 0.5  * (self.isJacked and 1.2 or 1.0)
						-- only hit the enemy if they are not invincible
						if v.invincibility <= 0 then
							-- make the enemy face in the opposite direction
							v.direction = ( self.direction == "right" and "left" or "right" )
							v:hit(params)
						end
						-- change the angle to opposite, and hit self
						params.angle = params.angle + 180
						params.knockback = params.knockback / (self.isJacked and 1.2 or 1.0)
						params.stun = params.stun / (self.isJacked and 1.2 or 1.0)
						self:hit(params)

					-- otherwise, attack the enemy normally
					elseif collision.intersecting( self.attackLightHitBox, v.hitBox ) then
						--if the enemy succesfully parries
						if enemySequence == "parry" .. ( v.isJacked and "Jacked" or "" ) and arrayContains( v.parryHitFrames, v.img.frame ) then
							-- stop the enemy's parry animation
							v.img:setSequence( "idle" .. ( v.isJacked and "Jacked" or "" ) )
							-- adjust the stats and hit self with parry knockback
							params.angle = params.angle + 180
							params.knockback = parryStats.knockback * (self.isJacked and 1.2 or 1.0)
							params.stun = parryStats.stun * (self.isJacked and 1.2 or 1.0)
							params.shock = parryStats.shock
							params.invuln = parryStats.invuln
							params.hitSound = parryStats.hitSound
							self:hit(params)
							-- add to the enemys jacked meter
							v.jacked = math.min( v.jacked + 25, v.jackedMax )

						elseif v.invincibility <= 0 then
							-- make the enemy face in the opposite direction
							v.direction = ( self.direction == "right" and "left" or "right" )							
							v:hit(params)
							if not self.isJacked then
								self.jacked = self.jacked + attackLightStats.jacked
							end
						end
					end

				-- if doing a kick
				elseif self.img.sequence == "kick" .. ( self.isJacked and "Jacked" or "" ) and arrayContains(self.kickHitFrames, self.img.frame) then

					-- initialize parameters for the hit
					local params = {}
					params.angle = math.atan2( (v.y - self.y) , (v.x - self.x) ) * (180 / math.pi)
					-- snap the angle to either 0 or 180 degress
					if params.angle % 360 >= 90 and params.angle < 270 then
						params.angle = 180
					else
						params.angle = 0
					end
					params.knockback = kickStats.knockback
					params.stun = kickStats.stun
					params.shock = kickStats.shock
					params.invuln = kickStats.invuln
					params.hitSound = kickStats.hitSound

					-- if the kick connects
					if collision.intersecting(self.kickHitBox, v.hitBox, v.kickHitBox) then

						-- if the other player is kicking at the same time, bounce back
						if enemyAttacking and enemySequence == "kick" .. ( v.isJacked and "Jacked" or "" ) and v.direction ~= self.direction then
							-- halve the power of the attack
							params.knockback = params.knockback * 0.5 * (self.isJacked and 1.2 or 1.0)
							params.stun = params.stun * 0.5 * (self.isJacked and 1.2 or 1.0)
							-- only hit the enemy if they are not invincible
							if v.invincibility <= 0 then
								-- make the enemy face in the opposite direction
								v.direction = ( self.direction == "right" and "left" or "right" )
								v:hit(params)
							end
							-- change angle to opposite and hit self
							params.angle = params.angle + 180
							params.knockback = params.knockback / (self.isJacked and 1.2 or 1.0)
							params.stun = params.stun / (self.isJacked and 1.2 or 1.0)
							self:hit(params)
						
						-- otherwise, attack normally
						elseif collision.intersecting( self.kickHitBox, v.hitBox ) then
							-- if the enemy parries
							if enemySequence == "parry" .. ( v.isJacked and "Jacked" or "" ) and arrayContains( v.parryHitFrames, v.img.frame ) then
								-- stop the enemy's parry animation
								v.img:setSequence( "idle" .. ( v.isJacked and "Jacked" or "" ) )
								-- adjust the stats and hit self with parry knockback
								params.angle = params.angle + 180
								params.knockback = parryStats.knockback * (self.isJacked and 1.2 or 1.0)
								params.stun = parryStats.stun * (self.isJacked and 1.2 or 1.0)
								params.shock = parryStats.shock
								params.invuln = parryStats.invuln
								params.hitSound = parryStats.hitSound
								self:hit(params)
								-- add to the enemys jacked meter
								v.jacked = math.min( v.jacked + 25, v.jackedMax )

							elseif v.invincibility <= 0 then
								-- make the enemy face in the opposite direction
								v.direction = ( self.direction == "right" and "left" or "right" )
								v:hit(params)
								if not self.isJacked then
									self.jacked = self.jacked + kickStats.jacked
								end
							end
						end
						
					end					

				end

			end -- end of attack collision detection

		end
	end

	self.bounds.x = newX
	self.bounds.y = newY

	self:updatePositionWithBounds()

	-- set the direction the player is facing based on the direction he is willing to travel
	if walkingDirection ~= "none" and self.img.sequence == "run" .. ( self.isJacked and "Jacked" or "" ) then
		self.direction = walkingDirection
	end
	
	-- set the player's animation, ignore if they are attacking
	if self.shock <= 0 then

		if not attacking then
			-- set the player's animation to "run" if they are running
			if self.xvel ~= 0 or movingHorizontal or opposingMotionHorizontal then
				if self.img.sequence ~= "run" .. ( self.isJacked and "Jacked" or "" ) then
					self.img:setSequence("run" .. ( self.isJacked and "Jacked" or "" ))
					self.img:play()
				end
			-- set the player's animation to "idle" if they are standing still
			else
				if self.img.sequence ~= "idle" .. ( self.isJacked and "Jacked" or "" ) then
					self.img:setSequence("idle" .. ( self.isJacked and "Jacked" or "" ))
					self.img:play()
				end
			end

		end

	else 	-- if the player is 'shocked'

		if self.img.sequence ~= "shocked" .. ( self.isJacked and "Jacked" or "" ) then
			self.img:setSequence( "shocked" .. ( self.isJacked and "Jacked" or "" ))
			self.img:play()
		end

	end

	-- set the timeScale of the player's animation based on his speed,
	-- but only if the player is in "run" animation
	local tscale

	if self.img.sequence == "run" .. ( self.isJacked and "Jacked" or "" ) then

		-- set "tscale" to be proportional to the player's velocity
		tscale = math.abs(self.xvel) / self.top

		-- clamp "tscale" to one of a few values
		if tscale < .2 then tscale = 0.4
		elseif tscale < .4 then tscale = .6
		elseif tscale < .6 then tscale = .8
		else tscale = 1 end

	-- just play the animation normally if it is not "run"
	else
		tscale = 1
	end

	-- change the sprite's timeScale and fix frame-skipping issue
	---[[
	if self.img.timeScale - (self.img.timeScale % 0.001) ~= tscale then
		local frameIndex = self.img.frame
		self.img.timeScale = tscale
		self.img:setFrame(frameIndex)
	end
	--]]

	-- update the image
	self:updateImg()

end

-- add this listener to the player's sprite
local function spriteListener (event)

	-- change back to idle animation after attack animation is finished
	if ( event.target.sequence == "attackHeavy" or 
		 event.target.sequence == "attackHeavyJacked" or 
		 event.target.sequence == "attackLight" or 
		 event.target.sequence == "attackLightJacked" or 
		 event.target.sequence == "kick" or
		 event.target.sequence == "kickJacked" or
		 event.target.sequence == "parry" or
		 event.target.sequence == "parryJacked" ) and event.phase == "ended" then
		
		event.target:setSequence( "idle" )
		event.target:play()
	
	elseif ( event.target.sequence == "jackedTransition" and event.phase == "ended" ) then
		event.target:setSequence( "idleJacked" )

	elseif ( event.target.sequence == "normalTransition" and event.phase == "ended" ) then
		event.target:setSequence( "idle" )
	end

	-- play sounds
	-- heavy attack sound
	if (event.target.sequence == "attackHeavy" or event.target.sequence == "attackHeavyJacked") and event.target.frame == attackHeavySoundFrame then
		audio.play( attackHeavyStats.swingSound )
	-- attack light sound
	elseif (event.target.sequence == "attackLight" or event.target.sequence == "attackLightJacked")  and event.target.frame == attackLightSoundFrame then
		audio.play( attackLightStats.swingSound )
	-- kick sound
	elseif (event.target.sequence == "kick" or event.target.sequence == "kickJacked")  and event.target.frame == kickSoundFrame then
		audio.play( kickStats.swingSound )
	end

end

function Player:new (o)
	o = o or {}
	setmetatable(o, {__index = self})

	if o.num == 1 then
		o.img = display.newSprite( images.player1SpriteSheet, images.player1Sequences )
	else
		o.img = display.newSprite( images.player2SpriteSheet, images.player1Sequences )
	end

	o.img:addEventListener( "sprite", spriteListener )

	o.stunImg = display.newSprite( images.playerStunSpriteSheet, images.playerStunSequences )
	o.stunImg.xScale = 3
	o.stunImg.yScale = 3
	o.stunImg:setSequence( "default" )
	o.stunImg:play()
	o.stunImg:setFillColor( 1, 1, 1, 0 )		-- set the stun indicator to be invisible

	o.x = o.spawnPoint.x
	o.y = o.spawnPoint.y
	o.width = o.width or 0
	o.height = o.height or 0
	o.xvel = o.xvel or 0
	o.yvel = o.yvel or 0

	o.img.anchorX = (19 / 42)
	o.img.anchorY = 0
	o.img:setSequence("idle" .. ( self.isJacked and "Jacked" or "" ))
	o.img:play()

	o.img.width = o.width
	o.img.height = o.height

	o:updateBoundsWithPosition()

	return o
end

return Player