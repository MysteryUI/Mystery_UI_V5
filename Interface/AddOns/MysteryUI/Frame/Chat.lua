--聊天增强

local addonName, L = ...; 
local function defaultFunc(L, key) 
return key; 
end 
setmetatable(L, {__index=defaultFunc}); 

--[[ 禁用脏话过滤器 ]]
local frame = CreateFrame("FRAME", "DisableProfanityFilter")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
local function eventHandler(self, event, ...)
	
	SetCVar( "profanityFilter", 0)
	BNSetMatureLanguageFilter(false)
	
end
frame:SetScript("OnEvent", eventHandler)

-- [[ 聊天 ]]
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0;
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0;

frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		frame:SetSize(340, 140)
		SetChatWindowSavedDimensions(i, 340, 140)
		if i == 1 then
			frame:ClearAllPoints()
			frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 12, 12)
		end
		FCF_SavePositionAndDimensions(frame)
	end
end)

local clickFunction = function(self) self:GetParent():ScrollToBottom() self:Hide() end;

local function hide(self)
	self:Hide();
end

-- 编辑框
for i= 1,10 do
	local editbox = _G['ChatFrame'..i..'EditBox']

	local a, b, c = select(6, editbox:GetRegions())
	a:SetAlpha(0)
	b:SetAlpha(0)
	c:SetAlpha(0)
		
	editbox:ClearAllPoints()
	editbox:SetPoint('BOTTOMLEFT', _G.ChatFrame1, 'TOPLEFT', -10, 20)
	editbox:SetPoint('BOTTOMRIGHT', _G.ChatFrame1, 'TOPRIGHT', -10, 20)
	editbox:SetAltArrowKeyMode(false)
		
end

DEFAULT_CHATFRAME_ALPHA = 0 

-- 频道名称
CHAT_FLAG_AFK = L['[暂离] ']
CHAT_FLAG_DND = L['[勿扰] ']
CHAT_FLAG_GM = L['[GM] ']

CHAT_SAY_GET = '%s:\32'
CHAT_YELL_GET = '%s:\32'

CHAT_WHISPER_GET = L['[来自] %s:\32']
CHAT_WHISPER_INFORM_GET = L['[告诉] %s:\32']

CHAT_BN_WHISPER_GET = L['[来自] %s:\32']
CHAT_BN_WHISPER_INFORM_GET = L['[告诉] %s:\32']

CHAT_GUILD_GET = L['[|Hchannel:Guild|h公会|h] %s:\32']
CHAT_OFFICER_GET = L['[|Hchannel:o|h官员|h] %s:\32']

CHAT_PARTY_GET = L['[|Hchannel:party|h队伍|h] %s:\32']
CHAT_PARTY_LEADER_GET = L['[|Hchannel:party|h队长|h] %s:\32']
CHAT_PARTY_GUIDE_GET = L['[|Hchannel:party|hDG|h] %s:\32']
CHAT_MONSTER_PARTY_GET = L['[|Hchannel:raid|hR|h] %s:\32']

CHAT_RAID_GET = L['[|Hchannel:raid|h团队|h] %s:\32']
CHAT_RAID_WARNING_GET = L['[警告!] %s:\32']
CHAT_RAID_LEADER_GET = L['[|Hchannel:raid|h团队领袖|h] %s:\32']

CHAT_BATTLEGROUND_GET = L['[|Hchannel:Battleground|h战场|h] %s:\32']
CHAT_BATTLEGROUND_LEADER_GET = L['[|Hchannel:Battleground|h战场领袖|h] %s:\32']

CHAT_YOU_CHANGED_NOTICE_BN = L['频道变更: |Hchannel:%d|h%s|h']
CHAT_YOU_JOINED_NOTICE_BN = L['加入频道: |Hchannel:%d|h%s|h']
CHAT_YOU_LEFT_NOTICE_BN = L['离开频道: |Hchannel:%d|h%s|h']
CHAT_SUSPENDED_NOTICE_BN = L['离开频道: |Hchannel:%d|h%s|h']

-- 复制框
ChatTypeInfo.BATTLEGROUND.sticky = 1
ChatTypeInfo.BATTLEGROUND_LEADER.sticky = 1
ChatTypeInfo.CHANNEL.sticky = 1
ChatTypeInfo.GUILD.sticky = 1
ChatTypeInfo.OFFICER.sticky = 1
ChatTypeInfo.PARTY.sticky = 1
ChatTypeInfo.RAID.sticky = 1
ChatTypeInfo.SAY.sticky = 1

local function CleanChat(f)
	f:SetClampRectInsets(0, 0, 0, 0);
	local ff = _G[f:GetName() .. "ButtonFrame"];
	ff:Hide();
	ff:SetScript("OnShow", hide);

	local bt = CreateFrame("Button", nil, f);
	bt:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollEnd-Up]]);
	bt:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollEnd-Down]]);
	bt:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollEnd-Disabled]]);
	bt:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
	bt:SetWidth(25);
	bt:SetHeight(25);
	bt:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
	bt:SetScript("OnClick", clickFunction);
	bt:Hide();
	f.downButton = bt;
end

ChatFrameMenuButton:Hide();
ChatFrameMenuButton:SetScript("OnShow", hide);
FriendsMicroButton:Hide();
FriendsMicroButton:SetScript("OnShow", hide);

for i = 1, NUM_CHAT_WINDOWS do
	local f = _G["ChatFrame" .. i];
	CleanChat(f);
end

hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(self)
	if self:GetCurrentScroll() ~= 0 then
		self.downButton:Show();
	else
		self.downButton:Hide();
	end
end)

--网址复制
local color = "C0C0C0"
local pattern = "[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]"

function string.color(text, color)
	return "|cff"..color..text.."|r"
end

function string.link(text, type, value, color)
	return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end

StaticPopupDialogs["LINKME"] = {
	text = L["复制网址"],
	button2 = CANCEL,
	hasEditBox = true,
    editBoxWidth = 400,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

local function f(url)
	return string.link("["..url.."]", "url", url, color)
end

local function hook(self, text, ...)
	self:f(text:gsub(pattern, f), ...)
end

function LinkMeURL()
	for i = 1, NUM_CHAT_WINDOWS do
		if ( i ~= 2 ) then
			local lframe = _G["ChatFrame"..i]
			lframe.f = lframe.AddMessage
			lframe.AddMessage = hook
		end
	end
end
LinkMeURL()

local ur = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(self, link, text, button)
	local type, value = link:match("(%a+):(.+)")
	if ( type == "url" ) then
		local dialog = StaticPopup_Show("LINKME")
		local editbox1 = _G[dialog:GetName().."EditBox"]  
		editbox1:SetText(value)
		editbox1:SetFocus()
		editbox1:HighlightText()
		local button = _G[dialog:GetName().."Button2"]
            
		button:ClearAllPoints()
           
		button:SetPoint("CENTER", editbox1, "CENTER", 0, -30)
	else
		ur(self, link, text, button)
	end
end

-----------标签--------------
local Fane = CreateFrame'Frame'
local inherit = GameFontNormalSmall

local updateFS = function(self, inc, flags, ...)
	local fstring = self:GetFontString()

	local font, fontSize = inherit:GetFont()
	if(inc) then
		fstring:SetFont(font, fontSize + 1, flags)
	else
		fstring:SetFont(font, fontSize, flags)
	end

	if((...)) then
		fstring:SetTextColor(...)
	end
end

local OnEnter = function(self)
	local emphasis = _G["ChatFrame"..self:GetID()..'TabFlash']:IsShown()
	updateFS(self, emphasis, 'OUTLINE', 1, 1, 1, 1)
end

local OnLeave = function(self)
	local r, g, b, al
	local id = self:GetID()
	local emphasis = _G["ChatFrame"..id..'TabFlash']:IsShown()

	if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
		r, g, b, al = 1, 1, 1, 0
	elseif emphasis then
		r, g, b, al = 1, 0, 0, 1
	else
		r, g, b, al = 1, 1, 1, 0
	end

	updateFS(self, emphasis, nil, r, g, b, al)
end

local ChatFrame2_SetAlpha = function(self, alpha)
	if(CombatLogQuickButtonFrame_Custom) then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local ChatFrame2_GetAlpha = function(self)
	if(CombatLogQuickButtonFrame_Custom) then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if(not frame.Fane) then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()

		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()

		frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
		frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
		frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide

		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()

		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)

		frame:SetAlpha(1)

		if(i ~= 2) then
			-- 可能不是最好的解决办法，但我们避免陷入UI框架淡出挂钩
			-- 系統這樣.
			frame.SetAlpha = UIFrameFadeRemoveFrame
		else
			frame.SetAlpha = ChatFrame2_SetAlpha
			frame.GetAlpha = ChatFrame2_GetAlpha

			if(CombatLogQuickButtonFrame_Custom) then
				CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
			end
		end

		frame.Fane = true
	end

	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame, nil, nil, 1, 1, 1, 0)
	else
		updateFS(frame, nil, nil, 1, 1, 1, 0)
	end
end

hooksecurefunc('FCF_StartAlertFlash', function(frame)
	local tab = _G['ChatFrame' .. frame:GetID() .. 'Tab']
	updateFS(tab, true, nil, 1, 0, 0)
end)

hooksecurefunc('FCFTab_UpdateColors', faneifyTab)

for i=1,7 do
	faneifyTab(_G['ChatFrame' .. i .. 'Tab'])
end

function Fane:ADDON_LOADED(event, addon)
	if(addon == 'Blizzard_CombatLog') then
		self:UnregisterEvent(event)
		self[event] = nil

		return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
	end
end
Fane:RegisterEvent'ADDON_LOADED'

Fane:SetScript('OnEvent', function(self, event, ...)
	return self[event](self, event, ...)
end)

----------复制聊天内容--------------

local frame = CreateFrame("Frame", "ChatCopyFrame", UIParent)
frame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = {left = 3, right = 3, top = 5, bottom = 3
}})

frame:SetBackdropColor(0, 0, 0, 1)
frame:SetWidth(500)
frame:SetHeight(400)
frame:SetPoint("LEFT", UIParent, "LEFT", 3, 10)
frame:SetFrameStrata("DIALOG")
frame:Hide()

local scrollArea = CreateFrame("ScrollFrame", "ChatCopyFrameScroll", frame, "UIPanelScrollFrameTemplate")
scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

editBox = CreateFrame("EditBox", "EvlChatCopyBox", frame)
editBox:SetMultiLine(true)
editBox:SetMaxLetters(20000)
editBox:EnableMouse(true)
editBox:SetAutoFocus(true)
editBox:SetFontObject(ChatFontNormal)
editBox:SetWidth(450)
editBox:SetHeight(270)
editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

scrollArea:SetScrollChild(editBox)

local close = CreateFrame("Button", "ChatCopyClose", frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -1)

local lines = {}
local getLines = function(...)
	local count = 1

	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		
		if region:GetObjectType() == "FontString" then
			lines[count] = tostring(region:GetText())
			count = count + 1
		end
	end

	return count - 1
end

local copyChat = function(self, chatTab)
	local chatFrame = _G["ChatFrame" .. chatTab:GetID()]
	local _, fontSize = chatFrame:GetFont()
	
	FCF_SetChatWindowFontSize(chatFrame, chatFrame, 0.01)
	
	local lineCount = getLines(chatFrame:GetRegions())
	
	FCF_SetChatWindowFontSize(chatFrame, chatFrame, fontSize)

	if lineCount > 0 then
		local text = table.concat(lines, "\n", 1, lineCount)

		frame:Show()
		editBox:SetText(text)
	end
end

local info = {
	text = L["复制聊天内容"],
	func = copyChat,
	notCheckable = 1	
}

local origFCF_Tab_OnClick = _G.FCF_Tab_OnClick
local FCF_Tab_OnClickHook = function(chatTab, ...)
	origFCF_Tab_OnClick(chatTab, ...)

	info.arg1 = chatTab
	
	UIDropDownMenu_AddButton(info)
end

FCF_Tab_OnClick = FCF_Tab_OnClickHook