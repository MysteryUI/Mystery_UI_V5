--MysteryUI核心设置

local addonName, L = ...; 
local function defaultFunc(L, key) 
return key; 
end 
setmetatable(L, {__index=defaultFunc}); 

local _G = _G  --解决头像在换类似天赋，符文的时候出现暴雪禁用插件的情况。

--[[ 选项 ]]
local SellGreyCrap = true           -- 是否自动出售灰色物品.
local HideHotKeys = false           -- 是否隐藏快捷键和宏在技能栏里的文本
local HideClock = false             -- 是否隐藏暴雪时钟
local MoveWatchFrame = true         -- 是否移动任务追踪框体

--头像布局切换设置：[PVP布局:/My pvp]，[PVE布局:/My pve] 注意命令后面的大小写必须一致！
local function slashCommand(str)
	if (str == 'pvp') then
        MyUnitframesDB.PVE_Style = false 
		MyUnitframesDB.PVP_Style = true
		StaticPopup_Show("RELOAD")
	elseif(str == 'pve') then
		MyUnitframesDB.PVE_Style = true 
		MyUnitframesDB.PVP_Style = false
		StaticPopup_Show("RELOAD")
	elseif(str == 'bz') then
	    MyUnitframesDB = {} 
		StaticPopup_Show("RELOAD")
	end
end

local eventframe = CreateFrame'Frame'
eventframe:RegisterEvent('ADDON_LOADED')

eventframe:SetScript('OnEvent', function(self, event, name)
	if(name ~= "MysteryUI") then return end
	self:UnregisterEvent('ADDON_LOADED')
 	SLASH_MysteryUI1 = '/My'
	SlashCmdList["MysteryUI"] = function(str) slashCommand(str) end

end)

StaticPopupDialogs["RELOAD"] = {
	text = L["切换布局你需要重新加载插件。"],
	OnAccept = function() 
		ReloadUI() 
	end,
	OnCancel = function() end ,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

--[[ 添加命令 ]]
SlashCmdList["FRAME"] = function() print(GetMouseFocus():GetName()) end
SLASH_FRAME1 = "/frame"--输入此命令检查鼠标位置框体的名称

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"--重载命令

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"--就位确认

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"--找GM的命令

--加载配置

local SetupUI = function() 
	SetCVar("chatStyle", "classic")
	SetCVar("chatMouseScroll", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowEnemyTotems", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("rotateMinimap", 0)
	SetCVar("UnitNameOwn", 1)
	SetCVar("UnitNameNPC", 1)
	SetCVar("UnitNameNonCombatCreatureName", 0)
	SetCVar("UnitNamePlayerPVPTitle", 1)
	SetCVar("UnitNameFriendlyPlayerName", 1)
	SetCVar("UnitNameFriendlyPetName", 1)
	SetCVar("UnitNameFriendlyGuardianName", 0)
	SetCVar("UnitNameFriendlyTotemName", 1)
	SetCVar("UnitNameEnemyPlayerName", 1)
	SetCVar("UnitNameEnemyPetName", 1)
	SetCVar("UnitNameEnemyGuardianName", 1)
	SetCVar("UnitNameEnemyTotemName", 1)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("screenshotQuality", 8)
	SetCVar("lootUnderMouse", 1)
	SetCVar("UberTooltips", 1)
	SetCVar("showArenaEnemyFrames", 0)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("consolidateBuffs",0)
	SetCVar("buffDurations",1)
--	SetCVar("useUiScale", 1)
--	SetCVar("uiScale", min(2, max(.9, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))))

	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	setupUI = true
	ReloadUI()
end

StaticPopupDialogs["SETUP_UI"] = {
	text = L["第一次使用MysteryUI_V5你需要重新加载插件。"], 
	button1 = ACCEPT, 
	button2 = CANCEL,
	OnAccept = SetupUI,
	timeout = 0, 
	whileDead = 1,
	hideOnEscape = 1, 
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event, addon)
	self:UnregisterEvent(event)
	if not setupUI then
		StaticPopup_Show("SETUP_UI")
	end
end)


--[[ 隐藏快捷键和宏在技能栏里的文本 ]]
if (HideHotKeys == true) then
local format = string.format;
local match = string.match;
local upper = strupper;
local _G = getfenv(0);
local f = {"ActionButton%d", "MultiBarBottomLeftButton%d", "MultiBarBottomRightButton%d", "MultiBarRightButton%d",
			"MultiBarLeftButton%d"}           
do
	for k, v in pairs(f) do
		for i = 1, 12 do
			local str = format(v, i);
			_G[str.."HotKey"].Show = function() end;
			_G[str.."Name"].Show = function() end;
			_G[str.."Name"]:Hide();
		end
	end
end
end

--隐藏错误提示(我没有目标等等）
local event = CreateFrame"Frame"
local dummy = function() end

UIErrorsFrame:UnregisterEvent"UI_ERROR_MESSAGE"
event.UI_ERROR_MESSAGE = function(self, event, error)
	if(not stuff[error]) then
		UIErrorsFrame:AddMessage(error, 1, .1, .1)
	end
end
	
event:RegisterEvent"UI_ERROR_MESSAGE"

--[[ 自动出售垃圾 ]]
local function OnEvent()
	for bag=0,4 do
		for slot=0,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and select(3, GetItemInfo(link)) == 0 then
				ShowMerchantSellCursor(1)
				UseContainerItem(bag, slot)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MERCHANT_SHOW")
f:SetScript("OnEvent", OnEvent)

if MerchantFrame:IsVisible() then OnEvent() end

--[[ 修理 - 变量是可以改变的，只要你想 ]]--
local 	iRepair_Chatter 	= true
local 	iRepair_GRF		= true
local 	iRepair_ROGR		= false

--[[ AUTO REPAIR SERVICES ]]--
local iRepair = CreateFrame("Frame", "iRepair")
	iRepair:RegisterEvent("MERCHANT_SHOW")
	iRepair:SetScript("OnEvent", function()
	local cost = GetRepairAllCost()
	local function iRepair_Guild()
		if iRepair_Chatter then
			print(L[" 公会银行自动修理费用: "].. GetCoinTextureString(cost) )
		end
		RepairAllItems(1)
	end
	local function iRepair_Self()
		if iRepair_Chatter then
			print(L[" 你支付的修理费用: "].. GetCoinTextureString(cost) )
		end
		RepairAllItems()
	end
	if IsModifierKeyDown() then
		return
	elseif CanMerchantRepair() and cost ~= 0 then
		if iRepair_GRF and CanGuildBankRepair() and cost <= GetGuildBankMoney() and (cost <= GetGuildBankWithdrawMoney() or GetGuildBankWithdrawMoney() == -1) then
			if iRepair_ROGR and GetNumRaidMembers() ~= 0 then
				iRepair_Guild()
			elseif not iRepair_ROGR then
				iRepair_Guild()
			elseif cost <= GetMoney() then
				iRepair_Self()
			else
				print(L[" 公会没有足够的资金修理，请尝试手动。"])
			end
		elseif cost <= GetMoney() then
			iRepair_Self()
		else
			print(L[" 你没有足够的资金修理。你需要 "]..GetCoinTextureString(cost)..L[" 的修理费。"])
		end
	end
end)


--[[ 隐藏暴雪时钟]]
if (HideClock == true) then
local name, addon = ...
local event1, event2 = "ADDON_LOADED", "PLAYER_ENTERING_WORLD"
local frame = CreateFrame("Frame")
frame:RegisterEvent(event1)
frame:RegisterEvent(event2)
frame:SetScript("OnEvent", function(self, event, arg1)

	if((event == event2 and name == arg1) or (event==event1)) then
		self:UnregisterEvent(event)
		LoadAddOn("Blizzard_TimeManager")
		TimeManagerClockButton:SetScript("OnUpdate", nil)
		TimeManagerClockButton:SetScript("OnEvent", nil)
		TimeManagerClockButton:SetScript("OnShow", function(self) 
			self:Hide()
		end)
		TimeManagerClockButton:Hide()
		if(event == event1) then
			self:RegisterEvent(event)
		end
	end
end)
end
---------------------------
--离开战斗回收插件内存
local eventcount = 0
local cf = CreateFrame("Frame")
cf:RegisterAllEvents()
cf:SetScript("OnEvent", function(self, event)
   eventcount = eventcount + 1
   if InCombatLockdown() then return end
   if eventcount > 6000 or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_ENABLED" then
      collectgarbage("collect")
      eventcount = 0
   end
end) 
