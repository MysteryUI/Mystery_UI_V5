﻿  -- // Filter
  -- // zork 
  --  法术监视
  --get the addon namespace
  local addon, ns = ...
  
  --object container
  local cfg = CreateFrame("Frame") 
  
  cfg.F_BuffList, cfg.F_DebuffList, cfg.F_CooldownList = {}, {}, {}
  
  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")
  
  -----------------------------
  -- CONFIG
  -----------------------------  
  
  cfg.highlightPlayerSpells = true
  cfg.updatetime            = 0.2 --how fast should the timer update itself
  
  if player_class == "MONK" then
  -- Buffs
  cfg.F_BuffList = {
    [1] = {
        spec = nil,
        spellid = 125359,   --猛虎之力
        size = 36,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 280 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
    [2] = {
        spec = nil,
        spellid = 116740,   --虎眼酒
		spelllist = {    	
		      [1] = 116740, --虎眼酒
			  [2] = 115308, --飘渺酒
			  [3] = 119607, --复苏之雾
            },
        size = 36,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -42, y = 280 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
	[3] = {
        spec = nil,
        spellid = 115307,   --酒醒入定
		spelllist = {    	
		      [1] = 115307, --酒醒入定
			  [2] = 127722, --青龙之忱
            },
        size = 36,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 42, y = 280 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.4,
            icon = 0.6,          
          },
        },
      },
    [4] = {
        spec = nil,
        spellid = 118636,   --强力金钟罩
        size = 36,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 322 },
        unit = "player",
        ismine = true,
        hide_ooc = false,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,          
          },
        },
      },
	}
    -- Debuffs  	
  cfg.F_DebuffList = {
    [1] = {
        spec = nil,
        spellid = 130320, -- 旭日东升踢
        size = 36,
        pos = { a1 = "RIGHT", a2 = "RIGHT", af = "TargetFrame", x = 0, y = 7 },
        unit = "target",
        ismine = true,
        desaturate = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0.0,
            icon = 0.6,          
          },
        },
      },
	}
  end
  
  -----------------------------
  -- HANDOVER
  -----------------------------
  
  --object container to addon namespace
  ns.cfg = cfg
  
  --------------------------------------
  
  --get the addon namespace
  local addon, ns = ...  
  
  --get the config
  local cfg = ns.cfg  
  
  local F_BuffList, F_DebuffList, F_CooldownList = cfg.F_BuffList, cfg.F_DebuffList, cfg.F_CooldownList
  
  rFilter3Frames = {}  --global variable gather all frames that can be moved ingame, will be accessed by slash command function later
  
  -----------------------------
  -- FUNCTIONS
  -----------------------------
  
  --format time func
  local GetFormattedTime = function(time)
    local hr, m, s, text
    if time <= 0 then text = ""
    elseif(time < 3600 and time > 60) then
      hr = floor(time / 3600)
      m = floor(mod(time, 3600) / 60 + 1)
      text = format('|cffffffff%d|cffCC3333m|r', m)
    elseif time < 60 then
      m = floor(time / 60)
      s = mod(time, 60)
      text = (m == 0 and format('|cffffffff%d|cffCC3333s|r', s))
    else
      hr = floor(time / 3600 + 1)
      text = format('|cffffffff%d|cffCC3333h|r', hr)
    end
    return text
  end
  
  local applySize = function(i)    
    local w = i:GetWidth()
    if w < i.minsize then w = i.minsize end    
    i:SetSize(w,w)
    i.glow:SetPoint("TOPLEFT",i,"TOPLEFT",-w*3.3/32,w*3.3/32)
    i.glow:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",w*3.3/32,-w*3.3/32)  
    i.icon:SetPoint("TOPLEFT",i,"TOPLEFT",w*3/32,-w*3/32)
    i.icon:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",-w*3/32,w*3/32)
    i.time:SetFont(STANDARD_TEXT_FONT, w*16/32, "THINOUTLINE")
    i.time:SetPoint("BOTTOM", 0, 0)    
    i.count:SetFont(STANDARD_TEXT_FONT, w*16/32, "OUTLINE")
    i.count:SetPoint("TOPRIGHT", 0,0)
  end
  
  --generate the frame name if a global one is needed
  local makeFrameName = function(f,type)
    if not f.move_ingame then return nil end
    local _, class = UnitClass("player")
    local spec = "None"
    if f.spec then spec = f.spec end
    return "rFilter3"..type.."Frame"..f.spellid.."Spec"..spec..class
  end
  
  local unlockFrame = function(i)
    if i.spec and i.spec ~= GetActiveTalentGroup() then
      return --only show icons that are visible for the current spec
    end    
    i:EnableMouse(true)
    i.locked = false
    i.dragtexture:SetAlpha(0.2)
    i:RegisterForDrag("LeftButton","RightButton")
    i:SetScript("OnEnter", function(s) 
      GameTooltip:SetOwner(s, "ANCHOR_BOTTOMRIGHT")
      GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("LEFT MOUSE + ALT + SHIFT to DRAG", 1, 1, 1, 1, 1, 1)
      GameTooltip:AddLine("RIGHT MOUSE + ALT + SHIFT to SIZE", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    i:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    i:SetScript("OnDragStart", function(s,b) 
      if IsAltKeyDown() and IsShiftKeyDown() and b == "LeftButton" then
        s:StartMoving()
      end
      if IsAltKeyDown() and IsShiftKeyDown() and b == "RightButton" then
        s:StartSizing()
      end
    end)
    i:SetScript("OnDragStop", function(s) 
      s:StopMovingOrSizing() 
    end)
  end
  
  local lockFrame = function(i)
    i:EnableMouse(nil)
    i.locked = true
    i.dragtexture:SetAlpha(0)
    i:RegisterForDrag(nil)
    i:SetScript("OnEnter", nil)
    i:SetScript("OnLeave", nil)
    i:SetScript("OnDragStart", nil)
    i:SetScript("OnDragStop", nil)
  end
  
  --simple frame movement
  local appyMoveFunctionality = function(f,i)
    if not f.move_ingame then 
      if i:IsUserPlaced() then
        i:SetUserPlaced(false)
      end
      return
    end
    i:SetHitRectInsets(-5,-5,-5,-5)
    i:SetClampedToScreen(true)
    i:SetMovable(true)
    i:SetResizable(true)
    i:SetUserPlaced(true)
    local t = i:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(i)
    t:SetTexture(0,1,0)
    t:SetAlpha(0)
    i.dragtexture = t
    i:SetScript("OnSizeChanged", function(s) 
      applySize(s)
    end)
    lockFrame(i) --lock frame by default
    table.insert(rFilter3Frames,i:GetName()) --load all the frames that can be moved into the global table
  end
  
  --unlock all frames
  local unlockAllFrames = function()
    for index,v in ipairs(rFilter3Frames) do 
      unlockFrame(_G[v])
    end
  end

  --lock all frames
  local lockAllFrames = function()
    for index,v in ipairs(rFilter3Frames) do 
      lockFrame(_G[v])
    end
  end
  
  --slash command functionality
  local function SlashCmd(cmd)    
    if (cmd:match"unlock") then
      unlockAllFrames()
    elseif (cmd:match"lock") then
      lockAllFrames()
    end
  end

  SlashCmdList["rfilter"] = SlashCmd;
  SLASH_rfilter1 = "/rfilter";
  SLASH_rfilter2 = "/rf";  
  
  local createIcon = function(f,index,type)

    local gsi_name, gsi_rank, gsi_icon, gsi_powerCost, gsi_isFunnel, gsi_powerType, gsi_castingTime, gsi_minRange, gsi_maxRange = GetSpellInfo(f.spellid)
    
    local i = CreateFrame("FRAME",makeFrameName(f,type),UIParent)
    i:SetSize(f.size,f.size)
    i:SetPoint(f.pos.a1,f.pos.af,f.pos.a2,f.pos.x,f.pos.y)
    i.minsize = f.size
    
    local gl = i:CreateTexture(nil, "BACKGROUND",nil,-8)
    gl:SetTexture("Interface\\Addons\\MysteryUI\\MyMedia\\simplesquare_glow")
    gl:SetVertexColor(0, 0, 0, 1)

    local ba = i:CreateTexture(nil, "BACKGROUND",nil,-7)
    ba:SetAllPoints(i)
    ba:SetTexture()
    
    local t = i:CreateTexture(nil,"BACKGROUND",nil,-6)
    t:SetTexture(gsi_icon)
    t:SetTexCoord(0.1,0.9,0.1,0.9)
    if f.desaturate then
      t:SetDesaturated(1)
    end

    local bo = i:CreateTexture(nil,"BACKGROUND",nil,-4)
    bo:SetTexture("Interface\\Addons\\MysteryUI\\MyMedia\\simplesquare_roth")
    bo:SetVertexColor(0.37,0.3,0.3,1)
    bo:SetAllPoints(i)
    
    local time = i:CreateFontString(nil, "BORDER")
    time:SetTextColor(1, 0.8, 0)
    
    local count = i:CreateFontString(nil, "BORDER")
    count:SetTextColor(1, 1, 1)
    count:SetJustifyH("RIGHT")
    
    i.glow = gl
    i.border = bo
    i.back = ba
    i.time = time
    i.count = count
    i.icon = t
    i.spec = f.spec --save the spec to the icon
    applySize(i)
    appyMoveFunctionality(f,i)
    f.iconframe = i
    f.name = gsi_name
    f.rank = gsi_rank
    f.texture = gsi_icon    

  end
  
  local checkDebuff = function(f,spellid)
    if f.move_ingame and not f.iconframe.locked then --make the icon visible in case we want to move it
      f.iconframe.icon:SetAlpha(1)
      f.iconframe:SetAlpha(1)
      f.iconframe.icon:SetDesaturated(nil)
      f.iconframe.time:SetText("30m")
      f.iconframe.count:SetText("3")
      return
    end
    if f.spec and f.spec ~= GetActiveSpecGroup() then
      f.iconframe:SetAlpha(0)
      return
    end
    if not UnitExists(f.unit) and f.validate_unit then
      f.iconframe:SetAlpha(0)
      return
    end
    if not InCombatLockdown() and f.hide_ooc then
      f.iconframe:SetAlpha(0)
      return      
    end
    local tmp_spellid = f.spellid
    if spellid then
      tmp_spellid = spellid --spellid gets overwritten for spelllists
      local gsi_name, gsi_rank, gsi_icon = GetSpellInfo(spellid)
      if gsi_name then
        f.name = gsi_name
        f.rank = gsi_rank
        f.texture_list = gsi_icon
        f.iconframe.icon:SetTexture(f.texture_list)
        --print(spellid..gsi_name)
      end
    end
    if f.name and f.rank then
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spID = UnitAura(f.unit, f.name, f.rank, "HARMFUL")
      --if name and (not f.ismine or (f.ismine and caster == "player")) then
      if name and (not f.ismine or (f.ismine and caster == "player")) and (not f.match_spellid or (f.match_spellid and spID == tmp_spellid)) then
        if caster == "player" and cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.2,0.6,0.8,1)
        elseif cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end        
        f.iconframe.icon:SetAlpha(f.alpha.found.icon)
        f.iconframe:SetAlpha(f.alpha.found.frame)
        if spellid then
          f.debufffound = true
          --break out of the debuff search loop
        end
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(nil)
        end
        --local value = floor((expires-GetTime())*10+0.5)/10
        if count and count > 1 then
          f.iconframe.count:SetText(count)
        else
          f.iconframe.count:SetText("")
        end
        local value = expires-GetTime()
        if value < 10 then
          f.iconframe.time:SetTextColor(1, 0.4, 0)
        else
          f.iconframe.time:SetTextColor(1, 0.8, 0)
        end
        f.iconframe.time:SetText(GetFormattedTime(value))
      else
        f.iconframe:SetAlpha(f.alpha.not_found.frame)
        f.iconframe.icon:SetAlpha(f.alpha.not_found.icon)
        if spellid then
          f.iconframe.icon:SetTexture(f.texture)
        end
        f.iconframe.time:SetText("")
        f.iconframe.count:SetText("")
        f.iconframe.time:SetTextColor(1, 0.8, 0)
        if cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end 
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(1)
        end
      end
    end
  end
  
  local checkBuff = function(f,spellid)
    if f.move_ingame and not f.iconframe.locked then --make the icon visible in case we want to move it
      f.iconframe.icon:SetAlpha(1)
      f.iconframe:SetAlpha(1)
      f.iconframe.icon:SetDesaturated(nil)
      f.iconframe.time:SetText("30m")
      f.iconframe.count:SetText("3")
      return
    end
    if f.spec and f.spec ~= GetActiveTalentGroup() then
      f.iconframe:SetAlpha(0)
      return
    end
    if not UnitExists(f.unit) and f.validate_unit then
      f.iconframe:SetAlpha(0)
      return
    end
    if not InCombatLockdown() and f.hide_ooc then
      f.iconframe:SetAlpha(0)
      return      
    end
    local tmp_spellid = f.spellid
    if spellid then
      tmp_spellid = spellid --spellid gets overwritten for spelllists
      local gsi_name, gsi_rank, gsi_icon = GetSpellInfo(spellid)
      if gsi_name then
        f.name = gsi_name
        f.rank = gsi_rank
        f.texture_list = gsi_icon
        f.iconframe.icon:SetTexture(f.texture_list)
        --print(spellid..gsi_name)
      end
    end
    if f.name and f.rank then
      local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spID = UnitAura(f.unit, f.name, f.rank, "HELPFUL")
      --if name and (not f.ismine or (f.ismine and caster == "player")) then
      if name and (not f.ismine or (f.ismine and caster == "player")) and (not f.match_spellid or (f.match_spellid and spID == tmp_spellid)) then
        if caster == "player" and cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.2,0.6,0.8,1)
        elseif cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end
        if spellid then
          f.bufffound = true
          --break out of the buff search loop
        end
        f.iconframe.icon:SetAlpha(f.alpha.found.icon)
        f.iconframe:SetAlpha(f.alpha.found.frame)
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(nil)
        end
        --local value = floor((expires-GetTime())*10+0.5)/10
        if count and count > 1 then
          f.iconframe.count:SetText(count)
        else
          f.iconframe.count:SetText("")
        end
        local value = expires-GetTime()
        if value < 10 then
          f.iconframe.time:SetTextColor(1, 0.4, 0)
        else
          f.iconframe.time:SetTextColor(1, 0.8, 0)
        end
        f.iconframe.time:SetText(GetFormattedTime(value))
      else
        f.iconframe:SetAlpha(f.alpha.not_found.frame)
        f.iconframe.icon:SetAlpha(f.alpha.not_found.icon)
        if spellid then
          f.iconframe.icon:SetTexture(f.texture)
        end
        f.iconframe.time:SetText("")
        f.iconframe.count:SetText("")
        f.iconframe.time:SetTextColor(1, 0.8, 0)
        if cfg.highlightPlayerSpells then
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
        end 
        if f.desaturate then
          f.iconframe.icon:SetDesaturated(1)
        end
      end
    end
  end
  
  local checkCooldown = function(f)
    if f.move_ingame and not f.iconframe.locked then --make the icon visible in case we want to move it
      f.iconframe.icon:SetAlpha(1)
      f.iconframe:SetAlpha(1)
      f.iconframe.icon:SetDesaturated(nil)
      f.iconframe.time:SetText("30m")
      f.iconframe.count:SetText("3")
      return
    end
    if f.spec and f.spec ~= GetActiveTalentGroup() then
      f.iconframe:SetAlpha(0)
      return
    end
    if not InCombatLockdown() and f.hide_ooc then
      f.iconframe:SetAlpha(0)
      return      
    end
    if f.name and f.spellid then
      local start, duration, enable = GetSpellCooldown(f.spellid)
      if start and duration then
        local now = GetTime()        
        local value = start+duration-now
        if(value > 0) and duration > 2 then
          --item is on cooldown show time
          f.iconframe.icon:SetAlpha(f.alpha.cooldown.icon)
          f.iconframe:SetAlpha(f.alpha.cooldown.frame)
          f.iconframe.count:SetText("")
          f.iconframe.border:SetVertexColor(0.37,0.3,0.3,1)
          if f.desaturate then
            f.iconframe.icon:SetDesaturated(1)
          end
          if value < 10 then
            f.iconframe.time:SetTextColor(1, 0.4, 0)
          else
            f.iconframe.time:SetTextColor(1, 0.8, 0)
          end
          f.iconframe.time:SetText(GetFormattedTime(value))
        else
          f.iconframe:SetAlpha(f.alpha.no_cooldown.frame)
          f.iconframe.icon:SetAlpha(f.alpha.no_cooldown.icon)
          f.iconframe.time:SetText("Biu")
          f.iconframe.count:SetText("")
          f.iconframe.time:SetTextColor(0, 0.8, 0)
          f.iconframe.border:SetVertexColor(0.4,0.6,0.2,1)
          if f.desaturate then
            f.iconframe.icon:SetDesaturated(nil)
          end
        end
      end
    end
  end
  
  local searchBuffs = function()
    for i,_ in ipairs(F_BuffList) do 
      local f = F_BuffList[i]
      if f.spelllist and f.spelllist[1] then
        --print('buff spelllist exists')
        f.bufffound = false
        for k,spellid in ipairs(f.spelllist) do
          if not f.bufffound then
            checkBuff(f,spellid)
          end
        end        
      else
        checkBuff(f)
      end
    end
  end

  local searchDebuffs = function()
    for i,_ in ipairs(F_DebuffList) do 
      local f = F_DebuffList[i]
      if  f.spelllist and f.spelllist[1] then
        --print('debuff spelllist exists')
        f.debufffound = false
        for k,spellid in ipairs(f.spelllist) do
          if not f.debufffound then
            checkDebuff(f,spellid)
          end
        end
      else
        checkDebuff(f)
      end
    end
  end

  local searchCooldowns = function()
    for i,_ in ipairs(F_CooldownList) do 
      local f = F_CooldownList[i]
      checkCooldown(f)
    end
  end

  local lastupdate = 0
  local rFilterOnUpdate = function(self,elapsed)
    lastupdate = lastupdate + elapsed    
    if lastupdate > cfg.updatetime then
      lastupdate = 0
      searchBuffs()
      searchDebuffs()
      searchCooldowns()
    end
  end  
  

  
  -----------------------------
  -- CALL
  -----------------------------

  local count = 0

  for i,_ in ipairs(F_BuffList) do 
    local f = F_BuffList[i]
    if not f.icon then 
      createIcon(f,i,"Buff")
    end
    count=count+1
  end
  
  for i,_ in ipairs(F_DebuffList) do 
    local f = F_DebuffList[i]
    if not f.icon then 
      createIcon(f,i,"Debuff")
    end
    count=count+1
  end
  
  for i,_ in ipairs(F_CooldownList) do 
    local f = F_CooldownList[i]
    if not f.icon then 
      createIcon(f,i,"Cooldown")
    end
    count=count+1
  end
  
  if count > 0 then    
    local a = CreateFrame("Frame")  
    a:SetScript("OnEvent", function(self, event)
      if(event=="PLAYER_LOGIN") then
        self:SetScript("OnUpdate", rFilterOnUpdate)
      end
    end)    
    a:RegisterEvent("PLAYER_LOGIN")  
  end
