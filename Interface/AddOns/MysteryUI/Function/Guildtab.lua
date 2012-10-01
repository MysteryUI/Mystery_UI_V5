--在社交面板（快捷键O）和公会面板（快捷键J）上添加这两个面板的切换按钮

local addonName, L = ...; 
local function defaultFunc(L, key) 
return key; 
end 
setmetatable(L, {__index=defaultFunc}); 

local roster = false
------------------------

local f = CreateFrame("Frame")

local function NST_OnClick(self)
	if GuildFrame and GuildFrame:IsVisible() then
		ToggleFriendsFrame()
		ToggleGuildFrame()
	else
		self:SetChecked(true)
	end
end

local function NGT_OnClick(self)
	if FriendsFrame and FriendsFrame:IsVisible() then
		ToggleGuildFrame()
		ToggleFriendsFrame()
		if roster then
			GuildFrameTab2:Click()
		end
	else
		self:SetChecked(true)
	end
end

local function CreateOtherButtons()
	f.nst2 = CreateFrame("CheckButton", nil, GuildFrame, "SpellBookSkillLineTabTemplate")
		f.nst2:Show()
		f.nst2:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 2, -45)
		f.nst2.tooltip = L["社交"]
		f.nst2:SetNormalTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon")
	
	f.ngt2 = CreateFrame("CheckButton", nil, f.nst2, "SpellBookSkillLineTabTemplate")
		f.ngt2:Show()
		f.ngt2.tooltip = L["公会"]
		f.ngt2:SetPoint("TOPLEFT", f.nst2, "BOTTOMLEFT", 0, -21)
		if GetGuildTabardFileNames() then
			f.ngt2:SetNormalTexture("Interface\\SpellBook\\GuildSpellbooktabBG")
			f.ngt2.TabardEmblem:Show()
			f.ngt2.TabardIconFrame:Show()
			SetLargeGuildTabardTextures("player", f.ngt2.TabardEmblem, f.ngt2:GetNormalTexture(), f.ngt2.TabardIconFrame)
		else
			f.ngt2:SetNormalTexture("Interface\\GuildFrame\\GuildLogo-NoLogo")
		end

	f.nst2:SetScript("OnClick", NST_OnClick)
	f.ngt2:SetScript("OnClick", NGT_OnClick)
	
	f.nst2:SetScript("OnShow", function()
			f.nst2:SetChecked(false)
			f.ngt2:SetChecked(true)
		end)
end

local function CreateButtons()
	f.nst = CreateFrame("CheckButton", nil, FriendsFrame, "SpellBookSkillLineTabTemplate")
		f.nst:Show()
		f.nst:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 2, -45)
		f.nst:SetFrameStrata("LOW")
		f.nst.tooltip = L["社交"]
		f.nst:SetNormalTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon")

	f.ngt = CreateFrame("CheckButton", nil, f.nst, "SpellBookSkillLineTabTemplate")
		f.ngt:Show()
		f.ngt:SetPoint("TOPLEFT", f.nst, "BOTTOMLEFT", 0, -21)
		f.ngt:SetFrameStrata("LOW")
		f.ngt.tooltip = L["公会"]
		if GetGuildTabardFileNames() then
			f.ngt:SetNormalTexture("Interface\\SpellBook\\GuildSpellbooktabBG")
			f.ngt.TabardEmblem:Show()
			f.ngt.TabardIconFrame:Show()
			SetLargeGuildTabardTextures("player", f.ngt.TabardEmblem, f.ngt:GetNormalTexture(), f.ngt.TabardIconFrame)
		else
			f.ngt:SetNormalTexture("Interface\\GuildFrame\\GuildLogo-NoLogo")
		end
	
	f.nst:SetScript("OnClick", NST_OnClick)
	f.ngt:SetScript("OnClick", NGT_OnClick)
	f.nst:SetScript("OnShow", function()
			f.nst:SetChecked(true)
			f.ngt:SetChecked(false)
		end)
	
	CreateButtons = nil
end

FriendsFrame:HookScript("OnShow", function()	--make sure we grab the tabard, and not create tabs unless frame is shown
		if not f.nst then
			CreateButtons()
		end
	end)
f:SetScript("OnEvent", function(self, event, addon)
		if addon == "Blizzard_GuildUI" then
			CreateOtherButtons()
			f:UnregisterEvent("ADDON_LOADED")
			CreateOtherButtons = nil
		end
	end)
f:RegisterEvent("ADDON_LOADED")
