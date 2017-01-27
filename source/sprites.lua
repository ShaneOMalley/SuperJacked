local sprites = {}

sprites.player1SpriteSheet = graphics.newImageSheet( "images/spriteSheetP1.png", {
	width = 42,
	height = 45,
	numFrames = 96,
} )

sprites.player2SpriteSheet = graphics.newImageSheet( "images/spriteSheetP2.png", {
	width = 42,
	height = 45,
	numFrames = 96,
} )

sprites.player1Sequences = {
	-- idle
	{
		name = "idle",
		frames = { 1,2,1,2,1,2,1,2,3,2 },
		time = 4000,
	},
	-- running
	{
		name = "run",
		start = 25,
		count = 8,
		time = 300,
	},
	-- stunned
	{
		name = "parry",
		frames = { 9,33,34,35,36,36,36,36,36,36,35,35,35,35,35,35,35,35,34,34,34,34,34,34,34,34,33,33,33,33,33,33,33,33, },
		time = 1000,
		loopCount = 1,
	},
	-- 'shocked'
	{
		name = "shocked",
		start = 60,
		count = 2,
		time = 300,
	},
	-- heavy attack
	{
		name = "attackHeavy",
		frames = { 9,9,10,10,11,11,12,12,17,17,18,18,19,20,21,22,23,22,21,12,10,9,1 },
		time = 900,
		loopCount = 1,
	},
	-- light attack
	{
		name = "attackLight",
		frames = { 9,10,11,9,13,14,15,16,15,14,13,1 },
		time = 400,
		loopCount = 1,
	},
	-- kick
	{
		name = "kick",
		frames = { 9,10,5,6,7,8,7,6,5,10,9,1 },
		time = 600,
		loopCount = 1,
	},
	{
		name = "jump",
		start = 3,
		count = 1,
		time = 20000,
		loopCount = 1,
	},
	-- jacked transition (normal to jacked)
	{
		name = "jackedTransition",
		start = 36,
		count = 21,
		time = 1000,
		loopCount = 1,
	},
	-- normal transition (jacked to normal)
	{
		name = "normalTransition",
		frames = {57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36},
		time = 1000,
		loopCount = 1,
	},

	-- "Jacked" variants
	-- idle
	{
		name = "idleJacked",
		frames = { 65,66,65,66,65,66,65,66,67,66 },
		time = 4000,
	},
	-- running
	{
		name = "runJacked",
		start = 89,
		count = 8,
		time = 300,
	},
	-- stunned
	{
		name = "parryJacked",
		frames = { 73,59,58,57,56,56,56,56,56,56,57,57,57,57,57,57,57,57,58,58,58,58,58,58,58,58,59,59,59,59,59,59,59,59, },
		time = 1000,
		loopCount = 1,
	},
	-- 'shocked'
	{
		name = "shockedJacked",
		start = 60,
		count = 2,
		time = 300,
	},
	-- heavy attack
	{
		name = "attackHeavyJacked",
		frames = { 73,73,74,74,75,75,76,76,81,81,82,82,83,84,85,86,85,84,76,74,73,65 },
		time = 900,
		loopCount = 1,
	},
	-- light attack
	{
		name = "attackLightJacked",
		frames = { 73,74,75,73,77,78,79,80,79,78,77,65 },
		time = 400,
		loopCount = 1,
	},
	-- kick
	{
		name = "kickJacked",
		frames = { 73,74,69,70,71,72,71,70,69,73,65 },
		time = 600,
		loopCount = 1,
	},
	{
		name = "jumpJacked",
		start = 68,
		count = 1,
		time = 200,
		loopCount = 1,
	},
	-- kickLoop, for the congratulations screen
	{
		name = "kickLoop",
		frames = { 9,10,5,6,7,8,7,6,5,10,9,1 },
		time = 500,
		loopCount = 0,
	},
	{
		name = "kickLoopJacked",
		frames = { 73,74,69,70,71,72,71,70,69,73,65 },
		time = 500,
		loopCount = 0,
	},

}
--]]

-- stun spritesheet
sprites.playerStunSpriteSheet = graphics.newImageSheet( "images/dizzySheet.png", {
	width = 17,
	height = 11,
	numFrames = 3,
} )

sprites.playerStunSequences = {
	-- default
	{
		name = "default",
		start = 1,
		count = 3,
		time = 1000,
	}
}

-- splashes
---[[
sprites.splashSpriteSheet = graphics.newImageSheet( "images/splash.png", {
	width = 600,
	height = 200,
	numFrames = 3,
} )

sprites.splashSequences = {
	{
		name = "blank",
		start = 1,
		count = 1,
		time = -1,
		loopCount = 1,
	},
	{
		name = "fight",
		start = 1,
		count = 1,
		time = 1000,
		loopCount = 1,
	},
	{
		name = "p1Wins",
		start = 2,
		count = 1,
	},
	{
		name = "p2Wins",
		start = 3,
		count = 1,
	},
}

-- Jacks sprites
-- stars
sprites.starSpriteSheet = graphics.newImageSheet( "images/starSpriteSheet.png", {
	width = 8,
	height = 8,
	numFrames = 3,
} )

sprites.starSequences = {
	-- twinkle
	{
		name = "twinkle",
		start = 1,
		count = 3,
		time = 7000,
	},
}
-- leaves
sprites.leavesSpriteSheet = graphics.newImageSheet( "images/cherrySpriteSheet.png", {
	width = 16,
	height = 16,
	numFrames = 3,
} )

sprites.leavesSequences = {
	-- leaves
	{
		name = "leaves",
		start = 1,
		count = 4,
		time = 4000,
	},
}
-- birds
sprites.birdSpriteSheet = graphics.newImageSheet( "images/bird.png",{
		width = 27,
		height = 24,
		numFrames = 5,
}	)

sprites.birdSequences = {
	-- idle
	{
		name = "idle",
		start = 1,
		count = 1,
	},
	{
		name = "fly",
		start = 2,
		count = 4,
		time = 600,
	}
	
}

-- playerStatus GUI element
sprites.playerStatusPath = "images/status.png"
sprites.player1StatusPath = "images/p1status.png"
sprites.player2StatusPath = "images/p2status.png"

-- stun meter
sprites.stunMeterPath = "images/stun.png"
sprites.jackedMeterPath = "images/jacked.png"

-- stocks path
sprites.stockPath = "images/stock.png"

sprites.bgSunPath = "images/sunX3.png"
sprites.bgHillsPath = "images/hills.png"
sprites.bgSkyPath = "images/longSky.png"
sprites.bgTreePath = "images/tree.png"
sprites.bgStarPath = "images/star.png"

sprites.bgCherryTreePath = "images/cherry.png"
sprites.bgCherrySkyPath = "images/cherrySky.png"
sprites.bgCherryCloudPath = "images/cherryCloud.png"
sprites.bgLeavesPath = "images/cherrySpriteSheet.png"
sprites.bgDeadSkyPath = "images/deadSky.png"
sprites.bgDeadTreePath = "images/deadTree.png"
sprites.bgBirdsPath = "images/bird.png"

return sprites