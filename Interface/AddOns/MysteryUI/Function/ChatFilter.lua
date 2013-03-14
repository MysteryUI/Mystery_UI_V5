
----------------------------------------------------
--1级小号屏蔽(从蘑菇整合包中提取)
--配置保存功能删除了,关不掉
--如果有其他聊天屏蔽类插件,可能会冲突把第一句话给屏蔽了,
----------------------------------------------
if not MuDelayCall then
	local Mudelaycalls = {}
	function MuDelayCall(fun1,arg1,fun2,arg2)
		local calls ={
			["fun1"] = fun1,
			["arg1"] = arg1,
			["fun2"] = fun2,
			["arg2"] = arg2,
			["start"] = GetTime(),
		}
		table.insert(Mudelaycalls,calls)
	end
	local delayframe= CreateFrame'Frame'
	delayframe:SetScript("OnUpdate",function(self,elapsed)
		for i=#Mudelaycalls,1,-1 do
			local t=Mudelaycalls[i]
			if type(t.fun2) == "number" and GetTime() - t.start >= t.fun2 or type(t.fun2) == "function" and t.fun2(t.arg2 and unpack(t.arg2)) then
				pcall(t.fun1,unpack(t.arg1))
				table.remove(Mudelaycalls,i)
			end
		end
	end)

end

local db = {
	whisper =false,
}
--[[ local f=CreateFrame'Frame'
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent",function()
	ChatFilterDB = ChatFilterDB or{}
	db = ChatFilterDB
end) ]]
local BADBOY_LEVEL= 10 --10级小号
local good, maybe, badboy, filterTable, login = {}, {}, CreateFrame("Frame", "Levels"), {}, nil
local whisp = "Levels: You need to be level %d to whisper me."
local err = "You have reached the maximum amount of friends, remove 2 for this addon to function properly!"

do
	local L = GetLocale()
	if L == "esES" or L == "esMX" then
		whisp = "Levels: Necesitas ser nivel %d para susurrarme."
		err = "Has llegado a la cantidad máxima de amigos, quita 2 amigos para que este addon funcione propiamente."
	elseif L == "zhTW" then
		whisp = "Levels: 你起碼要達到 %d 級才能密我。"
		err = "你的好友列表滿了，此插件需要你騰出2個好友空位!"
	elseif L == "zhCN" then
		whisp = "Levels: 你起码要达到 %d 级才能和我讲话"
		err = "你的好友列表满了，此插件模块需要你腾出2个好友空位!"
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(_,_,msg)
	if not db or db.whisper then
		return
	end
	if msg == ERR_FRIEND_LIST_FULL then
		print("|cFF33FF99Levels|r: ", err) --print a warning if we see a friends full message
		return
	end
	--this is a filter to remove the player added/removed from friends messages when we use it, otherwise they are left alone
	for k in pairs(filterTable) do
		if msg == (ERR_FRIEND_ADDED_S):format(k) or msg == (ERR_FRIEND_REMOVED_S):format(k) then
			return true
		end
	end
	if login~=2 and (msg:find(ERR_FRIEND_ADDED_S:sub(3)) or msg:find(ERR_FRIEND_REMOVED_S:sub(3))) then
		return true
	end
end)
local friendcatch-- = {}
badboy:RegisterEvent("PLAYER_LOGIN")
badboy:RegisterEvent("FRIENDLIST_UPDATE")

badboy:SetScript("OnEvent", function(_, evt,...)
	if evt == "PLAYER_LOGIN" then
		ShowFriends() --force a friends list update on login
		good[UnitName("player")] = true --add ourself to safe list
		--variable health check
		friendcatch = db.friendcatch or {}
		db.friendcatch = friendcatch
		if BADBOY_LEVEL and type(BADBOY_LEVEL) ~= "number" then BADBOY_LEVEL = nil end
		if BADBOY_LEVEL and BADBOY_LEVEL < 1 then BADBOY_LEVEL = nil end
	else
		if not db or db.whisper then
			return
		end
		if not login then --run on login only
			login = true
			local num = GetNumFriends()
			for i = 1, num do
				local n = GetFriendInfo(i)
				--add friends to safe list
				if n then good[n] = true end
			end
			MuDelayCall(function()login=2 end,{},2)
			MuDelayCall(function()
				for n in pairs(friendcatch) do
					if not filterTable[n] then
						friendcatch[n]=nil
					end
				end
			end
			,{},5)
			return
		end

		local num = GetNumFriends() --get total friends
		for i =  num,1,-1 do
			local player, level = GetFriendInfo(i)
			--sometimes a friend will return nil, I have no idea why, so force another update
			if not player then
				ShowFriends()
			else
				if maybe[player] then --do we need to process this person?
					RemoveFriend(player, true) --Remove player from friends list, the 2nd arg "true" is a fake arg added by request of tekkub, author of FriendsWithBenefits
					if type(level) ~= "number" then print("Level wasn't a number, tell BadBoy author! It was:", level) end
					if level < (filterTable[player] or (BADBOY_LEVEL + 1)) then
						--lower than level 2, or a level defined by the user = bad,
						--or lower than 58 and class is a Death Knight,
						--so whisper the bad player what level they must be to whisper us
					--	SendChatMessage(whisp:format(filterTable[player]), "WHISPER", nil, player)--11
						for _, v in pairs(maybe[player]) do
							for _, p in pairs(v) do
								wipe(p) --remove player data table
							end
							wipe(v) --remove player data table
						end
					else
						good[player] = true --higher = good
						--get all the frames, incase whispers are being recieved in more that one chat frame
						for _, v in pairs(maybe[player]) do
							--get all the chat lines (queued if multiple) for restoration back to the chat frame
							for _, p in pairs(v) do
								--this player is good, we must restore the whisper(s) back to chat
								if type(p[1])=="string" and _G[p[1]] then
									p[1] = _G[p[1]]
									if IsAddOnLoaded("WIM") then --WIM compat
										WIM.modules.WhisperEngine:CHAT_MSG_WHISPER(unpack(p))
									elseif type(p[9])=="number" then
										dbrepeak = db.repeak
										db.repeak = false
										ChatFrame_MessageEventHandler(unpack(p))
										db.repeak = dbrepeak
									end
								end
								wipe(p) --remove player data table
							end
							wipe(v) --remove player data table
						end
					end
					wipe(maybe[player]) --remove player data table
					maybe[player] = nil --remove remaining empty table
					friendcatch[player] = nil
					if next(friendcatch,nil)==nil then
						FriendsFrame:RegisterEvent("FRIENDLIST_UPDATE")
					end
				elseif friendcatch[player] then
					filterTable[player]  = BADBOY_LEVEL + 1
					RemoveFriend(player, true)
					friendcatch[player] = nil
				end
			end
		end
	end
end)

--incoming whisper filtering function
local function filter(...)
	if not db or db.whisper then
		return
	end
	--don't filter if good, GM, guild member, or x-server
	local player = select(4, ...)
	if UnitIsInMyGuild(player) or good[player] or player:find("%-") then return end
	local flag = select(8, ...)
	if flag == "GM" then return end

	--RealID support, don't scan people that whisper us via their character instead of RealID
	--that aren't on our friends list, but are on our RealID list.
	for i=1, select(2, BNGetNumFriends()) do
		local toon = BNGetNumFriendToons(i)
		for j=1, toon do
			local _, rName, rGame, rServer = BNGetFriendToonInfo(i, j)
			if rName == player and rGame == "WoW" and rServer == GetRealmName() then
				good[player] = true
				return
			end
		end
	end

	if not maybe[player] then maybe[player] = {} end --added to maybe
	local f = ...
	f = f:GetName()
	if IsAddOnLoaded("WIM") and not f:find("WIM") then return true end --WIM compat
	--one table per chatframe, incase we got whispers on 2+ chatframes
	if not maybe[player][f] then maybe[player][f] = {} end
	--one table per id, incase we got more than one whisper from a player whilst still processing
	local id = select(13, ...)
	maybe[player][f][id] = {}
	local n = IsAddOnLoaded("WIM") and 2 or 0 --WIM compat
	for i = 2, select("#", ...) do
		--store all the chat arguments incase we need to add it back (if it's a new good guy)
		maybe[player][f][id][i] = select(i+n, ...)
	end
	maybe[player][f][id][1] = f
	--Decide the level to be filtered
	local guid = select(14, ...)
	--local _, englishClass = GetPlayerInfoByGUID(guid)
	local level = BADBOY_LEVEL and tonumber(BADBOY_LEVEL)+1 or 2
	--if englishClass == "DEATHKNIGHT" then level = 58 end
	--Don't try to add a player to friends several times for 1 whisper (registered to more than 1 chat frame)
	if not filterTable[player] or filterTable[player] ~= level then
		filterTable[player] = level
		FriendsFrame:UnregisterEvent("FRIENDLIST_UPDATE")
		AddFriend(player, true) --add player to friends, the 2nd arg "true" is a fake arg added by request of tekkub, author of FriendsWithBenefits
		friendcatch[player] = true
	end
	if type(select(9,...))~="number" then --组队转发产生的第九个参数不是数字,会引起报错,并且发言者不一定是1级但是被转发者可能是1级.需要另外考虑
		--print(1,select(1,...),2,select(2,...),3,select(3,...),4,select(4,...),5,select(5,...),6,select(6,...),7,select(7,...),8,select(8,...),9,select(9,...),10,select(10,...))
		return
	end
	return true --filter everything not good (maybe) and not GM
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL",filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL",filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY",filter)