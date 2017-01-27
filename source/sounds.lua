-- import the Corona SDK audio module
local audio = require( "audio" )

-- the 'sounds' module
local sounds = {}

-- load each sound
-- sound effects
sounds.swingLight = audio.loadSound( "sounds/swing_light.wav" )
sounds.swingHeavy = audio.loadSound( "sounds/swing_heavy.wav" )
sounds.hitLight = audio.loadSound( "sounds/hit_light.wav" )
sounds.hitHeavy = audio.loadSound( "sounds/hit_heavy.wav" )
sounds.parrySuccess = audio.loadSound( "sounds/parry_success.wav" )
sounds.jacked = audio.loadSound( "sounds/jacked.wav" )
sounds.normal = audio.loadSound( "sounds/normal.wav" )

-- music
sounds.menu = audio.loadSound( "sounds/menu.ogg" )
sounds.battle_start = audio.loadSound( "sounds/battle_intro.ogg" )
sounds.battle_end = audio.loadSound( "sounds/battle_loop.ogg" )

-- return the module
return sounds