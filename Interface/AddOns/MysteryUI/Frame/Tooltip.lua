--[[鼠标提示]]---

local addonName, L = ...; 
local function defaultFunc(L, key) 
return key; 
end 
setmetatable(L, {__index=defaultFunc}); 

-- 简洁的公会队伍
local a=CreateFrame("Frame")
local GameTooltip, GetGuildInfo = GameTooltip, GetGuildInfo
a:SetScript("OnEvent",function()
    local _, rank = GetGuildInfo("mouseover")
    if rank then
        GameTooltip:AddDoubleLine(L["公會身份:"],rank,1,0.82,0,1,1,1)
        GameTooltip:Show()
    end
end)
a:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

--提示

local _, ns = ...
local cfg = {
    font = STANDARD_TEXT_FONT,
    fontsize = 13,
    outline = "THINOUTLINE",
    scale = 1.1,
    point = { "BOTTOMRIGHT", "BOTTOMRIGHT", -75, 215 },
    cursor = false,
    titles = true,
    tex = "Interface\\Addons\\MysteryUI\\MyMedia\\tex",
    backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        --tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    },
    bgcolor = { r=0.05, g=0.05, b=0.05, t=0.9 },
    bdrcolor = { r=0.3, g=0.3, b=0.3 },
    gcolor = { r=1, g=0.1, b=0.8 },
    you = L["<你>"],
    boss = "??",
    colorborderClass = true,
}

local classification = {
    elite = L["精英"],--精英标志
    rare = L["稀有"],--稀有标志
    rareelite = L["稀有精英"],--稀有精英标志
}

local hex
do 
    local format = string.format

    hex = function(color)
        return format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
    end
end

local function unitColor(unit)
    local color = { r=1, g=1, b=1 }
    if UnitIsPlayer(unit) then
        local _, class = UnitClass(unit)
        color = RAID_CLASS_COLORS[class]
        return color
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
            return color
        end
    end
    return color
end

function GameTooltip_UnitColor(unit)
    local color = unitColor(unit)
    return color.r, color.g, color.b
end

local function getTarget(unit)
    if UnitIsUnit(unit, "player") then
        return ("|cffff0000%s|r"):format(cfg.you)
    else
        return hex(unitColor(unit))..UnitName(unit).."|r"
    end
end

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()
    if unit then

        local color = unitColor(unit)
        local ricon = GetRaidTargetIndex(unit)

        if ricon then
            local text = GameTooltipTextLeft1:GetText()
            GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."18|t", text))
        end

        if UnitIsPlayer(unit) then
            self:AppendText((" |cff00cc00%s|r"):format(UnitIsAFK(unit) and CHAT_FLAG_AFK or UnitIsDND(unit) and CHAT_FLAG_DND or not UnitIsConnected(unit) and "<DC>" or ""))

            if not cfg.titles then
                local title = UnitPVPName(unit)
                if title then
                    local text = GameTooltipTextLeft1:GetText()
                    title = title:gsub(name, "")
                    text = text:gsub(title, "")
                    if text then GameTooltipTextLeft1:SetText(text) end
                end
            end

            local unitGuild = GetGuildInfo(unit)
            local text2 = GameTooltipTextLeft2:GetText()
            if unitGuild and text2 and text2:find("^"..unitGuild) then	
                GameTooltipTextLeft2:SetTextColor(cfg.gcolor.r, cfg.gcolor.g, cfg.gcolor.b)
            end
        end

        local level = UnitLevel(unit)
        if level then
            local unitClass = UnitIsPlayer(unit) and hex(color)..UnitClass(unit).."|r" or ""
            local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
            local diff = GetQuestDifficultyColor(level)

            if level == -1 then
                level = "|cffff0000"..cfg.boss
            end

            local classify = UnitClassification(unit)
            local textLevel = ("%s%s%s|r"):format(hex(diff), tostring(level), classification[classify] or "")

            for i=2, self:NumLines() do
                local tiptext = _G["GameTooltipTextLeft"..i]
                if tiptext:GetText():find(LEVEL) then
                    tiptext:SetText(("%s %s%s %s"):format(textLevel, creature, UnitRace(unit) or "", unitClass):trim())
                end

                if tiptext:GetText():find(PVP) then
                    tiptext:SetText(nil)
                end
            end
        end

        if UnitExists(unit.."target") then
            local tartext = ("%s: %s"):format(TARGET, getTarget(unit.."target"))
            self:AddLine(tartext)
        end

        GameTooltipStatusBar:SetStatusBarColor(color.r, color.g, color.b)

        if UnitIsDeadOrGhost(unit) then
            GameTooltipStatusBar:Hide()
            self:AddLine("|cffFF0000"..DEAD.."|r")
        end
    else
        GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
    end

    if GameTooltipStatusBar:IsShown() then
        self:AddLine(" ")
        GameTooltipStatusBar:ClearAllPoints()
        GameTooltipStatusBar:SetPoint("TOPLEFT", self:GetName().."TextLeft"..self:NumLines(), "TOPLEFT", 0, -4)
        GameTooltipStatusBar:SetPoint("TOPRIGHT", self, -10, 0)
    end
end)

GameTooltipStatusBar:SetStatusBarTexture(cfg.tex)
local bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints(GameTooltipStatusBar)
bg:SetTexture(cfg.tex)
bg:SetVertexColor(0.5, 0.5, 0.5, 0.5)

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
    if not value then
        return
    end
    local min, max = self:GetMinMaxValues()
    if (value < min) or (value > max) then
        return
    end
    local _, unit = GameTooltip:GetUnit()
    if unit then
        min, max = UnitHealth(unit), UnitHealthMax(unit)
        if not self.text then
            self.text = self:CreateFontString(nil, "OVERLAY")
            self.text:SetPoint("CENTER", GameTooltipStatusBar)
            self.text:SetFont(cfg.font, 12, cfg.outline)
        end
        self.text:Show()
        local hp = numberize(min).." / "..numberize(max)
        self.text:SetText(hp)
    end
end)

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    local frame = GetMouseFocus()
    if cfg.cursor and frame == WorldFrame then
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    else
        tooltip:SetOwner(parent, "ANCHOR_NONE")	
        tooltip:SetPoint(cfg.point[1], UIParent, cfg.point[2], cfg.point[3], cfg.point[4])
    end
    tooltip.default = 1
end)

local function setBakdrop(frame)
    frame:SetBackdrop(cfg.backdrop)
    frame:SetScale(cfg.scale)

    frame.freebBak = true
end

local function style(frame)
    if not frame.freebBak then
        setBakdrop(frame)
    end

    frame:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t)
    frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)

    if frame.GetItem then
        local _, item = frame:GetItem()
        if item then
            local quality = select(3, GetItemInfo(item))
            if(quality) then
                local r, g, b = GetItemQualityColor(quality)
                frame:SetBackdropBorderColor(r, g, b)
            end
        else
            frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)
        end
    end

    if cfg.colorborderClass then
        local _, unit = GameTooltip:GetUnit()
        if UnitIsPlayer(unit) then
            frame:SetBackdropBorderColor(GameTooltip_UnitColor(unit))
        end
    end

    if frame.NumLines then
        for index=1, frame:NumLines() do
            if index == 1 then
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize+2, cfg.outline)
            else
                _G[frame:GetName()..'TextLeft'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
            end
            _G[frame:GetName()..'TextRight'..index]:SetFont(cfg.font, cfg.fontsize, cfg.outline)
        end
    end
end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip,
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
}

for i, frame in ipairs(tooltips) do
    frame:SetScript("OnShow", function(frame) style(frame) end)
end

if IsAddOnLoaded("ManyItemTooltips") then
    MIT:AddHook("FreebTip", "OnShow", function(frame) style(frame) end)
end

local f = CreateFrame"Frame"
f:SetScript("OnEvent", function(self, event, ...) if ns[event] then return ns[event](ns, event, ...) end end)
function ns:RegisterEvent(...) for i=1,select("#", ...) do f:RegisterEvent((select(i, ...))) end end
function ns:UnregisterEvent(...) for i=1,select("#", ...) do f:UnregisterEvent((select(i, ...))) end end

ns:RegisterEvent"PLAYER_LOGIN"
function ns:PLAYER_LOGIN()
    for i, frame in ipairs(tooltips) do
        setBakdrop(frame)
    end

    ns:UnregisterEvent"PLAYER_LOGIN"
end

-----------SpellID-------------

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
	local id = select(11,UnitBuff(...))
	if id then
		self:AddDoubleLine(L["法术ID:"],id)
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
	local id = select(11,UnitDebuff(...))
	if id then
		self:AddDoubleLine(L["法术ID:"],id)
		self:Show()
	end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
	local id = select(11,UnitAura(...))
	if id then
		self:AddDoubleLine(L["法术ID:"],id)
		self:Show()
	end
end)

hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
	if string.find(link,"^spell:") then
		local id = string.sub(link,7)
		ItemRefTooltip:AddDoubleLine(L["法术ID:"],id)
		ItemRefTooltip:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	local id = select(3,self:GetSpell())
	if id then
		self:AddDoubleLine(L["法术ID:"],id)
		self:Show()
	end
end)

---显示BUFF和DEBUFF谁谁释放的-----

local function addAuraSource(self, func, unit, index, filter) 
   local caster = select(8, func(unit, index, filter)) 
   if caster then 
      self:AddLine(" ") 
      local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS 
      local castername = UnitName(caster) 
      local partypet, raidpet, color 
      if UnitIsPlayer(caster) then 
         color = colors[select(2,UnitClass(caster))] 
         castername = format('|cff%02X%02X%02X%s|r' , color.r*255, color.g*255, color.b*255, UnitName(caster)) 
      else 
         if caster == 'pet' or caster == 'vehicle' then 
            color = colors[select(2,UnitClass('player'))] 
            castername = format('|cff%02X%02X%02X%s|r%s%s', color.r*255, color.g*255, color.b*255, UnitName('player'), L['|cffC0C0C0的|r'], UnitName(caster)) 
         else 
            partypet = caster:match('^partypet(%d+)$') 
            raidpet = caster:match('^raidpet(%d+)$') 
            if partypet then 
               color = colors[select(2,UnitClass('party'..partypet))] 
               castername = format('|cff%02X%02X%02X%s|r%s%s' , color.r*255, color.g*255, color.b*255, UnitName("party"..partypet), L['|cffC0C0C0的|r'], UnitName(caster)) 
            elseif raidpet then 
               color = colors[select(2,UnitClass('party'..raidpet))] 
               castername = format('|cff%02X%02X%02X%s|r%s%s' , color.r*255, color.g*255, color.b*255, UnitName('raid'..raidpet), L['|cffC0C0C0的|r'], UnitName(caster)) 
            end 
         end 
      end 
      self:AddDoubleLine(L['|cffC0C0C0來自:|r'], castername) 
      self:Show() 
   end 
end 

local funcs = { 
   SetUnitAura = UnitAura, 
   SetUnitBuff = UnitBuff, 
   SetUnitDebuff = UnitDebuff, 
} 

for k, v in pairs(funcs) do 
   hooksecurefunc(GameTooltip, k, function(self, unit, index, filter) 
      addAuraSource(self, v, unit, index, filter) 
   end) 
end