------------------------------------------------------------
-- UnitMenus.lua
--
-- Abin
-- 2012/3/22
------------------------------------------------------------

local type = type
local wipe = wipe
local pairs = pairs
local ipairs = ipairs
local format = format
local UnitName = UnitName
local HasLFGRestrictions = HasLFGRestrictions
local ChatFrame_SendTell = ChatFrame_SendTell
local LeaveParty = LeaveParty
local ConvertToParty = ConvertToParty
local ConvertToRaid = ConvertToRaid
local InitiateTrade = InitiateTrade
local InspectUnit = InspectUnit
local InspectAchievements = InspectAchievements
local PromoteToLeader = PromoteToLeader
local DemoteAssistant = DemoteAssistant
local PromoteToAssistant = PromoteToAssistant
local UninviteUnit = UninviteUnit
local SetRaidTargetIcon = SetRaidTargetIcon
local GetRaidTargetIndex = GetRaidTargetIndex
local UnitGetAvailableRoles = UnitGetAvailableRoles
local UnitSetRole = UnitSetRole
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitExists = UnitExists
local CheckInteractDistance = CheckInteractDistance
local UnitIsUnit = UnitIsUnit
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local ToggleDropDownMenu = ToggleDropDownMenu
local CloseDropDownMenus = CloseDropDownMenus
local StaticPopup_Show = StaticPopup_Show
local GetLootMethod = GetLootMethod
local SetLootMethod = SetLootMethod
local GetLootThreshold = GetLootThreshold
local SetLootThreshold = SetLootThreshold
local strmatch = strmatch
local GetItemQualityColor = GetItemQualityColor
local GetPVPDesired = GetPVPDesired
local SetPVP = SetPVP
local GetDungeonDifficultyID = GetDungeonDifficultyID
local SetDungeonDifficultyID= SetDungeonDifficultyID
local GetRaidDifficulty = GetRaidDifficulty
local SetRaidDifficulty = SetRaidDifficulty

local _G = _G
local UnitPopupButtons = UnitPopupButtons
local UnitLootMethod = UnitLootMethod

local _, addon = ...

local frame = CreateFrame("Frame", "CompactRaidUnitButtonMenuFrame", UIParent, "UIDropDownMenuTemplate")

-- I cannot use UnitPopup_ShowMenu because protected actions such as set focus are not touchable here

local curDisplayedUnit, curUnit, curName, curWho, curGroup, curLeadship, curLfg, curGroupNum

-- I'm always under the impression that the menu button will be passed to the menu function as the FIRST argument, what the hell?
local function OnMenuClick(self, arg1, arg2)
	local func = self.swatchFunc
	if type(func) == "function" then
		func(arg1, arg2)
		CloseDropDownMenus()
	end
end

local function AddLine(flag, level, ...)
	local data = {}
	data.owner = frame
	data.menuList = flag
	data.notCheckable = level == 1

	local def = UnitPopupButtons[flag]
	if def then
		data.text = def.text
		data.icon = def.icon
		data.tCoordLeft = def.tCoordLeft
		data.tCoordRight = def.tCoordRight
		data.tCoordTop = def.tCoordTop
		data.tCoordBottom = def.tCoordBottom
		if def.color then
			data.colorCode = format("|cFF%02x%02x%02x", def.color.r * 255, def.color.g * 255, def.color.b * 255)
		end
	end

	local argCount = select("#", ...)
	local i
	for i = 1, argCount, 2 do
		local key = select(i, ...)
		if type(key) == "string" then
			data[key] = select(i + 1, ...)
		end
	end

	if data.func then
		data.swatchFunc = data.func
		data.func = OnMenuClick
	end

	UIDropDownMenu_AddButton(data, level)
end

local function IsLootMaster()
	local method, partyMaster, raidMaster = GetLootMethod()
	if method ~= "master" then
		return
	end

	local unit
	if curGroup == "raid" then
		if raidMaster then
			unit = "raid"..raidMaster
		end
	elseif curGroup == "party" then
		if partyMaster then
			if partyMaster == 0 then
				unit = "player"
			else
				unit = "party"..partyMaster
			end
		end
	end

	return unit and UnitIsUnit(unit, curUnit)
end

local function AddMe()

	-- pvp flag
	AddLine("PVP_FLAG", 1, "hasArrow", 1)

	local _, instanceType, _, _, _, _, isDynamicInstance = GetInstanceInfo()
	if not curLfg and UnitLevel("player") >= 65 then
		if instanceType == "none" or isDynamicInstance then
			AddLine("DUNGEON_DIFFICULTY", 1, "hasArrow", 1)
			AddLine("RAID_DIFFICULTY", 1, "hasArrow", 1)
		end
	end

	-- reset instances
	if not curLfg and instanceType == "none" and (not curGroup or curLeadship == "leader") then
		AddLine("RESET_INSTANCES", 1, "func", StaticPopup_Show, "arg1", "CONFIRM_RESET_INSTANCES")
	end

	-- loot method
	if curGroup then
		local method = GetLootMethod()
		local lootable = curLeadship == "leader" and not curLfg

		AddLine("LOOT_METHOD", 1, "text", UnitLootMethod[method].text, "hasArrow", lootable, "disabled", not lootable)

		if method == "master" or method == "group" or method == "needbeforegreed" then
			local threshold = GetLootThreshold() or 2
			local text = _G["ITEM_QUALITY"..threshold.."_DESC"]
			local _, _, _, color = GetItemQualityColor(threshold)
			AddLine("LOOT_THRESHOLD", 1, "text", "|c"..color..text.."|r", "hasArrow", lootable, "disabled", not lootable)
		end

		if lootable and not IsLootMaster() then
			AddLine("LOOT_PROMOTE", 1, "func", SetLootMethod, "arg1", "master", "arg2", curUnit)
		end
	end

	-- convert to raid/party
	if curLeadship == "leader" and not curLfg then
		if curGroup == "raid" then
			AddLine("CONVERT_TO_PARTY", 1, "func", ConvertToParty, "disabled", not curGroupNum or curGroupNum > 5)
		elseif curGroup == "party" then
			AddLine("CONVERT_TO_RAID", 1, "func", ConvertToRaid)
		end
	end

	-- raid targets
	if curLeadship or curGroup ~= "raid" then
		AddLine("RAID_TARGET_ICON", 1, "hasArrow", 1)
	end

	-- assign roles
	if curGroup and not curLfg then
		AddLine("SELECT_ROLE", 1, "hasArrow", 1)
	end

	-- leave party/raid
	if curGroup then
		AddLine("LEAVE", 1, "func", LeaveParty)
	end
end

local function AddMate()
	-- whisper
	AddLine("WHISPER", 1, "func", ChatFrame_SendTell, "arg1", curName)

	-- promote to leader
	if curLeadship == "leader" then
		if curGroup == "raid" then
			AddLine("RAID_LEADER", 1, "func", PromoteToLeader, "arg1", curUnit)
		elseif curGroup == "party" then
			AddLine("PROMOTE", 1, "func", PromoteToLeader, "arg1", curUnit)
		end
	end

	-- promote/demote raid officer
	if curLeadship == "leader" and curGroup == "raid" and not curLfg then
		if UnitIsRaidOfficer(curUnit) then
			AddLine("RAID_DEMOTE", 1, "func", DemoteAssistant, "arg1", curUnit)
		else
			AddLine("RAID_PROMOTE", 1, "func", PromoteToAssistant, "arg1", curUnit)
		end
	end

	-- loot method
	if curLeadship == "leader" and not curLfg and not IsLootMaster() then
		AddLine("LOOT_PROMOTE", 1, "func", SetLootMethod, "arg1", "master", "arg2", curUnit)
	end

	-- kick
	if curLfg then
		AddLine("VOTE_TO_KICK", 1, "func", UninviteUnit, "arg1", curUnit)
	elseif curLeadship then
		if curGroup == "raid" then
			AddLine("RAID_REMOVE", 1, "func", UninviteUnit, "arg1", curUnit)
		else
			AddLine("UNINVITE", 1, "func", UninviteUnit, "arg1", curUnit)
		end
	end


	-- inspect
	AddLine("INSPECT", 1, "func", InspectUnit, "arg1", curUnit)

	-- compare achievements
	AddLine("ACHIEVEMENTS", 1, "func", InspectAchievements, "arg1", curUnit)

	-- trade
	AddLine("TRADE", 1, "func", InitiateTrade, "arg1", curUnit)

	-- raid targets
	if curLeadship or curGroup ~= "raid" then
		AddLine("RAID_TARGET_ICON", 1, "hasArrow", 1)
	end

	-- assign roles
	if curLeadship and not curLfg then
		AddLine("SELECT_ROLE", 1, "hasArrow", 1)
	end
end

local function AddPet()
	-- raid targets
	if curLeadship or curGroup ~= "raid" then
		AddLine("RAID_TARGET_ICON", 1, "hasArrow", 1)
	end
end

local function Frame_OnMenuRequestLevel1()

	-- menu title
	AddLine(nil, 1, "text", curName, "isTitle", 1)

	if curWho == "me" then
		AddMe()
	elseif curWho == "mate" then
		AddMate()
	else
		AddPet()
	end

	-- cancel
	AddLine("CANCEL", 1)
end

local LOOT_METHOD_DEF = { "FREE_FOR_ALL,freeforall", "ROUND_ROBIN,roundrobin", "MASTER_LOOTER,master", "GROUP_LOOT,group", "NEED_BEFORE_GREED,needbeforegreed" }
local SET_ROLE_DEF = { "TANK", "HEALER", "DAMAGER", "NONE" }

local function Frame_OnMenuRequestLevel2(value)
	if value == "PVP_FLAG" then

		local pvpOn = GetPVPDesired()
		AddLine("PVP_ENABLE", 2, "func", SetPVP, "arg1", 1, "checked", pvpOn == 1)
		AddLine("PVP_DISABLE", 2, "func", SetPVP, "checked", pvpOn == 0)

	elseif value == "DUNGEON_DIFFICULTY" then

		local difficulty = GetDungeonDifficultyID()
		local i
		for i = 1, 3 do
			local res = (i == 3 and 8 or i)
			AddLine("DUNGEON_DIFFICULTY"..i, 2, "func", SetDungeonDifficultyID, "arg1", res, "checked", difficulty == res, "disabled", curGroup and curLeadship ~= "leader")
		end

	elseif value == "RAID_DIFFICULTY" then

		local difficulty = GetRaidDifficulty()
		local i
		for i = 1, 4 do
			AddLine("RAID_DIFFICULTY"..i, 2, "func", SetRaidDifficulty, "arg1", i, "checked", difficulty == i, "disabled", curGroup and curLeadship ~= "leader")
		end

	elseif value == "LOOT_METHOD" then

		local method = GetLootMethod()
		local i
		for i = 1, #LOOT_METHOD_DEF do
			local def = LOOT_METHOD_DEF[i]
			local flag, value = strmatch(def, "(.-),(.+)")
			AddLine(flag, 2, "func", SetLootMethod, "arg1", value, "arg2", "player", "checked", method == value)
		end

	elseif value == "LOOT_THRESHOLD" then

		local threshold = GetLootThreshold()
		local i
		for i = 2, 4 do
			AddLine("ITEM_QUALITY"..i.."_DESC", 2, "func", SetLootThreshold, "arg1", i, "checked", threshold == i)
		end

	elseif value == "RAID_TARGET_ICON" then

		local curIcon = GetRaidTargetIndex(curDisplayedUnit) or 0
		local i
		for i = 1, 8 do
			AddLine("RAID_TARGET_"..i, 2, "func", SetRaidTargetIcon, "arg1", curDisplayedUnit, "arg2", i, "checked", curIcon == i)
		end
		AddLine("RAID_TARGET_NONE", 2, "func", SetRaidTargetIcon, "arg1", curDisplayedUnit, "arg2", 0, "checked", curIcon == 0)

	elseif value == "SELECT_ROLE" then

		local canTank, canHeal = UnitGetAvailableRoles(curUnit)
		local role = UnitGroupRolesAssigned(curUnit)

		local i
		for i = 1, #SET_ROLE_DEF do
			local flag = SET_ROLE_DEF[i]
			AddLine("SET_ROLE_"..flag, 2, "func", UnitSetRole, "arg1", curUnit, "arg2", flag, "checked", role == flag, "disabled", (flag == "TANK" and not canTank) or (flag == "HEALER" and not canHeal))
		end
	end
end

local function MenuInitFunc(self, level, value)
	if not curUnit or not UnitExists(curUnit) then
		return
	end

	if level == 2 then
		Frame_OnMenuRequestLevel2(value)
	else
		Frame_OnMenuRequestLevel1()
	end
end

UIDropDownMenu_Initialize(frame, MenuInitFunc, "MENU")

local MONITOR_FUNCS = { InitiateTrade = 2, InspectUnit = 1, InspectAchievements = 1 }
local monitoredButtons = {}
local updateFrame = CreateFrame("Frame", nil, DropDownList1)
updateFrame:Hide()
updateFrame:SetScript("OnHide", updateFrame.Hide)
updateFrame:SetScript("OnUpdate", function(self)
	if not curUnit then
		return
	end

	local funcName, button
	for funcName, button in pairs(monitoredButtons) do
		if button.owner == frame then
			if CheckInteractDistance(curUnit, MONITOR_FUNCS[funcName]) then
				button:Enable()
			else
				button:Disable()
			end
		end
	end
end)

local function FindMenuButton(func)
	local i
	for i = 1, 16 do
		local button = _G["DropDownList1Button"..i]
		if not button then
			return
		end

		if button:IsVisible() and func and button.swatchFunc == func and button.owner == frame then
			return button
		end
	end
end

local prevButton
local function menuFunc(self)
	if prevButton ~= self then
		prevButton = self
		CloseDropDownMenus()
	end

	curDisplayedUnit = self.displayedUnit
	curUnit = self.unit
	curLfg = HasLFGRestrictions()
	curName, curWho, curGroup, curLeadship, curGroupNum = nil

	if not curDisplayedUnit or not curUnit or not UnitExists(curUnit) then
		return
	end

	local name, server = UnitName(curUnit)
	if server and server ~= "" then
		name = name.."-"..server
	end

	curName = name

	if UnitIsUnit(curUnit, "player") then
		curWho = "me"
	elseif UnitIsPlayer(curUnit) then
		curWho = "mate"
	end

	curGroup, curLeadship, curGroupNum = addon:GetGroupStats()

	local scale = addon:GetMainFrame():GetScale()
	ToggleDropDownMenu(1, nil, frame, self:GetName(), self:GetWidth() / 2 * scale, self:GetHeight() / 2 * scale)

	if not DropDownList1:IsVisible() then
		return
	end

	local funcName
	for funcName in pairs(MONITOR_FUNCS) do
		local button = FindMenuButton(_G[funcName])
		monitoredButtons[funcName] = button
		if button then
			updateFrame:Show()
		end
	end
end

addon:RegisterEventCallback("UnitButtonCreated", function(frame)
	frame.menu = menuFunc
end)