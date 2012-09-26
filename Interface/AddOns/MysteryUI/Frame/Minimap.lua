-- 隐藏无用
MinimapCluster:SetScale(1.0)
MinimapCluster:SetPoint("TOPRIGHT", "UIParent", "TOPRIGHT", -5, 5)
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapWorldMapButton:Hide()
MinimapZoneTextButton:Hide()
MinimapBorderTop:Hide()

-- 鼠标滚轴缩放
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)