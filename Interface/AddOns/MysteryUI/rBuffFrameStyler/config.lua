  -- // rBuffFrameStyler
  -- // zor

  -----------------------------
  -- INIT
  -----------------------------
  
  --get the addon namespace
  local addon, ns = ...
  
  --generate a holder for the config data
  local cfg = CreateFrame("Frame")
  
  -----------------------------
  -- CONFIG
  -----------------------------
  
  cfg.buffframe = {
    scale           = 1.1,
    pos             = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 }, 
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    rowSpacing      = 7,
    colSpacing      = 7,
    buffsPerRow     = 8,
    gap             = 20, --gap in pixel between buff and debuff
  }

  cfg.tempenchant = {
    scale           = 1.1,
    pos             = { a1 = "TOP", af = "Minimap", a2 = "BOTTOM", x = 40, y = -70 }, 
    userplaced      = true, --want to place the bar somewhere else?
    locked          = true, --frame locked, can be unlocked ingame via /rbuff
    colSpacing      = 7,
  }  
  
  cfg.textures = {
    normal            = "Interface\\Addons\\MysteryUI\\MyMedia\\gloss",
    outer_shadow      = "Interface\\Addons\\MysteryUI\\MyMedia\\outer_shadow",
  }
  
  cfg.background = {
    showshadow        = true,   --show an outer shadow?
    shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
    inset             = 6, 
  }
  
  cfg.color = {
    normal            = { r = 0.4, g = 0.35, b = 0.35, },
    classcolored      = false,
  }
  
  cfg.duration = {
    fontsize        = 13,
    pos             = { a1 = "BOTTOM", x = 0, y = 0 }, 
  }
  
  cfg.count = {
    fontsize        = 12,
    pos             = { a1 = "TOPRIGHT", x = 0, y = 0 }, 
  }
  
if GetLocale() == "zhCN" then
	cfg.font = "Fonts\\ARKai_T.TTF"
else
    cfg.font = "Fonts\\bLEI00D.TTF"
end

  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg
