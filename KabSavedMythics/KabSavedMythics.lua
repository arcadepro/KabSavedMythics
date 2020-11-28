local saved = {}
local report = {}
local dungeons = {}
-- local d1 = false
-- local d2 = false

--[[ local function isAttunedKingsRest()
-- id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy = GetAchievementInfo(12479)
	local _, _, _, achievementFlag, _, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(12479)
	return achievementFlag
end

local function isAttunedBoralus()
	return IsQuestFlaggedCompleted(53121)
end --]]

local function buildList()
	dungeons = {
	"De Other Side",
	"Halls of Atonement",
	"Mists of Tirna Scithe",
	"Plaguefall",
	"Sanguine Depths",
	"Spires of Ascension",
	"The Necrotic Wake",
	"Theater of Pain"
	}

--[[ 	if isAttunedKingsRest() then
		--print("not attuned")
		tinsert(dungeons,"Kings' Rest")
		d1 = true
	end

	if isAttunedBoralus() then
		--print("not attuned")
		tinsert(dungeons,"Siege of Boralus")
		d2 = true
	end --]]

	table.sort(dungeons)
end

local abbr = {
	["De Other Side"] = "Other Side",
	["Halls of Atonement"] = "Halls",
	["Mists of Tirna Scithe"] = "Mists",
	["Plaguefall"] = "Plaguefall",
	["Sanguine Depths"] = "Sanguine",
	["Spires of Ascension"] = "Spires",
	["The Necrotic Wake"] = "Necrotic Wake",
	["Theater of Pain"] = "Theater"
}

local function inRaid()
	return IsInRaid()
end

local function inParty()
	return IsInGroup()
end

local function clearTables()
	wipe(saved)
	wipe(report)
	wipe(dungeons)
end

local function gatherInfo()
	clearTables()
	buildList()
	for i = 1, GetNumSavedInstances() do
		local name, _ , _ , difficulty, locked = GetSavedInstanceInfo(i)
		if difficulty == 23 then -- 23mythic, 2heroic
			saved[name] = locked
		end
	end
end

local function tabulate()
	for _, v in pairs(dungeons) do
		if saved[v] == false or saved[v] == nil then
			--print(abbr[v])
			table.insert (report, abbr[v])
		end
	end
	table.sort(report)
	output = table.concat (report,", ")
end

local function reportInfo(var)
-- self
	if var == "self" then
		gatherInfo()
		print("---")
		print("\124cff00ff00Mythic Lockouts")
		print("---")
		for _, v in pairs(dungeons) do
			print(v, saved[v] and "\124cffff0000Saved" or "\124cff00ff00Available")
		end
--[[ 		local a1, a2
		if d1 == false then a1 = "Kings' Rest" else a1 = "" end
		if d2 == false then a2 = "Boralus" else a2 = "" end
		if d1 and d2 then return else print ("\124cffff0000Not attuned to:", a1, a2) end --]]
	end
-- party
	if var == "party" then
		gatherInfo()
		tabulate()
		SendChatMessage("Unsaved to: " .. output, "PARTY", nil, nil)
	end
-- guild
	if var == "guild" then
		gatherInfo()
		tabulate()
		SendChatMessage("Unsaved to: " .. output, "GUILD", nil, nil)
	end
-- custom
	if var == "custom" then
		gatherInfo()
		tabulate()
		if inParty() and not inRaid() then
			SendChatMessage("Unsaved to: " .. output, "PARTY", nil, nil)
		elseif inRaid() then
			SendChatMessage("Unsaved to: " .. output, "RAID", nil, nil)
		else
			SendChatMessage("Unsaved to: " .. output, "GUILD", nil, nil)
		end
	end
end

SlashCmdList["SELFREPORT"] = function()
	--print("self")
	reportInfo("self")
end
SLASH_SELFREPORT1 = '/sm' -- solo report

SlashCmdList["CUSTOMREPORT"] = function()
	--print("custom")
	reportInfo("custom")
end
SLASH_CUSTOMREPORT1 = '/smr' -- intelligent report

SlashCmdList["GUILDREPORT"] = function()
	--print("guild")
	reportInfo("guild")
end
SLASH_GUILDREPORT1 = '/smg' -- guild report

SlashCmdList["PARTYREPORT"] = function()
	--print("party")
	reportInfo("party")
end
SLASH_PARTYREPORT1 = '/smp' -- party report
