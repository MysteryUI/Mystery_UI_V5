--团队监察

local opacity = 0.5 --设置能见度

local t={}
for i=1,8 do
  t[i] = {}
  for j=1,5 do
     t[i][j] = string.format("CompactRaidGroup%dMember%d", i,j)
  end
end

local r={}
for i=1,40 do
  r[i] = string.format("CompactRaidFrame%d", i) 
end

local raidtimer = 0
local raid_frame = CreateFrame("Frame")
local x,y,z,w
local function raid_update(self, elapsed)
  raidtimer = raidtimer + elapsed
  if ( raidtimer > 0.1 ) then
    raidtimer = 0
    if w then
      
      --保持团队一起检查
      for i=1,w do
        x = _G[r[i]]
        if x then
          if x:GetAlpha()<0.8 then
            y=opacity
          else
            y=1
          end
          z= select(1,x:GetRegions()):GetAlpha()
          if z then
            if abs(y - z) > 0.2 then
              --print(y)print(select(1,x:GetRegions()):GetAlpha())
              select(1,x:GetRegions()):SetAlpha(y) -- 背景
              select(7,x:GetRegions()):SetAlpha(y) -- 名字文本
              select(1,x:GetChildren()):SetAlpha(y) -- 生命条
              select(2,x:GetChildren()):SetAlpha(y) -- 法力条
            end
          end
        end
      end
      
      --Keep Groups Together Checked
      for i=1,8 do
        for j=1,5 do
          x = _G[t[i][j]]
          
          if x then
            if x:GetAlpha()<0.8 then
              y=opacity
            else
              y=1
            end
            z= select(1,x:GetRegions()):GetAlpha()
            if z then
              if abs(y - z) > 0.2 then
                --print(y)print(select(1,x:GetRegions()):GetAlpha())
                select(1,x:GetRegions()):SetAlpha(y) -- 背景
                select(7,x:GetRegions()):SetAlpha(y) -- 名字文本
                select(1,x:GetChildren()):SetAlpha(y) -- 生命条
                select(2,x:GetChildren()):SetAlpha(y) -- 法力条
              end
            end
          end
          
        end
      end
    else
      --print("Blizz_Raid_Fader Disabled")
      raid_frame:SetScript("OnUpdate", nil)
    end
  end
end


local begin_frame = CreateFrame("Frame")
local function begin()
  w=UnitInRaid("player")
  if w then
    --print("Blizz_Raid_Fader Loaded")
    raid_frame:SetScript("OnUpdate", raid_update)
  else
    raid_frame:SetScript("OnUpdate", nil)
  end
end

begin_frame:SetScript("OnEvent", begin)
begin_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
begin_frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
begin_frame:RegisterEvent("RAID_ROSTER_UPDATE")



