------------------------------------------------------------
-- DisableBlizzard.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local _G = _G
local RegisterStateDriver = RegisterStateDriver
local SetCVar = SetCVar
local MAX_PARTY_MEMBERS = MAX_PARTY_MEMBERS

local _, addon = ...
local L = addon.L

local function DisableBlizzardFrame(frame)
	if not frame then
		return
	end

	frame:UnregisterAllEvents()
	frame:SetScript("OnEvent", nil)
	frame:SetScript("OnUpdate", nil)
	frame:SetScript("OnSizeChanged", nil)
	frame:EnableMouse(false)
	frame:EnableKeyboard(false)
	frame:Hide()
	frame:SetAlpha(0)
	frame:SetScale(0.01)
	RegisterStateDriver(frame, "visibility", "hide")
end

DisableBlizzardFrame(CompactRaidFrameManager)
DisableBlizzardFrame(CompactRaidFrameContainer)
DisableBlizzardFrame(CompactUnitFrameProfilesGeneralOptionsFrame)
DisableBlizzardFrame(CompactUnitFrameProfilesRaidStylePartyFrames)
DisableBlizzardFrame(CompactUnitFrameProfilesProfileSelector)
DisableBlizzardFrame(CompactUnitFrameProfilesSaveButton)
DisableBlizzardFrame(CompactUnitFrameProfilesDeleteButton)

CompactUnitFrameProfiles:UnregisterAllEvents()
CompactUnitFrameProfiles:SetScript("OnEvent", nil)
UIParent:UnregisterEvent("RAID_ROSTER_UPDATE")

-- Display some infomation so the user won't get confused when he sees a blank page
local prompt = CompactUnitFrameProfiles:CreateFontString(nil, "ARTWORK", "GameFontNormal")
prompt:SetText(L["over ride prompt"])
prompt:SetPoint("TOP", 0, -120)

local button = CreateFrame("Button", "CompactRaidOverrideButton", CompactUnitFrameProfiles, "UIPanelButtonTemplate")
button:SetSize(120, 24)
button:SetPoint("TOP", prompt, "BOTTOM", 0, -16)
button:SetText(SETTINGS)
button:SetScript("OnClick", function(self)
	addon.optionFrame:Show()
end)

local blizzPartyParent = CreateFrame("Frame", nil, UIParent, "SecureFrameTemplate")
blizzPartyParent:RegisterEvent("VARIABLES_LOADED")
blizzPartyParent:SetScript("OnEvent", function(self)
	SetCVar("useCompactPartyFrames", "0")
end)

local i
for i = 1, MAX_PARTY_MEMBERS do
	local frame = _G["PartyMemberFrame"..i]
	if frame then
		frame:SetParent(blizzPartyParent)
		--RegisterStateDriver(frame, "visibility", "show") -- just for debug
	end
end

if PartyMemberBackground then
	PartyMemberBackground:SetParent(blizzPartyParent)
end

addon:RegisterOptionCallback("showParty", function(value)
	if value then
		blizzPartyParent:Show()--Hide()
	else
		blizzPartyParent:Show()
	end
end)