--界面框体增强
local _G = _G  --解决头像在换类似天赋，符文的时候出现暴雪禁用插件的情况。
local _, class = UnitClass("player")

---------------------------------------------------
-- 标准配置
---------------------------------------------------
UnitFrames = {}
UnitFrames.config = {
---2个布局选1.或者都不选择（注意：下面PVP布局和PVE布局不能同时开启[= true]，但是可以同时关闭[= false]，当同时关闭[= false]时将恢复原系统定义布局)
    PVE_Style = true,               -- true or false 是否使用PVE布局（注意：PVP布局和PVE布局不能同时开启[= true]但是可以同时关闭[= false])
	PVP_Style = false,              -- true or false 是否使用PVP布局（注意：PVP布局和PVE布局不能同时开启[= true]但是可以同时关闭[= false])
---2个布局选1.或者都不选择（注意：上面PVP布局和PVE布局不能同时开启[= true]，但是可以同时关闭[= false]，当同时关闭[= false]时将恢复原系统定义布局)
    classTarget = false,            -- true or false 是否其他单位显示职业图标
	SetRune = false,                -- true or false 是否改变符文的样式和位置，（改变的话它将在屏幕中下位置以弧形排列）
    classColorPlayer = true,        -- true or false 是否渲染玩家职业框体颜色
    classColorTarget = true,        -- true or false 是否渲染目标职业框体颜色
    classColorFocus = true,         -- true or false 是否渲染焦点职业框体颜色
    classColorParty = true,         -- true or false 是否渲染队伍职业框体颜色
    repositionPartyText = false,    -- true or false 是否重新定位队伍文本
    largeAuraSize = 24,             -- Blizzard default value is 21
    smallAuraSize = 18,             -- Blizzard default value is 17
    customStatusText = true,        -- true or false (是否自定义状态文本)
    autoManaPercent = true,         -- true or false (是否用百分比显示法力值)
    thousandSeparators = true,      -- true or false  是否在1000...1000.000...1000.000.000的.上添加空位隔符
    simpleHealth = true,            -- 是否用K.M.G来精简计数 199.999 (200.000 to 200 k, 3.000.000 to 3 m)
	RaidHide = false,               -- 是否隐藏暴雪系统团队框体
}

UnitFrames.config.phrases = {
    ["1000 separator"] = " ",
    ["Dead"] = "|cFFFFFFFF死亡|r",
    ["Ghost"] = "|cFFFFFFFF鬼魂|r",
    ["Offline"] = "|cFFFFFFFF離綫|r",
    ["kilo"] = " k",  -- simpleHealth 1.000
    ["mega"] = " m",  -- simpleHealth 1.000.000
    ["giga"] = " g",  -- simpleHealth 1.000.000.000
}

--[[ 设置位置 ]]

if UnitFrames.config.PVE_Style then
--PVE布局
TargetFrame:ClearAllPoints() 
TargetFrame:SetPoint("CENTER", 200, -165) --目标框体位置

TargetFrameToT:ClearAllPoints()
TargetFrameToT:SetPoint("LEFT",TargetFrame,"Top", -15, -1)  --目标的目标的框体位置

TargetFrameToTTextureFrameName:ClearAllPoints() 
TargetFrameToTTextureFrameName:SetPoint("LEFT",TargetFrameToT,"Top", -1, -8)  --目标的目标的名字位置

FocusFrame:SetPoint("TOPLEFT", 250, -140) --焦点的框体位置
FocusFrameToT:SetPoint("BOTTOMRIGHT", -35, -13)  --焦点目标的框体位置

PartyMemberFrame1:ClearAllPoints() 
PartyMemberFrame1:SetPoint("TOPLEFT", 150, -240)  --队伍的框体位置

Boss1TargetFrame:ClearAllPoints() 
Boss1TargetFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",-140,-430) --BOSS框体的位置
Boss1TargetFrame.SetPoint=function()end

TargetFrameSpellBar:ClearAllPoints()
TargetFrameSpellBar:SetPoint("CENTER", UIParent, "CENTER", 0, -80) ---目标施法条的位置
TargetFrameSpellBar.SetPoint=function()end

--[[ 玩家框体固定 ]]
local function ScrewYouPlayerFrame()
	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint("CENTER", -200, -165) --玩家框体的位置
 end

hooksecurefunc("PlayerFrame_AnimateOut", function() PlayerFrame:SetAlpha(0); ScrewYouPlayerFrame() end)
hooksecurefunc("PlayerFrame_SequenceFinished", function() PlayerFrame:SetAlpha(1); ScrewYouPlayerFrame() end)
hooksecurefunc("PlayerFrame_UpdateStatus", ScrewYouPlayerFrame)

elseif UnitFrames.config.PVP_Style then
--PVP布局
TargetFrame:ClearAllPoints() 
TargetFrame:SetPoint("TOPRIGHT",PlayerFrame,"TOPRIGHT",100,-90) --目标框体位置

PetFrame:ClearAllPoints() 
PetFrame:SetPoint("TOPRIGHT",PlayerFrame,"TOPRIGHT",-220,-20) --目标框体位置

PartyMemberFrame1:ClearAllPoints() 
PartyMemberFrame1:SetPoint("TOPLEFT", 10, -200)  --队伍的框体位置

FocusFrame:SetPoint("TOPLEFT", 250, -500) --焦点的框体位置
FocusFrameToT:SetPoint("BOTTOMRIGHT", -35, -13)  --焦点目标的框体位置

Boss1TargetFrame:ClearAllPoints() 
Boss1TargetFrame:SetPoint("TOPRIGHT",UIParent,"TOPRIGHT",-140,-430) --BOSS框体的位置
Boss1TargetFrame.SetPoint=function()end

--[[ 玩家框体固定 ]]
local function ScrewYouPlayerFrame()
	PlayerFrame:ClearAllPoints()
	PlayerFrame:SetPoint("TOPLEFT", 150, -150) --玩家框体的位置
 end

hooksecurefunc("PlayerFrame_AnimateOut", function() PlayerFrame:SetAlpha(0); ScrewYouPlayerFrame() end)
hooksecurefunc("PlayerFrame_SequenceFinished", function() PlayerFrame:SetAlpha(1); ScrewYouPlayerFrame() end)
hooksecurefunc("PlayerFrame_UpdateStatus", ScrewYouPlayerFrame)

else 
--原系统样式
PartyMemberFrame1:ClearAllPoints() 
PartyMemberFrame1:SetPoint("TOPLEFT", 10, -120)  --队伍的框体位置
 end

--[[ 缩放设置 ]]
PlayerFrame:SetScale("1.0")
TargetFrame:SetScale("1.0")
for i=1,4 do _G["PartyMemberFrame"..i]:SetScale("1.3") end
Boss1TargetFrame:SetScale("1.0")
Boss2TargetFrame:SetScale("1.0")
Boss3TargetFrame:SetScale("1.0")
TargetFrameSpellBar:SetScale("1.1")
ComboFrame:SetScale("1.1")

--[[ 玩家施法条 ]]
local cbf = "CastingBarFrame"
local cbbs = "Interface\\CastingBar\\UI-CastingBar-Border-Small"
local cbfs = "Interface\\CastingBar\\UI-CastingBar-Flash-Small"

_G[cbf]:SetSize(140,10)
_G[cbf.."Border"]:SetSize(190,40)
_G[cbf.."Border"]:SetPoint("TOP", _G[cbf], 0, 15)
_G[cbf.."Border"]:SetTexture(cbbs)
_G[cbf.."Flash"]:SetSize(190,40)
_G[cbf]:SetScale("1.2")
_G[cbf.."Flash"]:SetPoint("TOP", _G[cbf], 0, 15)
_G[cbf.."Flash"]:SetTexture(cbfs)
_G[cbf.."Text"]:SetPoint("TOP", _G[cbf], 0, 4)
_G[cbf]:ClearAllPoints()
if UnitFrames.config.PVE_Style then
_G[cbf]:SetPoint("TOP", WorldFrame, "BOTTOM", 0, 130) --自己施法条的位置
_G[cbf].SetPoint = function() end
end
_G[cbf.."Icon"]:Show()
_G[cbf.."Icon"]:SetHeight(20)
_G[cbf.."Icon"]:SetWidth(20)

--[[ 施法计时]]
_G[cbf].timer = _G[cbf]:CreateFontString(nil)
_G[cbf].timer:SetFont(GameFontNormal:GetFont(), 14, "THINOUTLINE")
_G[cbf].timer:SetPoint("RIGHT", _G[cbf], "RIGHT", 24, 0)
_G[cbf].update = .1

local tcbf = "TargetFrameSpellBar"
_G[tcbf].timer = _G[tcbf]:CreateFontString(nil)
_G[tcbf].timer:SetFont(GameFontNormal:GetFont(), 14, "THINOUTLINE")
_G[tcbf].timer:SetPoint("RIGHT", _G[tcbf], "RIGHT", 24, 0)
_G[tcbf].update = .1

local fcbf = "FocusFrameSpellBar"
_G[fcbf].timer = _G[fcbf]:CreateFontString(nil)
_G[fcbf].timer:SetFont(GameFontNormal:GetFont(), 14, "THINOUTLINE")
_G[fcbf].timer:SetPoint("RIGHT", _G[fcbf], "RIGHT", 24, 0)
_G[fcbf].update = .1

hooksecurefunc("CastingBarFrame_OnUpdate", function(self, elapsed)
	if not self.timer then return end
	if self.update and self.update < elapsed then
		if self.casting then
			self.timer:SetText(format("%.1f", max(self.maxValue - self.value, 0)))
		elseif self.channeling then
			self.timer:SetText(format("%.1f", max(self.value, 0)))
		else
			self.timer:SetText("")
		end
		self.update = .1
	else
		self.update = self.update - elapsed
	end
end)

--[[ 焦点施法条 ]]
hooksecurefunc(FocusFrameSpellBar, "Show", function()
    FocusFrameSpellBar:SetScale("1.1")
	if UnitFrames.config.PVE_Style then
	FocusFrameSpellBar:ClearAllPoints()
	FocusFrameSpellBar:SetPoint("CENTER", UIParent, "CENTER", 0, 200)  --焦点施法条的位置
	FocusFrameSpellBar.SetPoint = function() end
	end
end)
FocusFrameSpellBar:SetStatusBarColor(0,0.45,0.9); FocusFrameSpellBar.SetStatusBarColor = function() end

if UnitFrames.config.SetRune or UnitFrames.config.PVE_Style then
--[[ 符文 ]]
RuneFrame:ClearAllPoints() 
RuneFrame:SetPoint("CENTER",UIParent,"CENTER",0,-170) --符文的框体位置
RuneFrame.SetPoint = function() end
for i=1,6 do _G["RuneButtonIndividual"..i]:SetScale("1.1") end
for i=1,6 do _G["RuneButtonIndividual"..i]:ClearAllPoints() end
RuneButtonIndividual3:SetPoint("CENTER",-12,0)
RuneButtonIndividual4:SetPoint("CENTER",12,0)
RuneButtonIndividual2:SetPoint("RIGHT",RuneButtonIndividual3,"LEFT",-4,8)
RuneButtonIndividual1:SetPoint("RIGHT",RuneButtonIndividual2,"LEFT",-4,8)
RuneButtonIndividual5:SetPoint("LEFT",RuneButtonIndividual4,"RIGHT",4,8)
RuneButtonIndividual6:SetPoint("LEFT",RuneButtonIndividual5,"RIGHT",4,8)
end

--[[ 隐藏pvp图标 ]]
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)

--[[ 隐藏战斗伤害文本 ]]
PetHitIndicator:ClearAllPoints() 
PlayerHitIndicator:ClearAllPoints()

--[[ 图标 ]]
if UnitFrames.config.classTarget then
UFP = "UnitFramePortrait_Update"; 
UICC = "Interface\\TargetingFrame\\UI-Classes-Circles"; 
CIT = CLASS_ICON_TCOORDS

hooksecurefunc(UFP,function(self) 
 if self.portrait then
  if self.unit == "player" or self.unit == "pet" or self.unit == "partypet1" or self.unit == "partypet2" or self.unit == "partypet3" or self.unit == "partypet4" then return end
   local t = CIT[select(2,UnitClass(self.unit))] 
 if t 
  then self.portrait:SetTexture(UICC) self.portrait:SetTexCoord(unpack(t)) end end end)
end


---------------------------------------------------
-- 特定配置
---------------------------------------------------
if class == "PRIEST" then
    UnitFrames.config.largeAuraSize = 24
    UnitFrames.config.smallAuraSize = 18
    UnitFrames.config.autoManaPercent = false
end
if class == "DRUID" then
    UnitFrames.config.repositionPartyText = false
end
if class == "MAGE" then
    UnitFrames.config.repositionPartyText = false
end
if class == "PALADIN" then
    UnitFrames.config.repositionPartyText = false
end
if class == "SHAMAN" then
    UnitFrames.config.repositionPartyText = false
end
if class == "WARLOCK" then
    UnitFrames.config.repositionPartyText = false
end
if class == "DEATHKNIGHT" then
    UnitFrames.config.repositionPartyText = false
end
if class == "HUNTER" then
    UnitFrames.config.repositionPartyText = false
end
if class == "ROGUE" then
    UnitFrames.config.autoManaPercent = false
end
if class == "WARRIOR" then
    UnitFrames.config.repositionPartyText = false
end
if class == "MONK" then
    UnitFrames.config.repositionPartyText = false
end

-------------------------------------------------------------------

local config = UnitFrames.config
local _, class = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
local color = nil
local h, hMax, hPercent, m, mMax, mPercent = 0

---------------------------------------------------
-- 队伍
---------------------------------------------------
local function partyMembersChanged()
    local partyMembers = GetNumSubgroupMembers()
    if not InCombatLockdown() and partyMembers > 0 then
        for i = 1, partyMembers do
            color = RAID_CLASS_COLORS[select(2, UnitClass("party"..i))]
            if color then
                _G["PartyMemberFrame"..i.."HealthBar"]:SetStatusBarColor(color.r, color.g, color.b)
                _G["PartyMemberFrame"..i.."HealthBar"].lockColor = true
            end
            if config.repositionPartyText then
                _G["PartyMemberFrame"..i.."HealthBarText"]:ClearAllPoints()
                _G["PartyMemberFrame"..i.."HealthBarText"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."HealthBar"], "RIGHT", 0, 0)
                _G["PartyMemberFrame"..i.."ManaBarText"]:ClearAllPoints()
                _G["PartyMemberFrame"..i.."ManaBarText"]:SetPoint("LEFT", _G["PartyMemberFrame"..i.."ManaBar"], "RIGHT", 0, 0)
            end    
        end
    end
end

---------------------------------------------------
-- 玩家框架
---------------------------------------------------
local function playerFrame()
    if not UnitHasVehicleUI("player") then
        PlayerName:SetWidth(0.01)
        PlayerFrameGroupIndicatorText:ClearAllPoints()
        PlayerFrameGroupIndicatorText:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", 0, -16)
        PlayerFrameGroupIndicatorLeft:Hide()
        PlayerFrameGroupIndicatorMiddle:Hide()
        PlayerFrameGroupIndicatorRight:Hide()
        PlayerFrameHealthBar:ClearAllPoints()
        PlayerFrameHealthBar:SetPoint("TOPLEFT", 106, -24)
        PlayerFrameHealthBar:SetHeight(26)
        if classcolor and config.classColorPlayer then
            PlayerFrameHealthBar:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b)
            PlayerFrameHealthBar.lockColor = true
        else
            color = FACTION_BAR_COLORS[8] -- 8 is exalted
            if color then
                PlayerFrameHealthBar:SetStatusBarColor(color.r, color.g, color.b)
                PlayerFrameHealthBar.lockColor = true
            end
        end
        PlayerFrameHealthBarText:ClearAllPoints()
        PlayerFrameHealthBarText:SetPoint("CENTER", PlayerFrameHealthBar, "CENTER", 0, 0)
        PlayerFrameManaBar:ClearAllPoints()
        PlayerFrameManaBar:SetPoint("TOPLEFT", 106, -52)
        PlayerFrameManaBar:SetHeight(13)
        PlayerFrameManaBarText:ClearAllPoints()
        PlayerFrameManaBarText:SetPoint("CENTER", PlayerFrameManaBar, "CENTER", 0, 0)
    else
        if config.classColorPlayer then
            color = FACTION_BAR_COLORS[8] -- 8 is exalted
            if color then
                PlayerFrameHealthBar:SetStatusBarColor(color.r, color.g, color.b)
                PlayerFrameHealthBar.lockColor = true
            end
        end
        PlayerFrameHealthBar:SetHeight(12)
        PlayerFrameManaBar:SetHeight(12)
    end
end
hooksecurefunc("PlayerFrame_UpdateArt", playerFrame)
hooksecurefunc("PlayerFrame_SequenceFinished", playerFrame)

---------------------------------------------------
-- 目标框体
---------------------------------------------------
local function targetFrame()
	TargetFrame.Background:SetPoint("TOPLEFT",7,-22);
    TargetFrame.deadText:ClearAllPoints()
    TargetFrame.deadText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
    TargetFrameTextureFrameName:ClearAllPoints()
    TargetFrameTextureFrameName:SetPoint("BOTTOMRIGHT", TargetFrame, "TOP", 0, -16)
    TargetFrameHealthBar:ClearAllPoints()
    TargetFrameHealthBar:SetPoint("TOPLEFT", 5, -24)
    TargetFrameHealthBar:SetHeight(26)
    TargetFrameTextureFrameHealthBarText:ClearAllPoints()
    TargetFrameTextureFrameHealthBarText:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 0)
    TargetFrameManaBar:ClearAllPoints()
    TargetFrameManaBar:SetPoint("TOPLEFT", 5, -52)
    TargetFrameManaBar:SetHeight(13)
    TargetFrameTextureFrameManaBarText:ClearAllPoints()
    TargetFrameTextureFrameManaBarText:SetPoint("CENTER", TargetFrameManaBar, "CENTER", 0, 0)
    TargetFrame.threatNumericIndicator:SetPoint("BOTTOM", PlayerFrame, "TOP", 75, -22)
end

local function targetChanged()
    if UnitIsPlayer("target") and config.classColorTarget then
        color = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
    else
        color = FACTION_BAR_COLORS[UnitReaction("target", "player")]
    end
    if ( not UnitPlayerControlled("target") and UnitIsTapped("target") and not UnitIsTappedByPlayer("target") and not UnitIsTappedByAllThreatList("target") ) then
        TargetFrameHealthBar:SetStatusBarColor(0.5, 0.5, 0.5)
    else
        if color then
            TargetFrameHealthBar:SetStatusBarColor(color.r, color.g, color.b)
            TargetFrameHealthBar.lockColor = true
        end
    end
	TargetFrame.nameBackground:Hide()
end
hooksecurefunc("TargetFrame_CheckFaction", targetChanged)

-- 来自TargetFrame.lua守则
function targetUpdateAuraPositions(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX)
    -- 光环定位
    local AURA_OFFSET_Y = 3;
    local LARGE_AURA_SIZE = config.largeAuraSize;
    local SMALL_AURA_SIZE = config.smallAuraSize;
    local size;
    local offsetY = AURA_OFFSET_Y;
    local rowWidth = 0;
    local firstBuffOnRow = 1;
    for i=1, numAuras do
        if ( largeAuraList[i] ) then
            size = LARGE_AURA_SIZE;
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y;
        else
            size = SMALL_AURA_SIZE;
        end
        if ( i == 1 ) then
            rowWidth = size;
            self.auraRows = self.auraRows + 1;
        else
            rowWidth = rowWidth + size + offsetX;
        end
        if ( rowWidth > maxRowWidth ) then
            updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY);
            rowWidth = size;
            self.auraRows = self.auraRows + 1;
            firstBuffOnRow = i;
            offsetY = AURA_OFFSET_Y;
        else
            updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY);
        end
    end
end
hooksecurefunc("TargetFrame_UpdateAuraPositions", targetUpdateAuraPositions)


---------------------------------------------------
-- 焦点框体
---------------------------------------------------
local function focusFrame()
	FocusFrame.Background:SetPoint("TOPLEFT",7,-22);
    FocusFrame.deadText:ClearAllPoints()
    FocusFrame.deadText:SetPoint("CENTER", FocusFrameHealthBar, "CENTER", 0, 0)
    FocusFrameTextureFrameName:ClearAllPoints()
    FocusFrameHealthBar:ClearAllPoints()
    FocusFrameHealthBar:SetPoint("TOPLEFT", 5, -24)
    FocusFrameHealthBar:SetHeight(26)
    FocusFrameManaBar:ClearAllPoints()
    FocusFrameManaBar:SetPoint("TOPLEFT", 5, -52)
    FocusFrameManaBar:SetHeight(13)
    FocusFrame.threatNumericIndicator:SetWidth(0.01)
    FocusFrame.threatNumericIndicator.bg:Hide()
    FocusFrame.threatNumericIndicator.text:Hide()
    FocusFrameTextureFrameHealthBarText:ClearAllPoints()
    FocusFrameTextureFrameHealthBarText:SetPoint("CENTER", FocusFrameHealthBar, "CENTER", 0, 0)
    FocusFrameTextureFrameManaBarText:ClearAllPoints()
    FocusFrameTextureFrameManaBarText:SetPoint("CENTER", FocusFrameManaBar, "CENTER", 0, 0)
end

local function focusChanged()
    if UnitIsPlayer("focus") and config.classColorFocus then
        color = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
    else
        color = FACTION_BAR_COLORS[UnitReaction("focus", "player")]
    end
    if color then
        FocusFrameHealthBar:SetStatusBarColor(color.r, color.g, color.b)
        FocusFrameHealthBar.lockColor = true
    end
	FocusFrame.nameBackground:Hide()
end

---------------------------------------------------
-- 队伍框体 
---------------------------------------------------

    PartyMemberFrame1HealthBar:ClearAllPoints()
    PartyMemberFrame1HealthBar:SetPoint("TOPLEFT", 45, -13)
    PartyMemberFrame1HealthBar:SetHeight(10)
    PartyMemberFrame1ManaBar:ClearAllPoints()
    PartyMemberFrame1ManaBar:SetPoint("TOPLEFT", 45, -25)
    PartyMemberFrame1ManaBar:SetHeight(4)
    PartyMemberFrame2HealthBar:ClearAllPoints()
    PartyMemberFrame2HealthBar:SetPoint("TOPLEFT", 45, -13)
    PartyMemberFrame2HealthBar:SetHeight(10)
    PartyMemberFrame2ManaBar:ClearAllPoints()
    PartyMemberFrame2ManaBar:SetPoint("TOPLEFT", 45, -25)
    PartyMemberFrame2ManaBar:SetHeight(4)
    PartyMemberFrame3HealthBar:ClearAllPoints()
    PartyMemberFrame3HealthBar:SetPoint("TOPLEFT", 45, -13)
    PartyMemberFrame3HealthBar:SetHeight(10)
    PartyMemberFrame3ManaBar:ClearAllPoints()
    PartyMemberFrame3ManaBar:SetPoint("TOPLEFT", 45, -25)
    PartyMemberFrame3ManaBar:SetHeight(4)
	PartyMemberFrame4HealthBar:ClearAllPoints()
    PartyMemberFrame4HealthBar:SetPoint("TOPLEFT", 45, -13)
    PartyMemberFrame4HealthBar:SetHeight(10)
    PartyMemberFrame4ManaBar:ClearAllPoints()
    PartyMemberFrame4ManaBar:SetPoint("TOPLEFT", 45, -25)
    PartyMemberFrame4ManaBar:SetHeight(4)

---------------------------------------------------
-- 文本
---------------------------------------------------
local function createFrame(name, parent, point, xOffset, yOffset, width, alignment)
    local f = CreateFrame("Frame", name, parent)
    f:SetPoint(point, parent, point, xOffset, yOffset)
    f:SetWidth(width)
    f:SetHeight(20)
    f.text = f:CreateFontString(name.."text", "OVERLAY")
    f.text:SetAllPoints(f)
    f.text:SetFontObject(TextStatusBarText)
    f.text:SetJustifyH(alignment)
end

createFrame("fplayerdead",        PlayerFrameHealthBar, "CENTER",  0, 0, 200, "CENTER")
createFrame("fplayerpercent",     PlayerFrameHealthBar, "LEFT",    0, 0,  40, "RIGHT")
createFrame("fplayerhealth",      PlayerFrameHealthBar, "RIGHT",  -5, 0,  75, "RIGHT")
createFrame("fplayermanapercent", PlayerFrameManaBar,   "LEFT",    0, 0,  40, "RIGHT")
createFrame("fplayermana",        PlayerFrameManaBar,   "RIGHT",  -5, 0,  75, "RIGHT")

createFrame("ftargetdead",        TargetFrameHealthBar, "CENTER",  0, 0, 200, "CENTER")
createFrame("ftargetoffline",     TargetFrameManaBar,   "CENTER",  0, 0, 200, "CENTER")
createFrame("ftargetpercent",     TargetFrameHealthBar, "LEFT",    0, 0,  40, "RIGHT")
createFrame("ftargethealth",      TargetFrameHealthBar, "RIGHT",  -5, 0,  75, "RIGHT")
createFrame("ftargetmanapercent", TargetFrameManaBar,   "LEFT",    0, 0,  40, "RIGHT")
createFrame("ftargetmana",        TargetFrameManaBar,   "RIGHT",  -5, 0,  75, "RIGHT")

createFrame("ffocusdead",         FocusFrameHealthBar,  "CENTER",  0, 0, 200, "CENTER")
createFrame("ffocusoffline",      FocusFrameManaBar,    "CENTER",  0, 0, 200, "CENTER")
createFrame("ffocuspercent",      FocusFrameHealthBar,  "LEFT",    0, 0,  40, "RIGHT")
createFrame("ffocushealth",       FocusFrameHealthBar,  "RIGHT",  -5, 0,  75, "RIGHT")
createFrame("ffocusmanapercent",  FocusFrameManaBar,    "LEFT",    0, 0,  40, "RIGHT")
createFrame("ffocusmana",         FocusFrameManaBar,    "RIGHT",  -5, 0,  75, "RIGHT")

local function round(n, dp)
    return math.floor((n * 10^dp) + .5) / (10^dp)
end

local function format(n)
    local strLen = strlen(n)
    if not config.customStatusText then
        return n
    end
--  if config.simpleHealth and n > 999999999 then
    if config.simpleHealth and strLen > 9 then
        return round(n/1e9, 1)..config.phrases["giga"]
--  elseif config.simpleHealth and n > 999999 then
    elseif config.simpleHealth and strLen > 6 then
        return round(n/1e6, 1)..config.phrases["mega"]
--  elseif config.simpleHealth and strLen > 5 then -- no simpleHealth under 100.000
    elseif config.simpleHealth and n > 199999 then -- no simpleHealth under 199.999
        return round(n/1e3, 0)..config.phrases["kilo"]
    elseif config.thousandSeparators then
        local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)')
        return left..(num:reverse():gsub('(%d%d%d)', '%1'..config.phrases["1000 separator"]):reverse())..right
    else
        return n
    end
end

local function unitText(unit)
    if config.customStatusText and (unit == "player" or unit == "target" or unit == "focus") then
        h = UnitHealth(unit)
        if UnitIsDeadOrGhost(unit) then
            _G["f"..unit.."health"]:Hide()
            _G["f"..unit.."percent"]:Hide()
            _G["f"..unit.."dead"]:Hide()--Show()
            if UnitIsGhost(unit) then
                _G["f"..unit.."dead"].text:SetText(config.phrases["Ghost"])
            else
                _G["f"..unit.."dead"].text:SetText(config.phrases["Dead"])
            end
        else
            _G["f"..unit.."dead"]:Hide()
            if (unit == "player" and GetCVarBool("playerStatusText")) or (not (unit == "player") and GetCVarBool("targetStatusText")) then
                _G["f"..unit.."health"]:Show()
                _G["f"..unit.."health"].text:SetText(format(h))
                if GetCVarBool("statusTextPercentage") then
                    hMax = UnitHealthMax(unit)
                    hPercent = math.floor((h / hMax) * 100)
                    _G["f"..unit.."percent"]:Show()
                    _G["f"..unit.."percent"].text:SetText(hPercent.."%")
                else
                    _G["f"..unit.."percent"]:Hide()
                end
            else
                _G["f"..unit.."health"]:Hide()
                _G["f"..unit.."percent"]:Hide()
            end
        end
        m = UnitPower(unit)
        if m > 0 then
            if UnitIsDeadOrGhost(unit) then
                _G["f"..unit.."mana"]:Hide()
                _G["f"..unit.."manapercent"]:Hide()
            elseif (unit == "player" and GetCVarBool("playerStatusText")) or (not (unit == "player") and GetCVarBool("targetStatusText")) then
                _G["f"..unit.."mana"]:Show()
                _G["f"..unit.."mana"].text:SetText(format(m))
                local showManaPercent = false
                if config.autoManaPercent then
                    if UnitPowerType(unit) == 0 then
                        showManaPercent = true
                    end
                end
                if GetCVarBool("statusTextPercentage") and showManaPercent then
                    mMax = UnitPowerMax(unit)
                    mPercent = math.floor((m / mMax) * 100)
                    _G["f"..unit.."manapercent"]:Show()
                    _G["f"..unit.."manapercent"].text:SetText(mPercent.."%")
                else
                    _G["f"..unit.."manapercent"]:Hide()
                end
            else
                _G["f"..unit.."mana"]:Hide()
                _G["f"..unit.."manapercent"]:Hide()
            end
        else
            _G["f"..unit.."mana"]:Hide()
            _G["f"..unit.."manapercent"]:Hide()
        end
        if unit == "target" or unit == "focus" then
            if UnitIsConnected(unit) then
                _G["f"..unit.."offline"]:Hide()
            else
                _G["f"..unit.."offline"]:Show()
                _G["f"..unit.."mana"]:Hide()
                _G["f"..unit.."manapercent"]:Hide()
            end
        end
    end
end

---------------------------------------------------
-- 更新
---------------------------------------------------
if config.customStatusText then
    function PlayerFrameHealthBarText:Show() end
    function PlayerFrameManaBarText:Show() end
    function TargetFrameTextureFrameHealthBarText:Show() end
    function TargetFrameTextureFrameManaBarText:Show() end
    function FocusFrameTextureFrameHealthBarText:Show() end
    function FocusFrameTextureFrameManaBarText:Show() end
    PlayerFrameHealthBarText:Hide()
    PlayerFrameManaBarText:Hide()
    TargetFrameTextureFrameHealthBarText:Hide()
    TargetFrameTextureFrameManaBarText:Hide()
    FocusFrameTextureFrameHealthBarText:Hide()
    FocusFrameTextureFrameManaBarText:Hide()
end

local function cvarUpdate()
    if GetCVarBool("fullSizeFocusFrame") then
        FocusFrameTextureFrameName:SetPoint("BOTTOMRIGHT", FocusFrame, "TOP", 0, -16)
    else
        FocusFrameTextureFrameName:SetPoint("BOTTOMRIGHT", FocusFrame, "TOP", 10, -16)
    end
    unitText("player")
    unitText("target")
    unitText("focus")
end

---------------------------------------------------
-- 事件
---------------------------------------------------
local w = CreateFrame("Frame")
w:RegisterEvent("PLAYER_ENTERING_WORLD")
w:RegisterEvent("PLAYER_REGEN_ENABLED")
w:RegisterEvent("PLAYER_TARGET_CHANGED")
w:RegisterEvent("PLAYER_FOCUS_CHANGED")
w:RegisterEvent("CVAR_UPDATE")
w:RegisterEvent("UNIT_HEALTH")
w:RegisterEvent("UNIT_POWER")
if config.classColorParty then
    w:RegisterEvent("PARTY_MEMBERS_CHANGED")
end
function w:OnEvent(event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        playerFrame()
        targetFrame()
        focusFrame()
        cvarUpdate()
        unitText("player")
    elseif event == "PLAYER_REGEN_ENABLED" then
        playerFrame()
    elseif event == "PLAYER_TARGET_CHANGED" then
        targetChanged()
        unitText("target")
    elseif event == "PLAYER_FOCUS_CHANGED" then
        focusChanged()
        unitText("focus")
    elseif event == "UNIT_HEALTH" or event == "UNIT_POWER" then
        local arg1 = ...
        unitText(arg1)
    elseif event == "CVAR_UPDATE" then
        cvarUpdate()
    elseif event == "PARTY_MEMBERS_CHANGED" then
        partyMembersChanged()
    end
end
w:SetScript("OnEvent", w.OnEvent)

--隐藏系统团队

if UnitFrames.config.RaidHide then
 local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:SetScript("OnEvent", function(self, event)
			CompactRaidFrameManager:UnregisterAllEvents()
			CompactRaidFrameManager:Hide()
			CompactRaidFrameContainer:UnregisterAllEvents()
			CompactRaidFrameContainer:Hide()
    end)
end
