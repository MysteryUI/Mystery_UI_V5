--[[
	item.lua
		An item slot button
--]]

local AddonName, Addon = ...
local ItemSlot = Addon:NewClass('ItemSlot', 'Button')

local Unfit = LibStub('Unfit-1.0')
local ItemSearch = LibStub('LibItemSearch-1.0')

local BagInfo = Addon('BagInfo')
local ItemInfo = Addon('ItemInfo')


--[[ Constructor ]]--

function ItemSlot:New()
	return self:Restore() or self:Create()
end

function ItemSlot:Set(parent, bag, slot)
	self:SetParent(self:GetDummyBag(parent, bag))
	self:SetID(slot)

	if self:IsVisible() then
		self:Update()
	else
		self:Show()
	end
end

--constructs a brand new item slot
function ItemSlot:Create()
	local id = self:GetNextItemSlotID()
	local item = self:Bind(self:GetBlizzardItemSlot(id) or self:ConstructNewItemSlot(id))

	--add a quality border texture
	local border = item:CreateTexture(nil, 'OVERLAY')
	border:SetWidth(67)
	border:SetHeight(67)
	border:SetPoint('CENTER', item)
	border:SetTexture([[Interface\Buttons\UI-ActionButton-Border]])
	border:SetBlendMode('ADD')
	border:Hide()
	item.border = border
	
	--add a quality border texture
	item.questBorder = _G[item:GetName() .. 'IconQuestTexture']

	--hack, make sure the cooldown model stays visible
	item.cooldown = _G[item:GetName() .. 'Cooldown']

	--get rid of any registered frame events, and use my own
	item:SetScript('OnEvent', nil)
	item:SetScript('OnEnter', item.OnEnter)
	item:SetScript('OnLeave', item.OnLeave)
	item:SetScript('OnShow', item.OnShow)
	item:SetScript('OnHide', item.OnHide)
	item:SetScript('PostClick', item.PostClick)
	item.UpdateTooltip = nil

	return item
end

--creates a new item slot for <id>
function ItemSlot:ConstructNewItemSlot(id)
	return CreateFrame('Button', ('%sItem%d'):format(AddonName, id), nil, 'ContainerFrameItemButtonTemplate')
end

--returns an available blizzard item slot for <id>
function ItemSlot:GetBlizzardItemSlot(id)
	--only allow reuse of blizzard frames if all frames are enabled
	if not self:CanReuseBlizzardBagSlots() then
		return nil
	end

	local bag = ceil(id / MAX_CONTAINER_ITEMS)
	local slot = (id-1) % MAX_CONTAINER_ITEMS + 1
	local item = _G[format('ContainerFrame%dItem%d', bag, slot)]

	if item then
		item:SetID(0)
		item:ClearAllPoints()
		return item
	end
end

function ItemSlot:CanReuseBlizzardBagSlots()
	return true
end

--returns the next available item slot
function ItemSlot:Restore()
	local item = ItemSlot.unused and next(ItemSlot.unused)
	if item then
		ItemSlot.unused[item] = nil
		return item
	end
end

--gets the next unique item slot id
do
	local id = 1
	function ItemSlot:GetNextItemSlotID()
		local nextID = id
		id = id + 1
		return nextID
	end
end



--[[ ItemSlot Destructor ]]--

function ItemSlot:Free()
	self:Hide()
	self:SetParent(nil)
	self:UnlockHighlight()

	ItemSlot.unused = ItemSlot.unused or {}
	ItemSlot.unused[self] = true
end


--[[ Frame Events ]]--

function ItemSlot:OnShow()
	self:Update()
end

function ItemSlot:OnHide()
	self:HideStackSplitFrame()
end

function ItemSlot:OnDragStart()
	if self:IsCached() and CursorHasItemSlot() then
		ClearCursor()
	end
end

function ItemSlot:OnModifiedClick(button)
	local link = self:IsCached() and self:GetItem()
	if link then
		HandleModifiedItemClick(link)
	end
end

function ItemSlot:OnEnter()
	local dummySlot = self:GetDummyItemSlot()

	if self:IsCached() then
		dummySlot:SetParent(self)
		dummySlot:SetAllPoints(self)
		dummySlot:Show()
	else
		dummySlot:Hide()

		if self:IsBank() then
			if self:GetItem() then
				self:AnchorTooltip()
				GameTooltip:SetInventoryItem('player', BankButtonIDToInvSlotID(self:GetID()))
				GameTooltip:Show()
				CursorUpdate(self)
			end
		else
			ContainerFrameItemButton_OnEnter(self)
		end
	end
end

function ItemSlot:OnLeave()
	GameTooltip:Hide()
	BattlePetTooltip:Hide()
	ResetCursor()
end


--[[ Update Methods ]]--


-- Update the texture, lock status, and other information about an item
function ItemSlot:Update()
	if not self:IsVisible() then return end

	local texture, count, locked, quality, readable, lootable, link = self:GetInfo()

	self:SetItem(link)
	self:SetTexture(texture)
	self:SetCount(count)
	self:SetLocked(locked)
	self:SetReadable(readable)
	self:SetBorderQuality(quality)
	self:UpdateCooldown()
	self:UpdateSlotColor()

	if GameTooltip:IsOwned(self) then
		self:UpdateTooltip()
	end
end

--item link
function ItemSlot:SetItem(itemLink)
	self.hasItem = itemLink or nil
end

function ItemSlot:GetItem()
	return self.hasItem
end

--item texture
function ItemSlot:SetTexture(texture)
	SetItemButtonTexture(self, texture or self:GetEmptyItemTexture())
end

function ItemSlot:GetEmptyItemTexture()
	if self:ShowingEmptyItemSlotTexture() then
		return [[Interface\PaperDoll\UI-Backpack-EmptySlot]]
	end
	return nil
end

--item slot color
function ItemSlot:UpdateSlotColor()
	if (not self:GetItem()) and self:ColoringBagSlots() then
		if self:IsTradeBagSlot() then
			local r, g, b = self:GetTradeSlotColor()
			SetItemButtonTextureVertexColor(self, r, g, b)
			self:GetNormalTexture():SetVertexColor(r, g, b)
			return
		end
	end

	SetItemButtonTextureVertexColor(self, 1, 1, 1)
	self:GetNormalTexture():SetVertexColor(1, 1, 1)
end

--item count
function ItemSlot:SetCount(count)
	SetItemButtonCount(self, count)
end

--readable status
function ItemSlot:SetReadable(readable)
	self.readable = readable
end

--locked status
function ItemSlot:SetLocked(locked)
	SetItemButtonDesaturated(self, locked)
end

function ItemSlot:UpdateLocked()
	self:SetLocked(self:IsLocked())
end

--returns true if the slot is locked, and false otherwise
function ItemSlot:IsLocked()
	return ItemInfo:IsLocked(self:GetPlayer(), self:GetBag(), self:GetID())
end

--colors the item border based on the quality of the item.  hides it for common/poor items
function ItemSlot:SetBorderQuality(quality)
	local border = self.border
	local qBorder = self.questBorder
	
	qBorder:Hide()
	border:Hide()

	if self:HighlightingQuestItems() then
		local isQuestItem, isQuestStarter = self:IsQuestItem()
		if isQuestItem then
			border:SetVertexColor(1, .82, .2,  self:GetHighlightAlpha())
			border:Show()
			return
		end

		if isQuestStarter then
			qBorder:SetTexture(TEXTURE_ITEM_QUEST_BANG)
			qBorder:Show()
			return
		end
	end
	
	local link = select(7, self:GetInfo())
	if Unfit:IsItemUnusable(link) then
		local r, g, b = RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b
		border:SetVertexColor(r, g, b, self:GetHighlightAlpha())
		border:Show()
		return
	end

	if self:GetItem() and quality and quality > 1 then
		local r, g, b = GetItemQualityColor(quality)
		border:SetVertexColor(r, g, b, self:GetHighlightAlpha())
		border:Show()
	end
end

function ItemSlot:UpdateBorder()
	local texture, count, locked, quality = self:GetInfo()
	self:SetBorderQuality(quality)
end

--cooldown
function ItemSlot:UpdateCooldown()
	if self:GetItem() and (not self:IsCached()) then
		ContainerFrame_UpdateCooldown(self:GetBag(), self)
	else
		CooldownFrame_SetTimer(self.cooldown, 0, 0, 0)
		SetItemButtonTextureVertexColor(self, 1, 1, 1)
	end
end

--stack split frame
function ItemSlot:HideStackSplitFrame()
	if self.hasStackSplit and self.hasStackSplit == 1 then
		StackSplitFrame:Hide()
	end
end

--tooltip methods
ItemSlot.UpdateTooltip = ItemSlot.OnEnter

function ItemSlot:AnchorTooltip()
	if self:GetRight() >= (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end
end

--highlight
function ItemSlot:Highlight(enable)
	if enable then		
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end



--[[ Accessor Methods ]]--

function ItemSlot:GetPlayer()
	local player
	if self:GetParent() then
		local p = self:GetParent():GetParent()
		player = p and p:GetPlayer()
	end
	return player or UnitName('player')
end

function ItemSlot:GetBag()
	return self:GetParent() and self:GetParent():GetID() or -1
end

function ItemSlot:IsSlot(bag, slot)
	return self:GetBag() == bag and self:GetID() == slot
end

function ItemSlot:IsCached()
	return BagInfo:IsCached(self:GetPlayer(), self:GetBag())
end

function ItemSlot:IsBank()
	return BagInfo:IsBank(self:GetBag())
end

function ItemSlot:GetInfo()
	local texture, count, locked, quality, readable, lootable, link = ItemInfo:GetInfo(self:GetPlayer(), self:GetBag(), self:GetID())
	return texture, count, locked, quality, readable, lootable, link
end


--[[ Item Type Highlighting ]]--

function ItemSlot:HighlightingItemsByQuality()
	return true
end

function ItemSlot:HighlightingQuestItems()
	return true
end

function ItemSlot:GetHighlightAlpha()
	return 0.5
end

local QUEST_ITEM_SEARCH = string.format('t:%s|%s', select(10, GetAuctionItemClasses()), 'quest')
function ItemSlot:IsQuestItem()
	local itemLink = self:GetItem()
	if not itemLink then
		return false, false
	end

	if self:IsCached() then
		return ItemSearch:Find(itemLink, QUEST_ITEM_SEARCH), false
	else
		local isQuestItem, questID, isActive = GetContainerItemQuestInfo(self:GetBag(), self:GetID())
		return isQuestItem, (questID and not isActive)
	end
end


--[[ Item Slot Coloring ]]--

function ItemSlot:IsTradeBagSlot()
	return BagInfo:IsTradeBag(self:GetPlayer(), self:GetBag())
end

function ItemSlot:GetTradeSlotColor()	
	return 0.5, 1, 0.5
end

function ItemSlot:ColoringBagSlots()
	return true
end


--[[ Empty Slot Visibility ]]--

function ItemSlot:ShowingEmptyItemSlotTexture()
	return true
end


--[[ Delicious Hacks ]]--

-- dummy slot - A hack, used to provide a tooltip for cached items without tainting other item code
function ItemSlot:GetDummyItemSlot()
	ItemSlot.dummySlot = ItemSlot.dummySlot or ItemSlot:CreateDummyItemSlot()
	return ItemSlot.dummySlot
end

function ItemSlot:CreateDummyItemSlot()
	local slot = CreateFrame('Button')
	slot:RegisterForClicks('anyUp')
	slot:SetToplevel(true)
	slot:Hide()

	local function Slot_OnEnter(self)
		local parent = self:GetParent()
		local item = parent:IsCached() and parent:GetItem()
		
		if item then
			parent.AnchorTooltip(self)
			
			if item:find('battlepet:') then
				local _, specie, level, quality, health, power, speed = strsplit(':', item)
				local name = item:match('%[(.-)%]')
				
				BattlePetToolTip_Show(
					tonumber(specie), level, tonumber(quality), health, power, speed, name)
			else
				GameTooltip:SetHyperlink(item)
				GameTooltip:Show()
			end
		end
		
		parent:LockHighlight()
	end

	local function Slot_OnLeave(self)
		self:GetParent():OnLeave()
		self:Hide()
	end

	local function Slot_OnHide(self)
		local parent = self:GetParent()
		if parent then
			parent:UnlockHighlight()
		end
	end

	local function Slot_OnClick(self, button)
		self:GetParent():OnModifiedClick(button)
	end

	slot.UpdateTooltip = Slot_OnEnter
	slot:SetScript('OnClick', Slot_OnClick)
	slot:SetScript('OnEnter', Slot_OnEnter)
	slot:SetScript('OnLeave', Slot_OnLeave)
	slot:SetScript('OnShow', Slot_OnEnter)
	slot:SetScript('OnHide', Slot_OnHide)

	return slot
end


--dummy bag, a hack to enforce the internal blizzard rule that item:GetParent():GetID() == bagID
function ItemSlot:GetDummyBag(parent, bag)
	local dummyBags = parent.dummyBags

	--metatable magic to create a new frame on demand
	if not dummyBags then
		dummyBags = setmetatable({}, {
			__index = function(t, k)
				local f = CreateFrame('Frame', nil, parent)
				f:SetID(k)
				t[k] = f
				return f
			end
		})
		parent.dummyBags = dummyBags
	end

	return dummyBags[bag]
end