--°´¼ü°ó¶¨

local function IsSpecificButton(self, name)
    local sbut = self:GetName():match(name)
    if (sbut) then
        return true
    else
        return false
    end
end

hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
    local hotkey = _G[self:GetName()..'HotKey']

    if (not IsSpecificButton(self, 'VehicleMenuBarActionButton')) then
            hotkey:ClearAllPoints()
            hotkey:SetPoint('TOPRIGHT', self, 0, -3)
            hotkey:SetFont(GameFontNormal:GetFont(), 15, 'THINOUTLINE')
            hotkey:SetVertexColor(0.6, 0.6, 0.6)
    end
end)

local gsub = string.gsub

hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
    local hotkey = _G[self:GetName()..'HotKey']
    local text = hotkey:GetText()

    text = gsub(text, '(s%-)', 'S-')
    text = gsub(text, '(a%-)', 'A-')
    text = gsub(text, '(c%-)', 'C-')
    text = gsub(text, '(st%-)', 'C-') -- german control 'Steuerung'

    for i = 1, 30 do
        text = gsub(text, _G['KEY_BUTTON'..i], 'M'..i)
    end

    for i = 1, 9 do
        text = gsub(text, _G['KEY_NUMPAD'..i], 'Nu'..i)
    end

    text = gsub(text, KEY_MOUSEWHEELUP, 'MU')
    text = gsub(text, KEY_MOUSEWHEELDOWN, 'MD')
    text = gsub(text, KEY_NUMLOCK, 'NuL')
    text = gsub(text, KEY_PAGEUP, 'PU')
    text = gsub(text, KEY_PAGEDOWN, 'PD')
    text = gsub(text, KEY_SPACE, '_')
    text = gsub(text, KEY_INSERT, 'Ins')
    text = gsub(text, KEY_HOME, 'Hm')
    text = gsub(text, KEY_DELETE, 'Del')

    hotkey:SetText(text)
end)