--动作条增强
--by Binny

local BarScale = 0.9
local HideMainButtonArt = false
local HideExperienceBar = false

local MenuButtonFrames = {
	HelpMicroButton,
	MainMenuMicroButton,
	EJMicroButton,
	CompanionsMicroButton,		-- Added for 5.x
	LFDMicroButton,
	PVPMicroButton,
	GuildMicroButton,
	QuestLogMicroButton,
	AchievementMicroButton,
	TalentMicroButton,
	SpellbookMicroButton,
	CharacterMicroButton,
}

local BagButtonFrameList = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot,
	CharacterBag1Slot,
	CharacterBag2Slot,
	CharacterBag3Slot,
	KeyRingButton,
}
			
local ButtonGridIsShown = false
local Empty_Art = "Interface\\Addons\\MysteryUI\\MyMedia\\Empty"
local MouseInSidebar, MouseInCorner = false

local Bar = CreateFrame("Frame", "Bar", WorldFrame)
local CornerMenuFrame = CreateFrame("Frame", "Bar_CornerMenuFrame", UIParent)
local SideMouseoverFrame = CreateFrame("Frame", "Bar_SideBarMouseoverFrame", UIParent)
local CornerMouseoverFrame = CreateFrame("Frame", "Bar_CornerBarMouseoverFrame", UIParent)

local SetSidebarAlpha

CornerMenuFrame:SetFrameStrata("LOW")
CornerMenuFrame:SetWidth(300)
CornerMenuFrame:SetHeight(128)
CornerMenuFrame:SetPoint("BOTTOMRIGHT")
CornerMenuFrame:SetScale(BarScale)
CornerMenuFrame.MicroButtons = CreateFrame("Frame", nil, CornerMenuFrame)
CornerMenuFrame.BagButtonFrame = CreateFrame("Frame", nil, CornerMenuFrame)

-- 事件更新

local DelayedEventWatcher = CreateFrame("Frame")
local DelayedEvents = {}
local function CheckDelayedEvent(self)
	local pendingEvents, currentTime = 0, GetTime()
	for functionToCall, timeToCall in pairs(DelayedEvents) do
		if currentTime > timeToCall then
			DelayedEvents[functionToCall] = nil
			functionToCall()
		end
	end
	-- 检查后防止丢失
	for functionToCall, timeToCall in pairs(DelayedEvents) do pendingEvents = pendingEvents + 1 end
	if pendingEvents == 0 then DelayedEventWatcher:SetScript("OnUpdate", nil) end
end
local function DelayEvent(functionToCall, timeToCall)
	DelayedEvents[functionToCall] = timeToCall
	DelayedEventWatcher:SetScript("OnUpdate", CheckDelayedEvent)
end

-- 事件更新

local function ForceTransparent(frame) 
		frame:Hide()
		frame:SetAlpha(0)
end

local function RefreshMainActionBars()
	local anchor
	local anchorOffset = 4
	local repOffset = 0
	local initialOffset = 32
	
	-- [[
	-- 隐藏声望条
	if HideExperienceBar == true or HideMainButtonArt == true then
		MainMenuExpBar:Hide()
		ReputationWatchBar:Hide()
	end
	--]]
	
	if MainMenuExpBar:IsShown() then repOffset = 9 end
	if ReputationWatchBar:IsShown() then repOffset = repOffset + 9 end
		
	if MultiBarBottomLeft:IsShown() then
		anchor = MultiBarBottomLeft
		anchorOffset = 4
	else
		anchor = ActionButton1;
		anchorOffset = 8 + repOffset
	end
	
	if MultiBarBottomRight:IsShown() then
		--print("MultiBarBottomRight")
		MultiBarBottomRight:ClearAllPoints()
		MultiBarBottomRight:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset )
		anchor = MultiBarBottomRight
		anchorOffset = 4
	end
	
	-- 宠物动作条, PetActionButton1
	if PetActionBarFrame:IsShown() then
		--print("PetActionBarFrame")
		PetActionButton1:ClearAllPoints()
		PetActionButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT",  initialOffset, anchorOffset)
		anchor = PetActionButton1
		anchorOffset = 4
	end
	
	-- [[ 姿态栏
	if StanceBarFrame:IsShown() then
		--print("StanceBarFrame")
		StanceButton1:ClearAllPoints();
		StanceButton1:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset+4);
		anchor = StanceButton1
		--anchorOffset = 4
		anchorOffset = 4
	end
	--]]

	-- PossessBarFrame, PossessButton1
	PossessBarFrame:ClearAllPoints();
	PossessBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, anchorOffset);		
end

	
function SetSidebarAlpha()
	local Alpha = 0
	if MouseInSidebar or ButtonGridIsShown then Alpha = 1 end
	if SpellFlyout:IsShown() then 
		DelayEvent(SetSidebarAlpha, GetTime()+.5)
	else
		for i = 1, 12 do
			_G["MultiBarRightButton"..i]:SetAlpha(Alpha);
			_G["MultiBarLeftButton"..i]:SetAlpha(Alpha);
		end
	end

end

local function HookFrame_Microbuttons(frameTarget)
	frameTarget:HookScript("OnEnter", function() if not UnitHasVehicleUI("player") then CornerMenuFrame:SetAlpha(1) end end)
	frameTarget:HookScript("OnLeave", function() CornerMenuFrame:SetAlpha(0) end)
end

local function HookFrame_CornerBar(frameTarget)
	frameTarget:HookScript("OnEnter", function() CornerMenuFrame:SetAlpha(1) end)
	frameTarget:HookScript("OnLeave", function() CornerMenuFrame:SetAlpha(0) end)
end

local function HookFrame_SideBar(frameTarget)
	frameTarget:HookScript("OnEnter", function() MouseInSidebar = true; SetSidebarAlpha() end)
	frameTarget:HookScript("OnLeave", function() MouseInSidebar = false; SetSidebarAlpha() end)
end

local function ConfigureCornerBars()
	if not UnitHasVehicleUI("player") then 
		CharacterMicroButton:ClearAllPoints();
		CharacterMicroButton:SetPoint("BOTTOMRIGHT", CornerMenuFrame.MicroButtons, "BOTTOMRIGHT", -270, 0);
		for i, name in pairs(MenuButtonFrames) do name:SetParent(CornerMenuFrame.MicroButtons) end
	end
end

local function ConfigureSideBars()
	-- 右侧动作条
	if MultiBarRight:IsShown() then
		SideMouseoverFrame:Show()
		MultiBarRight:EnableMouse();
		SideMouseoverFrame:SetPoint("BOTTOMRIGHT", MultiBarRight, "BOTTOMRIGHT", 0,0)
		-- 右侧动作条2
		if MultiBarLeft:IsShown() then
			MultiBarLeft:EnableMouse();
			SideMouseoverFrame:SetPoint("TOPLEFT", MultiBarLeft, "TOPLEFT", -6,0)	
		else SideMouseoverFrame:SetPoint("TOPLEFT", MultiBarRight, "TOPLEFT", -6,0) end
	else SideMouseoverFrame:Hide() 	end
end

local function RefreshPositions()
	if InCombatLockdown() then return end 
	-- 改变中央按钮和状态栏的大小
    MainMenuBar:SetWidth(512);
	MainMenuExpBar:SetWidth(512);
    ReputationWatchBar:SetWidth(512);
    MainMenuBarMaxLevelBar:SetWidth(512);
    ReputationWatchStatusBar:SetWidth(512);
	
	-- 隐藏背景
	ForceTransparent(SlidingActionBarTexture0)
	ForceTransparent(SlidingActionBarTexture1)
	-- [[ 变身，光环，姿态栏
    ForceTransparent(StanceBarLeft)
    ForceTransparent(StanceBarMiddle)
    ForceTransparent(StanceBarRight)
	--]]
    ForceTransparent(PossessBackground1)
    ForceTransparent(PossessBackground2)

	ConfigureSideBars()
    RefreshMainActionBars()
	ConfigureCornerBars()
end

	
-- 事件处理
local events = {}

function events:ACTIONBAR_SHOWGRID() ButtonGridIsShown = true; SetSidebarAlpha() end
function events:ACTIONBAR_HIDEGRID() ButtonGridIsShown = false; SetSidebarAlpha() end
function events:UNIT_EXITED_VEHICLE()  RefreshPositions(); DelayEvent(ConfigureCornerBars, GetTime()+1) end	-- Echos the event to verify positions
events.PLAYER_ENTERING_WORLD = RefreshPositions
events.UPDATE_INSTANCE_INFO = RefreshPositions	
events.PLAYER_TALENT_UPDATE = RefreshPositions
events.PLAYER_LEVEL_UP = RefreshPositions
events.ACTIVE_TALENT_GROUP_CHANGED = RefreshPositions
events.SPELL_UPDATE_USEABLE = RefreshPositions
events.PET_BAR_UPDATE = RefreshPositions
events.UNIT_ENTERED_VEHICLE = RefreshPositions
events.UPDATE_BONUS_ACTIONBAR = RefreshPositions
events.UPDATE_MULTI_CAST_ACTIONBAR = RefreshPositions
events.CLOSE_WORLD_MAP = RefreshPositions
events.PLAYER_LEVEL_UP = RefreshPositions

local function EventHandler(frame, event) 
	if events[event] then 
		--print(GetTime(), event)
		events[event]() 
	end 
end

-- 设置事件监测
for eventname in pairs(events) do 
	Bar:RegisterEvent(eventname)
end

-----------------------------------------------------------------------------
-- 操作菜单和背包
do
	-- 调用更新的函数时，默认界面的变化
	hooksecurefunc("UIParent_ManageFramePositions", RefreshPositions);
	-- 按照要求移动
	UIPARENT_MANAGED_FRAME_POSITIONS["MultiBarBottomRight"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PetActionBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["ShapeshiftBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["PossessBarFrame"] = nil
	UIPARENT_MANAGED_FRAME_POSITIONS["MultiCastActionBarFrame"] = nil
	
	-- 缩放
	MainMenuBar:SetScale(BarScale)
	MultiBarRight:SetScale(BarScale)
	MultiBarLeft:SetScale(BarScale)

	-- 调整填充
	MainMenuBarTexture0:SetPoint("LEFT", MainMenuBar, "LEFT", 0, 0);
    MainMenuBarTexture1:SetPoint("RIGHT", MainMenuBar, "RIGHT", 0, 0);
 	MainMenuBarLeftEndCap:SetPoint("RIGHT", MainMenuBar, "LEFT", 32, 0);
    MainMenuBarRightEndCap:SetPoint("LEFT", MainMenuBar, "RIGHT", -32, 0); 
	
	-- 隐藏一些不需要的
	for i = 1, 10 do
		_G["StanceButton"..i.."NormalTexture2"]:SetTexture(Empty_Art)
	end
	
	-- 隐藏一些不需要的
	MainMenuBarPageNumber:Hide();
    ActionBarUpButton:Hide();
    ActionBarDownButton:Hide();
	-- 经验条
	MainMenuBarTexture2:SetTexture(Empty_Art)
	MainMenuBarTexture3:SetTexture(Empty_Art)
	MainMenuBarTexture2:SetAlpha(0)
	MainMenuBarTexture3:SetAlpha(0)
	for i=1,19 do _G["MainMenuXPBarDiv"..i]:SetTexture(Empty_Art) end
	
	-- 隐藏休息状态（双倍经验）
	ExhaustionLevelFillBar:SetTexture(Empty_Art)
	ExhaustionTick:SetAlpha(0)
	
	-- 最高等级声望条
	MainMenuMaxLevelBar0:SetAlpha(0)
	MainMenuMaxLevelBar1:SetAlpha(0)
	MainMenuMaxLevelBar2:SetAlpha(0)
	MainMenuMaxLevelBar3:SetAlpha(0)
	-- 声望条背景 (对于声望条)
	ReputationWatchBarTexture0:SetAlpha(0)
	ReputationWatchBarTexture1:SetAlpha(0)
	ReputationWatchBarTexture2:SetAlpha(0)
	ReputationWatchBarTexture3:SetAlpha(0)
	-- 声望条背景 (对于经验条)
	ReputationXPBarTexture0:SetAlpha(0)
	ReputationXPBarTexture1:SetAlpha(0)
	ReputationXPBarTexture2:SetAlpha(0)
	ReputationXPBarTexture3:SetAlpha(0)

	-- 设置宠物动作条
	PetActionBarFrame:SetAttribute("unit", "pet")
	RegisterUnitWatch(PetActionBarFrame)

	-- 设置鼠标悬停
	ConfigureSideBars()
	SetSidebarAlpha()
	ConfigureCornerBars()
	CornerMenuFrame:SetAlpha(0)
	
	if HideMainButtonArt == true then
		-- 隐藏标准背景
		MainMenuBarTexture0:Hide()
		MainMenuBarTexture1:Hide()
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
	end
	
	MainMenuBar:HookScript("OnShow", function() 
		--print("Showing")
		RefreshPositions() 
	end)
end

-----------------------------------------------------------------------------
-- 侧面动作条
do
	-- 安装侧面动作条
	SideMouseoverFrame:SetScript("OnEnter", function() MouseInSidebar = true; SetSidebarAlpha() end)
	SideMouseoverFrame:SetScript("OnLeave", function() MouseInSidebar = false;SetSidebarAlpha() end)
	SideMouseoverFrame:EnableMouse();
	
	HookFrame_SideBar(MultiBarRight)
	HookFrame_SideBar(MultiBarLeft)
	for i = 1, 12 do HookFrame_SideBar( _G["MultiBarRightButton"..i] ) end
	for i = 1, 12 do HookFrame_SideBar( _G["MultiBarLeftButton"..i] ) end
end

-----------------------------------------------------------------------------
-- 角落菜单
do
	-- 钥匙链
	for i, name in pairs(BagButtonFrameList) do
		name:SetParent(CornerMenuFrame.BagButtonFrame)
	end
	
    MainMenuBarBackpackButton:ClearAllPoints();
	MainMenuBarBackpackButton:SetPoint("BOTTOM");
	MainMenuBarBackpackButton:SetPoint("RIGHT", -60, 0);
	--MainMenuBarBackpackButton:SetScale(.8)
	
	-- 设置上下翻查按钮
	for i, name in pairs(BagButtonFrameList) do HookFrame_CornerBar( name) end
	for i, name in pairs(MenuButtonFrames) do HookFrame_Microbuttons( name) end

	-- 两只鸟
	CornerMenuFrame:SetScale(BarScale)
	CornerMenuFrame.MicroButtons:SetAllPoints(CornerMenuFrame)
	CornerMenuFrame.BagButtonFrame:SetPoint("TOPRIGHT", 2, -18)
	CornerMenuFrame.BagButtonFrame:SetHeight(64)
	CornerMenuFrame.BagButtonFrame:SetWidth(256)
	CornerMenuFrame.BagButtonFrame:SetScale(1.02)

	-- 系统菜单鼠标悬停设置
	CornerMouseoverFrame:EnableMouse();
	CornerMouseoverFrame:SetFrameStrata("BACKGROUND")

	CornerMouseoverFrame:SetPoint("TOP", MainMenuBarBackpackButton, "TOP", 0,10)
	CornerMouseoverFrame:SetPoint("RIGHT", UIParent, "RIGHT")
	CornerMouseoverFrame:SetPoint("BOTTOM", UIParent, "BOTTOM")
	CornerMouseoverFrame:SetWidth(322)

	CornerMouseoverFrame:SetScript("OnEnter", function() CornerMenuFrame:SetAlpha(1)   end)
	CornerMouseoverFrame:SetScript("OnLeave", function() CornerMenuFrame:SetAlpha(0)   end)
end

--开始菜单
Bar:SetScript("OnEvent", EventHandler);
Bar:SetFrameStrata("TOOLTIP")
Bar:Show()

--------------------------------
---超出施法距离技能显示为红色---
--------------------------------

local addonName, GreenRange = ...

-- constants
local RANGE_CHECK_INTERVAL = 0.1
local DB_VERSION = 1


-- upvalues
local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc
local ActionHasRange = ActionHasRange
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction

-- local functions
local print
--((@)) local Debug
local HandleEvent
local BuildTimer
local CacheAbstractSet

-- local functions (range)
local MarkOOR
local UnmarkOOR
local UpdateAllRanges
local ShouldWeWatchThis
local SupersedeBlizColors
local SnarfButton

-- local functions (flashing)
local UpdateAllFlashing
local AddFlash
local RemoveFlash

-- locals
local db
local optionsFrame = CreateFrame("Frame")
local OOR_R, OOR_G, OOR_B
local OOM_R, OOM_G, OOM_B

-- locals (range)
local nRanged = 0
local watchedForRange = {}
local watchedForRange_cache = {}
local watchedForRange_rebuild
local rangeTimer

-- locals (flashing)
local nFlashing = 0
local flashesCurrentlyRed = false
local flashingButtons = {}
local flashingButtons_cache = {}
local flashingButtons_rebuild
local flashingTimer

local Frame_Show = optionsFrame.Show
local Frame_Hide = optionsFrame.Hide
local CheckButton_IsVisible = ActionButton1.IsVisible
local Texture_Show = ActionButton1Icon.Show
local Texture_Hide = ActionButton1Icon.Hide
local Texture_GetVertexColor = ActionButton1Icon.GetVertexColor
local Texture_SetVertexColor = ActionButton1Icon.SetVertexColor

-------------
--  Utils  --
-------------

do -- print
	local prefix = "|cff33ff99"..addonName.."|r:"
	function print(...)
		_G.print(prefix, ...)
	end
end

------------------------------------
--  Addon-Level Objects / Events  --
------------------------------------

_G.GreenRange = GreenRange
GreenRange.optionsFrame = optionsFrame

function GreenRange:SetOOR_Color(r, g, b)
	OOR_R, OOR_G, OOR_B = r, g, b
	db.oor[1], db.oor[2], db.oor[3] = r, g, b
	local EnumerateFrames = EnumerateFrames
	local frame = EnumerateFrames()
	while frame do
		if frame:IsObjectType("CheckButton") and frame.oor then
			Texture_SetVertexColor(frame.icon, r, g, b)
			Texture_SetVertexColor(frame.normalTexture, r, g, b)
		end
		frame = EnumerateFrames(frame)
	end
end

function GreenRange:SetOOM_Color(r, g, b)
	OOM_R, OOM_G, OOM_B = r, g, b
	db.oom[1], db.oom[2], db.oom[3] = r, g, b
	local EnumerateFrames = EnumerateFrames
	local frame = EnumerateFrames()
	while frame do
		if frame:IsObjectType("CheckButton") and frame.oor == false and frame.usableState == 1 then
			Texture_SetVertexColor(frame.icon, r, g, b)
			Texture_SetVertexColor(frame.normalTexture, r, g, b)
		end
		frame = EnumerateFrames(frame)
	end
end

function GreenRange.HandleEvent(frame, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if nRanged > 0 then
			rangeTimer:Play()
		end
		if nFlashing > 0 then
			flashingTimer:Play()
		end
	elseif event == "PLAYER_LEAVING_WORLD" then
		rangeTimer:Stop()
		flashingTimer:Stop()
	end
end

optionsFrame:SetScript("OnEvent", function(frame, event, name)
	if name ~= addonName then return end

	frame:UnregisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", GreenRange.HandleEvent)
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("PLAYER_LEAVING_WORLD")

	-- Init!
	if not GreenRangeDB then
		GreenRangeDB = {
			db_version = DB_VERSION,
			oor = { 1.0, 0.2, 0.2 },
			oom = { 0.2, 0.2, 1.0 },
		}
	end
	db = GreenRangeDB
	OOR_R, OOR_G, OOR_B = db.oor[1], db.oor[2], db.oor[3]
	OOM_R, OOM_G, OOM_B = db.oom[1], db.oom[2], db.oom[3]

	-- range stuff
	rangeTimer = BuildTimer(RANGE_CHECK_INTERVAL, UpdateAllRanges, true)
	hooksecurefunc("ActionButton_OnUpdate", SnarfButton)
	--((@)) hooksecurefunc("ActionButton_OnUpdate", function(...) Debug("Snarfed from ActionButton_OnUpdate") end)
	hooksecurefunc("ActionButton_UpdateUsable", SupersedeBlizColors)
	--((@)) hooksecurefunc("ActionButton_UpdateUsable", function(...) Debug("ActionButton_UpdateUsable") end)
	hooksecurefunc("ActionButton_Update", ShouldWeWatchThis)

	-- flash stuff
	flashingTimer = BuildTimer(ATTACK_BUTTON_FLASH_TIME, UpdateAllFlashing, true)
	flashingTimer:SetScript("OnStop", function() flashesCurrentlyRed = false end)
	hooksecurefunc("ActionButton_StartFlash", AddFlash)
	hooksecurefunc("ActionButton_StopFlash", RemoveFlash)

	--[===[@debug@
	InitDebug()
	--@end-debug@]===]
end)
optionsFrame:RegisterEvent("ADDON_LOADED")

function BuildTimer(interval, func, fireOnPlay)
	local bucketFrame = CreateFrame("Frame")
	local function ShowBucketFrame()
		Frame_Show(bucketFrame)
	end
	Frame_Hide(bucketFrame)
	bucketFrame:SetScript("OnUpdate", func)

	local animGroup = AnimTimerFrame:CreateAnimationGroup()
	if fireOnPlay then
		animGroup:SetScript("OnPlay", ShowBucketFrame)
	end
	local anim = animGroup:CreateAnimation("Animation")
	anim:SetDuration(interval)
	anim:SetOrder(1)
	anim:SetScript("OnFinished", ShowBucketFrame)
	animGroup:SetLooping("REPEAT")
	return animGroup
end


function CacheAbstractSet(hashVersion, arrayVersion)
	local i, last = 0, #arrayVersion
	for k,_ in pairs(hashVersion) do
		i = i + 1
		arrayVersion[i] = k
	end
	while i < last do
		arrayVersion[last] = nil
		last = last - 1
	end
end

-------------------------
--  Range-Check Timer  --
-------------------------

function UpdateAllRanges(internalFrame)
	Frame_Hide(internalFrame)
	local IsActionInRange = IsActionInRange
	local watchedForRange_cache = watchedForRange_cache

	-- validate cache
	if watchedForRange_rebuild then
		--((@)) Debug("rebuild watchedForRange")
		CacheAbstractSet(watchedForRange, watchedForRange_cache)
		watchedForRange_rebuild = nil
	end

	-- iterate on cache
	for i = 1,#watchedForRange_cache do
		local button = watchedForRange_cache[i]
		local newOOR = not not (IsActionInRange(button.action) == 0)

		if newOOR ~= button.oor then
			local ToggleMark = newOOR and MarkOOR or UnmarkOOR
			ToggleMark(button)
		end
	end
end


function ShouldWeWatchThis(button)
	--((@)) Debug("ShouldWeWatchThis")
	local isWatched = watchedForRange[button]
	local shouldWatch = button.eventsRegistered and ActionHasRange(button.action) and CheckButton_IsVisible(button)

	if isWatched then
		if not shouldWatch then
			-- Lost our range-sensitive action. Stop watching.
			if button.oor then
				UnmarkOOR(button)
			end
			watchedForRange[button] = nil
			watchedForRange_rebuild = 1
			nRanged = nRanged - 1
			if nRanged == 0 then
				--((@)) Debug("rangeTimer: Stop!")
				rangeTimer:Stop()
			end
		end
	else
		if shouldWatch then
			-- Gained a range-sensitive action. Start watching.
			if button.oor == nil then
				--((@)) Debug("Snarfed from ShouldWeWatchThis")
				SnarfButton(button)
			end
			if IsActionInRange(button.action) == 0 then
				MarkOOR(button)
			end
			watchedForRange[button] = 1
			watchedForRange_rebuild = 1
			nRanged = nRanged + 1
			if nRanged == 1 then
				--((@)) Debug("rangeTimer: Play!")
				rangeTimer:Play()
			end
		end
	end
end

-- Flag the button as 'oor', and turn it red.
function MarkOOR(button)
	--((@)) Debug("MarkOOR")
	button.oor = true
	local r, g, b = OOR_R, OOR_G, OOR_B
	local Texture_SetVertexColor = Texture_SetVertexColor
	Texture_SetVertexColor(button.icon, r, g, b)
	Texture_SetVertexColor(button.normalTexture, r, g, b)
end

-- Unflag the button as 'oor', and apply any color changes noted by the hooks.
function UnmarkOOR(button)
	--((@)) Debug("UnmarkOOR")
	button.oor = false

	local usableState = button.usableState
	local r1, g1, b1, r2, g2, b2 = 1, 1, 1, 1, 1, 1 -- defaults
	if usableState == 0 then
		-- defaults white
	elseif usableState == 1 then
		-- oom
		r1, g1, b1 = OOM_R, OOM_G, OOM_B
		r2, g2, b2 = r1, g1, b1
	else
		-- unusable. second half defaults white.
		r1, g1, b1 = 0.4, 0.4, 0.4
	end
	local Texture_SetVertexColor = Texture_SetVertexColor
	Texture_SetVertexColor(button.icon, r1, g1, b1)
	Texture_SetVertexColor(button.normalTexture, r2, g2, b2)
end

------------------
--  Main Hooks  --
------------------

-- Make the button use our colors, but keep track of how the Bliz code wants it colored.
function SupersedeBlizColors(button)
	--((@)) Debug("SupersedeBlizColors")
	local oor = button.oor
	if oor ~= nil then
		local isUsable, notEnoughMana = IsUsableAction(button.action)
		local usableState = isUsable and 0 or (notEnoughMana and 1 or 2)
		button.usableState = usableState

		if oor then
			local r, g, b = OOR_R, OOR_G, OOR_B
			local Texture_SetVertexColor = Texture_SetVertexColor
			Texture_SetVertexColor(button.icon, r, g, b)
			Texture_SetVertexColor(button.normalTexture, r, g, b)
		elseif usableState == 1 then
			local r, g, b = OOM_R, OOM_G, OOM_B
			local Texture_SetVertexColor = Texture_SetVertexColor
			Texture_SetVertexColor(button.icon, r, g, b)
			Texture_SetVertexColor(button.normalTexture, r, g, b)
		end
	end
end

-- Steal the button the first time it tries to update, and make it use our code instead.
function SnarfButton(button)
	--((@)) Debug("SnarfButton")
	button.icon = _G[button:GetName().."Icon"] -- unnecessary after 4.0, but harmless
	button.normalTexture = button:GetNormalTexture()
	button.oor = false
	SupersedeBlizColors(button)

	button:SetScript("OnUpdate", nil)
	ShouldWeWatchThis(button)
	button:HookScript("OnShow", ShouldWeWatchThis)
	button:HookScript("OnHide", ShouldWeWatchThis)
end


function UpdateAllFlashing(internalFrame)
	Frame_Hide(internalFrame)
	local flashingButtons_cache = flashingButtons_cache

	-- validate cache
	if flashingButtons_rebuild then
		--((@)) Debug("rebuild flashingButtons")
		CacheAbstractSet(flashingButtons, flashingButtons_cache)
		flashingButtons_rebuild = nil
	end

	flashesCurrentlyRed = not flashesCurrentlyRed
	local ShowOrHide = flashesCurrentlyRed and Texture_Show or Texture_Hide

	-- iterate on cache
	for i = 1,#flashingButtons_cache do
		ShowOrHide(flashingButtons_cache[i].flash)
	end
end


function AddFlash(button)
	if not flashingButtons[button] then
		local flash = button.flash
		if not flash then
			flash = _G[button:GetName().."Flash"]
			button.flash = flash
		end
		if flashesCurrentlyRed then
			Texture_Show(flash)
		end
		flashingButtons[button] = 1
		flashingButtons_rebuild = 1
		nFlashing = nFlashing + 1
		if nFlashing == 1 then
			flashingTimer:Play()
		end
	end
end

function RemoveFlash(button)
	if flashingButtons[button] then
		flashingButtons[button] = nil
		flashingButtons_rebuild = 1
		nFlashing = nFlashing - 1
		if nFlashing == 0 then
			flashingTimer:Stop()
		end
	end
end
