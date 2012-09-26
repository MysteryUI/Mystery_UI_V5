------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local _G = _G
local type = type
local _

local addonName, addon = ...
local L = addon.L
local templates = addon.optionTemplates

-------------------------------------------------------
-- The option frame
-------------------------------------------------------

local frame = UICreateInterfaceOptionPage("CompactRaidOptionFrame", addon.name.." "..addon.version, nil, nil, UIParent)
addon.optionFrame = frame
frame:SetDialogStyle("TITLE_DIALOG", true)
frame:SetSize(858, 660)
frame:SetPoint("CENTER")

------------------------------------------------------------
-- Register slash command to toggle the option frame
------------------------------------------------------------
SLASH_COMPACTRAID1 = "/compactraid"
SLASH_COMPACTRAID2 = "/craid"
SlashCmdList["COMPACTRAID"] = function(cmd)
	if cmd and strlower(cmd) == "debug" then
		addon:SetDebugMode(not addon:IsDebugMode())
	else
		frame:Toggle()
	end
end

function frame:AddCategory(title, optionPage, parentTitle)
	if type(title) ~= "string" or type(optionPage) ~= "table" then
		return
	end

	optionPage:Hide()
	optionPage:SetParent(self.pageContainer)
	optionPage:ClearAllPoints()
	optionPage:SetAllPoints(self.pageContainer)

	local level = 1
	local position
	if type(parentTitle) == "string" then
		position = self.categories:FindData(parentTitle, function(data, text) return data.title == text end)
		local data = self.categories:GetData(position)
		if data then
			level = data.level + 1
		end
	end
	self.categories:InsertData({ title = title, page = optionPage, level = level }, position and position + 1)
end

addon:RegisterEventCallback("OnModuleCreated", function(module)
	local page = templates:CreateModulePage(module)
	frame:AddCategory(module.title, page, module.parent)
end)

-------------------------------------------------------
-- Left panel: container of module categories
-------------------------------------------------------

local leftPanel = CreateFrame("Frame", frame:GetName().."LeftPanel", frame)
frame.leftPanel = leftPanel
leftPanel:SetBackdrop({ tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }})
leftPanel:SetBackdropBorderColor(0.75, 0.75, 0.75, 0.75)
leftPanel:SetPoint("TOPLEFT", 24, -32)
leftPanel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 220, 50)

local list = UICreateVirtualScrollList(leftPanel:GetName().."List", leftPanel, 10, 1)
frame.categories = list
list:SetPoint("TOPLEFT", 4, -5)
list:SetPoint("BOTTOMRIGHT", -4, 4)

function list:OnButtonCreated(button)
	local text = button:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	button.text = text
end

function list:OnButtonUpdate(button, data)
	local text = button.text
	text:ClearAllPoints()
	text:SetPoint("LEFT", (data.level - 1) * 8 + 5, 0)
	button.text:SetText(data.title)
	if self.checkedTexture.button == button then
		self.curButton = button
		button.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
end

local selectedPage
function frame:GetSelectedPage()
	return selectedPage
end

function list:OnSelectionChanged(position, data)
	local disabledPage = frame.disabledPage
	disabledPage:Hide()

	local page = selectedPage
	if page then
		page:Hide()
		addon:BroadcastEvent("OnModulePageHide", page.module, page)
	end

	page = data and data.page
	disabledPage.peerPage = page

	selectedPage = page
	if page then
		local module = page.module
		local disabled = module and not module:IsEnabled()
		if disabled then
			disabledPage:Show()
		else
			page:Show()
		end

		addon:BroadcastEvent("OnModulePageShow", module, page, disabled)
	end

	if self.curButton then
		self.curButton.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end

	self.curButton = self.checkedTexture.button
	if self.curButton then
		self.curButton.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
end

function list:OnButtonEnter(button, data, motion)
	button.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end

function list:OnButtonLeave(button, data, motion)
	if button ~= self.curButton then
		button.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end
end

-------------------------------------------------------
-- Right panel: container of option pages
-------------------------------------------------------

local rightPanel = CreateFrame("Frame", frame:GetName().."RightPanel", frame)
frame.rightPanel = rightPanel
rightPanel:SetBackdrop({ tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }})
rightPanel:SetBackdropBorderColor(0.75, 0.75, 0.75, 0.75)
rightPanel:SetPoint("TOPRIGHT", -24, -24)
rightPanel:SetPoint("BOTTOMLEFT", leftPanel, "BOTTOMRIGHT", 12, 0)

local pageContainer = CreateFrame("Frame", frame:GetName().."PageContainer", rightPanel)
frame.pageContainer = pageContainer
pageContainer:SetPoint("TOPLEFT", 6, -6)
pageContainer:SetPoint("BOTTOMRIGHT", -5, 5)

local buttonClose = CreateFrame("Button", frame:GetName().."Close", frame, "UIPanelButtonTemplate")
frame.buttonClose = buttonClose
buttonClose:SetSize(96, 24)
buttonClose:SetText(CLOSE)
buttonClose:SetPoint("TOPRIGHT", rightPanel, "BOTTOMRIGHT", 0, -5)
buttonClose:SetScript("OnClick", function() frame:Hide() end)

frame.disabledPage = templates:CreateDisabledPage(pageContainer)

-------------------------------------------------------
-- The first option page
-------------------------------------------------------

local module = {}
module.title = L["core module"]
module.desc = L["desc"]
module.Print = addon.Print

function addon:GetCoreModule()
	return module
end

function module:HasFlag(flag)
	return flag == "secure"
end

local scrollFrame = templates:CreateScrollFrame(frame:GetName().."CoreScrollFrame", rightPanel)

local page = templates:CreateModulePage(module)
page:SetParent(scrollFrame)
page.buttonDefaults:SetParent(scrollFrame)
page:Show()
page:SetSize(200, 200)
scrollFrame:SetScrollChild(page)

page.module = nil
module.optionPage = scrollFrame

local arrowFrame = templates:CreateNotifyFrame(frame:GetName().."ArrowFrame", scrollFrame, 186, 1)
arrowFrame:SetPoint("BOTTOMRIGHT", rightPanel, "BOTTOMRIGHT", -28, 26)
arrowFrame:SetText(L["scroll down for more options"])

local function UpdateArrowFrame()
	if scrollFrame:GetVerticalScrollRange() < scrollFrame:GetVerticalScroll() + 5 then
		arrowFrame:Hide()
	elseif not arrowFrame:IsClosed() then
		arrowFrame:Show()
	end
end

scrollFrame:HookScript("OnScrollRangeChanged", UpdateArrowFrame)
scrollFrame:HookScript("OnVerticalScroll", UpdateArrowFrame)

frame:AddCategory(L["core module"].."|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t", scrollFrame)
scrollFrame:ClearAllPoints()
scrollFrame:SetPoint("TOPLEFT")
scrollFrame:SetPoint("BOTTOMRIGHT", -22, 0)
list:SetSelection(1)

------------------------------------------------------------
-- General option items
------------------------------------------------------------

local anchor

local group = templates:CreateOptionMultiSelectionGroup(page, L["general options"])
page:AnchorToTopLeft(group, 0, -6)
group:AddButton(L["lock position"], "lock")
group:AddButton(L["show solo"], "showSolo", 1)
group:AddButton(L["show party"], "showParty", 1)
group:AddButton(L["show party pets"], "showPartyPets", 1, "charOption", 1)
group:AddButton(L["show raid pets"], "showRaidPets", 1, "charOption", 1)
group:AddButton(L["horizontal align"], "grouphoriz", 1)
group:AddButton(L["keep raid groups together"], "keepgroupstogether", 1)

local lockCheck = group[1]
addon:RegisterOptionCallback("lock", function(value)
	lockCheck:SetChecked(value)
end)

local MEMORY_PER_BUTTON = 3.85 -- Approximated memory consumption per unit button, in kilo-bytes

templates:CreateCheckButtonInfo(group[5], L["memory monitor tooltip title option"], format(L["memory monitor tooltip text option 1"], MEMORY_PER_BUTTON * 20))
templates:CreateCheckButtonInfo(group[7], L["memory monitor tooltip title option"], format(L["memory monitor tooltip text option 2"], MEMORY_PER_BUTTON * 40))

------------------------------------------------------------
-- Raid option items
------------------------------------------------------------

local filterCombo = templates:CreateOptionCombo(page, "raidFilter", L["sort raid units"], 1)
filterCombo.text:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 28, -6)
filterCombo:AddLine(NONE, nil)
filterCombo:AddLine(CLASS, "CLASS")
filterCombo:AddLine(MAINTANK.."/"..MAIN_ASSIST, "ROLE")
filterCombo:AddLine(RAID_SORT_ALPHABETICAL, "NAME")
filterCombo:AddLine(RAID_SORT_GROUP, "GROUP")

local groupAnchor = group[-1]
addon:RegisterOptionCallback("keepgroupstogether", function(value)
	local yOffset
	if value then
		filterCombo:Hide()
		yOffset = -16
	else
		filterCombo:Show()
		yOffset = -42

	end

	local group = page.clickGroup
	group:ClearAllPoints()
	group:SetPoint("TOPLEFT", groupAnchor, "BOTTOMLEFT", 0, yOffset)
end)

------------------------------------------------------------
-- Mouse-click options
------------------------------------------------------------

group = templates:CreateOptionSingleSelectionGroup(page, L["mouse-click response"], "clickDownMode")
page.clickGroup = group
group:AddButton(L["button down"], 1)
group:AddButton(L["button up"])

------------------------------------------------------------
-- Tooltip options
------------------------------------------------------------

anchor = group[1]
group = templates:CreateOptionSingleSelectionGroup(page, L["show tooltips"], "showtooltip")
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -16)
group:AddButton(ALWAYS, 2)
group:AddButton(L["out of combat"], 1)
group:AddButton(NEVER, 0)

anchor = group[1]
group = templates:CreateOptionSingleSelectionGroup(page, L["tooltip position"], "tooltipPosition")
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -16)
group:AddButton(DEFAULT, 0)
group:AddButton(L["tooltip position unit frame"], 1)

------------------------------------------------------------
-- Unit frame options
------------------------------------------------------------

anchor = group[1]
group = templates:CreateOptionMultiSelectionGroup(page, L["unit options"])
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -16)
group:AddButton(L["hide role icon"], "hideRoleIcon")
group:AddButton(L["hide raid target icon"], "hideRaidIcon")
group:AddButton(L["invert bar color"], "invertColor")
group:AddButton(L["hide bar background"], "hidebarbkgnd")

local bkColor = templates:CreateLabeledColorSwatch(nil, page, L["unit background color"], "unitBkColor")
bkColor:SetPoint("TOP", group[-1], "BOTTOM", 0, -4)

local scaleSlider = templates:CreateOptionSlider(page, "scale", L["frame scale"], 25, 300, 5, "%d%%", 1)
scaleSlider:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 8, -56)

local spacingSlider = templates:CreateOptionSlider(page, "spacing", L["unit spacing"], 0, 10, 1, nil, 1)
spacingSlider:SetPoint("LEFT", scaleSlider, "RIGHT", 20, 0)

local widthSlider = templates:CreateOptionSlider(page, "width", L["unit width"], 24, 120, 2, nil, 1)
widthSlider:SetPoint("TOPLEFT", scaleSlider, "BOTTOMLEFT", 0, -38)

local heightSlider = templates:CreateOptionSlider(page, "height", L["unit height"], 24, 120, 2, nil, 1)
heightSlider:SetPoint("LEFT", widthSlider, "RIGHT", 20, 0)

local powerBarSlider = templates:CreateOptionSlider(page, "powerBarHeight", L["mana height"], 0, 10)
powerBarSlider:SetPoint("TOPLEFT", widthSlider, "BOTTOMLEFT", 0, -38)

local outrangeAlphaSlider = templates:CreateOptionSlider(page, "outrangeAlpha", L["outrange alpha"], 25, 100, 5, "%d%%")
outrangeAlphaSlider:SetPoint("LEFT", powerBarSlider, "RIGHT", 20, 0)

------------------------------------------------------------
-- Health bar color options
------------------------------------------------------------

anchor = group[-1]
group = templates:CreateColorSelectionGroup(page, L["health bar color"], "forceHealthColor", "healthColor")
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -192)

------------------------------------------------------------
-- Health text options
------------------------------------------------------------

local healthTextCombo = templates:CreateOptionCombo(page, "healthtextmode", L["health text"])
healthTextCombo.text:SetPoint("TOPLEFT", group[1], "BOTTOMLEFT", 0, -6)
healthTextCombo:AddLine(COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_NONE, 0)
healthTextCombo:AddLine(COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_HEALTH, 1)
healthTextCombo:AddLine(COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_LOSTHEALTH, 2)
healthTextCombo:AddLine(COMPACT_UNIT_FRAME_PROFILE_HEALTHTEXT_PERC, 3)

group = templates:CreateColorSelectionGroup(page, L["power bar color"], "forcePowerColor", "powerColor")
group:SetPoint("TOPLEFT", healthTextCombo.text, "BOTTOMLEFT", 0, -20)

------------------------------------------------------------
-- Name text options
------------------------------------------------------------

anchor = group[1]
group = templates:CreateColorSelectionGroup(page, L["name text options"], "forceNameColor", "nameColor")
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -16)

local nameLenSlider = templates:CreateOptionSlider(page, "nameWidthLimit", L["text length"], 0, 100, 5, "%d%%")
nameLenSlider:SetPoint("TOPLEFT", group[1], "BOTTOMLEFT", 8, -26)

local nameHeightSlider = templates:CreateOptionSlider(page, "nameHeight", L["text height"], 4, 20)
nameHeightSlider:SetPoint("LEFT", nameLenSlider, "RIGHT", 20, 0)

local nameXOffSlider = templates:CreateOptionSlider(page, "nameXOffset", L["x-offset"], -20, 20)
nameXOffSlider:SetPoint("TOPLEFT", nameLenSlider, "BOTTOMLEFT", 0, -34)

local nameYOffSlider = templates:CreateOptionSlider(page, "nameYOffset", L["y-offset"], -20, 20)
nameYOffSlider:SetPoint("LEFT", nameXOffSlider, "RIGHT", 20, 0)

------------------------------------------------------------
-- Container options
------------------------------------------------------------

group = templates:CreateOptionMultiSelectionGroup(page, L["frame container options"])
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -176)
group:AddButton(L["hide tool buttons"], "hideToolboxes", 1)

anchor = group

local containerAlphaSlider = templates:CreateOptionSlider(page, "containerAlpha", L["background alpha"], 0, 100, 5, "%d%%")
containerAlphaSlider:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 8, -64)

local borderSizeSlider = templates:CreateOptionSlider(page, "containerBorderSize", L["border size"], 0, 24, 1, nil, 1)
borderSizeSlider:SetPoint("LEFT", containerAlphaSlider, "RIGHT", 20, 0)

------------------------------------------------------------
-- Aura options
------------------------------------------------------------
group = templates:CreateOptionMultiSelectionGroup(page, L["aura options"])
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -100)
group:AddButton(L["hide buffs"], "hideBuffs")
group:AddButton(L["hide debuffs"], "hideDebuffs")
group:AddButton(L["only show dispellable debuffs"], "onlyDispellable")
group:AddButton(L["hide dispels"], "hideDispels")

------------------------------------------------------------
-- Loads addon option data
------------------------------------------------------------

function addon:ApplyOption(option, ...)
	self:BroadcastOptionEvent(option, ...)
	self:UpdateContainerSize()
end

local function LoadOption(option, default, minVal, maxVal, char)
	local dbname = char and "chardb" or "db"
	local value = addon[dbname][option]
	if default then
		if type(value) ~= type(default) then
			value = default
		elseif minVal or maxVal then
			value = addon:NormalizeNumber(value, minVal, maxVal, default)
		end
	end

	addon[dbname][option] = value
	addon:ApplyOption(option, value)
end

local function LoadOptionColor(option, defaultR, defaultG, defaultB)
	local r, g, b = addon:UnpackColor(addon.db[option], defaultR, defaultG, defaultB)
	addon.db[option] = addon:PackColor(r, g, b)
	addon:ApplyOption(option, r, g, b)
end

local function InitOptionData(db, chardb)
	-- Some option features are changed in recent update
	if not db.v30 then
		db.v30 = 1
		db.lock =1
		db.showSolo = 1
		db.showParty = 1
		db.keepgroupstogether = 1
		db.raidFilter = "CLASS"
		chardb.showPartyPets = 1
	end

	-- Initialize addon data
	LoadOption("scale", 100, 25, 300)
	LoadOption("width", 64, 24, 120)
	LoadOption("height", 40, 24, 120)
	LoadOption("spacing", 2, 0, 10)
	LoadOption("outrangeAlpha", 60, 0, 100)
	LoadOptionColor("unitBkColor", 0, 0, 0)
	LoadOption("hideRoleIcon")
	LoadOption("hideRaidIcon")
	LoadOption("tooltipPosition", 1, 0, 1)
	LoadOption("hideToolboxes", 1)

	LoadOption("hidebarbkgnd", 1)
	LoadOption("showSolo")
	LoadOption("showParty")
	LoadOption("showPartyPets", nil, nil, nil, 1)
	LoadOption("showRaidPets", nil, nil, nil, 1)

	LoadOption("powerBarHeight", 3, 0, 10)

	LoadOption("clickDownMode")
	LoadOption("showtooltip", 1, 0, 2)

	LoadOption("nameWidthLimit", 75, 0, 100)
	LoadOption("nameHeight", 12, 4, 20)
	LoadOption("nameXOffset", 0, -20, 20)
	LoadOption("nameYOffset", 0, -20, 20)

	LoadOption("forceNameColor")
	LoadOptionColor("nameColor", 1, 1, 1)
	LoadOption("forceHealthColor")
	LoadOptionColor("healthColor", 0, 1, 0)
	LoadOption("forcePowerColor")
	LoadOptionColor("powerColor", 0, 0, 1)

	LoadOption("healthtextmode", 0, 0, 3)

	LoadOption("grouphoriz")
	LoadOption("keepgroupstogether")
	LoadOption("raidFilter")

	LoadOption("containerAlpha", 0, 0, 100)
	LoadOption("containerBorderSize", 12, 0, 24)

	LoadOption("hideBuffs")
	LoadOption("hideDebuffs")
	LoadOption("onlyDispellable")
	LoadOption("hideDispels")
end

addon:RegisterEventCallback("OnInitialize", InitOptionData)

function module:OnRestoreDefaults()
	local modules = addon.db.modules
	wipe(addon.db)
	addon.db.modules = modules

	modules = addon.chardb.modules
	wipe(addon.chardb)
	addon.chardb.modules = modules

	InitOptionData(addon.db, addon.chardb)
end

------------------------------------------------------------
-- Memory monitor
------------------------------------------------------------

local monitor = templates:CreateInfoButton(frame:GetName().."MemoryMonitor", scrollFrame)
monitor:SetPoint("TOPLEFT", leftPanel, "BOTTOMLEFT", 0, -9)

function monitor:OnTooltip(tooltip)
	tooltip:AddLine(L["memory monitor tooltip title"])
	tooltip:AddLine(L["memory monitor tooltip text 1"], 1, 1, 1, 1)
	tooltip:AddLine(L["memory monitor tooltip text 2"], 1, 1, 1, 1)
	local recommendation
	if addon.chardb.showRaidPets then
		recommendation = L["memory monitor tooltip recommenation 1"]
	elseif #(addon:GetRaidGroup("pet")) > 10 or (#(addon:GetRaidGroup("group")) > 10 and #(addon:GetRaidGroup(8)) > 4) then
		recommendation = L["memory monitor tooltip recommenation 2"]
	else
		recommendation = L["memory monitor tooltip recommenation none"]
	end
	tooltip:AddLine(L["memory monitor tooltip recommenation"]..recommendation, 1, 1, 1, 1)
end

local monitorText = monitor:CreateFontString(monitor:GetName().."Text", "ARTWORK", "GameFontHighlight")
monitorText:SetPoint("LEFT", monitor, "RIGHT", 4, 0)

local function UpdateMemoryUsage()
	local buttons = addon:NumButtons()
	local color
	if buttons <= 52 then
		color = "00ff00" -- Best case: solo (2), party (10), one raid (40)
	elseif buttons <= 72 then
		color = "ffff00" -- Normal case: solo (2), party (10), one raid (40), raid pet (20)
	else
		color = "ff0000" -- Worst case: all (112) - solo (2), party (10), two raid (40 * 2), raid pet (20)
	end

	UpdateAddOnMemoryUsage()
	monitorText:SetFormattedText(L["memory monitor info"], color, buttons, color, GetAddOnMemoryUsage(addonName))
end

monitor:SetScript("OnShow", UpdateMemoryUsage)

monitor:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 1 then
		self.elapsed = 0
		UpdateMemoryUsage()
	end
end)