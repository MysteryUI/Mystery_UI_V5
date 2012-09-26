-------��������ǿ
  -----------------------------
  -- ����
  -----------------------------
  
  local colorswitcher = false --true/false  �Ƿ��л���ɫ
  local showhpvalue   = true --true/false �Ƿ��������ֵ
  local alwaysshowhp  = false --true/false �Ƿ�����ʾ����ֵ%����Ӿ�ȷ������ֵ
  
  -----------------------------
  -- �����趨
  -----------------------------

  --���õ�λ���ƹ���
  local applyNameText = function(f,nameText)
    local txt = nameText:GetText() or ""
    f.na:SetText(txt)
  end
  
  --���õȼ�����
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

  --����Σ����ɫ����
  local applyDifficultyColor = function(f,levelText)
    local r,g,b = levelText:GetTextColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    f.lvl:SetTextColor(r,g,b)
  end
  
  --���õж���ɫ����
  local applyEnemyColor = function(f,healthBar)
    local r,g,b = healthBar:GetStatusBarColor()
    r,g,b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
    if r==0 and g==0 and b==1 then
      --���ѷ���Ա���óɰ�ɫ���ǿ��Զ�ȡ��
      f.na:SetTextColor(1,0,1)
    else
      f.na:SetTextColor(r,g,b)
    end
    if colorswitcher then
      healthBar.bg:SetVertexColor(r,g,b,0.9)
      healthBar.new:SetVertexColor(0.2*r,0.2*g,0.2*b,0.9)
      healthBar:SetStatusBarTexture("")
      --����������.����ʱ�����ִ���
    end
  end
  
  --���ָ�ʽ����
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
  
  --������������ֻ��ĳЩ����ʱ���ã�
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
  
  --�ƶ��Ŷ�ͼ�깦��
  local moveRaidIcon = function(raidIcon,healthBar)
    raidIcon:ClearAllPoints()
    raidIcon:SetSize(20,20)
    raidIcon:SetPoint("BOTTOM",healthBar,"TOP",0,17)
  end
  
  --�ƶ�BOSSͼ�깦��
  local moveBossIcon = function(f, bossIcon)
    bossIcon:ClearAllPoints()
    bossIcon:SetPoint("RIGHT", f.na, "LEFT", 0, 0)
  end
  
  --����ʩ������������
  local createCastbarBG = function(castBar)
    local t = castBar:CreateTexture(nil,"BACKGROUND",-8)
    t:SetAllPoints(castBar)
    t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-BarFill")
    t:SetVertexColor(0,0,0,0.4)
    t:Hide()
    castBar.bg = t
  end
  
  --������������������
  local createHealthbarBG = function(healthBar)
    --����������
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

  --�����ַ��ȼ�.���ֹ���
  local createNewFontStrings = function(f,healthBar)
    --����
    local na = f:CreateFontString(nil, "BORDER")
    na:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    na:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
    na:SetPoint("RIGHT", healthBar, 5, 0)
    na:SetJustifyH("LEFT")        
    --�ַ��ȼ�
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
  
  --����ʩ������λ
  local updateCastbarPosition = function(castBar)    
    castBar.border:ClearAllPoints()
    castBar.border:SetPoint("CENTER",castBar:GetParent(),"CENTER",-19,-29)

    --�ı�ʩ������ɫΪ����ɫ.����������εĻ�
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
  
  --��ʼʩ��������
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
  
  --��ʼ��������С
  local initHealthCastbarSize = function(healthBar, castBar)
    local w,h = healthBar:GetWidth(), healthBar:GetHeight()
    healthBar.w = w
    healthBar.h = h
    castBar.w = w
    castBar.h = h
  end
  
  --���ر�ѩ��
  local hideBlizz = function(nameText,levelText,dragonTexture)
    nameText:Hide()
    levelText:Hide()
    dragonTexture:SetTexture("")
  end
  

  --������
  local updateStyle = function(f)
    --��ȡֵ
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()
    local barfill, castborderTexture, shield, castbaricon = castBar:GetRegions()
    --Ӧ����ɫ
    applyEnemyColor(f,healthBar)
    applyDifficultyColor(f,levelText)      
    
    --Ӧ���ı�
    applyNameText(f,nameText)
    applyLvlText(f,levelText,dragonTexture,bossIcon)
    
    --����
    hideBlizz(nameText,levelText,dragonTexture)
  end

  --��ʼ�����
  local initStyle = function(f)
    --��ȡֵ
    local healthBar, castBar = f:GetChildren()
    local threatTexture, borderTexture, highlightTexture, nameText, levelText, bossIcon, raidIcon, dragonTexture = f:GetRegions()
    local barfill, castborderTexture, shield, castbaricon = castBar:GetRegions()
    
    --��ʼ����������ʩ�����Ĵ�С
    initHealthCastbarSize(healthBar,castBar)
    --�����������ı���
    createHealthbarBG(healthBar)
        
    --�����µ��ַ��ı�
    createNewFontStrings(f,healthBar)
    
    --Ӧ����ɫ
    applyEnemyColor(f,healthBar)
    applyDifficultyColor(f,levelText)
    
    --Ӧ���ı�
    applyNameText(f,nameText)
    applyLvlText(f,levelText,dragonTexture,bossIcon)

    --�ƶ�һЩͼ��
    moveBossIcon(f, bossIcon)
    moveRaidIcon(raidIcon,healthBar)
    
    --��ʼ��ʩ����
    initCastbars(castBar,castborderTexture, shield, castbaricon)
    
    --����һЩ��ѩԪ��
    hideBlizz(nameText,levelText,dragonTexture)
    
    -- ���Ǻ���0.0
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


  --������ķ����
  local styleNamePlate = function(f)    
    f.styled = initStyle(f)
  end

  local IsNamePlateFrame = function(f)
       
    local o = select(2,f:GetRegions())
    if not o or o:GetObjectType() ~= "Texture" or o:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then   
    f.styled = true --����������..��Ҳ��T..T
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
  
