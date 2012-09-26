-------姓名版增强
  -----------------------------
  -- 配置
  -----------------------------
  
  local colorswitcher = false --true/false  是否切换颜色
  local showhpvalue   = true --true/false 是否禁用生命值
  local alwaysshowhp  = false --true/false 是否在显示生命值%后添加精确的生命值
  
  -----------------------------
  -- 功能设定
  -----------------------------

  --设置单位名称功能
  local applyNameText = function(f,nameText)
    local txt = nameText:GetText() or ""
    f.na:SetText(txt)
  end
  
  --设置等级功能
  local applyLvlText = function(f,levelText,dragonTexture,bossIcon)
    local elite = ""
    if dragonTexture:IsShown() == 1 then 
      elite = "+" 
    end   
    if bossIcon:IsShown() ~= 1 then
      f.lvl:SetText((levelText:GetText() or "")..elite)
    else
      f.lvl:SetText("")
    end
  end

  --设置危险颜色功能
  local applyDifficultyColor = function(f,levelText)
    local r,g,b = levelText:GetTextColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    f.lvl:SetTextColor(r,g,b)
  end
  
  --设置敌对颜色功能
  local applyEnemyColor = function(f,healthBar)
    local r,g,b = healthBar:GetStatusBarColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    if r==0 and g==0 and b==1 then
      --把友方成员设置成暗色的是可以读取的
      f.na:SetTextColor(1,0,1)
    else
      f.na:SetTextColor(r,g,b)
    end
    if colorswitcher then
      healthBar.bg:SetVertexColor(r,g,b,0.9)
      healthBar.new:SetVertexColor(0.2*r,0.2*g,0.2*b,0.9)
      healthBar:SetStatusBarTexture("")
      --隐藏生命条.他有时候会出现错误
    end
  end
  
  --数字格式功能
  local numFormat = function(v)
    local string = ""
    if v > 1E6 then
      string = (floor((v/1E6)*10)/10).."m"
    elseif v > 1E3 then
      string = (floor((v/1E3)*10)/10).."k"
    else
      string = v
    end  
    return string
  end
  
  --更新生命条（只在某些设置时调用）
  local updateHealthbar = function(healthBar,value)
    if healthBar and value then
      local min, max = healthBar:GetMinMaxValues()
      if value == 'x' then value = max end
      local p = floor(value/max*100)
      if colorswitcher then
        if p == 100 then
          healthBar.bg:SetWidth(0.01) --fix (0) makes the bar go anywhere
        elseif p < 100 then
          local w = healthBar.w
          healthBar.bg:SetWidth(w-(w*p/100)) --calc new width of bar based on size of healthbar
        end
      end
      if showhpvalue then
        if p < 100 then
          healthBar.hpval:SetText(numFormat(value).."  "..p.."%")
        elseif p == 100 and alwaysshowhp then
          healthBar.hpval:SetText(numFormat(value).."  "..p.."%")
        else
          healthBar.hpval:SetText("")
        end
      end      
    end
  
  end
  
  --移动团队图标功能
  local moveRaidIcon = function(raidIcon,healthBar)
    raidIcon:ClearAllPoints()
    raidIcon:SetSize(20,20)
    raidIcon:SetPoint("BOTTOM",healthBar,"TOP",0,17)
  end
  
  --移动BOSS图标功能
  local moveBossIcon = function(f, bossIcon)
    bossIcon:ClearAllPoints()
    bossIcon:SetPoint("RIGHT", f.na, "LEFT", 0, 0)
  end
  
  --创建施法条背景功能
  local createCastbarBG = function(castBar)
    local t = castBar:CreateTexture(nil,"BACKGROUND",-8)
    t:SetAllPoints(castBar)
    t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t:SetVertexColor(0,0,0,0.4)
    t:Hide()
    castBar.bg = t
  end
  
  --创建生命条背景功能
  local createHealthbarBG = function(healthBar)
    --生命条背景
    local t = healthBar:CreateTexture(nil,"BACKGROUND",-8)
    if colorswitcher then
      t:SetPoint("TOP",0,0)
      t:SetPoint("RIGHT",0,0)
      t:SetPoint("BOTTOM",0,0)
      t:SetWidth(0.01)
      local n = healthBar:CreateTexture(nil,"BACKGROUND",-8)
      n:SetPoint("TOP",0,0)
      n:SetPoint("LEFT",0,0)
      n:SetPoint("BOTTOM",0,0)
      n:SetPoint("RIGHT", t, "LEFT", 0, 0) --right point of n will anchor left point of t
      n:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
      healthBar.new = n
    else
      t:SetAllPoints(healthBar)
    end
    t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t:SetVertexColor(0,0,0,0.4)
    healthBar.bg = t
  end

  --创建字符等级.名字功能
  local createNewFontStrings = function(f,healthBar)
    --名字
    local na = f:CreateFontString(nil, "BORDER")
    na:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    na:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    na:SetPoint("RIGHT", healthBar, 5, 0)
    na:SetJustifyH("LEFT")        
    --字符等级
    local lvl = f:CreateFontString(nil, "BORDER")
    lvl:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    lvl:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    lvl:SetPoint("LEFT", healthBar, 0, 0)
    lvl:SetJustifyH("LEFT")    
    na:SetPoint("LEFT", lvl, "RIGHT", 0, 0) --left point of name will be right point of level
    f.na = na
    f.lvl = lvl
    if showhpvalue then
      local hp = healthBar:CreateFontString(nil, "OVERLAY")
      hp:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
      hp:SetPoint("RIGHT",-1,0)
      hp:SetJustifyH("RIGHT")
      healthBar.hpval = hp
    end
  end
  
  --更新施法条定位
  local updateCastbarPosition = function(castBar)    
    castBar.border:ClearAllPoints()
    castBar.border:SetPoint("CENTER",castBar:GetParent(),"CENTER",-19,-29)

    --改变施法条颜色为暗红色.如果它被屏蔽的话
    if castBar.shield:IsShown() == 1 then
      castBar:SetStatusBarColor(0.7,0,0)
    else
      castBar:SetStatusBarColor(1,0.7,0)
    end
    castBar.shield:ClearAllPoints()
    castBar.shield:SetPoint("CENTER",castBar:GetParent(),"CENTER",-19,-29)

    castBar:SetPoint("RIGHT",castBar.border,-1,0)
    castBar:SetPoint("TOP",castBar.border,0,-12)
    castBar:SetPoint("BOTTOM",castBar.border,0,12)
    castBar:SetPoint("LEFT",castBar.border,22,0)

    castBar.icon:ClearAllPoints()
    castBar.icon:SetPoint("LEFT",castBar.border,3,0)
    
  end
  
  --初始施法条对象
  local initCastbars = function(castBar,castborderTexture, shield, castbaricon)
    castborderTexture:SetTexture("Interface\\Tooltips\\Nameplate-CastBar")
    castborderTexture:SetSize(castBar.w+25,(castBar.w+25)/4)
    castborderTexture:SetTexCoord(0,1,0,1)
    castBar.border = castborderTexture
    
    castborderTexture:SetDrawLayer("OVERLAY", 1)
    shield:SetSize(castBar.w+25,(castBar.w+25)/4)
    shield:SetTexCoord(0,1,0,1)
    castBar.shield = shield
    
    castbaricon:SetTexCoord(0.1,0.9,0.1,0.9)
    castbaricon:SetDrawLayer("OVERLAY", 4)
    castBar.icon = castbaricon
    
    castBar:SetStatusBarColor(1,0.7,0)
    createCastbarBG(castBar)    
    
    castBar:HookScript("OnShow", function(s)
      s.bg:Show()
      updateCastbarPosition(s)
    end)
    
    castBar:HookScript("OnHide", function(s)
      s.bg:Hide()
    end)    
  end
  
  --初始化参数大小
  local initHealthCastbarSize = function(healthBar, castBar)
    local w,h = healthBar:GetWidth(), healthBar:GetHeight()
    healthBar.w = w
    healthBar.h = h
    castBar.w = w
    castBar.h = h
  end
  
  --隐藏暴雪的
  local hideBlizz = function(nameText,levelText,dragonTexture)
    nameText:Hide()
    levelText:Hide()
    dragonTexture:SetTexture("")
  end
  

  --风格更新
  local updateStyle = function(f)
    --获取值
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()
    local barfill, castborderTexture, shield, castbaricon = castBar:GetRegions()
    --应用颜色
    applyEnemyColor(f,healthBar)
    applyDifficultyColor(f,levelText)      
    
    --应用文本
    applyNameText(f,nameText)
    applyLvlText(f,levelText,dragonTexture,bossIcon)
    
    --禁用
    hideBlizz(nameText,levelText,dragonTexture)
  end

  --初始化风格
  local initStyle = function(f)
    --获取值
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()
    local barfill, castborderTexture, shield, castbaricon = castBar:GetRegions()
    
    --初始化生命条和施法条的大小
    initHealthCastbarSize(healthBar,castBar)
    --创建生命条的背景
    createHealthbarBG(healthBar)
        
    --创建新的字符文本
    createNewFontStrings(f,healthBar)
    
    --应用颜色
    applyEnemyColor(f,healthBar)
    applyDifficultyColor(f,levelText)
    
    --应用文本
    applyNameText(f,nameText)
    applyLvlText(f,levelText,dragonTexture,bossIcon)

    --移动一些图标
    moveBossIcon(f, bossIcon)
    moveRaidIcon(raidIcon,healthBar)
    
    --初始化施法条
    initCastbars(castBar,castborderTexture, shield, castbaricon)
    
    --禁用一些暴雪元素
    hideBlizz(nameText,levelText,dragonTexture)
    
    -- 不是很亮0.0
    healthBar:SetStatusBarTexture("Interface\\Addons\\MysteryUI\\MyMedia\\tex")
    castBar:SetStatusBarTexture("Interface\\Addons\\MysteryUI\\MyMedia\\tex")
    highlightTexture:SetTexture("")
    --highlightTexture:SetAlpha(0.2)
    
    if colorswitcher or showhpvalue then
      healthBar:SetScript("OnValueChanged", updateHealthbar)
      if alwaysshowhp then
        updateHealthbar(healthBar,'x')
      end
    end
    
    f:HookScript("OnShow", function(s)
      updateStyle(s)      
    end)
    
    return true

  end


  --姓名版的风格功能
  local styleNamePlate = function(f)    
    f.styled = initStyle(f)
  end

  local IsNamePlateFrame = function(f)
       
    local o = select(2,f:GetRegions())
    if not o or o:GetObjectType() ~= "Texture" or o:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then   
    f.styled = true --不在碰他了..在也不T..T
    return false
    end
    return true
  end

  local lastupdate = 0
    
  local searchNamePlates = function(self,elapsed)
    lastupdate = lastupdate + elapsed
    
    if lastupdate > 0.33 then
      lastupdate = 0
      local num = select("#", WorldFrame:GetChildren())
      for i = 1, num do
        local f = select(i, WorldFrame:GetChildren())      
        if not f.styled and IsNamePlateFrame(f) then 
          styleNamePlate(f)
        end
      end 
      
    end
  end
  
  local a = CreateFrame("Frame")
  a:SetScript("OnEvent", function(self, event)
    if(event=="PLAYER_LOGIN") then
      SetCVar("ShowClassColorInNameplate",1)--1
      SetCVar("bloattest",0)--0.0
      SetCVar("bloatnameplates",0)--0.0
      
      SetCVar("bloatthreat",0)--1
      self:SetScript("OnUpdate", searchNamePlates)
    end
  end)
  
  a:RegisterEvent("PLAYER_LOGIN")
  
