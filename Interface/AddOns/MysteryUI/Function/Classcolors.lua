-----------------Ö°ÒµÑÕÉ«---------------

local   UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS =
        UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS
local _, class, c

local function colour(statusbar, unit)
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(c.r, c.g, c.b)
    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
	colour(self, self.unit)
end)

local sb = _G.GameTooltipStatusBar
local addon = CreateFrame("Frame", "StatusColour")
addon:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
addon:SetScript("OnEvent", function()
	colour(sb, "mouseover")
end)


  rRAID_CLASS_COLORS = {
  	["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45 },
  	["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79 },
  	["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0 },
  	["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73 },
  	["MAGE"] = { r = 0.41, g = 0.8, b = 0.94 },
  	["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41 },
  	["DRUID"] = { r = 1.0, g = 0.49, b = 0.04 },
  	["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87 },
  	["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43 },
  	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
	["MONK"] = { r = 0.0, g = 1.0 , b = 0.59 },
  }