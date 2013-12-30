--动作条增强
--by Binny Mystery

--设置两种布局，玩家可以2选1，
local MyBar = true           -- true or false 是否使用小屏幕动作条布局.（默认）
local BZBar = false          -- true or false 是否使用宽屏幕布局.（去除系统菜单，把右侧动作条替换到系统菜单位置）

------------------------------
--小屏幕动作条布局增强（默认）
------------------------------
if (MyBar == true) then
local BarScale = 0.9
local HideMainButtonArt = false  -- true or false 是否隐藏狮鹫和主动作条的背景材质
local HideExperienceBar = false  -- true or false 是否隐藏经验条

local MenuButtonFrames = {
    StoreMicroButton,          --5.42更新商城按钮
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
	local Alpha = 0  ----右侧动作条鼠标悬停设置：1为不需要鼠标悬停（也就是正常显示），0则为鼠标悬停！ 
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
--	MultiBarLeft:SetScale(BarScale)  --去掉注释会把[右边动作条2]变小

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
	CornerMenuFrame:Show();--Hide(); ---隐藏暴雪系统菜单
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
	--隐藏背包，如果需要显示请注释掉下面这句并把【包裹定位】下面的注释打开即可！
	MainMenuBarBackpackButton:Hide();
	-- --包裹定位
    -- MainMenuBarBackpackButton:ClearAllPoints();
	-- MainMenuBarBackpackButton:SetPoint("BOTTOM");
	-- MainMenuBarBackpackButton:SetPoint("RIGHT", -60, 0);
	-- --MainMenuBarBackpackButton:SetScale(.8)
	
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

-- Start  Bar
Bar:SetScript("OnEvent", EventHandler);
Bar:SetFrameStrata("TOOLTIP")
Bar:Show()

SLASH_BAR1 = '/bar'
SlashCmdList['BAR'] = RefreshPositions;

local function GetMouseoverFrame() 
	local frame = EnumerateFrames(); -- Get the first frame
	while frame do
	  if ( frame:IsVisible() and MouseIsOver(frame) ) then
		print(frame:GetName() or string.format("[未命名框体: %s]", tostring(frame)), frame.this);
	  end
	  if frame and frame.GetObjectType then frame = EnumerateFrames(frame); -- Get the next frame
	  else frame = nil end
	end
end;

SLASH_GETMOUSEOVERFRAME1 = '/getmouseoverframe'
SlashCmdList['GETMOUSEOVERFRAME'] = GetMouseoverFrame
end

------------------------------------------------------------------------------------
--宽屏布局=暴雪隐藏系统菜单动作条布局，宽屏幕适用（去除系统菜单，把右侧动作条替换到系统菜单位置）
------------------------------------------------------------------------------------
if (BZBar == true) then
local CornerMenuFrame = false; -- 在右下方切换系统菜单

local BarScale = 0.9

	MainMenuBar:SetScale(BarScale)
	MultiBarRight:SetScale(BarScale)
	MultiBarLeft:SetScale(BarScale)
--	CornerMenuFrame:SetScale(BarScale)

-- 主动作条重新定位 --
local function FixStuff()
    MainMenuBarTexture2:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
    MainMenuBarTexture2:SetTexCoord(0, 1, 0.58203125, 0.75);
    MainMenuBarTexture2:SetPoint("CENTER", MainMenuBarArtFrame, 124, 0)
    MainMenuBarTexture3:SetTexture("Interface\\MainMenuBar\\UI-MainMenuBar-Dwarf")
    MainMenuBarTexture3:SetTexCoord(0, 1, 0.58203125, 0.75);
    MainMenuBarTexture3:SetPoint("CENTER", MainMenuBarArtFrame, 376, 0)
    MainMenuBarRightEndCap:SetPoint("CENTER", MainMenuBarArtFrame, 536, 0)
    MainMenuBar:SetPoint("CENTER", 4, 0)
end

-- 定位动作条 --
local function MoveStuff()
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetPoint("LEFT", "MultiBarBottomLeft", "RIGHT", 4, 0);
    MultiBarLeft:ClearAllPoints()
    MultiBarLeft:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", sin(180) * 100, 98)
    for i = 1, 12 do
        local b = _G["MultiBarRightButton"..i]
        if (i == 1) then
            b:ClearAllPoints()
            b:SetPoint("LEFT", "ActionButton12", "RIGHT", 6, 0)
        else
            b:ClearAllPoints()
            b:SetPoint("LEFT", _G["MultiBarRightButton"..i-1], "RIGHT", 6, 0)
        end
    end
end

-- 隐藏/重新定位的东西 --
local function HideStuff()
    MainMenuBarPageNumber:Hide();
    ActionBarDownButton:Hide();
    ActionBarUpButton:Hide();
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, -1, -300)
    CharacterMicroButton:ClearAllPoints()
    if (CornerMenuFrame==true) then
        CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, -274, -2)
    elseif (CornerMenuFrame==false) then
        CharacterMicroButton:SetPoint("BOTTOMRIGHT", UIParent, 5000, 0)
    end
end
-- 解决WatchFrame的定位
local o = WatchFrame.SetPoint
function WatchFrame:SetPoint(a1, frame, a2, x, y)
	if frame == "MinimapCluster" then o(self, a1, frame, a2, x+48, y)
	elseif frame == "UIParent" then o(self, "BOTTOM", frame, "BOTTOM", 0, y) end
end

FixStuff()
MoveStuff()
HideStuff()
end


--------------------------------
---超出施法距离技能显示为红色---
--------------------------------

hooksecurefunc("ActionButton_OnUpdate", function(self, elapsed)
	if ( self.rangeTimer == TOOLTIP_UPDATE_TIME and self.action) then
		local range = false
		if ( IsActionInRange(self.action) == 0 ) then
			getglobal(self:GetName().."Icon"):SetVertexColor(1, 0, 0)
			getglobal(self:GetName().."NormalTexture"):SetVertexColor(1, 0, 0)
			range = true
		end;
		if ( self.range ~= range and range == false ) then
			ActionButton_UpdateUsable(self)
		end;
		self.range = range
	end
end)