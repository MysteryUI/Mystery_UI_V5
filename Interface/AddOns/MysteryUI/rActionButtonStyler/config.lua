﻿
  -- // rActionButtonStyler
  -- // zork - 2012

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

  cfg.textures = {
    normal            = "Interface\\AddOns\\MysteryUI\\MyMedia\\gloss",
    flash             = "Interface\\AddOns\\MysteryUI\\MyMedia\\flash",
    hover             = "Interface\\AddOns\\MysteryUI\\MyMedia\\hover",
    pushed            = "Interface\\AddOns\\MysteryUI\\MyMedia\\pushed",
    checked           = "Interface\\AddOns\\MysteryUI\\MyMedia\\checked",
    equipped          = "Interface\\AddOns\\MysteryUI\\MyMedia\\gloss_grey",
    buttonback        = "Interface\\AddOns\\MysteryUI\\MyMedia\\button_background",
    buttonbackflat    = "Interface\\AddOns\\MysteryUI\\MyMedia\\button_background_flat",
    outer_shadow      = "Interface\\AddOns\\MysteryUI\\MyMedia\\outer_shadow",
  }

  cfg.background = {
    showbg            = true,  --show an background image?
    showshadow        = true,   --show an outer shadow?
    useflatbackground = false,  --true uses plain flat color instead
    backgroundcolor   = { r = 0.2, g = 0.2, b = 0.2, a = 0.3},
    shadowcolor       = { r = 0, g = 0, b = 0, a = 0.9},
    classcolored      = false,
    inset             = 5,
  }

  cfg.color = {
    normal            = { r = 0.3, g = 0.3, b = 0.3, },
    equipped          = { r = 0.1, g = 0.5, b = 0.1, },
    classcolored      = false,
  }

  cfg.hotkeys = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 },
    pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
  }

  cfg.macroname = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 },
    pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
  }

  cfg.itemcount = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 },
  }

  cfg.cooldown = {
    spacing         = 0,
  }

if GetLocale() == "zhCN" then
	cfg.font = "Fonts\\ARKai_T.TTF"
else
    cfg.font = "Fonts\\FRIZQT__.TTF"
end 

  -----------------------------
  -- HANDOVER
  -----------------------------

  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg
