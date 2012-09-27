	------------------------------------------------------------
--	��ɫͿ���޸�Ĭ�Ͻ��� ~ ���� Aprikot
	------------------------------------------------------------
	
--	����
	------
	local class = false  	-- ������ͷ�����ɫ�����������������ɫ��
	local gradient = false	-- false ������һ����ɫ(���= trueʱ��������ɫ��������Ǵ�ɫ)
	local topcolor = {  	-- �����Ľ�����ɫ (rgb)
    	r = 0.5,
		g = 0.5,
		b = 0.5,
	}
	local bottomcolor = {	-- �ײ��Ľ���ɫ (rgb)
    	r = 0.5,
		g = 0.5,
		b = 0.5,
	}
	local topalpha = 1.0	-- ����͸����
	local bottomalpha = 1.0	-- �ײ�͸����
	
	-- ����ʱ�����ʱ�Ӱ�ť����ɫ��
	if not IsAddOnLoaded("Blizzard_TimeManager") then
		LoadAddOn("Blizzard_TimeManager")
	end
	
--	Ϳ�ĵĶ���
	----------------
	local objects = {
	
		-- ����
		RuneButtonIndividual1:GetRegions(),
		RuneButtonIndividual1Border:GetRegions(),	
		RuneButtonIndividual2:GetRegions(),
		RuneButtonIndividual2Border:GetRegions(),
		RuneButtonIndividual3:GetRegions(),
		RuneButtonIndividual3Border:GetRegions(),
		RuneButtonIndividual4:GetRegions(),
		RuneButtonIndividual4Border:GetRegions(),
		RuneButtonIndividual5:GetRegions(),
		RuneButtonIndividual5Border:GetRegions(),
		RuneButtonIndividual6:GetRegions(),
		RuneButtonIndividual6Border:GetRegions(),

		-- ��λ����
		PlayerFrameTexture,
        select(2, PlayerFrameAlternateManaBar:GetRegions()),
		TargetFrameTextureFrameTexture,
		FocusFrameTextureFrameTexture,
		TargetFrameToTTextureFrameTexture,
		FocusFrameToTTextureFrameTexture,
		PetFrameTexture,
        PartyMemberFrame1Texture,
        PartyMemberFrame2Texture,
        PartyMemberFrame3Texture,
        PartyMemberFrame4Texture,
        
        PartyMemberFrame1PetFrameTexture,
        PartyMemberFrame2PetFrameTexture,
        PartyMemberFrame3PetFrameTexture,
        PartyMemberFrame4PetFrameTexture,
		
        Boss1TargetFrameTexture,
        Boss2TargetFrameTexture,
        Boss3TargetFrameTexture,
		Boss4TargetFrameTexture,
        
        CompactRaidGroup1BorderFrame,
        CompactRaidGroup2BorderFrame,
        CompactRaidGroup3BorderFrame,
        CompactRaidGroup4BorderFrame,
        CompactRaidGroup5BorderFrame,
        CompactRaidGroup6BorderFrame,
        CompactRaidGroup7BorderFrame,
        CompactRaidGroup8BorderFrame,
        
        CompactRaidFrameContainerBorderFrameBorderBottom,
        CompactRaidFrameContainerBorderFrameBorderBottomLeft,
        CompactRaidFrameContainerBorderFrameBorderBottomRight,
        CompactRaidFrameContainerBorderFrameBorderLeft,
        CompactRaidFrameContainerBorderFrameBorderRight,
        CompactRaidFrameContainerBorderFrameBorderTop,
        CompactRaidFrameContainerBorderFrameBorderTopLeft,
        CompactRaidFrameContainerBorderFrameBorderTopRight,

        -- �Ŷӿ��
        CompactRaidFrameManagerToggleButton:GetRegions(),
        CompactRaidFrameManagerBg,
        CompactRaidFrameManagerBorderBottom,
        CompactRaidFrameManagerBorderBottomLeft,
        CompactRaidFrameManagerBorderBottomRight,
        CompactRaidFrameManagerBorderRight,
        CompactRaidFrameManagerBorderTopLeft,
        CompactRaidFrameManagerBorderTopRight,
        CompactRaidFrameManagerBorderTop,
		
		-- С��ͼ
        MiniMapBattlefieldBorder,
        MiniMapLFGFrameBorder,
		MinimapBackdrop,
		MinimapBorder,
		MiniMapMailBorder,
		MiniMapTrackingButtonBorder,
		MinimapBorderTop,
		MinimapZoneTextButton,
		MiniMapWorldMapButton,
		MiniMapWorldMapButton,
		MiniMapWorldIcon,
		MinimapZoomIn:GetRegions(),
		select(3, MinimapZoomIn:GetRegions()),
		MinimapZoomOut:GetRegions(),
		select(3, MinimapZoomOut:GetRegions()),
		TimeManagerClockButton:GetRegions(),
		MiniMapWorldMapButton:GetRegions(),
		select(6, GameTimeFrame:GetRegions()),
		
		-- ������
--[[	
       --��������ʾ�ھ������Ĳ���	
		ReputationXPBarTexture0,
		ReputationXPBarTexture1,
		ReputationXPBarTexture2,
		ReputationXPBarTexture3,
]]		
		MainMenuBarTexture0,
		MainMenuBarTexture1,
		MainMenuBarTexture2,
		MainMenuBarTexture3,
		MainMenuXPBarTextureRightCap,
		MainMenuXPBarTextureMid,
		MainMenuXPBarTextureLeftCap,
		ActionBarUpButton:GetRegions(),
		ActionBarDownButton:GetRegions(),
 --[[      
        --������
        ReputationWatchBarTexture0,
        ReputationWatchBarTexture1,
        ReputationWatchBarTexture2,
        ReputationWatchBarTexture3,
  ]]      		
		-- ������
		MainMenuXPBarDiv1,
		MainMenuXPBarDiv2,
		MainMenuXPBarDiv3,
		MainMenuXPBarDiv4,
		MainMenuXPBarDiv5,
		MainMenuXPBarDiv6,
		MainMenuXPBarDiv7,
		MainMenuXPBarDiv8,
		MainMenuXPBarDiv9,
		MainMenuXPBarDiv10,
		MainMenuXPBarDiv11,
		MainMenuXPBarDiv12,
		MainMenuXPBarDiv13,
		MainMenuXPBarDiv14,
		MainMenuXPBarDiv15,
		MainMenuXPBarDiv16,
		MainMenuXPBarDiv17,
		MainMenuXPBarDiv18,
		MainMenuXPBarDiv19,
		
		-- ���찴ť
		select(2, FriendsMicroButton:GetRegions()),
		ChatFrameMenuButton:GetRegions(),
		ChatFrame1ButtonFrameUpButton:GetRegions(),
		ChatFrame1ButtonFrameDownButton:GetRegions(),
		select(2, ChatFrame1ButtonFrameBottomButton:GetRegions()),
		ChatFrame2ButtonFrameUpButton:GetRegions(),
		ChatFrame2ButtonFrameDownButton:GetRegions(),
		select(2, ChatFrame2ButtonFrameBottomButton:GetRegions()),
		
		-- ����
		select(2,CastingBarFrame:GetRegions()),
		select(2,MirrorTimer1:GetRegions()),
		CastingBarFrameBorder,
		FocusFrameSpellBarBorder,
		TargetFrameSpellBarBorder,
        
	}
	
--	��������ɫ
	-------------------------
	if class then
		local classcolor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
		topcolor.r, topcolor.g, topcolor.b = (classcolor.r * 1.2), (classcolor.g * 1.2), (classcolor.b * 1.2)
	end

--	ͼ�湦��
	--------------
	local paint = function(object)
		object:SetDesaturated(1)
			if gradient then
				object:SetGradientAlpha("VERTICAL", bottomcolor.r, bottomcolor.g, bottomcolor.b, bottomalpha, topcolor.r, topcolor.g, topcolor.b, topalpha)
			else
				object:SetVertexColor(topcolor.r, topcolor.g, topcolor.b, topalpha)
			end
	end

--	ִ��!
	--------
	local exec = function()
		for i,v in pairs(objects) do
			if v:GetObjectType() == "Texture" then
				paint(v)
			end
		end
	end
	exec()

--	����
	-------------
	-- ������ť�ϵ�����
	select(5, GameTimeFrame:GetRegions()):SetVertexColor(1, 1, 1)
	
	-- ��ӢĿ������ı����޸�
	hooksecurefunc("TargetFrame_CheckClassification", function(self)
		self.borderTexture:SetDesaturated(1);
	end);

	
	-- ʨ�ղ���ˮƷ�ݶ� <3
	if gradient then
		MainMenuBarLeftEndCap:SetGradientAlpha("HORIZONTAL", bottomcolor.r, bottomcolor.g, bottomcolor.b, bottomalpha, topcolor.r, topcolor.g, topcolor.b, topalpha)
		MainMenuBarRightEndCap:SetGradientAlpha("HORIZONTAL", topcolor.r, topcolor.g, topcolor.b, topalpha, bottomcolor.r, bottomcolor.g, bottomcolor.b, bottomalpha)
	else
		MainMenuBarLeftEndCap:SetVertexColor(topcolor.r, topcolor.g, topcolor.b, topalpha)
		MainMenuBarRightEndCap:SetVertexColor(topcolor.r, topcolor.g, topcolor.b, topalpha)
	end
	
	-- ��Ϸ������ʾ
	TOOLTIP_DEFAULT_COLOR = { r = topcolor.r * 0.7, g = topcolor.g * 0.7, b = topcolor.b * 0.7 };
	TOOLTIP_DEFAULT_BACKGROUND_COLOR = { r = bottomcolor.r * 0.2, g = bottomcolor.g * 0.2, b = bottomcolor.b * 0.2};
	
	-- ͨ������ÿ������ɫ���ý���Alpha
	select(5,ShardBarFrameShard1:GetRegions()):SetVertexColor(topcolor.r, topcolor.g, topcolor.b, topalpha)
	select(5,ShardBarFrameShard2:GetRegions()):SetVertexColor(topcolor.r, topcolor.g, topcolor.b, topalpha)
	select(5,ShardBarFrameShard3:GetRegions()):SetVertexColor(topcolor.r, topcolor.g, topcolor.b, topalpha)