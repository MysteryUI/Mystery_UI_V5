local addonName, addon = ...

addon.spellDB = {
   
	-- Higher up = higher display prio
	
	-- immunitys
	"45438",	-- Ice Block
	"33786", 	-- Cyclone
	"642", 		-- Divine Shield
	"1022",		-- Hand of Protection
	"19263", 	-- Deterrence
	"46924",	-- Bladestorm

	-- stuns
	"408", 		-- Kidney Shot
	"1833",		-- Cheap Shot
	"12809", 	-- Concussion Blow
	"46968", 	-- Shockwave
	"853", 		-- Hammer of Justice
	"105593",	-- Fist of Justice
	"49203", 	-- Hungering Cold
	"85388", 	-- Throwdown
	"44572", 	-- Deep Freeze
	"5211",	 	-- Bash
	"19503", 	-- Scatter Shot
	"30283", 	-- Shadowfury
	"89605", 	-- Aura of Foreboding
	"89766", 	-- Axe Toss
	"22570", 	-- Maim
	"9005", 	-- Pounce
	"47481",	-- Gnaw
	"1776", 	-- Gouge
	"6770",		-- Sap
	"87195",	-- Paralysis
	"88625",	-- Holy Word: Chastise   
	"90337",	-- Bad Manner (monkey stun)   
	"12489",	-- Improved Cone of Cold
	"65929",	-- Charge Stun
	"20253", 	-- Intercept 
	"91797", 	-- Monstrous Blow (Gnaw with DT)
	   
	--cc
	"91807", 	-- Shambling Rush (Leap with DT)
	"87100",	-- Sin and Punishment
	"1513", 	-- Scare Beast
	"2637",		-- Hibernate
	"605", 		-- Mind Control
	"64044",	-- Psychic Horror
	"2094", 	-- Blind
	"118", 		-- Polymorph
	"118271", 	-- 灼烧冲击
--	"44457", 	-- 活体炸弹
	"51514", 	-- Hex
	"6789", 	-- Death Coil
	"5246", 	-- Intimidating Shout 
	"8122",		-- Psychic Scream
	"5484", 	-- Howl of Terror
	"5782",		-- Fear
	"6358",		-- Seduction
	"1499",		-- Freezing Trap
	"20066",	-- Repentance
	"339", 		-- Entangling Roots
	"8377", 	-- Earthgrab
	"31661",	-- Dragon's Breath
	"16689", 	-- Nature's Grasp
	"82691", 	-- Ring of Frost
	"23694", 	-- Improved Hamstring
	"76780", 	-- Bind Elemental
	"19387", 	-- Entrapment
	
	-- cc immune
	"53271",	-- Master's Call
	"1044", 	-- Hand of Freedom
	"31224",	-- Cloak of Shadows
	"51271",	-- Pillar of Frost

	"31821", 	-- Aura Mastery
	
	-- dmg reductions
	"48707", 	-- Anti-Magic Shell
	"30823", 	-- Shamanistic Rage 
	"33206", 	-- Pain Suppression
	"47585", 	-- Dispersion
	"871", 		-- Shield Wall
	"48792",	-- Icebound Fortitude
	"498", 		-- Divine Protection
	"22812", 	-- Barkskin
	"61336",	-- Survival Instincts	
	"5277", 	-- Evasion
	"74001",	-- Combat Readiness
	"47788",	 -- Guardian Spirit
   
	-- silences
	"47476", 	-- Strangulate
	"1330", 	-- Garrote - Silence
	"55021", 	-- Silenced - Improved Counterspell
	"15487", 	-- Silence (priest)
	"19647", 	-- Spell Lock
	"34490", 	-- Silencing Shot
	"28730", 	-- Arcane Torrent
	
	-- disarms
	"676", 		-- Disarm
	"51722", 	-- Dismantle
	
	--dmg buffs  
	"34692", 	-- The Beast Within
	"31884", 	-- Avenging Wrath
	"51713", 	-- Shadow Dance 
	
	--helpful buffs
	"85499",	-- Speed of Light
	"6940", 	-- Hand of Sacrifice
	"89488", 	-- Strength of Soul
	"23920", 	-- Spell Reflection (warrior)
	"68992", 	-- Darkflight (Worgen racial)
	"31642", 	-- Blazing Speed
	"54428", 	-- Divine Plea
	"2983", 	-- Sprint
	"1850", 	-- Dash
	"29166", 	-- Innervate
	
}

local L = addon

function addon.CreateConfig()

	addon.panel = CreateFrame("Frame", addonName.."panel", UIParent)
	addon.panel.name = "ControlTimers"
	InterfaceOptions_AddCategory(addon.panel)

	addon.title = addon.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	addon.title:SetPoint("TOPLEFT", 16, -16)
	addon.title:SetText(L["ControlTimers Config"])

	addon.subtitle = addon.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	addon.subtitle:SetPoint("TOPLEFT", addon.title, "BOTTOMLEFT", 0, -8)
	addon.subtitle:SetNonSpaceWrap(true)
	addon.subtitle:SetText("v"..addon.version)
	addon.subtitle:SetTextColor(1, 1, 1, 0.5)
	
	----------------------------------
	-- panel 1 start
	----------------------------------
	
	addon.submenu1 = CreateFrame("Frame", addonName.."submenu1", addon.panel)
	addon.submenu1.name = L["Display"]
	addon.submenu1.parent = addon.panel.name
	InterfaceOptions_AddCategory(addon.submenu1)
	local p1 = addon.submenu1

	p1.title = p1:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	p1.title:SetPoint("TOPLEFT", addon.submenu1, "TOPLEFT", 16, -16)
	p1.title:SetText(L["Display"])

	p1.subtitle = p1:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	p1.subtitle:SetPoint("TOPLEFT", p1.title, "BOTTOMLEFT", 0, -8)
	p1.subtitle:SetNonSpaceWrap(true)
	p1.subtitle:SetText(L["Display Settings"])

	addon.dropdown1 = CreateFrame("Frame", addonName.."dropdown1", p1, "UIDropDownMenuTemplate")
	addon.dropdown1:SetPoint("TOPLEFT", p1.subtitle, "BOTTOMLEFT", -10, -30)
	addon.dropdown1:SetWidth(40)
	addon.dropdown1.font = addon.dropdown1:CreateFontString(addonName.."dropdownFont", "ARTWORK", "GameFontNormalSmall")
	addon.dropdown1.font:SetPoint("BOTTOMLEFT", addon.dropdown1, "TOPLEFT", 20, 0)
	addon.dropdown1.font:SetText(L["Font Size:"])
	_G[addon.dropdown1:GetName().."Button"]:SetScript("OnClick", function(self, button, down)
		  ToggleDropDownMenu(1, nil, addon.dropdown1, self:GetName(), -100 ,0)
	end)

	local info = {}

	function addon.dropdown1.initialize(self, level)
		if not level then return end
		wipe(info)
		if level == 1 then
			addon.CreateMenu(info)
		end
	end

	function addon.OnClickFunc(button, arg1, arg2, checked)
		addon.db.fontSize = arg1
		local newfont, size = _G[arg2]:GetFont()
		addon.testFont:SetFont(newfont, size, "OUTLINE")
		addon.testFont2:SetFont(newfont, size/1.3, "OUTLINE")
		addon.arenaTextureFrame.font:SetFont(newfont, size/1.3, "OUTLINE")
		-- print("selected " .. arg1, arg2)
		UIDropDownMenu_SetText(addon.dropdown1, arg1)
	end	
		
	function addon.CreateMenu(info)
		for k, v in pairs(addon.fontsDB) do
			info.text = k
			info.isTitle = nil
			info.notCheckable = nil
			info.func = addon.OnClickFunc
			info.arg1 = k
			info.arg2 = v
			info.fontObject = addon[k]
			info.checked = addon.isCurrent(k)
			UIDropDownMenu_AddButton(info)
		end
	end	

	function addon.isCurrent(font)
		if addon.db.fontSize == font then
			return true
		else
			return false
		end
	end

	addon.texture = p1:CreateTexture()
	addon.texture:SetTexture("Interface\\Icons\\Spell_Holy_SealOfValor")
	addon.texture:SetPoint("LEFT", addon.dropdown1, "RIGHT", 200, 0)
	
	addon.testFont = p1:CreateFontString(nil, "ARTWORK")
	addon.testFont:SetPoint("CENTER", addon.texture, "CENTER")
	local newfont, size = _G[addon.fontsDB[addon.db.fontSize]]:GetFont()
	addon.testFont:SetFont(newfont, size, "OUTLINE")
	addon.testFont:SetText("8.2")
	addon.testFont:SetTextColor(addon.db.r, addon.db.g, addon.db.b, addon.db.a)

	addon.texture2 = p1:CreateTexture()
	addon.texture2:SetTexture("Interface\\Icons\\Spell_Shadow_NetherCloak")
	addon.texture2:SetPoint("LEFT", addon.texture, "RIGHT", 0, 0)
	addon.texture2:SetHeight(40)
	addon.texture2:SetWidth(40)
	
	addon.testFont2 = p1:CreateFontString(nil, "ARTWORK")
	addon.testFont2:SetPoint("CENTER", addon.texture2, "CENTER")
	local newfont, size = _G[addon.fontsDB[addon.db.fontSize]]:GetFont()
	addon.testFont2:SetFont(newfont, size/1.3, "OUTLINE")
	addon.testFont2:SetText("4.9")
	addon.testFont2:SetTextColor(addon.db.r, addon.db.g, addon.db.b, addon.db.a)
	
	addon.colorButton = CreateFrame("Button", nil, p1, "OptionsCheckButtonTemplate")
	local frame = addon.colorButton
	frame:SetPoint("TOPLEFT", addon.dropdown1, "BOTTOMLEFT", 20, -10)
	frame:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight")
	frame:SetScript("OnClick", function(self)
		addon.ShowColorPicker(addon.db.r, addon.db.g, addon.db.b, addon.myColorCallback);
	end)
	
	frame.texture = frame:CreateTexture(nil, "OVERLAY")
	frame.texture:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
	frame.texture:SetTexture(addon.db.r, addon.db.g, addon.db.b)
	frame.texture:SetPoint("CENTER", frame, "CENTER")
	frame.texture:SetHeight(frame:GetHeight()/2)
	frame.texture:SetWidth(frame:GetHeight()/2)

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.text:SetPoint("LEFT", frame, "RIGHT")
	frame.text:SetText(L["Font Color"])
	frame.text:SetTextColor(1, 1, 1)
	
	p1.checkbox1 = CreateFrame("CheckButton", addonName.."p1_checkbox1", p1, "ChatConfigCheckButtonTemplate")
	p1.checkbox1:SetPoint("TOPLEFT", addon.colorButton, "BOTTOMLEFT", 0, -5)
	_G[p1.checkbox1:GetName().."Text"]:SetText(L["Show Decimals"])
	_G[p1.checkbox1:GetName().."Text"]:SetPoint("LEFT",  p1.checkbox1, "RIGHT", 3, 1)
	p1.checkbox1.tooltip = L["Click to toggle decimal display on frames"]
	p1.checkbox1:Show()
	p1.checkbox1:SetScript("OnClick", function(self, button, down)
		if  p1.checkbox1:GetChecked() then
			addon.db.showDecimals = true
			addon.testFont:SetText("8.2")
			addon.testFont2:SetText("4.9")
			addon.arenaTextureFrame.font:SetText("2.7")
		else
			addon.testFont:SetText("8")
			addon.testFont2:SetText("4")
			addon.arenaTextureFrame.font:SetText("2")
			addon.db.showDecimals = false
		end
	end)
	
	p1.font = p1:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	p1.font:SetPoint("TOPLEFT", p1.checkbox1, "BOTTOMLEFT", 5, -30)
	p1.font:SetText(L["Font Position:"])
	p1.font:SetTextColor(1, 1, 1)
	
	function addon.Text_SetPoint(self)
		local id, parent = self:GetID(), "CENTER"
		if id == 1 then
			parent = "CENTER"
		elseif id == 2 then
			parent = "TOP"
		elseif id == 3 then
			parent = "BOTTOM"
		elseif id == 4 then
			parent = "RIGHT"
		elseif id == 5 then
			parent = "LEFT"
		end
		addon.UpdateFontParent(parent)
		addon.db.fontParent = parent
	end
	
	for i = 1, 5 do
		local button = CreateFrame("Button", "pt_btn"..i, p1, "UIPanelButtonTemplate")
		button:SetHeight(25)
		button:SetWidth(25)
		button:SetID(i)
		button:SetScript("OnClick", addon.Text_SetPoint)
	end

	pt_btn1:SetPoint("LEFT", p1.font, "RIGHT", 50, 0)
	pt_btn2:SetPoint("BOTTOM", pt_btn1, "TOP")
	pt_btn3:SetPoint("TOP", pt_btn1, "BOTTOM")
	pt_btn4:SetPoint("LEFT", pt_btn1, "RIGHT")
	pt_btn5:SetPoint("RIGHT", pt_btn1, "LEFT")

	addon.slider1 = CreateFrame("Slider", addonName.."slider1", p1, "OptionsSliderTemplate")
	addon.slider1:SetPoint("TOPLEFT", p1.font, "BOTTOMLEFT", 0, -70)
	_G[addon.slider1:GetName().."Text"]:SetText(L["Arena Frame Scale: "] .. string.format("%.0f", addon.db.arenaFrameScale*100).."%")
	addon.slider1.tooltipText = L["Drag to set Arena Frame Scale"]
	_G[addon.slider1:GetName().."Low"]:SetText("100%")
	_G[addon.slider1:GetName().."High"]:SetText("200%")
	addon.slider1:SetWidth(155)
	addon.slider1:SetMinMaxValues(1, 2)
	addon.slider1:SetValue(addon.db.arenaFrameScale)
	addon.slider1:SetValueStep(0.1)
	addon.slider1:SetScript("OnValueChanged", function(self, value)
		addon.db.arenaFrameScale = value
		_G[addon.slider1:GetName().."Text"]:SetText(L["Arena Frame Scale: "] .. string.format("%.0f", value*100).."%")
		addon.arenaTextureFrame:SetScale(value)
	end)
	
	addon.arenaTextureFrame = CreateFrame("Frame", nil, p1)
	addon.arenaTextureFrame.tex = addon.arenaTextureFrame:CreateTexture(nil, "OVERLAY")
	addon.arenaTextureFrame.tex:SetTexture("Interface\\ArenaEnemyFrame\\UI-ArenaTargetingFrame")
	addon.arenaTextureFrame.tex:SetTexCoord(0, 0.796, 0, 0.5)
	addon.arenaTextureFrame.tex:SetPoint("TOPLEFT", addon.slider1, "BOTTOMLEFT", 20, -10)
	addon.arenaTextureFrame.tex:SetWidth(102)
	addon.arenaTextureFrame.tex:SetHeight(32)
	addon.arenaTextureFrame.port = addon.arenaTextureFrame:CreateTexture(nil, "ARTWORK")
	SetPortraitToTexture(addon.arenaTextureFrame.port, "Interface\\Icons\\Ability_Rogue_KidneyShot")
	addon.arenaTextureFrame.port:SetPoint("RIGHT", addon.arenaTextureFrame.tex, "RIGHT", -2, 0)
	addon.arenaTextureFrame.port:SetWidth(25)
	addon.arenaTextureFrame.port:SetHeight(25)
	
	addon.numberFrame = CreateFrame("Frame", nil, p1)
	addon.numberFrame:SetFrameStrata("DIALOG")
	addon.arenaTextureFrame.font = addon.numberFrame:CreateFontString(nil, "OVERLAY")
	addon.arenaTextureFrame.font:SetPoint("CENTER", addon.arenaTextureFrame.port, "CENTER")
	local newfont, size = _G[addon.fontsDB[addon.db.fontSize]]:GetFont()
	addon.arenaTextureFrame.font:SetFont(newfont, size/1.3, "OUTLINE")
	addon.arenaTextureFrame.font:SetText("2.7")
	addon.arenaTextureFrame.font:SetTextColor(addon.db.r, addon.db.g, addon.db.b, addon.db.a)
	
	----------------------------------
	-- panel 1 end
	----------------------------------
	
	----------------------------------
	-- panel 2 start
	----------------------------------
	addon.submenu2 = CreateFrame("Frame", addonName.."submenu2", addon.panel)
	addon.submenu2.name = L["Frames"]
	addon.submenu2.parent = addon.panel.name
	InterfaceOptions_AddCategory(addon.submenu2)
	local p2 = addon.submenu2

	p2.title = p2:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	p2.title:SetPoint("TOPLEFT", addon.submenu2, "TOPLEFT", 16, -16)
	p2.title:SetText(L["Frames"])

	p2.subtitle = p2:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	p2.subtitle:SetPoint("TOPLEFT", p2.title, "BOTTOMLEFT", 0, -8)
	p2.subtitle:SetNonSpaceWrap(true)
	p2.subtitle:SetText(L["Frame Settings"])
	
	addon.checkbox3 = CreateFrame("CheckButton", addonName.."checkbox3", p2, "ChatConfigCheckButtonTemplate")
	addon.checkbox3:SetPoint("LEFT", p2.subtitle, "LEFT", 0, -30)
	_G[addon.checkbox3:GetName().."Text"]:SetText(L["Enable on Player Frame"])
	_G[addon.checkbox3:GetName().."Text"]:SetPoint("LEFT", addon.checkbox3, "RIGHT", 3, 1)
	addon.checkbox3.tooltip = L["Click to toggle aura display on Player Frame"]
	addon.checkbox3:SetScript("OnClick", function(self, button, down)
		if addon.checkbox3:GetChecked() then
			addon.db.showPlayerAuras = true
		else
			addon.db.showPlayerAuras = false
		end
	end)
	
	addon.checkbox1 = CreateFrame("CheckButton", addonName.."checkbox1", p2, "ChatConfigCheckButtonTemplate")
	addon.checkbox1:SetPoint("TOPLEFT", addon.checkbox3, "BOTTOMLEFT", 0, -5)
	_G[addon.checkbox1:GetName().."Text"]:SetText(L["Enable on Party Frames"])
	_G[addon.checkbox1:GetName().."Text"]:SetPoint("LEFT", addon.checkbox1, "RIGHT", 3, 1)
	addon.checkbox1.tooltip = L["Click to toggle aura display on Party Frames"]
	addon.checkbox1:Show()
	addon.checkbox1:SetScript("OnClick", function(self, button, down)
		if addon.checkbox1:GetChecked() then
			addon.db.showPartyAuras = true
		else
			addon.db.showPartyAuras = false
		end
	end)
	
	addon.checkbox2 = CreateFrame("CheckButton", addonName.."checkbox2", p2, "ChatConfigCheckButtonTemplate")
	addon.checkbox2:SetPoint("TOPLEFT", addon.checkbox1, "BOTTOMLEFT", 15, -5)
	_G[addon.checkbox2:GetName().."Text"]:SetText(L["Always Show Blizzard Party Frames in Arena"])
	_G[addon.checkbox2:GetName().."Text"]:SetPoint("LEFT", addon.checkbox2, "RIGHT", 3, 1)
	addon.checkbox2.tooltip = L["Click to toggle Blizzard Party Frames display"]
	addon.checkbox2:Hide()
	addon.checkbox2:SetScript("OnClick", function(self, button, down)
		if addon.checkbox2:GetChecked() then
			addon.db.showPartyFrames = true
		else
			addon.db.showPartyFrames = false
		end
	end)
	
	addon.checkbox4 = CreateFrame("CheckButton", addonName.."checkbox4", p2, "ChatConfigCheckButtonTemplate")
	addon.checkbox4:SetPoint("TOPLEFT", addon.checkbox1, "BOTTOMLEFT", 0, -35)
	_G[addon.checkbox4:GetName().."Text"]:SetText(L["Enable on Blizzard Arena Frames"])
	_G[addon.checkbox4:GetName().."Text"]:SetPoint("LEFT", addon.checkbox4, "RIGHT", 3, 1)
	addon.checkbox4.tooltip = L["Click to toggle aura display on Blizzard Arena Frames"]
	addon.checkbox4:SetScript("OnClick", function(self, button, down)
		if addon.checkbox4:GetChecked() then
			addon.db.showArenaAuras = true
		else
			addon.db.showArenaAuras = false
		end
	end)
end