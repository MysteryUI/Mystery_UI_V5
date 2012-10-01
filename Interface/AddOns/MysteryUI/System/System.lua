--系统菜单美化 By 三小三 

local addonName, L = ...; 
local function defaultFunc(L, key) 
return key; 
end 
setmetatable(L, {__index=defaultFunc}); 

lpanels:CreateLayout("System", {
-----------------------------------------
--info
-----------------------------------------
	{	name = "System",  parent = "UIParent", level = 1,
    	 x_off = 3, y_off = 0, anchor_to = "BOTTOMRIGHT", anchor_from = "BOTTOMRIGHT",
		width = 202, height = 91,  mouse = true, 
		tex_file ="Interface\\Addons\\MysteryUI\\MyMedia\\tex", bg_color = "0.05 0.05 0.05", bg_alpha = 0.9,
--		tex_file ="SidebarB", bg_color = "0 0 0", bg_alpha = 0.8,
		border = "Interface\\Tooltips\\UI-Tooltip-Border", border_size = 16, inset = 3, border_color = "0.3 0.3 0.3 1",
--		border = "GlowTex", border_size = 5, inset = 4, border_color = "0 0 0 1",

       OnLoad = function(self)
		self:RegisterEvent("PLAYER_ENTERING_WORLD");
		end;
		OnEvent = function(self,event,...)
		if (event == "PLAYER_ENTERING_WORLD") then
		LP_System:ClearAllPoints()
		LP_System:SetPoint("BOTTOMRIGHT", 200, 0)
		end
		end
	},
   {    name = "Tab5", parent = "LP_System", level = 3,
	    strata = "BACKGROUND", tex_file = "Interface\\Addons\\MysteryUI\\MyMedia\\tex",
        anchor_to = "TOPRIGHT", anchor_from = "TOPLEFT", x_off = 4, y_off = 0,  bg_color = "0.05 0.05 0.05",
        width = 30, height = 91, bg_alpha = .9,  mouse = true, flip_h = false,
		border = "Interface\\Tooltips\\UI-Tooltip-Border", border_size = 16, inset = 3, border_color = "0.3 0.3 0.3 1",
--		border = "GlowTex", border_size = 5, inset = 4, border_color = "0 0 0 1",
		text = {string = "S\ny\ns\nt\ne\nm\n", 
		size = 10, shadow = { color = "1 1 1", y = -2, x = 2, alpha = .1},
		outline = 1, font = "04B08.ttf", anchor_from = "TOP", anchor_to = "TOP", x_off = 2, y_off = -10
		},       
		OnClick = function(self, button)
		     if (not self.collapsed) then
			  self.collapsed = true;			  
			  LP_System:ClearAllPoints()
			  LP_System:SetPoint("BOTTOMRIGHT", 2, 0)
		     else
			  self.collapsed = false;
			  LP_System:ClearAllPoints()
			  LP_System:SetPoint("BOTTOMRIGHT", 200, 0)
		    end
	   end	;
	   OnEnter=function(self)
	   --self.bg:SetVertexColor(1, 164/255, 162/255, .8)
	   self.bg:SetVertexColor(171/255, 174/255, 178/255, .3)  
	   end;
	   OnLeave=function(self)
	   self.bg:SetVertexColor(0, 0, 0, .8)
	   end	
    },
	{	name = "home",  parent = "LP_System", level = 2,
    	 x_off = -7, y_off = 0, anchor_to = "TOPRIGHT", anchor_from = "TOPRIGHT",
		width = 42, height = 42,  mouse = true, 
		tex_file ="World", bg_color = "1 1 1", bg_alpha = 1,
	},
	{	name = "rline5",  parent = "LP_System", level = 2,
    	 x_off = -22, y_off = -12, anchor_to = "TOP", 
		width = 135, height = 1, anchor_from = "TOP",
		tex_file ="TaskbarWhite", bg_color = "1 1 1", bg_alpha = 0.4,
	},	
	{	name = "rline5_1",  parent = "LP_System", level = 2,
    	 x_off = 0, y_off = 8, anchor_to = "BOTTOM", 
		width = 176, height = 1, anchor_from = "BOTTOM",
		tex_file ="TaskbarWhite", bg_color = "1 1 1", bg_alpha = 0.4,
	},
----------------------------
--CHARACTER_BUTTON
----------------------------
   {	name = "Character", parent = "LP_System", level = 2,  x_off = 14, y_off = 10, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="p", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   --self.bg:SetVertexColor(1, 164/255, 162/255, .3)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   p = CreateFrame("Frame", nil, self)
	   p:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   p:SetPoint("TOP", LP_Character, "TOP", 0, 21)
	   p:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   p:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   p:SetWidth(70)
	   p:SetHeight(30)
	   p:SetFrameLevel(4)
	      
	    pt = p:CreateFontString(nil, 'OVERLAY')
		pt:SetPoint("CENTER", p, "CENTER", 0, 0)
		pt:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		pt:SetTextColor(1, 1, 1)
		pt:SetText(L["角色信息"])
		UIFrameFadeIn(p, 2, 0, 1)
		UIFrameFadeIn(pt, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(p, 0.5, 1, 0)
	   UIFrameFadeOut(pt, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleCharacter("PaperDollFrame")
	   end
	},
-----------------------------------------
--SPELLBOOK_ABILITIES_BUTTON
-----------------------------------------
   {	name = "spellb", parent = "LP_System", level = 2,  x_off = 39, y_off = 10, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="Reader", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   s = CreateFrame("Frame", nil, self)
	   s:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   s:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   s:SetPoint("TOP", LP_spellb, "TOP", 0, 21)
	   s:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   s:SetWidth(60)
	   s:SetHeight(30)
	   s:SetFrameLevel(4)
	      
	    st = s:CreateFontString(nil, 'OVERLAY')
		st:SetPoint("CENTER", s, "CENTER", 0, 0)
		st:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		st:SetTextColor(1, 1, 1)
		st:SetText(L["法术书"])
		UIFrameFadeIn(s, 2, 0, 1)
		UIFrameFadeIn(st, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(s, 0.5, 1, 0)
	   UIFrameFadeOut(st, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleFrame(SpellBookFrame)
	   end
	},
-----------------------------------------
--TALENTS_BUTTON
-----------------------------------------
   {	name = "talents", parent = "LP_System", level = 2,  x_off = 67, y_off = 10, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="spellb", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   t = CreateFrame("Frame", nil, self)
	   t:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   t:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   t:SetPoint("TOP", LP_talents, "TOP", 0, 21)
	   t:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   t:SetWidth(60)
	   t:SetHeight(30)
	   t:SetFrameLevel(4)
	      
	    tt = t:CreateFontString(nil, 'OVERLAY')
		tt:SetPoint("CENTER", t, "CENTER", 0, 0)
		tt:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		tt:SetTextColor(1, 1, 1)
		tt:SetText(L["天赋"])
		UIFrameFadeIn(t, 2, 0, 1)
		UIFrameFadeIn(tt, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(t, 0.5, 1, 0)
	   UIFrameFadeOut(tt, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             if not IsAddOnLoaded("Blizzard_TalentUI") then LoadAddOn("Blizzard_TalentUI") end 
              ToggleFrame(PlayerTalentFrame)
	   end
	},
-----------------------------------------
--ACHIEVEMENT_BUTTON
-----------------------------------------
   {	name = "Achievement", parent = "LP_System", level = 2,  x_off = 95, y_off = 10, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="cj", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   a = CreateFrame("Frame", nil, self)
	   a:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   a:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   a:SetPoint("TOP", LP_Achievement, "TOP", 0, 21)
	   a:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   a:SetWidth(60)
	   a:SetHeight(30)
	   a:SetFrameLevel(4)
	      
	    at = a:CreateFontString(nil, 'OVERLAY')
		at:SetPoint("CENTER", a, "CENTER", 0, 0)
		at:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		at:SetTextColor(1, 1, 1)
		at:SetText(L["成就"])
		UIFrameFadeIn(a, 2, 0, 1)
		UIFrameFadeIn(at, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(a, 0.5, 1, 0)
	   UIFrameFadeOut(at, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleAchievementFrame()
	   end
	},
-----------------------------------------
--PetJournal_BUTTON
-----------------------------------------
   {	name = "PetJournal", parent = "LP_System", level = 2,  x_off = 123, y_off = 10, bg_alpha = 1,
		width = 26, height = 26, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="Personal", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   pj = CreateFrame("Frame", nil, self)
	   pj:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   pj:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   pj:SetPoint("TOP", LP_PetJournal, "TOP", 0, 21)
	   pj:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   pj:SetWidth(80)
	   pj:SetHeight(30)
	   pj:SetFrameLevel(4)
	      
	    pjt = pj:CreateFontString(nil, 'OVERLAY')
		pjt:SetPoint("CENTER", pj, "CENTER", 0, 0)
		pjt:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		pjt:SetTextColor(1, 1, 1)
		pjt:SetText(L["坐骑与宠物"])
		UIFrameFadeIn(pj, 2, 0, 1)
		UIFrameFadeIn(pjt, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(pj, 0.5, 1, 0)
	   UIFrameFadeOut(pjt, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             TogglePetJournal()
	   end
	},
----------------------------
--QUESTLOG_BUTTON
----------------------------
   {	name = "questl", parent = "LP_System", level = 2,  x_off = 14, y_off = -19, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="rw", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   q = CreateFrame("Frame", nil, self)
	   q:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   q:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   q:SetPoint("TOP", LP_questl, "TOP", 0, 21)
	   q:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   q:SetWidth(60)
	   q:SetHeight(30)
	   q:SetFrameLevel(4)
	      
	    qt = q:CreateFontString(nil, 'OVERLAY')
		qt:SetPoint("CENTER", q, "CENTER", 0, 0)
		qt:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		qt:SetTextColor(1, 1, 1)
		qt:SetText(L["任务日志"])
		UIFrameFadeIn(q, 2, 0, 1)
		UIFrameFadeIn(qt, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(q, 0.5, 1, 0)
	   UIFrameFadeOut(qt, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleFrame(QuestLogFrame)
	   end
	},
----------------------------
--SOCIAL_BUTTON
----------------------------
   {	name = "social", parent = "LP_System", level = 2,  x_off = 39, y_off = -20, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="sj", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   so = CreateFrame("Frame", nil, self)
	   so:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   so:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   so:SetPoint("TOP", LP_social, "TOP", 0, 21)
	   so:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   so:SetWidth(60)
	   so:SetHeight(30)
	   so:SetFrameLevel(4)
	      
	    sot = so:CreateFontString(nil, 'OVERLAY')
		sot:SetPoint("CENTER", so, "CENTER", 0, 0)
		sot:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		sot:SetTextColor(1, 1, 1)
		sot:SetText(L["社交"])
		UIFrameFadeIn(so, 2, 0, 1)
		UIFrameFadeIn(sot, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(so, 0.5, 1, 0)
	   UIFrameFadeOut(sot, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleFriendsFrame(1)
	   end
	},
----------------------------
--PVP
----------------------------
   {	name = "pvp", parent = "LP_System", level = 2,  x_off = 67, y_off = -20, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="pvp", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   pv = CreateFrame("Frame", nil, self)
	   pv:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   pv:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   pv:SetPoint("TOP", LP_pvp, "TOP", 0, 21)
	   pv:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   pv:SetWidth(60)
	   pv:SetHeight(30)
	   pv:SetFrameLevel(4)
	      
	    pvt = pv:CreateFontString(nil, 'OVERLAY')
		pvt:SetPoint("CENTER", pv, "CENTER", 0, 0)
		pvt:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		pvt:SetTextColor(1, 1, 1)
		pvt:SetText(L["PVP"])
		UIFrameFadeIn(pv, 2, 0, 1)
		UIFrameFadeIn(pvt, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(pv, 0.5, 1, 0)
	   UIFrameFadeOut(pvt, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleFrame(PVPFrame)
	   end
	},
----------------------------
--LFG_TITLE
----------------------------
   {	name = "lfg", parent = "LP_System", level = 2,  x_off = 95, y_off = -20, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="x", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(self)
	   self.bg:SetVertexColor(1, 1, 1, .3)
	   lf = CreateFrame("Frame", nil, self)
	   lf:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   lf:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   lf:SetPoint("TOP", LP_lfg, "TOP", 0, 21)
	   lf:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   lf:SetWidth(80)
	   lf:SetHeight(30)
	   lf:SetFrameLevel(4)
	      
	    lft = lf:CreateFontString(nil, 'OVERLAY')
		lft:SetPoint("CENTER", lf, "CENTER", 0, 0)
		lft:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		lft:SetTextColor(1, 1, 1)
		lft:SetText(L["寻找地下城"])
		UIFrameFadeIn(lf, 2, 0, 1)
		UIFrameFadeIn(lft, 2, 0, 1)
	   end;
	   OnLeave = function(self)
	   self.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(lf, 0.5, 1, 0)
	   UIFrameFadeOut(lft, 0.5, 1, 0)
	   end;
	   OnClick = function(self, button)
             ToggleFrame(PVEFrame)
	   end
	},
----------------------------
--GUILDFRAME
----------------------------
   {	name = "GuildFrame", parent = "LP_System", level = 2,  x_off = 123, y_off = -20, bg_alpha = 1,
		width = 24, height = 24, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="Finder", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(seh)
	   seh.bg:SetVertexColor(1, 1, 1, .3)
	   h = CreateFrame("Frame", nil, seh)
	   h:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   h:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   h:SetPoint("TOP", LP_GuildFrame, "TOP", 0, 21)
	   h:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   h:SetWidth(60)
	   h:SetHeight(30)
	   h:SetFrameLevel(4)
	      
	    ht = h:CreateFontString(nil, 'OVERLAY')
		ht:SetPoint("CENTER", h, "CENTER", 0, 0)
		ht:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		ht:SetTextColor(1, 1, 1)
		ht:SetText(L["公会"])
		UIFrameFadeIn(h, 2, 0, 1)
		UIFrameFadeIn(ht, 2, 0, 1)
	   end;
	   OnLeave = function(seh)
	   seh.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(h, 0.5, 1, 0)
	   UIFrameFadeOut(ht, 0.5, 1, 0)
	   end;
	   OnClick = function(seh, button)
             ToggleGuildFrame()
	   end
	},
----------------------------
--EncounterJournal_BUTTON
----------------------------
   {	name = "EncounterJournal", parent = "LP_System", level = 2,  x_off = 151, y_off = -15, bg_alpha = 1,
		width = 30, height = 30, anchor_to = "LEFT", anchor_from = "LEFT",
		tex_file ="My Computer W", bg_color = "1 1 1", mouse = true, 
	   OnEnter = function(seh)
	   seh.bg:SetVertexColor(1, 1, 1, .3)
	   ej = CreateFrame("Frame", nil, seh)
	   ej:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8",edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3}})
	   ej:SetBackdropColor(0.05, 0.05, 0.05, .9)
	   ej:SetPoint("TOP", LP_EncounterJournal, "TOP", 0, 21)
	   ej:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)
	   ej:SetWidth(80)
	   ej:SetHeight(30)
	   ej:SetFrameLevel(4)
	      
	    ejt = ej:CreateFontString(nil, 'OVERLAY')
		ejt:SetPoint("CENTER", ej, "CENTER", 0, 0)
		ejt:SetFont("Fonts\\ARKai_T.TTF", 14, "THICKOUTLINE")
		ejt:SetTextColor(1, 1, 1)
		ejt:SetText(L["地下城手册"])
		UIFrameFadeIn(ej, 2, 0, 1)
		UIFrameFadeIn(ejt, 2, 0, 1)
	   end;
	   OnLeave = function(seh)
	   seh.bg:SetVertexColor(1, 1, 1, 1)
	   UIFrameFadeOut(ej, 0.5, 1, 0)
	   UIFrameFadeOut(ejt, 0.5, 1, 0)
	   end;
	   OnClick = function(seh, button)
             ToggleEncounterJournal()
	   end
	},	
}); lpanels:ApplyLayout(nil, "System")