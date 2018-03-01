--/TODO\--
--Fix a bug when listener catches a word from whole sentence and triggers the event.
--math.random crashed out with array after exceeding length. functions must to be redone asap.
--dodgy afk module. announcer needs to be fixed asap

--FUNCTIONS TO DO--
--!boss 1-12  - basically explanaitions for each boss in icecrown citadel
--!group - invites to group and stays for infinite time till request author leaves the group.
--!teleport - well this ones tricky but basically invites to group and spawns a teleport to any selected destination
--!raid section must be reworked so it would only answer to the Raid Leader calls, and ignore others.



----------------------------------------

--!sex answer variables. for guild perverts.--
local SexJokeTable = {
 "Yes please!",
 "Prepare your rim job skills.",
 "Only for 50g a minute I will leave you breathless. and Poor too.",
 "Sex? With you? /lol",
 "Don't make me laugh.",
 "Go get some gear first.",
 "No way!",
 "I'm just a bot you pervert."
 }
--Announce variables--
local AnnounceTable = {
"Remember to update your guild note with Gearscore, Role(Tank,healer,or DPS) and Timezone! Professions are optional",
"All upcoming raids are registered within calendar! Raid time is always server time! Sign up!",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
"10",
}

local WHOLE_MSG_TRIGGERS = { -- These will only match the whole message
	"invite",
	"ginvite",
	
	
}

local ipairs = ipairs
local strmatch = string.match
--Initialize function frames
local f = CreateFrame("Frame");
local MyFilterAddon = CreateFrame("Frame");

-- auto inviter. not finished, as missing either passleadoncommand thing, or atleast auto-pass after accept invitation
REPLYINVITER_ENABLED = true -- Hopefully this will be overwritten with the saved value when ADDON_LOADED fires

for i, trigger in ipairs(WHOLE_MSG_TRIGGERS) do
	WHOLE_MSG_TRIGGERS[i] = "^" .. trigger .. "$"
end

local function isMatch(msg)
	for _, trigger in ipairs(WHOLE_MSG_TRIGGERS) do
		if strfind(msg, trigger) then
			return true
		end
	end
		
	return false
end

local function Partyfilter(self, event, arg1, msg, author, ...)
	if isMatch(msg:trim()) then
		InviteUnit(author)
		if VERBOSE then
			print(("ReplyInviter: Invited %s to the group."):format(author))
		end
	end
end
local function GuildChatFilter(self, event, arg1, msg, author,...)
	if arg1:match("!time") then
		hour,minute = GetGameTime();
		SendChatMessage("The server time is " .. hour .. ":" .. minute .. " GMT on Icecrown realm.", "GUILD", "common", author);
	end
	if arg1:match("!date") then
		SendChatMessage("The date is " .. date("%d/%m/%y %H:%M:%S"), "GUILD", "common", author);
	end
-- For test purposes
	if arg1:match("!ping") then
		SendChatMessage("pong!", "GUILD", "common", author);
	end
		if arg1:match("!hi") then
		SendChatMessage("Hey there!", "GUILD", "common", author);
	end
	if arg1:match("good bot") then
		SendChatMessage("Thank you :3", "GUILD", "common", author);
	end
-- debug end --
	if arg1:match("!help") then
		SendChatMessage("All available commands (starts with !) : time, date, ping, sex .", "GUILD", "common", author);
	end
	if arg1:match("!sex") then
		local result = {}
			for i=1,1 do -- N here, e.g 3 if you want 3 elements
				result[i] = table.remove(SexJokeTable,math.random(#SexJokeTable))
			end
		SendChatMessage(table.concat(result,", "), "GUILD", "common", author);
	end
end

--Raid helper.
local function RaidChatFilter(self, event, arg1, arg2, msg, author,...)
	if arg1:match("!raidrules") then
		SendChatMessage("1. No flaming.", "RAID", "common", author);
	    SendChatMessage("2. Don't be toxic.", "RAID", "common", author);
		SendChatMessage("3. Wipes happen. don't ragequit immediatelly.", "RAID", "common", author);
		SendChatMessage("4. Rolls going over priority, MS>OS>VENDOR/Disenchant", "RAID", "common", author);
	    SendChatMessage("Have fun!", "RAID", "common", author);
	end
end

f:SetScript("OnUpdate",f.onUpdate)

function MyFilterAddon:PLAYER_LOGIN()
  ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", GuildChatFilter)
  ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", Partyfilter)
print("Guild chat is hooked.");
  ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", RaidChatFilter)
print("Raid chat is hooked.");
print("GuildMonitor v0.1-alpha loaded. type !help for list of commands.");
end

MyFilterAddon:RegisterEvent'PLAYER_LOGIN'

MyFilterAddon:SetScript('OnEvent', function(self, event, ...)
  return self[event](self, event )
end)
SLASH_REPLYINVITER1, SLASH_REPLYINVITER2 = "/replyinviter", "/ri"

SlashCmdList.REPLYINVITER = function(input)
	if REPLYINVITER_ENABLED then
		REPLYINVITER_ENABLED = false
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", filter)
		print("ReplyInviter: Disabled")
	else
		REPLYINVITER_ENABLED = true
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
		print("ReplyInviter: Enabled")
	end
end