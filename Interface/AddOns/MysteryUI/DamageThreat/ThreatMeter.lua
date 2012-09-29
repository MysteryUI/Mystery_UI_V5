-- Config start
local texture = "Interface\\AddOns\\MysteryUI\\MyMedia\\tex"
local width, height = 150, 12
local font = GameFontNormal:GetFont()
local font_size = 10
local font_style = 'OUTLINE'
local anchor = "TOPLEFT"
local pos_x, pos_y = 200, -14
local spacing = 4
local backdrop_color = {0, 0, 0, 0.35}
local border_color = {0, 0, 0, 1}
local border_size = 1
local visible = 3

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = [=[Interface\ChatFrame\ChatFrameBackground]=], edgeSize = border_size,
	insets = {top = 0, left = 0, bottom = 0, right = 0},
}

local anchorframe = CreateFrame("Frame", "ThreatMeter", UIParent)
anchorframe:SetSize(width, height)
anchorframe:SetPoint(anchor, x, pos_x, pos_y)
if UIMovableFrames then tinsert(UIMovableFrames, anchorframe) end

local bar, tList, barList = {}, {}, {}
local max = math.max
local timer = 0
local targeted = false

RAID_CLASS_COLORS["PET"] = {r = 0, g = 0.7, b = 0,}

local CreateFS = CreateFS or function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	fstring:SetFont(font or GameFontNormal:GetFont(), font_size, font_style)
	fstring:SetShadowColor(0, 0, 0, 1)
	fstring:SetShadowOffset(0, 0)
	return fstring
end

local CreateBG = CreateBG or function(parent)
	local bg = CreateFrame("Frame", nil, parent)
	bg:SetPoint("TOPLEFT", parent, "TOPLEFT", -1, 1)
	bg:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 1, -1)
	bg:SetFrameLevel(parent:GetFrameLevel() - 1)
	bg:SetBackdrop(backdrop)
	bg:SetBackdropColor(unpack(backdrop_color))
	bg:SetBackdropBorderColor(unpack(border_color))
	return bg
end

local truncate = function(value)
	if value >= 1e6 then
		return string.format('%.2fm', value / 1e6)
	elseif value >= 1e4 then
		return string.format('%.1fk', value / 1e3)
	else
		return string.format('%.0f', value)
	end
end

local AddUnit = function(unit)
	local threatpct, rawpct, threatval = select(3, UnitDetailedThreatSituation(unit, "target"))
	if threatval and threatval < 0 then
		threatval = threatval + 410065408
	end
	local guid = UnitGUID(unit)
	if not tList[guid] then
		tinsert(barList, guid)
		tList[guid] = {
			name = UnitName(unit),
			class = UnitIsPlayer(unit) and select(2, UnitClass(unit)) or "PET",
		}
	end
	tList[guid].pct = threatpct or 0 
	tList[guid].val = threatval or 0
end

local CheckUnit = function(unit)
	if UnitExists(unit) and UnitIsVisible(unit) then
		AddUnit(unit)
		if UnitExists(unit.."pet") then
			AddUnit(unit.."pet")
		end
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetSize(width, height)
	bar:SetStatusBarTexture(texture)
	bar:SetMinMaxValues(0, 100)
	bar.bg = CreateBG(bar)
	bar.left = CreateFS(bar)
	bar.left:SetPoint('LEFT', 2, 1)
	bar.left:SetPoint('RIGHT', -50, 1)
	bar.left:SetJustifyH('LEFT')
	bar.right = CreateFS(bar)
	bar.right:SetPoint('RIGHT', -2, 1)
	bar.right:SetJustifyH('RIGHT')
	bar:Hide()
	return bar
end

local SortMethod = function(a, b)
	return tList[b].pct < tList[a].pct
end

local UpdateBars = function()
	for i, v in pairs(bar) do
		v:Hide()
	end
	table.sort(barList, SortMethod)
	for i = 1, #barList do
		cur = tList[barList[i]]
		max = tList[barList[1]]
		if i > visible or not cur or cur.pct == 0 then break end
		if not bar[i] then 
			bar[i] = CreateBar()
			bar[i]:SetPoint("TOP", anchorframe, 0, - (height + spacing) * (i-1))
		end
		bar[i]:SetValue(100 * cur.pct / max.pct)
		local color = RAID_CLASS_COLORS[cur.class]
		bar[i]:SetStatusBarColor(color.r, color.g, color.b)
		bar[i].left:SetText(cur.name)
		bar[i].right:SetText(string.format("%s (%d%%)", truncate(cur.val/100), cur.pct))
		bar[i]:Show()
	end
end

local UpdateThreat = function()
	if targeted then
		if GetNumGroupMembers() > 0 then
			local unit = IsInRaid() and "raid" or "party"
			for i = 1, GetNumGroupMembers(), 1 do
				CheckUnit(unit..i)
			end
		end
		CheckUnit("targettarget")
		CheckUnit("player")
	end
	UpdateBars()
end

local OnEvent = function(self, event, ...)
	if event == "PLAYER_TARGET_CHANGED" or event == "UNIT_THREAT_LIST_UPDATE" then
		if UnitExists("target") and not UnitIsDead("target") and not UnitIsPlayer("target") and UnitCanAttack("player", "target") then
			targeted = true
		else
			targeted = false
		end
	end
	if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_REGEN_ENABLED" then
		wipe(tList)
		wipe(barList)
	end
	UpdateThreat()
end

local addon = CreateFrame("frame")
addon:SetScript('OnEvent', OnEvent)
addon:RegisterEvent("PLAYER_TARGET_CHANGED")
addon:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
addon:RegisterEvent("PLAYER_REGEN_ENABLED")

SlashCmdList["Threat"] = function(msg)
	for i = 1, 6 do
		tList[i] = {
			name = UnitName("player"),
			class = select(2, UnitClass("player")),
			pct = i/6*100,
			val = i*10000,
		}
		tinsert(barList, i)
	end
	UpdateBars()
	wipe(tList)
	wipe(barList)
end
SLASH_Threat1 = "/threat"