------------------------------------------------------------
-- TerraceOfEndlessSpring.lua
--
-- Abin
-- 2012/10/05
------------------------------------------------------------

local module = CompactRaid:FindModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 320 -- Terrace of Endless Spring
local BOSS

-- Protectors of the Endless (683)
BOSS = 683
module:RegisterDebuff(TIER, INSTANCE, BOSS, 117519)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122874)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 118191)

-- Tsulong (742)
BOSS = 742
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122777)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123012)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123036)

-- Lei Shi (729)
BOSS = 729
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123121)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123705)

-- Sha of Fear (709)
BOSS = 709
module:RegisterDebuff(TIER, INSTANCE, BOSS, 117999)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119086)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119775)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119985)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 120629)