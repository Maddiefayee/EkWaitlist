--[[
--
--  EkWaitList 5.01
--
--  Refer to index.html for documentation and complete change history.
--
--  Author: Dargen of Eternal Keggers, Terenas.
--          http://www.eternalkeggers.net
--
--  Addons: http://www.wowinterface.com/portal.php?uid=25131
--          http://my.curse.com/dargen/projects/
--
--]]

-- ------
-- Saved variables
-- ------

-- Saved variables in version 1.0
EkWaitList_FirstRun = nil;  -- nil==First time the addon has been run, 0==Not the first time.
EkWaitList_MovableWindow = 0;   -- 0==Window not movable, 1==Movable
EkWaitList_WaitList = {};  -- Holds the wait list data
EkWaitList_InRaidFlag = nil;   -- nil==Not in a raid, 1==In a raid
EkWaitList_ShowRank = 0;

EkWaitList_Whispers_wlCommands = 0;   -- Wait list whispers: 0=Disable, 1=Enable
EkWaitList_Whispers_wlIncoming = 1;   -- Display incoming wait list whisper commands: 0=No, 1=Yes
EkWaitList_Whispers_wlOutgoing = 0;   -- Display outgoing wait list whisper commands: 0=No, 1=Yes
EkWaitList_Whispers_wlConfig = {};  -- Wait list configuration array (which commands you've enabled, etc).
EkWaitList_Whispers_wlNonGuild = 1;  -- Allow non-guild members to use waitlist whisper commands: 0=No, 1=Yes

EkWaitList_MainNameUse = 1;  -- Use main character names in guild notes (0==No, 1==Yes)
EkWaitList_MainNameNote = 1;  -- Main character name is stored in: 1==Public note, 2==Officer note
EkWaitList_MainNameStart = "[";  -- Character(s) used to start the main character name (0 or more characters).
EkWaitList_MainNameEnd = "]";  -- Character(s) used to end the main character name (0 or more characters).

EkWaitList_SendWaitListTo = "";  -- Name of person to send the wait list to.

-- Saved variables in version 1.1
EkWaitList_RemoveUponJoin = 1;  -- 1==Automatically remove player from waitlist when they join the raid, 0==No automatic removal.
EkWaitList_AnnounceChannel = "";  -- Name of channel to announce the wait list over.

-- Saved variables in version 1.30
EkWaitList_ShowTooltips = 1;  -- 1==Show detailed tooltips, 0=Don't.
EkWaitList_ShowAtCursor = 0;  -- 1==Show detailed tooltips by the mouse pointer, 0==Show at default location (lower right corner of screen).
EkWaitList_ShowWaitTime = 0;  -- 1==Show wait time, 0==Show added time.

-- ------
-- Variables not saved.
-- ------
EkWaitList_Version = "5.01";

EkWaitList_Slash1 = "/ekwl";
EkWaitList_Slash2 = "/ekwaitlist";

EkWaitList_AddonName = "<EkWaitList>";  -- Used in whispers and at start of messages in chat frame.

EkWaitList_VarsLoaded = false;
EkWaitList_Test = 0;  -- 0==Normal mode, 1=Test mode.
EkWaitList_LastWhisper = nil;  -- Name of person who last whispered the player

EkWaitList_GuildInfo = {};
EkWaitList_GuildRosterFlag = nil;
EkWaitList_GuildRosterUpdates = 0;

EkWaitList_Whisper_Queue = {};  -- List of whispers that need to be sent
EkWaitList_Whisper_Queue_Timer = nil;  -- Countdown timer until next whisper is sent.
EkWaitList_Whisper_Queue_Interval = 0.03;   -- Time between sending whispers (seconds).

EkWaitList_SentList_WaitList = nil;   -- Temprarily holds wait list sent to us by another person.
EkWaitList_SentList_From = nil;  -- Name of person who sent us the wait list in EkWaitList_SentList_WaitList.
EkWaitList_SentList_Timer = nil;  -- Timeout countdown timer used when receiving WD messages.
EkWaitList_SentList_TimerDefault = 8;  -- Timeout countdown timer used when receiving WD messages.
EkWaitList_SentList_Count = 0;  -- Used to count number of WD messages still remaining to be read.

EkWaitList_DefPromptDelay = 1;  -- Default delay between prompt windows
EkWaitList_PromptTimer = nil;  -- nil==No prompt timer, not nil==Prompt frame time remaining.
EkWaitList_PromptDelay = nil;  -- nil==No delay, not nil==Delay between prompt frames
EkWaitList_ShowPrompts = {};  -- element is 1 if we want to show the user the prompt, else nil.
EkWaitList_DisabledRaidPrompts = {};   -- element is 1 if user has disabled prompt for remainder of this raid, else nil.

-- Keys for the _ShowPrompts[] and _DisabledRaidPrompts[] tables.
EkWaitList_PROMPT_WAITLIST_JOIN = "wl";  -- Prompt to clear wait list when joining raid
EkWaitList_PROMPT_WAITLIST_SENT = "wd";  -- Prompt to use the wait list that was sent to you

EkWaitList_PromptKeys = {
	EkWaitList_PROMPT_WAITLIST_JOIN,
	EkWaitList_PROMPT_WAITLIST_SENT,
};

EkWaitList_Whispers_command = "wl";  -- The main wait list whisper command, which is followed by these...
EkWaitList_Whispers_waitlist = {
	["help"] = { ["enabled"] = 1, ["keyword"] = EkWaitList_TEXT_Whisper_Help },
	["who"] = { ["enabled"] = 1, ["keyword"] = EkWaitList_TEXT_Whisper_Who },
	["add"] = { ["enabled"] = 1, ["keyword"] = EkWaitList_TEXT_Whisper_Add },
	["main"] = { ["enabled"] = 1, ["keyword"] = EkWaitList_TEXT_Whisper_Main },
	["remove"] = { ["enabled"] = 1, ["keyword"] = EkWaitList_TEXT_Whisper_Remove },
	["comment"] = { ["enabled"] = 1, ["keyword"] = EkWaitList_TEXT_Whisper_Comment },
};

-- The announce command's allowed channels.
EkWaitList_Who_Channels = {
	{channel = "guild", keywords = EkWaitList_TEXT_Channel_Guild},
	{channel = "officer", keywords = EkWaitList_TEXT_Channel_Officer},
	{channel = "party", keywords = EkWaitList_TEXT_Channel_Party},
	{channel = "raid", keywords = EkWaitList_TEXT_Channel_Raid},
	{channel = "say", keywords = EkWaitList_TEXT_Channel_Say},
	{channel = "yell", keywords = EkWaitList_TEXT_Channel_Yell},
	{channel = "reply", keywords = EkWaitList_TEXT_Channel_Reply},
};

-- Array containing 3-element arrays: [1]==Name, [2]==Attendance % (0-100), [3]==Position in % list (1-n).
EkWaitList_PercentData = nil;

-- The "unknown" class must be the first item in this array.
-- Avoid changing the 'id' numbers. They are used when sending waitlist data between players.
-- The 'type' values are the unlocalized class names (all uppercase) (do not change).
-- The 'name' values are the localized class names (mixed case).
-- The 'id' numbers DO NOT correspond to the index values for EkWaitList_EditFrame_ClassDropDown_List.
EkWaitList_ClassList = {
	{id= 1, type="UNKNOWN",      name=EkWaitList_TEXT_Class_Unknown},
	{id= 2, type="DRUID",        name=EkWaitList_TEXT_Class_Druid},
	{id= 3, type="HUNTER",       name=EkWaitList_TEXT_Class_Hunter},
	{id= 4, type="MAGE",         name=EkWaitList_TEXT_Class_Mage},
	{id= 5, type="PALADIN",      name=EkWaitList_TEXT_Class_Paladin},
	{id= 6, type="PRIEST",       name=EkWaitList_TEXT_Class_Priest},
	{id= 7, type="ROGUE",        name=EkWaitList_TEXT_Class_Rogue},
	{id= 8, type="SHAMAN",       name=EkWaitList_TEXT_Class_Shaman},
	{id= 9, type="WARLOCK",      name=EkWaitList_TEXT_Class_Warlock},
	{id=10, type="WARRIOR",      name=EkWaitList_TEXT_Class_Warrior},
	{id=11, type="DEATHKNIGHT",  name=EkWaitList_TEXT_Class_DeathKnight},
	{id=12, type="MONK",         name=EkWaitList_TEXT_Class_Monk},
};

-- EkCheck configuration for this addon.
EkWaitList_EkCheck_Config = {
	addonName = "EkWaitList",
	funcPrefix = "EkWaitList_EkCheck_",
	defaultColumn = 11,
	columns = {
		{ heading=EkWaitList_TEXT_EkCheck_Version, width=60, show=11, sort=11, order="A", justify="CENTER", red=nil, green=nil, blue=nil },
	},
};

-- ----------
-- Blizzard addon code called from this addon:
--
--   ChatFrame.lua:
--     - ChatFrame_MessageEventHandler
--     - ChatFrame_OpenChat
--     - ChatEdit_ParseText
--
--   GameTooltip.lua:
--     - GameTooltip_AddNewbieTip
--
--   UIDropDownMenu.lua:
--     - UIDropDownMenu_AddButton
--     - UIDropDownMenu_Initialize
--     - UIDropDownMenu_SetSelectedID
--     - UIDropDownMenu_SetText
--     - UIDropDownMenu_SetWidth
--
--   UIPanelTemplates.lua:
--     - PanelTemplates_DeselectTab
--     - PanelTemplates_SelectTab
--     - PanelTemplates_SetNumTabs
--     - PanelTemplates_SetTab
--     - PanelTemplates_Tab_OnClick
--     - PanelTemplates_TabResize
--     - PanelTemplates_UpdateTabs
--
--     - FauxScrollFrame_GetOffset
--     - FauxScrollFrame_OnVerticalScroll
--     - FauxScrollFrame_Update
--
--   UIParent.lua:
--     - ShowUIPanel
--     - HideUIPanel
--
--
-- Blizzard addon code which calls this addon:
--
--   UIDropDownMenu.lua:
--     - UIDropDownMenuButton_OnClick
--
--
-- Blizzard variables used by this addon:
--
--   DEFAULT_CHAT_FRAME
--   NORMAL_FONT_COLOR
--   SlashCmdList
--   UISpecialFrames
--
--
-- Blizzard frames used by this addon:
--
--   ChatFrameEditBox
--   UIParent
--   WhoFrameEditBox
--
--
-- EkCheck references:
--
--   EkCheck_RegisterAddon
--
--
-- EkImport references:
--
--   EkImport_Get_Attendance1
--   EkImport_Get_ImportDate
--   EkImport_UIPercent
-- ----------

local MULTIBYTE_CHAR = "([\192-\255]?%a?[\128-\191]*)";

local function strlen_utf8(str)
	-- Get length of string in characters. This may not equal the number of bytes in the string.
	return strlenutf8(str);
end

local function strupper_utf8(str)
	-- Convert string to upper case.

	-- If entire string is composed of 1-byte characters, then use normal function.
	if (strlen_utf8(str) == strlen(str)) then
		return strupper(str);
	end

	return string.gsub(str, MULTIBYTE_CHAR, string.upper);
end

local function strlower_utf8(str)
	-- Convert string to lower case.

	-- If entire string is composed of 1-byte characters, then use normal function.
	if (strlen_utf8(str) == strlen(str)) then
		return strlower(str);
	end

	return string.gsub(str, MULTIBYTE_CHAR, string.lower);
end

local function strsub_utf8(str, startChar, endChar)
	-- Parameters:
	-- 	str -- string.
	-- 	startChar -- starting character position
	--		-- this is not a byte position.
	--		-- if negative, then starting character is counted from right side of string.
	--		-- if zero, then starting character is 1.
	--		-- if greater than number of characters in string, then returns empty string.
	-- 	endChar -- ending character position
	--		-- if nil, then all characters after startChar are returned.
	--		-- if negative, then ending character is counted from right side of string.
	--		-- if less than startChar, then returns empty string.

	local numChars = strlen_utf8(str);
	local numBytes = strlen(str);

	-- If entire string is composed of 1-byte characters, then use normal function.
	if (numChars == numBytes) then
		return strsub(str, startChar, endChar);
	end

	local bytePos = 1;
	local charPos = 1;
	local startByte;

	-- Examine the startChar parameter.
	if (startChar == 0) then
		startChar = 1;
	elseif (startChar < 1) then
		-- Recalculate starting character position from right side of string.
		startChar = numChars + startChar + 1;
		if (startChar < 1) then
			startChar = 1;
		end
	end
	if (startChar > numChars) then
		return "";
	end

	-- Locate the first character
	while (charPos < startChar and bytePos <= numBytes) do
		local char = string.byte(str, bytePos);
		if (char >= 240) then
			bytePos = bytePos + 4;
		elseif (char >= 224) then
			bytePos = bytePos + 3;
		elseif (char >= 192) then
			bytePos = bytePos + 2;
		else 
			bytePos = bytePos + 1;
		end
		charPos = charPos + 1;
	end
	startByte = bytePos;

	-- Examine the endChar parameter.
	if (endChar == nil) then
		return strsub(str, startByte);
	elseif (endChar < 0) then
		-- Recalculate ending character position from right side of string.
		endChar = numChars + endChar + 1;
		if (endChar < 1) then
			endChar = 1;
		end
	end
	if (endChar < startChar) then
		return "";
	end

	-- Extract the requested number of characters.
	while (endChar >= startChar and bytePos <= #str) do
		local char = string.byte(str, bytePos);
		if (char > 240) then
			bytePos = bytePos + 4;
		elseif (char > 224) then
			bytePos = bytePos + 3;
		elseif (char > 192) then
			bytePos = bytePos + 2;
		else 
			bytePos = bytePos + 1;
		end
		endChar = endChar - 1;
	end
	return strsub(str, startByte, bytePos - 1);
end

local function strname_utf8(str)
	-- Capitalize the first character and uncapitalize the rest.

	-- If entire string is composed of 1-byte characters, then use normal function.
	if (strlen_utf8(str) == strlen(str)) then
		return strupper(strsub(str, 1, 1)) .. strlower(strsub(str, 2));
	end

	return strupper_utf8(strsub_utf8(str, 1, 1)) .. strlower_utf8(strsub_utf8(str, 2));
end

function EkWaitList_NormalizeName(name)
	-- ----------
	-- Normalize a character name.
	-- - First character upper case, remainder in lower case.
	-- - 12 characters maximum.
	--
	-- Parameter: name -- Name of character
	--
	-- Returns: a) Normalized name, or "".
	-- ----------
	local valName;

	valName = name;

	-- Remove leading, trailing, and embedded spaces.
	valName = string.match(name, "(%S+)");  -- Match non-space characters

	if (valName and valName ~= "") then
		-- Limit to 12 characters maximum.
		valName = strsub_utf8(valName, 1, 12);
		-- Upper case first letter, lower case the rest
		valName = strname_utf8(valName);
	else
		valName = "";
	end

	return valName;
end

function EkWaitList_GetNumRaidMembers()
	if (IsInRaid()) then
		return GetNumGroupMembers();
	else
		return 0;
	end
end

function EkWaitList_GetNumPartyMembers()
	return GetNumSubgroupMembers();
end

local GetNumRaidMembers = EkWaitList_GetNumRaidMembers;
local GetNumPartyMembers = EkWaitList_GetNumPartyMembers;

function EkWaitList_OnLoad(self)
	-- --------------
	-- Adding is being loaded.
	-- --------------
	SLASH_ekwaitlist1 = EkWaitList_Slash1;
	SLASH_ekwaitlist2 = EkWaitList_Slash2;

	SlashCmdList["ekwaitlist"] = function( msg )
		EkWaitList_Command(msg);
	end

	self:RegisterEvent("CHAT_MSG_WHISPER"); 
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM"); 
	self:RegisterEvent("GUILD_ROSTER_UPDATE");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");
	self:RegisterEvent("GROUP_ROSTER_UPDATE");
	self:RegisterEvent("PLAYER_LOGIN"); 

	for i=1, 9 do
		local mbut = _G["EkWaitList_Frame_MenuButton" .. i];
		if (mbut) then
			mbut:SetFrameLevel(mbut:GetFrameLevel()+2);
		end
	end
end


function EkWaitList_ShowVersion(print2)
	-- --------------
	-- Display current version of the addon.
	-- --------------
	local text = "EkWaitList " .. EkWaitList_Version .. " by Dargen, Eternal Keggers, Terenas."
	if (print2) then
		EkWaitList_Print2(text);
	else
		EkWaitList_Print(text);
	end
end


function EkWaitList_ShowInvalid()
	-- --------------
	-- Display message when an invalid command is supplied.
	-- --------------
	EkWaitList_Print(string.format(EkWaitList_TEXT_Msg_Invalid_Command, EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Help));
end


function EkWaitList_OnEvent(self, event, ...)
	-- --------------
	-- Envent handler.
	-- --------------

	if (event == "PLAYER_LOGIN") then
		if (not EkWaitList_VarsLoaded) then
			EkWaitList_VarsLoaded = true;

			if (EkWaitList_MovableWindow == 1) then
				EkWaitList_Frame_UISpecialFrame(1);
				EkWaitList_Frame_UIPanelSet(0);
				EkWaitList_Frame_MoveButton:Show();
			else
				EkWaitList_Frame_MoveButton:Hide();
				EkWaitList_Frame_UISpecialFrame(0);
				EkWaitList_Frame_UIPanelSet(1);
			end

			-- Initialize the wait list whisper commands.
			EkWaitList_Whisper_WaitList_Config();

			-- If EkImport addon is installed, then get the attendance percentage list.
			if (EkImport_Get_Attendance1) then
				EkWaitList_PercentData = EkImport_Get_Attendance1();
				if (EkWaitList_PercentData) then
					for j=1,#EkWaitList_PercentData do
						EkWaitList_PercentData[j][1] = strlower_utf8(EkWaitList_PercentData[j][1]);
						EkWaitList_PercentData[j][3] = j;  -- Remember position in the % list.
					end
					-- Sort attendance list by name
					sort(EkWaitList_PercentData, function (a, b)
										if (a[1] < b[1]) then
											return true;
										else
											return false;
										end
									end);
					if (EkImport_Get_ImportDate) then
						local date1, date2 = EkImport_Get_ImportDate();
						EkWaitList_WaitFrame_SubTitle:SetText(EkWaitList_TEXT_Msg_Attendance_As_Of .. date2);
					end
				end
			end

			if (not EkWaitList_PercentData) then
				-- No attendance data, so default to showing guild rank instead (in the wait list frame).
				EkWaitList_ShowRank = 1;
			end

			-- Initialize the wait list.
			EkWaitList_WaitFrame_WaitList_Config();
			EkWaitList_WaitFrame_ListInit();

			if (EkWaitList_FirstRun == nil) then
				EkWaitList_Print(EkWaitList_TEXT_Msg_First_Run);
				EkWaitList_ShowVersion();
				EkWaitList_Print(string.format(EkWaitList_TEXT_Msg_To_Open_Window, EkWaitList_Slash1, EkWaitList_Slash2));
				EkWaitList_FirstRun = 0;
			end

			-- Request an updated guild roster.
			if (IsInGuild()) then
				EkWaitList_GuildRoster();
			end

			if (EkCheck_RegisterAddon) then
				EkCheck_RegisterAddon(EkWaitList_EkCheck_Config);
			end
		end
		return;
	end

	if (not EkWaitList_VarsLoaded) then
		return;
	end

	if (event == "GUILD_ROSTER_UPDATE") then
		-- ----
		-- Guild roster updates.
		-- ----
		if (EkWaitList_GuildRosterUpdates > 0) then
			-- This is an update event that resulted from calls to EkWaitList_SetGuildRosterShowOffline().
			EkWaitList_GuildRosterUpdates = EkWaitList_GuildRosterUpdates - 1;
			if (EkWaitList_GuildRosterUpdates <= 0) then
				EkWaitList_GuildRosterUpdates = 0;
			end
		else
			-- Unexpected or GuildRoster() guild roster update event. Set a flag so we can deal with
			-- it the next time we need to access the guild info array.
			EkWaitList_GuildRosterFlag = 1;
		end

	elseif (event == "GROUP_ROSTER_UPDATE") then
		-- ----
		-- Test for raid changes.
		-- ----

		-- If people in the wait list are also in the party/raid, then remove them from the wait list.
		if (EkWaitList_RemoveUponJoin == 1) then
			EkWaitList_WaitFrame_RemoveMembers();
		end

	elseif ( event == "CHAT_MSG_WHISPER" ) then
		-- ----
		-- Check for a wait list whisper command.
		-- ----
		local text, player = ...;

		if (EkWaitList_Whispers_wlCommands == 1) then

			-- Test for the wait list command...
			local pos1, pos2, cmd, rest = string.find(text, "^%s-(%S+)(.*)");
			if (cmd and strlower(cmd) == EkWaitList_Whispers_command) then

				-- Test for the whisper command...
				pos1, pos2, cmd, rest = string.find(rest, "^%s-(%S+)(.*)");
				if (not cmd) then
					cmd = "";
				end

				for k, v in pairs(EkWaitList_Whispers_waitlist) do
					if (v["enabled"] == 1 and v["keyword"] == strlower(cmd)) then
						if (k == "help") then
							EkWaitList_Whisper_WaitList_Commands(player);
							return;

						elseif (k == "who") then
							EkWaitList_Whisper_WaitList_Who(player);
							return;

						elseif (k == "add") then
							local addName;
							pos1, pos2, addName = string.find(rest, "^%s-(%S+).*");

							EkWaitList_Whisper_WaitList_Add(player, addName);
							return;

						elseif (k == "main") then
							EkWaitList_Whisper_WaitList_Main(player);
							return;

						elseif (k == "remove") then
							EkWaitList_Whisper_WaitList_Remove(player);
							return;

						elseif (k == "comment") then
							local comment;
							pos1, pos2, comment = string.find(rest, "^%s-(.*)");

							EkWaitList_Whisper_WaitList_Comment(player, comment);
							return;
						end
					end
				end
			end
		end

		-- -----
		-- Test for incoming wait list data.
		-- -----
		local pos1, pos2, cmd, msg = string.find(text, "^" .. EkWaitList_AddonName .. " %*(%u+)%* (.*)$");
		if (cmd and msg) then
			-- Incoming data message.
			EkWaitList_Whisper_SentList_Receive_Msg(player, cmd, msg);
			return;
		end

		-- The whisper is not EkWaitList related.
		EkWaitList_LastWhisper = player;  -- Remember name of the last player to whisper us.
	end
end


-- Hook
EkWaitList_oldChatFrame_MessageEventHandler = ChatFrame_MessageEventHandler;
function EkWaitList_newChatFrame_MessageEventHandler(self, event, ...)
	-- ----------
	-- Handle chat frame events.
	-- ----------

	if (event == "CHAT_MSG_WHISPER") then
		-- Prevent incoming wait list whispers from appearing in the chat frame.
		local text = ...;
		if (EkWaitList_Whispers_wlCommands == 1 and EkWaitList_Whispers_wlIncoming == 0) then

			-- Test for the wait list command...
			local pos1, pos2, cmd, rest = string.find(text, "^%s-(%S+)(.*)");
			if (cmd and strlower(cmd) == EkWaitList_Whispers_command) then

				-- Test for the whisper command...
				pos1, pos2, cmd, rest = string.find(rest, "^%s-(%S+)(.*)");
				if (not cmd) then
					cmd = "";
				end

				for k, v in pairs(EkWaitList_Whispers_waitlist) do
					if (v["keyword"] == strlower(cmd)) then
						return;
					end
				end
			end
		end

		-- Prevent incoming wait list data from appearing in the chat frame.
		local pos1, pos2, cmd, msg = string.find(text, "^" .. EkWaitList_AddonName .. " %*(%u+)%* (.*)$");
		if (cmd and msg) then
			return;
		end

	elseif (event == "CHAT_MSG_WHISPER_INFORM") then
		-- Prevent outgoing wait list whisper text from appearing in the chat frame.
		local text = ...;
		if (EkWaitList_Whispers_wlCommands == 1 and EkWaitList_Whispers_wlOutgoing == 0) then
			-- Try and match with the addon name
			if (strsub(text, 1, strlen(EkWaitList_AddonName)) == EkWaitList_AddonName) then
				return;
			end
		end

		-- Prevent outgoing wait list data from appearing in the chat frame.
		local pos1, pos2, cmd, msg = string.find(text, "^" .. EkWaitList_AddonName .. " %*(%u+)%* (.*)$");
		if (cmd and msg) then
			return;
		end
	end

	EkWaitList_oldChatFrame_MessageEventHandler(self, event, ...);
end
ChatFrame_MessageEventHandler = EkWaitList_newChatFrame_MessageEventHandler;

function EkWaitList_OnUpdate(self, elapsed)
	-- --------------
	-- Handles timed events, etc.
	-- --------------
	local inRaid;

	if (not EkWaitList_VarsLoaded) then
		return;
	end

	if (EkWaitList_InRaid()) then
		inRaid = 1;  -- in raid, or pretending to be while testing.
	else
		inRaid = nil;
	end

	if (not inRaid and EkWaitList_InRaidFlag) then
		-- We were in a raid, but aren't any longer.
		EkWaitList_DisabledRaidPrompts = {};
		EkWaitList_ShowPrompts = {};
	end

	if (inRaid and not EkWaitList_InRaidFlag) then
		-- We are in a raid now, but we weren't until now.
		EkWaitList_TestPrint("You have joined a raid.");

		-- Prompt user to clear waitlist?
		if (#EkWaitList_WaitList > 0) then
			if (EkWaitList_PromptFrame_Mode ~= EkWaitList_PROMPT_WAITLIST_JOIN) then
				EkWaitList_ShowPrompts[EkWaitList_PROMPT_WAITLIST_JOIN] = 1;
			end
		end
	end

	if (EkWaitList_InRaidFlag ~= inRaid) then
		EkWaitList_InRaidFlag = inRaid;
	end

	if (EkWaitList_Whisper_Queue_Timer) then
		EkWaitList_Whisper_Queue_Timer = EkWaitList_Whisper_Queue_Timer - elapsed;
		if (EkWaitList_Whisper_Queue_Timer < 0) then
			-- Send next message in the queue...
			if (EkWaitList_SendQueueMsg()) then
				-- A message was sent.
				EkWaitList_Whisper_Queue_Timer = EkWaitList_Whisper_Queue_Interval;
			else
				-- No more messages in the queue.
				EkWaitList_Whisper_Queue_Timer = nil;
			end
		end
	end

	if (EkWaitList_WaitFrame_WhoElapsed) then
		EkWaitList_WaitFrame_WhoElapsed = EkWaitList_WaitFrame_WhoElapsed - elapsed;
		if (EkWaitList_WaitFrame_WhoElapsed < 0.1) then
			EkWaitList_WaitFrame_WhoElapsed = nil;
			if (EkWaitList_WaitFrame_MenuNum == 1) then
				local sel = EkWaitList_WaitFrame_Selected;
				if ( #sel == 1 and not EkWaitList_WaitFrame_WhoElapsed ) then
					-- Enable the "who" button
					EkWaitList_Frame_MenuButton5:Enable();
				end
			end
		end
	end

	-- Timeout counter used while waiting for WD messages.
	if (EkWaitList_SentList_Timer) then
		EkWaitList_SentList_Timer = EkWaitList_SentList_Timer - elapsed;
		if (EkWaitList_SentList_Timer < 0) then
			EkWaitList_Whisper_SentList_Reset();
		end
	end

	-- Test for delay between prompt windows.
	if (EkWaitList_PromptDelay) then
		EkWaitList_PromptDelay = EkWaitList_PromptDelay - elapsed;
		if (EkWaitList_PromptDelay < 0.1) then
			EkWaitList_PromptDelay = nil;
		end
	end

	-- If waiting for user to respond to the prompt window...
	if (EkWaitList_PromptTimer and EkWaitList_PromptFrame_:IsShown() and EkWaitList_PromptTimer < 9999) then
		EkWaitList_PromptTimer = EkWaitList_PromptTimer - elapsed;
		if (EkWaitList_PromptTimer < 0.1) then
			-- Window timer has run out, so cancel the prompt.
			EkWaitList_PromptTimer = nil;
			EkWaitList_PromptFrame_Button2_OnClick();
			EkWaitList_PromptDelay = EkWaitList_DefPromptDelay;
		else
			EkWaitList_PromptFrame_Button2:SetText(EkWaitList_TEXT_PromptWindow_Button_Close .. "  (" .. ceil(EkWaitList_PromptTimer) .. ")");
		end
	end

	-- Test if we need to display a prompt window.
	for i = 1, #EkWaitList_PromptKeys do
		local k = EkWaitList_PromptKeys[i];
		if (EkWaitList_ShowPrompts[k]) then
			if (EkWaitList_DisabledRaidPrompts[k]) then
				EkWaitList_ShowPrompts[k] = nil;
			else
				if (not EkWaitList_PromptTimer and not EkWaitList_PromptDelay) then
					-- Prompt user.
					EkWaitList_ShowPrompts[k] = nil;
					EkWaitList_PromptFrame_Mode = k;
					EkWaitList_PromptFrame_:Show();
				end
			end
		end
	end
end


function EkWaitList_Command(msg)
	-- --------------
	-- Main command routine.
	-- --------------
	local pos1, pos2, cmd, rest = string.find(msg, "^%s-(%S+)(.*)");

	local command = "";
	if (cmd) then
		command = strlower(cmd);
	else
		cmd = "";
	end

	if (command == nil or command == "") then
		-- Toggle GUI visibility.
		EkWaitList_UIToggle();

	elseif (command == EkWaitList_TEXT_Command_Help or command == "?") then
		-- Display help.
		EkWaitList_Print2(" ");
		EkWaitList_ShowVersion(2);
		EkWaitList_Print2(" ");
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Add .. " -- " .. EkWaitList_TEXT_Help_Add);
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Add .. " <" .. EkWaitList_TEXT_Help_Text_Name .. "> -- " .. EkWaitList_TEXT_Help_AddName);
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Remove .. " <" .. EkWaitList_TEXT_Help_Text_Name .. "> -- " .. EkWaitList_TEXT_Help_Remove);
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_ReloadUI .. " -- " .. EkWaitList_TEXT_Help_ReloadUI);
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Reset .. " -- " .. EkWaitList_TEXT_Help_Reset);
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Announce .. " <" .. EkWaitList_TEXT_HELP_Text_Channel .. "> -- " .. EkWaitList_TEXT_Help_Announce .. " " .. EkWaitList_GetAnnounceKeywords());
		EkWaitList_Print2(EkWaitList_Slash1 .. " " .. EkWaitList_TEXT_Command_Help .. " -- " .. EkWaitList_TEXT_Help_Help);
		EkWaitList_Print2(EkWaitList_Slash1 .. " -- " .. EkWaitList_TEXT_Help_Window);

	elseif (command == EkWaitList_TEXT_Command_Add) then
		local pos1, pos2, name = string.find(rest, "^%s-(%S+).*");
		if (not name) then
			-- Show the add a player to waitlist pane
			EkWaitList_UIShowAdd();
		else
			-- Add specified player to the wait list.
			EkWaitList_Command_Waitlist_Add(name);
		end

	elseif (command == EkWaitList_TEXT_Command_ReloadUI) then
		-- Reload user interface.
		ReloadUI();

	elseif (command == EkWaitList_TEXT_Command_Remove) then
		local pos1, pos2, name = string.find(rest, "^%s-(%S+).*");
		if (name) then
			-- Remove specified player from the wait list.
			EkWaitList_Command_Waitlist_Remove(name);
		else
			EkWaitList_ShowInvalid();
		end

	elseif (command == EkWaitList_TEXT_Command_Reset) then
		-- Reset the window to the default locked position.
		if (EkWaitList_MovableWindow == 1) then
			EkWaitList_Frame_UnlockWindow(0);  -- Lock it (will reset position).
			EkWaitList_Frame_UnlockWindow(1);  -- Unlock it again (make it movable).
		else
			EkWaitList_Frame_UnlockWindow(0);  -- Lock it (will reset position).
		end
		EkWaitList_Print(EkWaitList_TEXT_Msg_Window_Reset);

	elseif (command == EkWaitList_TEXT_Command_Announce or
		command == EkWaitList_TEXT_Command_Announce2 or
		command == EkWaitList_TEXT_Command_Announce3) then
		-- -----
		-- Announce who is on the wait list.
		-- -----
		local pos1, pos2, keyword = string.find(rest, "^%s-(%S+).*");
		EkWaitList_Command_Announce(keyword);

	elseif (command == "_test") then
		-- Toggle test mode.
		if (EkWaitList_Test == 1) then
			EkWaitList_Print("Test mode disabled.");
			EkWaitList_Test = 0;
			return;
		end

		-- Test mode will:
		-- - Enable printing of certain events and their arguments.
		EkWaitList_Test = 1;
		EkWaitList_Print("Test mode enabled.");

	else
		EkWaitList_ShowInvalid();
	end
end

function EkWaitList_GetAnnounceKeywords()
	-- ----------
	-- Build a string containing a list of the announce command keywords.
	-- ----------
	local text = "";
	for i = 1, #EkWaitList_Who_Channels do
		local wc = EkWaitList_Who_Channels[i];
		local kw = wc.keywords;
		for j = 1, #kw do
			if (text ~= "") then
				text = text .. ", ";
			end
			text = text .. kw[j];
		end
	end
	return text;
end

function EkWaitList_Command_Waitlist_Add(name)
	-- ----------
	-- Add player to the wait list via a command.
	-- ----------
	EkWaitList_WaitFrame_AddPlayer(1, name)
end

function EkWaitList_Command_Waitlist_Remove(name)
	-- ----------
	-- Remove player from the wait list via a command.
	-- ----------
	EkWaitList_WaitFrame_RemovePlayer(1, name)
end

function EkWaitList_Command_Announce(keyword)
	-- ----------
	-- Announce who is on the wait list.
	-- ----------
	if (not keyword) then
		if (IsInGuild()) then
			keyword = "guild";
		else
			EkWaitList_Print(EkWaitList_TEXT_Msg_Who_NoKeywordSpecified);
			return;
		end
	end

	-- If user put a slash in front of the keyword or channel, then remove it.
	if (strsub(keyword, 1, 1) == "/") then
		keyword = strsub(keyword, 2);
	end

	if (EkWaitList_IsEmpty(keyword)) then
		EkWaitList_Print(EkWaitList_TEXT_Msg_Who_NoKeywordSpecified);
		return;
	end

	local keywordl = strlower(keyword);

	-- Look up the keyword in order to get the chat type that we need.
	local chatType, chanName, chanNum;

	for i = 1, #EkWaitList_Who_Channels do
		local wc = EkWaitList_Who_Channels[i];
		local kw = wc.keywords;
		for j = 1, #kw do
			if (keywordl == kw[j]) then
				chatType = wc.channel;
				break;
			end
		end
		if (chatType) then
			break;
		end
	end

	-- If we did not find the keyword...
	if (not chatType) then
		-- Assume the user specified a chat channel name or number.
		chatType = "channel";
		chanName = keyword;

		EkWaitList_AnnounceChannel = chanName;

		-- Validate the channel name/number
		chanNum = GetChannelName(chanName);
		if (chanNum == 0) then
			EkWaitList_Print(EkWaitList_TEXT_Msg_Who_InvalidChannel .. ": " .. chanName);
			return;
		end
	elseif (chatType == "reply") then
		-- Whisper the last person who sent us a whisper.
		chatType = "whisper";
		if (not EkWaitList_LastWhisper) then
			EkWaitList_Print(EkWaitList_TEXT_Msg_Who_NoLastWhisper);
			return;
		else
			-- Name of last person who sent us a whisper.
			chanNum = EkWaitList_LastWhisper;
		end
	end

	-- Announce over the channel who is on the wait list.
	EkWaitList_AddQueueMsg(EkWaitList_GetWhoIsOnWaitList(), chatType, chanNum, 0);
end

function EkCanOfficerChat(rank)
	-- -----
	-- Test if player can speak in officer chat.
	-- (requires a previous GuildRoster() call at some point).
	--
	-- Note: This relies on the order of the flags returned
	--       by GuildControlGetRankFlags().
	--
	-- Param: rank -- 0==Guild master, 1==Officer, etc.
	-- -----
	if (IsInGuild()) then
		if (GuildControlGetNumRanks() == 0) then
			GuildRoster();
		end
		local guildName, rankName, rankIndex;
		if (rank) then
			rankIndex = rank;
		else
			-- Rank index returned by GetGuildInfo() starts at 0 for guild master.
			guildName, rankName, rankIndex = GetGuildInfo("player");
		end
		-- GuildControlSetRank() requires a rank 1 for guild master, so add 1.
		rankIndex = rankIndex + 1;
		if (rankIndex and rankIndex <= GuildControlGetNumRanks()) then
			GuildControlSetRank(rankIndex);
			local rankFlags = { GuildControlGetRankFlags() };
			-- Flag [4] is 1 if the rank can speak in officer chat.
		        if (rankFlags and rankFlags[4] == 1) then
				return true;
			end
		end
	end
	return false;
end

-- ------------------------------------------------------------------
-- Show/hide/toggle/refresh UI panels
-- ------------------------------------------------------------------

function EkWaitList_UIRefresh()
	-- ----
	-- Refresh the current UI frame.
	-- ----
	if (EkWaitList_Frame_:IsShown()) then
		EkWaitList_Frame_Refresh();
	end
end

function EkWaitList_UIShow()
	-- Show the GUI
	if (not EkWaitList_Frame_:IsShown()) then
		EkWaitList_Frame_UIPanelShow(EkWaitList_Frame_);
	end
end

function EkWaitList_UIHide()
	-- Hide the GUI
	if (EkWaitList_Frame_:IsShown()) then
		EkWaitList_Frame_UIPanelHide(EkWaitList_Frame_);
	end
end

function EkWaitList_UIToggle()
	-- Toggle GUI visibility.
	if (EkWaitList_Frame_:IsShown()) then
		EkWaitList_Frame_UIPanelHide(EkWaitList_Frame_);
	else
		EkWaitList_Frame_UIPanelShow(EkWaitList_Frame_);
	end
end

function EkWaitList_UIToggleWaiting()
	-- Toggle the waiting pane
	if (EkWaitList_Frame_:IsShown()) then
		if (EkWaitList_Frame_GetTab() == EkWaitList_Frame_TabWait) then
			EkWaitList_Frame_UIPanelHide(EkWaitList_Frame_);
			return;
		end
	end

	EkWaitList_Frame_UIPanelShow(EkWaitList_Frame_);
	if (EkWaitList_WaitFrame_Mode == 1 or EkWaitList_WaitFrame_Mode == 2) then
		EkWaitList_WaitFrame_Mode = 0;
	end
	EkWaitList_Frame_GotoTab(EkWaitList_Frame_TabWait);
end

function EkWaitList_UIToggleOptions(page)
	-- Toggle the options pane
	if (EkWaitList_Frame_:IsShown()) then
		if (EkWaitList_Frame_GetTab() == EkWaitList_Frame_TabOptions) then
			if (EkWaitList_OptionsFrame_Page == page or page == nil) then
				EkWaitList_Frame_UIPanelHide(EkWaitList_Frame_);
				return;
			end
		end
	end

	EkWaitList_Frame_UIPanelShow(EkWaitList_Frame_);
	if (page ~= nil) then
		EkWaitList_OptionsFrame_Page = page;
	end
	EkWaitList_Frame_GotoTab(EkWaitList_Frame_TabOptions);
end

function EkWaitList_UIShowAdd()
	-- Show the add a player to waitlist pane
	if (not EkWaitList_Frame_:IsShown()) then
		EkWaitList_Frame_UIPanelShow(EkWaitList_Frame_);
	end

	local editadd = false;
	if (EkWaitList_Frame_GetTab() == EkWaitList_Frame_TabWait) then
		if (EkWaitList_WaitFrame_Mode == 1 or EkWaitList_WaitFrame_Mode == 2) then
			editadd = true;
		end
	end

	if (not editadd) then
		EkWaitList_WaitFrame_Mode = 0;
		EkWaitList_Frame_GotoTab(EkWaitList_Frame_TabWait);
		EkWaitList_WaitFrame_ShowAddPlayer();
	end
end

-- ------------------------------------------------------------------
-- Miscellaneous
-- ------------------------------------------------------------------

function EkWaitList_Print(msg)
	-- ----------------
	-- Print a message.
	-- ----------------
	DEFAULT_CHAT_FRAME:AddMessage(EkWaitList_AddonName .. " " .. msg);
	return;
end


function EkWaitList_Print2(msg)
	-- ----------------
	-- Print a message.
	-- ----------------
	DEFAULT_CHAT_FRAME:AddMessage(msg);
	return;
end


function EkWaitList_TestPrint(msg)
	-- ----------------
	-- Print a message (in test mode only).
	-- ----------------
	if (EkWaitList_Test == 1) then
		DEFAULT_CHAT_FRAME:AddMessage(EkWaitList_AddonName .. " " .. msg);
	end
	return;
end


function EkWaitList_GetGameTime()
	-- -----------
	-- Get game time (server time).
	--
	-- Returns: Local date("*t") array with hour & min replaced with the server hour & min.
	--
	--          The goal is to get a value that can be used in a date() call to format the
	--          time with locale's am/pm indicator.  The local date stored in the returned
	--          value should be ignored, as it may not be correct depending on the current time
	--          and the time zone you are in compared to the server's time zone.
	-- -----------

	-- Get locate date values.
	local local_date = date("*t");

	-- Get server's hour and min values.
	local server_hour, server_min = GetGameTime();

	-- Replace local date's hour and min with server values.
	local_date.hour = server_hour;
	local_date.min = server_min;

	-- Return time value.
	return time(local_date);
end


function EkWaitList_GetDate(year, month, day, hour, min, sec)
	-- ----------
	-- Returns date table for the specified numbers.
	-- ----------
	local tbl = {year = year, month = month, day = day, hour = hour, min = min, sec = sec};

	-- Determine correct daylight savings time flag.
	local date1 = date("*t", time(tbl));

	-- Assign correct dst value back to the table we're building.
	tbl.isdst = date1.isdst;

	-- Reconvert the table now that we have the correct dst flag, to fill in
	-- the other values we weren't passed as parameters.
	return date("*t", time(tbl));
end


function EkWaitList_SendWhisper(msg, name, splitlong)
	-- ----------
	-- Add whisper to the message queue.
	-- ----------
	if (not splitlong) then
		splitlong = 1;
	end
	EkWaitList_AddQueueMsg(msg, "WHISPER", name, splitlong, 1);
end

function EkWaitList_SendWhisper2(msg, name, splitlong)
	-- ----------
	-- Add whisper to the message queue (won't send "<EkWaitList>" at start of whisper).
	-- ----------
	if (not splitlong) then
		splitlong = 1;
	end
	EkWaitList_AddQueueMsg(msg, "WHISPER", name, splitlong, 0);
end

function EkWaitList_AddQueueMsg(msg, chatType, name, splitlong, addonFlag)
	-- ----------
	-- Add a message to the queue.
	-- ----------
	tinsert(EkWaitList_Whisper_Queue, {msg = msg, chatType = chatType, name = name, splitlong = splitlong, addonFlag = addonFlag});

	if (not EkWaitList_Whisper_Queue_Timer) then
		EkWaitList_Whisper_Queue_Timer = EkWaitList_Whisper_Queue_Interval;
	end
end


function EkWaitList_SendQueueMsg()
	-- ----------
	-- Send next message that is in the queue.
	--
	-- Returns: true if message was sent, false if nothing to send.
	-- ----------
	if (#EkWaitList_Whisper_Queue > 0) then
		local rec = EkWaitList_Whisper_Queue[1];

		EkWaitList_SendChatMessage(rec.msg, rec.chatType, rec.name, rec.splitlong, rec.addonFlag);

		tremove(EkWaitList_Whisper_Queue, 1);
		return true;
	end
	return false;
end


function EkWaitList_SendChatMessage(msg, chatType, name, splitlong, addonFlag)
	-- ----------
	-- Send a chat message.
	--
	-- chatType -- Type of chat message: SAY, GUILD, RAID, PARTY, OFFICER,
	--             WHISPER, CHANNEL, EMOTE, YELL, RAID_WARNING.
	-- ----------
	local len, pos, text;
	local addon = EkWaitList_AddonName .. " ";
	if (addonFlag == 0) then
		addon = "";
	end
	local addlen = strlen(addon);
	local maxlen = 250 - addlen;  -- Max message allowed is 254 characters.
	local priorValue;

	priorValue = GetCVar("autoClearAFK");
	SetCVar("autoClearAFK", 0);

	if (splitlong) then
		-- Send the message (in pieces if the message is too large).
		len = strlen(msg);
		while (len > 0) do
			if (len <= maxlen) then
				pos = len + 1;
			else
				-- Starting at character maxlen+1, look backwards for a space.
				pos = maxlen + 1;
				while (pos > 0) do
					if (strsub(msg, pos, pos) == " ") then
						break;
					end
					pos = pos - 1;
				end
				if (pos <= 0) then
					pos = maxlen + 1;
				end
			end
			text = strsub(msg, 1, pos - 1);
			msg = strsub(msg, pos);
			len = strlen(msg);

			SendChatMessage(addon .. text, chatType, nil, name);
		end
	else
		SendChatMessage(addon .. msg, chatType, nil, name);
	end

	SetCVar("autoClearAFK", priorValue);
end


function EkWaitList_IsEmpty(text)
	-- -----------
	-- Test if a string is empty or all blanks.
	-- -----------
	local count;
	local length = strlen(text);

	for i=1, length, 1 do
		if ( strsub(text, i, i) ~= " " ) then
			return false;
		end
	end

	return true;
end


function EkWaitList_InRaid()
	-- -----------
	-- Test if we are currently in a raid.
	-- -----------
	local inRaid;
	if (EkWaitList_Test > 0) then
		-- In test mode. Pretend we are in a raid.
		inRaid = 1;
	else
		if (GetNumRaidMembers() > 0) then
			inRaid = 1;
		else
			inRaid = nil;
		end
	end
	return inRaid;
end


function EkWaitList_GuildRoster()
	-- --------------
	-- Request guild roster from server.
	-- --------------
	if (not IsInGuild()) then
		return;
	end
	-- Add 1 to show we are expecting another guild roster update event.
--	EkWaitList_GuildRosterUpdates = EkWaitList_GuildRosterUpdates + 1;
	GuildRoster();
end

function EkWaitList_SetGuildRosterShowOffline(offline)
	-- --------------
	-- Set whether to see the offline players in the guild or not.
	-- --------------
	if (not IsInGuild()) then
		return;
	end
	-- Add 1 to show we are expecting another guild roster update event.
	EkWaitList_GuildRosterUpdates = EkWaitList_GuildRosterUpdates + 1;
	SetGuildRosterShowOffline(offline);
end

function EkWaitList_GetGuildInfo(offline)
	-- --------------
	-- Get guild roster information.
	-- --------------
	if (not EkWaitList_GuildRosterFlag) then
		return;
	end

	EkWaitList_GuildRosterFlag = nil;

	local oldOffline = GetGuildRosterShowOffline();
	EkWaitList_SetGuildRosterShowOffline(offline);

	local num = GetNumGuildMembers();
	EkWaitList_GuildInfo = {};

	if (num > 0) then
		-- EkWaitList_GuildInfo[num] = {};
		local rec;
		local main;
		local name, rank, rankIndex, level, class, zone, group, note, officernote, online, status;
		for i=1, num do
			name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i);
			group = "no";

			if (name) then
				rec = {};
				rec["name"] = name;
				rec["lower"] = strlower_utf8(name);
				rec["rank"] = rank;
				rec["rankIndex"] = rankIndex;
				rec["class"] = class;
				rec["note"] = note;
				rec["officernote"] = officernote;
				rec["online"] = online;
				rec["level"] = level;

				rec["cpos"] = 0;
				rec["cpercent"] = 0;
				rec["mpos"] = 0;
				rec["mpercent"] = 0;

				main = nil;

				if (EkWaitList_MainNameUse == 1) then
					local pattern = EkWaitList_MainName_GetPattern();
					local pos1, pos2;
					if (EkWaitList_MainNameNote == 2) then
						-- Extract name of main character from the officer note.
						pos1, pos2, main = string.find(officernote, pattern);
					else
						-- Extract name of main character from the public note.
						pos1, pos2, main = string.find(note, pattern);
					end
				end

				-- If not using main names, or if one could not be found, then default to the character's name.
				if (main == nil or main == "") then
					main = name;
				end

				main = EkWaitList_NormalizeName(main);
				rec["main"] = main;  -- name of player's main character.

				table.insert(EkWaitList_GuildInfo, rec);
			end
		end
		-- Sort the table
		sort(EkWaitList_GuildInfo, function (a, b)
							if (a["lower"] < b["lower"]) then
								return true;
							else
								return false;
							end
						end)

		if (EkWaitList_PercentData) then
			EkWaitList_MergeAttend();
		end
	end

	EkWaitList_SetGuildRosterShowOffline(oldOffline);
end

function EkWaitList_MergeAttend()
	-- ----------------
	-- Merge attendance data with guild main/alternate info.
	--
	-- Updates: EkWaitList_GuildInfo[]
	-- ----------------
	local attendData;
	local numAttend;
	local mainAttend, newAttend;
	local guildData;

	guildData = EkWaitList_GuildInfo;

	-- Retrieve the list of names sorted by attendance.
	-- [row][1] == name
	-- [row][2] == attendance percentage
	attendData = EkWaitList_PercentData;
	numAttend = #attendData;

	-- -----
	-- Create table indexed by each player's main character's name.
	-- Each entry will have the player's total attendance percentage
	-- and the player's best position in the attendance list.
	-- -----
	mainAttend = {};
	for i=1,numAttend do
		local name, perc, posn, guildRec, rec, main;

		name = attendData[i][1];
		perc = attendData[i][2];
		posn = attendData[i][3];
		name = EkWaitList_NormalizeName(name);

		-- Get name of main character for this player.
		local pos = EkWaitList_IsNameInGuild(name);
		if (pos == 0) then
			-- Name is not in the guild.
			rec = {};
			rec["pos"] = posn;
			rec["percent"] = perc;
			mainAttend[name] = rec;
		else
			-- Name is in the guild.
			guildRec = EkWaitList_GuildInfo[pos];

			main = guildRec["main"];

			-- Update main character's data
			rec = mainAttend[main];
			if (not rec) then
				-- Create new entry in the table for this character.
				rec = {};
				rec["pos"] = posn;
				rec["percent"] = perc;
				mainAttend[main] = rec;
			else
				-- Accumulate percentages for this player's characters.
				rec["percent"] = rec["percent"] + perc;
				-- Keep track of the lowest (best) character's position in the attendance list.
				if (posn < rec["pos"]) then
					rec["pos"] = posn;
				end
			end

			-- Update this character's data in the guild record.
			guildRec["cpos"] = posn;
			guildRec["cpercent"] = perc;
		end
	end

	-- -----
	-- Copy main characters' attendance percentages into the guild array.
	-- -----
	for i=1,#EkWaitList_GuildInfo do
		local name, main, mainRec, guildRec;

		guildRec = EkWaitList_GuildInfo[i];

		-- Get main character's name.
		main = guildRec["main"];

		-- Get attendance info for the main character.
		mainRec = mainAttend[main];

		if (mainRec) then
			guildRec["mpercent"] = mainRec["percent"];  -- total attendance percentage
			guildRec["mpos"] = mainRec["pos"];   -- best position in attendance list
		else
			guildRec["mpercent"] = 0;
			guildRec["mpos"] = #attendData + 1;
		end
	end
end

function EkWaitList_IsNameInGuild(player)
	-- --------------
	-- Test if a player name is in the guild.
	-- Returns: a) If not found in guild list, returns 0.
	--          b) If found in guild list, returns subscript within EkWaitList_GuildInfo[].
	-- --------------
	if (not player or player == "") then
		return 0;
	end

	local text = strlower_utf8(player);
	local name, num, info;
	local left, right, mid;
	local findtext, rec, found;

	if (not IsInGuild()) then
		return 0;
	end

	EkWaitList_GetGuildInfo(1);

	info = EkWaitList_GuildInfo;
	num = #info;

	left = 1;
	right = #info;
	found = 0;

	while (left <= right) do
		mid = floor((left + right) / 2);
		rec = info[mid];

		if (rec["lower"] == text) then
			found = mid;
			break;
		end

		if (text < rec["lower"]) then
			right = mid - 1;
		else
			left  = mid + 1;
		end
	end

	return found;	
end

function EkWaitList_GetMainName(name)
	-- ----------
	-- Get main name of a character in the guild.
	--
	-- Returns: 1a) nil, if you are not in a guild, or the name is not in the guild roster.
	--          1b) the name of the character's main.
	--          2a) nil, if you are not in a guild.
	--          2b) 0, if name not found in guild roster
	--          2c) >0, if the name was found in the guild roster.
	-- ----------
	local main, pos, rec;

	if (IsInGuild()) then
		local pos;
		pos = EkWaitList_IsNameInGuild(name);
		if (pos ~= 0) then
			rec = EkWaitList_GuildInfo[pos];
			main = rec["main"];
		end
	end

	return main, pos;
end

function EkWaitList_MainName_Convert(text)
	-- ----------
	-- Convert special characters in the main name start/end strings.
	--
	-- Returns: Modified string usable in a string.find() pattern.
	-- ----------
	local special = {"^", "$", "(", ")", "%", ".", "[", "]", "*", "+", "-", "?"};
	local len = strlen(text);
	local result = "";
	for i = 1, len do
		local char = strsub(text, i, i);
		for j = 1, #special do
			if (char == special[j]) then
				char = "%" .. char;
				break;
			end
		end
		result = result .. char;
	end
	return result;
end

function EkWaitList_MainName_GetPattern()
	-- ----------
	-- Create a main name pattern for use with string.find().
	--
	-- Returns: Pattern string.
	-- ----------
	local mainStart = EkWaitList_MainName_Convert(EkWaitList_MainNameStart);
	local mainEnd = EkWaitList_MainName_Convert(EkWaitList_MainNameEnd);
	local pattern = mainStart .. "%s-(%S+)%s-" .. mainEnd;
	return pattern;
end

function EkWaitList_Name_AutoComplete(self)
	-- --------------
	-- Automatically complete player name as user types it.
	-- --------------
	local text = strlower_utf8(self:GetText());
	local textlen = strlen(text);
	local name, info;
	local left, right, mid;
	local findtext, rec;
	local left, right, mid;

	if (not IsInGuild()) then
		return;
	end

	EkWaitList_GetGuildInfo(1);

	info = EkWaitList_GuildInfo;

	findtext = "^" .. text;

	left = 1;
	right = #info;

	while (left <= right) do
		mid = floor((left + right) / 2);
		rec = info[mid];

		-- if (rec["lower"] == text) then
		if (strfind(rec["lower"], findtext)) then

			-- Update the name
			self:SetText(rec["name"]);
			self:HighlightText(textlen, -1);
			return;
		end

		if (text < rec["lower"]) then
			right = mid - 1;
		else
			left  = mid + 1;
		end
	end
end

function EkWaitList_SetTooltip_Cursor(owner, normalText)
	-- ----------
	-- Set tooltip anchored to the cursor.
	-- ----------
--	if (EkWaitList_ShowTooltips ~= 1) then
--		return
--	end
	GameTooltip:SetOwner(owner, "ANCHOR_CURSOR");
	GameTooltip:SetText(normalText);
	GameTooltip:Show();
end

function EkWaitList_SetTooltip_Anchor(owner, normalText, anchor, x, y, wrap)
	-- ----------
	-- Set tooltip using specified anchor.
	-- ----------
	local r, g, b, alpha;
--	if (EkWaitList_ShowTooltips ~= 1) then
--		return
--	end
	GameTooltip:SetOwner(owner, anchor, x, y);
	GameTooltip:SetText(normalText, r, g, b, alpha, wrap);
	GameTooltip:Show();
end

function EkWaitList_SetTooltip_Corner(owner, normalText, detailedText, anchor)
	-- ----------
	-- Set tooltip in lower right corner of screen.
	--
	-- Param: normalText -- Brief tooltip text.
	-- Param: detailedText -- Detailed tooltip text.
	-- ----------
	local r, g, b, alpha, wrap;
	if (EkWaitList_ShowTooltips ~= 1) then
		return
	end
	r = 1;
	g = 1;
	b = 1;
	alpha = 1;
	wrap = 1;
	if (EkWaitList_ShowAtCursor == 1) then
		if (not anchor) then
			local oType = owner:GetObjectType();
			if (oType == "CheckButton") then
				anchor = "ANCHOR_LEFT";
			elseif (oType == "Button") then
				anchor = "ANCHOR_BOTTOMRIGHT";
			elseif (oType == "EditBox") then
				anchor = "ANCHOR_RIGHT";
			elseif (oType == "Frame") then
				anchor = "ANCHOR_RIGHT";
			else
				anchor = "ANCHOR_RIGHT";
			end
		end
		GameTooltip:SetOwner(owner, anchor);
	else
		GameTooltip_SetDefaultAnchor(GameTooltip, owner);
	end
	if (normalText) then
		GameTooltip:SetText(normalText, r, g, b, alpha, wrap);
		if (detailedText) then
			GameTooltip:AddLine(detailedText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
		end
	else
		GameTooltip:SetText(detailedText, r, g, b, alpha, wrap);
	end
	GameTooltip:Show();
end

function EkWaitList_HideTooltip()
	-- ----------
	-- Hide the tooltip.
	-- ----------
	GameTooltip:Hide();
end

function EkWaitList_SetButtonTextColor(button, r, g, b, a)
	-- ----------
	-- Set text color of specified button.
	-- ----------
	local text;
	text = button:GetText();
	if (strsub(text, 1, 2) == "|c") then
		text = strsub(text, 11);
	end
	if (not a) then
		a = 1;
	end
	button:SetText(string.format("|c%02x%02x%02x%02x%s", a * 255, r * 255, g * 255, b * 255, text));
end

-- *!*
-- -------------------------------------------------------------------------
-- EkWaitList_Frame
-- -------------------------------------------------------------------------

EkWaitList_Frame_SUBFRAMES = {
	{"EkWaitList_WaitFrame_", "EkWaitList_EditFrame_"},
	{"EkWaitList_OptionsFrame_", "EkWaitList_OptionsFrame2_"},
};

EkWaitList_Frame_TabWait = 1;
EkWaitList_Frame_TabOptions = 2;

function EkWaitList_Frame_UnlockWindow(movable)
	-- --------------
	-- Make window movable/unmovable.
	-- --------------
	EkWaitList_MovableWindow = movable;
	EkWaitList_Frame_UIPanelHide(EkWaitList_Frame_);
	if ( movable == 1 ) then
		EkWaitList_Frame_UISpecialFrame(1);
		EkWaitList_Frame_UIPanelSet(0);
		EkWaitList_Frame_MoveButton:Show();
	else
		EkWaitList_Frame_MoveButton:Hide();
		EkWaitList_Frame_UISpecialFrame(0);
		EkWaitList_Frame_UIPanelSet(1);
	end
	EkWaitList_Frame_UIPanelShow(EkWaitList_Frame_);
end

function EkWaitList_Frame_UIPanelSet(set)
	-- --------------
	-- Set or clear standard UI Panel settings for the window.
	-- This allows the frame to act like a standard UI panel (shift right when you open another)
	-- when ShowUIPanel() and HideUIPanel() are used.
	-- --------------
	local frame = EkWaitList_Frame_;

	if (set == 1) then
		-- UIPanelWindows["EkWaitList_Frame_"] = { area = "left", pushable = 1, whileDead = 1 };

		frame:SetAttribute("UIPanelLayout-defined", true);
		frame:SetAttribute("UIPanelLayout-area", "left");
		frame:SetAttribute("UIPanelLayout-pushable", 1);
		frame:SetAttribute("UIPanelLayout-whileDead", 1);
		frame:SetAttribute("UIPanelLayout-enabled", true);
	else
		-- UIPanelWindows["EkWaitList_Frame_"] = nil;

		frame:SetAttribute("UIPanelLayout-enabled", false);
	end
end

function EkWaitList_Frame_UIPanelShow(frame)
	-- ----------
	-- Show the frame.
	-- ----------
	ShowUIPanel(frame);
--	frame:Show();
end

function EkWaitList_Frame_UIPanelHide(frame)
	-- ----------
	-- Hide the frame.
	-- ----------
	HideUIPanel(frame);
--	frame:Hide();
end

function EkWaitList_Frame_UISpecialFrame(set)
	-- --------------
	-- Set or clear UI Special Frame settings for the window.
	-- (this allows you to press ESC to close the frame).
	-- --------------
	if (set == 1) then
		tinsert(UISpecialFrames, "EkWaitList_Frame_");
	else
		for key, val in pairs(UISpecialFrames) do
			if ( key == "EkWaitList_Frame_" ) then
				val = nil;
			end
		end
	end
end

function EkWaitList_Frame_ShowSubFrame(frameName)
	-- ----------
	-- Show/hide the sub frames.
	-- ----------
	EkWaitList_Frame_ShowSubFrameTable(frameName, EkWaitList_Frame_SUBFRAMES);
end

function EkWaitList_Frame_ShowSubFrameTable(frameName, frameNameTable)
	-- ----------
	-- Show/hide the sub frame names listed in a table.
	-- ----------
	local frame;
	for index, value in pairs(frameNameTable) do
		if ( type(value) == "table" ) then
			EkWaitList_Frame_ShowSubFrameTable(frameName, value);
		else
			frame = _G[value];
			if ( frame ) then
				if ( value == frameName ) then
					frame:Show();
				else
					frame:Hide();
				end
			end
		end
	end
end

function EkWaitList_Frame_HideSubFrames()
	-- ----------
	-- Hide the sub frames.
	-- ----------
	EkWaitList_Frame_HideSubFrameTable(EkWaitList_Frame_SUBFRAMES);
end

function EkWaitList_Frame_HideSubFrameTable(frameNameTable)
	-- ----------
	-- Hide the sub frame names listed in a table.
	-- ----------
	local frame;
	for index, value in pairs(frameNameTable) do
		if ( type(value) == "table" ) then
			EkWaitList_Frame_HideSubFrameTable(value);
		else
			frame = _G[value];
			if ( frame ) then
				frame:Hide();
			end
		end
	end
end

function EkWaitList_Frame_OnLoad(self)
	-- ----------
	-- Frame has been loaded.
	-- ----------
	local frame = EkWaitList_Frame_;

	PanelTemplates_SetNumTabs(self, #EkWaitList_Frame_SUBFRAMES);

	-- Initial tab to be selected
	frame.selectedTab = EkWaitList_Frame_TabWait;

	PanelTemplates_UpdateTabs(self);
end

function EkWaitList_Frame_OnShow()
	-- ----------
	-- Show the frame.
	-- ----------
	local fname = "EkWaitList_Frame_";
	local frame = _G[fname];
	local tab = frame.selectedTab;

	if (tab == EkWaitList_Frame_TabOptions) then
		fname = EkWaitList_Frame_SUBFRAMES[tab][EkWaitList_OptionsFrame_Page];
	else
		if (EkWaitList_WaitFrame_Mode == 0) then
			fname = EkWaitList_Frame_SUBFRAMES[tab][1]; -- Wait
		else
			fname = EkWaitList_Frame_SUBFRAMES[tab][2]; -- Edit/add
		end
	end

	EkWaitList_Frame_ShowSubFrame(fname);
	PlaySound("igMainMenuOpen");
end

function EkWaitList_Frame_GetTab()
	-- ----------
	-- Get current tab number.
	-- ----------
	local frame = EkWaitList_Frame_;
	local tab = frame.selectedTab;
	return tab;
end

function EkWaitList_Frame_Refresh()
	-- ----------
	-- Refresh the frame.
	-- ----------
	local frame = EkWaitList_Frame_;
	local tab = frame.selectedTab;

	if ( tab == EkWaitList_Frame_TabOptions ) then
		EkWaitList_OptionsFrame_OnShow();

	else
		if (EkWaitList_WaitFrame_Mode == 0) then
			EkWaitList_WaitFrame_OnShow();
		else
			EkWaitList_EditFrame_OnShow();
		end

	end
end

function EkWaitList_Frame_OnHide(self)
	-- ----------
	-- Hide the frame.
	-- ----------
	PlaySound("igMainMenuClose");
	EkWaitList_Frame_HideSubFrames();
	self:StopMovingOrSizing();
end

function EkWaitList_Frame_Tab_OnClick(self)
	-- ----------
	-- User clicked a tab on the frame.
	-- ----------
	EkWaitList_WaitFrame_MenuNum = 1;
	if (EkWaitList_WaitFrame_Mode == 1 or EkWaitList_WaitFrame_Mode == 2) then
		EkWaitList_WaitFrame_Mode = 0;
	end
	PanelTemplates_Tab_OnClick(self, EkWaitList_Frame_);
	EkWaitList_Frame_OnShow();
end

function EkWaitList_Frame_GotoTab(tab)
	-- ----------
	-- Display one of the UI tab pages.
	-- ----------
	local frame = EkWaitList_Frame_;

	PanelTemplates_SetTab(frame, tab);
	EkWaitList_WaitFrame_MenuNum = 1;
	if (EkWaitList_WaitFrame_Mode == 1 or EkWaitList_WaitFrame_Mode == 2) then
		EkWaitList_WaitFrame_Mode = 0;
	end
	EkWaitList_Frame_OnShow();
end

function EkWaitList_Frame_MenuButton_HideAll()
	-- ----------
	-- Hide all menu buttons.
	-- ----------
	EkWaitList_Frame_MenuButton1:Hide();
	EkWaitList_Frame_MenuButton2:Hide();
	EkWaitList_Frame_MenuButton3:Hide();
	EkWaitList_Frame_MenuButton4:Hide();
	EkWaitList_Frame_MenuButton5:Hide();
	EkWaitList_Frame_MenuButton6:Hide();
	EkWaitList_Frame_MenuButton7:Hide();
	EkWaitList_Frame_MenuButton8:Hide();
	EkWaitList_Frame_MenuButton9:Hide();

	EkWaitList_Frame_MenuButton21:Hide();
	EkWaitList_Frame_MenuButton22:Hide();
	EkWaitList_Frame_MenuButton23:Hide();
end

function EkWaitList_Frame_MenuButton_OnClick(buttonNum)
	-- ----------
	-- User clicked on a menu button.
	-- ----------
	local tab = EkWaitList_Frame_.selectedTab;

	if (tab == EkWaitList_Frame_TabWait) then
		local mode = EkWaitList_WaitFrame_Mode;
		if (mode == 0) then
			EkWaitList_WaitFrame_MenuButton_OnClick(buttonNum);
		elseif (mode == 1) then
			EkWaitList_EditFrame_MenuButton_OnClick(buttonNum);
		elseif (mode == 2) then
			EkWaitList_EditFrame_MenuButton_OnClick(buttonNum);
		end
	end
end

function EkWaitList_Frame_MenuButton_OnEnter(buttonNum)
	-- ----------
	-- Mouse is over a menu button.
	-- ----------
	local tab = EkWaitList_Frame_.selectedTab;

	EkWaitList_Frame_MenuButton_Over = buttonNum;  -- Mouse is over this button.
	if (tab == EkWaitList_Frame_TabWait) then
		local mode = EkWaitList_WaitFrame_Mode;
		if (mode == 0) then
			EkWaitList_WaitFrame_MenuButton_OnEnter(buttonNum);
		elseif (mode == 1) then
			EkWaitList_EditFrame_MenuButton_OnEnter(buttonNum);
		elseif (mode == 2) then
			EkWaitList_EditFrame_MenuButton_OnEnter(buttonNum);
		end
	end
end

function EkWaitList_Frame_MenuButton_OnLeave(buttonNum)
	-- ----------
	-- Mouse is leaving a menu button.
	--
	-- buttonNum -- may be nil
	-- ----------
	EkWaitList_Frame_MenuButton_Over = nil;  -- Mouse is no longer over this button.
	EkWaitList_HideTooltip();
end

-- *!*
-- -------------------------------------------------------------------------
-- EkWaitList_OptionsFrame (the "options" tab)
-- -------------------------------------------------------------------------

EkWaitList_OptionsFrame_Page = 1;

function EkWaitList_OptionsFrame_OnLoad()
	-- ----------
	-- Options frame is being loaded.
	-- ----------
	local cmds = {"Help", "Who", "Add", "Main", "Remove", "Comment"};  -- order, name, capitals are important.
	local cmd, fs, text, kw;

	-- EkWaitList_TEXT_Options_Whispers_Help
	-- EkWaitList_TEXT_Options_Whispers_Who
	-- EkWaitList_TEXT_Options_Whispers_Add
	-- EkWaitList_TEXT_Options_Whispers_Main
	-- EkWaitList_TEXT_Options_Whispers_Remove
	-- EkWaitList_TEXT_Options_Whispers_Comment

	-- Assign text to the fontstrings beside each check box for the
	-- wait list whisper commands in the options window.
	for i = 1, #cmds do
		cmd = cmds[i];

		fs = _G["EkWaitList_OptionsFrame_Whisper" .. cmd .. "Text"];

		text = _G["EkWaitList_TEXT_Options_Whispers_" .. cmd] .. " (" .. EkWaitList_Whispers_command;
		kw = EkWaitList_Whispers_waitlist[strlower(cmd)]["keyword"];
		if (kw ~= "") then
			text = text .. " " .. kw;
		end
		text = text .. ")";

		fs:SetText(text);
	end
end

function EkWaitList_OptionsFrame_OnShow()
	-- ----------
	-- Show the frame.
	-- ----------


	if (EkWaitList_OptionsFrame_Page == 1) then
		EkWaitList_OptionsFrame_TitleText:SetText("EkWaitList " .. EkWaitList_Version);
		EkWaitList_OptionsFrame_MovableCB_Update();
		EkWaitList_OptionsFrame_WhisperCB_Update();
		EkWaitList_OptionsFrame_WhisperIncomingCB_Update();
		EkWaitList_OptionsFrame_WhisperOutgoingCB_Update();
		EkWaitList_OptionsFrame_WhisperNonGuildCB_Update();
		EkWaitList_OptionsFrame_WhisperHelpCB_Update();
		EkWaitList_OptionsFrame_WhisperWhoCB_Update();
		EkWaitList_OptionsFrame_WhisperAddCB_Update();
		EkWaitList_OptionsFrame_WhisperMainCB_Update();
		EkWaitList_OptionsFrame_WhisperRemoveCB_Update();
		EkWaitList_OptionsFrame_WhisperCommentCB_Update();

	elseif (EkWaitList_OptionsFrame_Page == 2) then
		EkWaitList_OptionsFrame2_TitleText:SetText("EkWaitList " .. EkWaitList_Version);
		EkWaitList_OptionsFrame_RemoveUponJoinCB_Update();
		EkWaitList_OptionsFrame_MainNameUseCB_Update();
		EkWaitList_OptionsFrame_MainNameNoteDropDown_Update();
		EkWaitList_OptionsFrame_MainNameStartEB_Update();
		EkWaitList_OptionsFrame_MainNameEndEB_Update();
		EkWaitList_OptionsFrame_ShowTooltipsCB:SetChecked(EkWaitList_ShowTooltips);
		EkWaitList_OptionsFrame_ShowAtCursorCB:SetChecked(EkWaitList_ShowAtCursor);
		EkWaitList_OptionsFrame_ShowAtCursorCB_Update();

	end

	EkWaitList_OptionsFrame_ClearFocus();
	EkWaitList_Frame_MenuButton_HideAll();
end

function EkWaitList_OptionsFrame_ClearFocus()
	-- ----------
	-- Clear focus from edit boxes
	-- ----------
	local StartEB = EkWaitList_OptionsFrame_MainNameStartEB;
	local EndEB = EkWaitList_OptionsFrame_MainNameEndEB;

	StartEB:ClearFocus();
	EndEB:ClearFocus();
end

-- ----------
-- "Movable window"
-- ----------

function EkWaitList_OptionsFrame_MovableCB_OnClick()
	-- ----------
	-- Toggle the "movable window" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_MovableCB;

	if ( CB:GetChecked() ) then
		EkWaitList_MovableWindow = 1;
	else
		EkWaitList_MovableWindow = 0;
	end

	EkWaitList_Frame_UnlockWindow(EkWaitList_MovableWindow);

	EkWaitList_OptionsFrame_ClearFocus();
end

function EkWaitList_OptionsFrame_MovableCB_Update()
	-- ----------
	-- Update the "movable window" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_MovableCB;

	CB:SetChecked(EkWaitList_MovableWindow);
end

-- ----------
-- "Automatically remove players that join the party/raid"
-- ----------

function EkWaitList_OptionsFrame_RemoveUponJoinCB_OnClick()
	-- ----------
	-- Toggle the "automatic remove upon join" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_RemoveUponJoinCB;

	if ( CB:GetChecked() ) then
		EkWaitList_RemoveUponJoin = 1;
	else
		EkWaitList_RemoveUponJoin = 0;
	end

	EkWaitList_OptionsFrame_ClearFocus();
end

function EkWaitList_OptionsFrame_RemoveUponJoinCB_Update()
	-- ----------
	-- Update the "automatic remove upon join" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_RemoveUponJoinCB;

	CB:SetChecked(EkWaitList_RemoveUponJoin);
end

-- ----------
-- "Use main character names."
-- ----------

function EkWaitList_OptionsFrame_MainNameUseCB_OnClick()
	-- ----------
	-- Toggle the "use main character names" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_MainNameUseCB;

	if ( CB:GetChecked() ) then
		EkWaitList_MainNameUse = 1;
	else
		EkWaitList_MainNameUse = 0;
	end
	EkWaitList_OptionsFrame_MainNameUseCB_Update()

	EkWaitList_GuildRosterFlag = 1;

	EkWaitList_OptionsFrame_ClearFocus();
end

function EkWaitList_OptionsFrame_MainNameUseCB_Update()
	-- ----------
	-- Update the "use main character names" checkbox.
	-- ----------
	local useCB = EkWaitList_OptionsFrame_MainNameUseCB;
	local DDframe = EkWaitList_OptionsFrame_MainNameNoteDropDown;
	local DDbutton = EkWaitList_OptionsFrame_MainNameNoteDropDownButton;
	local startEB = EkWaitList_OptionsFrame_MainNameStartEB;
	local endEB = EkWaitList_OptionsFrame_MainNameEndEB;

	if (EkWaitList_MainNameUse == 0) then
		useCB:SetChecked(0);
--		DDbutton:Disable();
		DDframe:Hide();
		startEB:Hide();
		endEB:Hide();
	else
		useCB:SetChecked(1);
--		DDbutton:Enable();
		DDframe:Show();
		startEB:Show();
		endEB:Show();
	end
end

-- ----------
-- "Main name is stored in"
-- ----------

EkWaitList_OptionsFrame_MainNameNoteDropDown_List = { EkWaitList_TEXT_Options_Public_Note, EkWaitList_TEXT_Options_Officer_Note };

function EkWaitList_OptionsFrame_MainNameNoteDropDown_OnLoad()
	-- ----------
	-- Load the "Main name is in" dropdown menu.
	-- ----------
	local DD = EkWaitList_OptionsFrame_MainNameNoteDropDown;

	local id;
	if ( EkWaitList_MainNameNote ) then
		id = EkWaitList_MainNameNote;
	else
		id = 1;
	end

	UIDropDownMenu_Initialize(DD, EkWaitList_OptionsFrame_MainNameNoteDropDown_Initialize);
	UIDropDownMenu_SetWidth(DD, 110);
	EkWaitList_OptionsFrame_MainNameNoteDropDown_Set(id);
end

function EkWaitList_OptionsFrame_MainNameNoteDropDown_Initialize()
	-- ----------
	-- Initialize the "Main name is in" dropdown menu.
	-- ----------
	local info;
	for key, val in pairs(EkWaitList_OptionsFrame_MainNameNoteDropDown_List) do
		info = {};
		info.text = val;
		info.func = EkWaitList_OptionsFrame_MainNameNoteDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function EkWaitList_OptionsFrame_MainNameNoteDropDown_Update()
	-- ----------
	-- Update the "Main name is in" dropdown menu.
	-- ----------
	EkWaitList_OptionsFrame_MainNameNoteDropDown_Set(EkWaitList_MainNameNote);
end

function EkWaitList_OptionsFrame_MainNameNoteDropDown_OnClick(self)
	-- ----------
	-- User has selected an item from the "Main name is stored in" dropdown menu.
	-- ----------
	EkWaitList_MainNameNote = self:GetID();
	EkWaitList_OptionsFrame_MainNameNoteDropDown_Set(self:GetID());

	EkWaitList_GuildRosterFlag = 1;

	EkWaitList_OptionsFrame_ClearFocus();
end

function EkWaitList_OptionsFrame_MainNameNoteDropDown_Set(id)
	-- ----------
	-- Set the current value of the "Main name is in" dropdown menu.
	-- ----------
	local DD = EkWaitList_OptionsFrame_MainNameNoteDropDown;
	UIDropDownMenu_SetSelectedID(DD, id);
	UIDropDownMenu_SetText(DD, EkWaitList_OptionsFrame_MainNameNoteDropDown_List[id]);
end

-- ----------
-- "Main name starts with"
-- ----------

function EkWaitList_OptionsFrame_MainNameStartEB_EditStart()
	-- ----------
	-- Start editing the character(s) that start the main name.
	-- ----------
	local EB = EkWaitList_OptionsFrame_MainNameStartEB;

	if ( EB.editing ) then
		return;
	end

	EB.editing = 1;
	EB:HighlightText();
end

function EkWaitList_OptionsFrame_MainNameStartEB_EditStop(cancel)
	-- ----------
	-- User has stopped editing the character(s) that start the main name.
	-- ----------
	local EB = EkWaitList_OptionsFrame_MainNameStartEB;

	if ( not EB.editing ) then
		return;
	end

	local value = EB:GetText();

	EB.editing = nil;
	EB:HighlightText(0, 0);

	if ( not cancel ) then
		EkWaitList_MainNameStart = value;
		EkWaitList_GuildRosterFlag = 1;
	else
		EkWaitList_OptionsFrame_MainNameStartEB_Update();
	end
end

function EkWaitList_OptionsFrame_MainNameStartEB_Update()
	-- ----------
	-- Update the character(s) that start the main name.
	-- ----------
	local EB = EkWaitList_OptionsFrame_MainNameStartEB;

	if ( not EB.editing ) then
		EB:SetText(EkWaitList_MainNameStart);
	end
end

function EkWaitList_OptionsFrame_MainNameStartEB_OnTab(eb)
	eb:ClearFocus();
	if (not IsShiftKeyDown()) then
		EkWaitList_OptionsFrame_MainNameEndEB:SetFocus();
	end
end

-- ----------
-- "Main name ends with"
-- ----------

function EkWaitList_OptionsFrame_MainNameEndEB_EditStart()
	-- ----------
	-- Start editing the character(s) that end the main name.
	-- ----------
	local EB = EkWaitList_OptionsFrame_MainNameEndEB;

	if ( EB.editing ) then
		return;
	end

	EB.editing = 1;
	EB:HighlightText();
end

function EkWaitList_OptionsFrame_MainNameEndEB_EditStop(cancel)
	-- ----------
	-- User has stopped editing the character(s) that end the main name.
	-- ----------
	local EB = EkWaitList_OptionsFrame_MainNameEndEB;

	if ( not EB.editing ) then
		return;
	end

	local value = EB:GetText();

	EB.editing = nil;
	EB:HighlightText(0, 0);

	if ( not cancel ) then
		EkWaitList_MainNameEnd = value;
		EkWaitList_GuildRosterFlag = 1;
	else
		EkWaitList_OptionsFrame_MainNameEndEB_Update();
	end
end

function EkWaitList_OptionsFrame_MainNameEndEB_Update()
	-- ----------
	-- Update the character(s) that end the main name.
	-- ----------
	local EB = EkWaitList_OptionsFrame_MainNameEndEB;

	if ( not EB.editing ) then
		EB:SetText(EkWaitList_MainNameEnd);
	end
end

function EkWaitList_OptionsFrame_MainNameEndEB_OnTab(eb)
	eb:ClearFocus();
	if (IsShiftKeyDown()) then
		EkWaitList_OptionsFrame_MainNameStartEB:SetFocus();
	end
end

-- ----------
-- "Show detailed tooltips"
-- ----------

function EkWaitList_OptionsFrame_ShowTooltipsCB_OnClick()
	-- ----------
	-- Toggle the "show detailed tooltips" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_ShowTooltipsCB;

	if ( CB:GetChecked() ) then
		EkWaitList_ShowTooltips = 1;
	else
		EkWaitList_ShowTooltips = 0;
	end

	EkWaitList_OptionsFrame_ShowAtCursorCB_Update();
	EkWaitList_OptionsFrame_ClearFocus();
end

function EkWaitList_OptionsFrame_ShowTooltipsCB_Update()
	-- ----------
	-- Update the "show detailed tooltips" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_ShowTooltipsCB;

	CB:SetChecked(EkWaitList_ShowTooltips);
end

-- ----------
-- "Show tooltips at cursor"
-- ----------

function EkWaitList_OptionsFrame_ShowAtCursorCB_OnClick()
	-- ----------
	-- Toggle the "show tooltips at cursor" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_ShowAtCursorCB;

	if ( CB:GetChecked() ) then
		EkWaitList_ShowAtCursor = 1;
	else
		EkWaitList_ShowAtCursor = 0;
	end

	EkWaitList_OptionsFrame_ClearFocus();
end

function EkWaitList_OptionsFrame_ShowAtCursorCB_Update()
	-- ----------
	-- Update the "show tooltips at cursor" checkbox.
	-- ----------
	if (EkWaitList_ShowTooltips == 1) then
		EkWaitList_OptionsFrame_ShowAtCursorCB:Enable();
	else
		EkWaitList_OptionsFrame_ShowAtCursorCB:Disable();
	end
end

-- ----------
-- "Wait list whispers."
-- ----------

function EkWaitList_OptionsFrame_WhisperCB_OnClick()
	-- ----------
	-- Toggle the "Wait list whispers" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperCB;

	if ( CB:GetChecked() ) then
		EkWaitList_Whispers_wlCommands = 1;
	else
		EkWaitList_Whispers_wlCommands = 0;
	end
	EkWaitList_OptionsFrame_WhisperCB_Update();
end

function EkWaitList_OptionsFrame_WhisperCB_Update()
	-- ----------
	-- Update the "Wait list whispers" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperCB;
	local CB1 = EkWaitList_OptionsFrame_WhisperIncomingCB;
	local CB2 = EkWaitList_OptionsFrame_WhisperOutgoingCB;
	local CB3 = EkWaitList_OptionsFrame_WhisperHelpCB;
	local CB4 = EkWaitList_OptionsFrame_WhisperWhoCB;
	local CB5 = EkWaitList_OptionsFrame_WhisperAddCB;
	local CB6 = EkWaitList_OptionsFrame_WhisperRemoveCB;
	local CB7 = EkWaitList_OptionsFrame_WhisperNonGuildCB;
	local CB8 = EkWaitList_OptionsFrame_WhisperMainCB;
	local CB9 = EkWaitList_OptionsFrame_WhisperCommentCB;

	if (EkWaitList_Whispers_wlCommands == 0) then
		CB:SetChecked(0);
		CB1:Disable();
		CB2:Disable();
		CB3:Disable();
		CB4:Disable();
		CB5:Disable();
		CB6:Disable();
		CB7:Disable();
		CB8:Disable();
		CB9:Disable();
	else
		CB:SetChecked(1);
		CB1:Enable();
		CB2:Enable();
		CB3:Enable();
		CB4:Enable();
		CB5:Enable();
		CB6:Enable();
		CB7:Enable();
		CB8:Enable();
		CB9:Enable();
	end
end

function EkWaitList_OptionsFrame_WhisperIncomingCB_OnClick()
	-- ----------
	-- Toggle the "Display incoming wait list whispers" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperIncomingCB;

	if ( CB:GetChecked() ) then
		EkWaitList_Whispers_wlIncoming = 1;
	else
		EkWaitList_Whispers_wlIncoming = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperIncomingCB_Update()
	-- ----------
	-- Update the "Display incoming Wait list whispers" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperIncomingCB;

	if (EkWaitList_Whispers_wlIncoming == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperOutgoingCB_OnClick()
	-- ----------
	-- Toggle the "Display outgoing wait list whispers" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperOutgoingCB;

	if ( CB:GetChecked() ) then
		EkWaitList_Whispers_wlOutgoing = 1;
	else
		EkWaitList_Whispers_wlOutgoing = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperOutgoingCB_Update()
	-- ----------
	-- Update the "Display outgoing Wait list whispers" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperOutgoingCB;

	if (EkWaitList_Whispers_wlOutgoing == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperNonGuildCB_OnClick()
	-- ----------
	-- Toggle the "Anyone can use the add command" option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperNonGuildCB;

	if ( CB:GetChecked() ) then
		EkWaitList_Whispers_wlNonGuild = 1;
	else
		EkWaitList_Whispers_wlNonGuild = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperNonGuildCB_Update()
	-- ----------
	-- Update the "Anyone can use the add command" checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperNonGuildCB;

	if (EkWaitList_Whispers_wlNonGuild == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperHelpCB_OnClick()
	-- ----------
	-- Toggle the "wait list whispers" help option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperHelpCB;
	local option = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	if (not config["help"]) then
		config["help"] = {};
	end

	if ( CB:GetChecked() ) then
		option["help"]["enabled"] = 1;
		config["help"]["enabled"] = 1;
	else
		option["help"]["enabled"] = 0;
		config["help"]["enabled"] = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperHelpCB_Update()
	-- ----------
	-- Update the "Wait list whispers" help checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperHelpCB;

	if (EkWaitList_Whispers_waitlist["help"]["enabled"] == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperWhoCB_OnClick()
	-- ----------
	-- Toggle the "wait list whispers" WHO option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperWhoCB;
	local option = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	if (not config["who"]) then
		config["who"] = {};
	end

	if ( CB:GetChecked() ) then
		option["who"]["enabled"] = 1;
		config["who"]["enabled"] = 1;
	else
		option["who"]["enabled"] = 0;
		config["who"]["enabled"] = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperWhoCB_Update()
	-- ----------
	-- Update the "Wait list whispers" WHO checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperWhoCB;

	if (EkWaitList_Whispers_waitlist["who"]["enabled"] == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperAddCB_OnClick()
	-- ----------
	-- Toggle the "wait list whispers" ADD option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperAddCB;
	local option = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	if (not config["add"]) then
		config["add"] = {};
	end

	if ( CB:GetChecked() ) then
		option["add"]["enabled"] = 1;
		config["add"]["enabled"] = 1;
	else
		option["add"]["enabled"] = 0;
		config["add"]["enabled"] = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperAddCB_Update()
	-- ----------
	-- Update the "Wait list whispers" ADD checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperAddCB;

	if (EkWaitList_Whispers_waitlist["add"]["enabled"] == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperMainCB_OnClick()
	-- ----------
	-- Toggle the "wait list whispers" MAIN option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperMainCB;
	local option = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	if (not config["main"]) then
		config["main"] = {};
	end

	if ( CB:GetChecked() ) then
		option["main"]["enabled"] = 1;
		config["main"]["enabled"] = 1;
	else
		option["main"]["enabled"] = 0;
		config["main"]["enabled"] = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperMainCB_Update()
	-- ----------
	-- Update the "Wait list whispers" MAIN checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperMainCB;

	if (EkWaitList_Whispers_waitlist["main"]["enabled"] == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperRemoveCB_OnClick()
	-- ----------
	-- Toggle the "wait list whispers" REMOVE option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperRemoveCB;
	local option = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	if (not config["remove"]) then
		config["remove"] = {};
	end

	if ( CB:GetChecked() ) then
		option["remove"]["enabled"] = 1;
		config["remove"]["enabled"] = 1;
	else
		option["remove"]["enabled"] = 0;
		config["remove"]["enabled"] = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperRemoveCB_Update()
	-- ----------
	-- Update the "Wait list whispers" REMOVE checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperRemoveCB;

	if (EkWaitList_Whispers_waitlist["remove"]["enabled"] == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

function EkWaitList_OptionsFrame_WhisperCommentCB_OnClick()
	-- ----------
	-- Toggle the "wait list whispers" COMMENT option.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperCommentCB;
	local option = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	if (not config["comment"]) then
		config["comment"] = {};
	end

	if ( CB:GetChecked() ) then
		option["comment"]["enabled"] = 1;
		config["comment"]["enabled"] = 1;
	else
		option["comment"]["enabled"] = 0;
		config["comment"]["enabled"] = 0;
	end

end

function EkWaitList_OptionsFrame_WhisperCommentCB_Update()
	-- ----------
	-- Update the "Wait list whispers" COMMENT checkbox.
	-- ----------
	local CB = EkWaitList_OptionsFrame_WhisperCommentCB;

	if (EkWaitList_Whispers_waitlist["comment"]["enabled"] == 0) then
		CB:SetChecked(0);
	else
		CB:SetChecked(1);
	end
end

-- *!*
-- -------------------------------------------------------------------------
-- EkWaitList_WaitFrame (the "wait" tab: waiting to join party/raid)
-- -------------------------------------------------------------------------

EkWaitList_WaitFrame_MenuNum = 1;
EkWaitList_WaitFrame_Order = "pos";
EkWaitList_WaitFrame_LastSort = EkWaitList_WaitFrame_Order;  -- Last sort type
EkWaitList_WaitFrame_Ascend = 1;  -- nil=Descending, 1=Ascending
EkWaitList_WaitFrame_NumToDisplay = 15;
EkWaitList_WaitFrame_Height = 16;
EkWaitList_WaitFrame_Selected = {};
EkWaitList_WaitFrame_SelectedTemp = {};
EkWaitList_WaitFrame_Mode = 0;  -- 0==Main, 1=Add, 2=Edit
EkWaitList_WaitFrame_WhoElapsed = nil;

function EkWaitList_WaitFrame_NewPlayer(pos, name, class, altname, comment, percent, rankIndex)
	-- ----------
	-- Create new player record.
	-- ----------
	local local_time = time();
	local server_time = EkWaitList_GetGameTime();

	local rec;

	rec = {};

	rec["pos"] = pos;
	rec["name"] = name;
	rec["class"] = class;

	rec.local_time = local_time;
	rec.server_time = server_time;

	rec["altname"] = altname;
	rec["comment"] = comment;
	rec["percent"] = percent;
	rec["rankIndex"] = rankIndex;

	return rec;
end

function EkWaitList_WaitFrame_OnLoad()
	-- ----------
	-- Load frame.
	-- ----------
end

function EkWaitList_WaitFrame_OnShow()
	-- ----------
	-- Show frame.
	-- ----------
	local msg;

	EkWaitList_WaitFrame_TitleText:SetText("EkWaitList " .. EkWaitList_Version);

	msg = EkWaitList_WaitFrame_Message;
	msg:SetTextColor(1, 1, 1);

	if (EkWaitList_PercentData) then
		EkWaitList_WaitFrame_ViewButton:Show();
		EkWaitList_WaitFrame_ToggleButton:Show();
	else
		EkWaitList_WaitFrame_ViewButton:Hide();
		EkWaitList_WaitFrame_ToggleButton:Hide();
		EkWaitList_ShowRank = 1;
	end
	EkWaitList_WaitFrame_ToggleTimeButton:Show();

	EkWaitList_WaitFrame_WaitList_Config();

	EkWaitList_Frame_MenuButton_HideAll();

	EkWaitList_WaitFrame_ShowMenu();
	EkWaitList_WaitFrame_ListUpdate();
end

function EkWaitList_WaitFrame_WaitList_Config()
	-- ----------
	-- Configure wait list.
	-- ----------
	local rec;
	local local_date;

	for i=1,#EkWaitList_WaitList do
		rec = EkWaitList_WaitList[i];
		rec["percent"] = EkWaitList_WaitFrame_LookupPercent(rec["name"]);
	end
end

function EkWaitList_WaitFrame_LookupPercent(name)
	-- ----------
	-- Lookup attendance percentage for the specified name.
	-- ----------
	local percent;

	percent = 0;
	if (EkWaitList_PercentData) then
		local pos = EkWaitList_IsNameInGuild(name);
		if (pos > 0) then
			local grec = EkWaitList_GuildInfo[pos];
			percent = grec["mpercent"];
		else
			local attend, lower;
			attend = EkWaitList_PercentData;
			lower = strlower_utf8(name);
			for j=1,#attend do
				if (attend[j][1] == lower) then
					percent = attend[j][2];
					break;
				end
			end
		end
	end

	return percent;
end

function EkWaitList_WaitFrame_ListInit()
	-- ----------
	-- Initialize the array to be displayed.
	-- ----------
	EkWaitList_WaitFrame_Selected = {};
	EkWaitList_WaitFrame_Sort(EkWaitList_WaitFrame_Order);
end

function EkWaitList_WaitFrame_SelToTemp()
	-- ----------
	-- Convert current selection array (containing numeric subscripts)
	-- into a temporary selection array (containing index strings).
	-- ----------
	local list = EkWaitList_WaitList;
	local sel = EkWaitList_WaitFrame_Selected;
	local sel2;
	local sub, len;

	sel2 = {};  -- temp selection array.
	len = #sel;
	for i=1, len do
		sub = sel[i];
		table.insert(sel2, list[sub]["name"]);
	end

	EkWaitList_WaitFrame_SelectedTemp = sel2;
end

function EkWaitList_WaitFrame_TempToSel()
	-- ----------
	-- Convert temporary selection array (containing index strings)
	-- into a new current selection array (containing numeric subscripts).
	-- ----------
	local list = EkWaitList_WaitList;
	local sel = EkWaitList_WaitFrame_Selected;
	local sel2 = EkWaitList_WaitFrame_SelectedTemp;
	local sub, len, len2, count, index;

	len = #list;
	len2 = #sel2;
	sel = {};  -- start a new selection set
	if (len2 > 0) then
		count = 0;
		for i=1, len do
			index = list[i]["name"];
			-- Look up the index string in the temp selection array.
			for j=1, len2 do
				if (index == sel2[j]) then
					table.insert(sel, i);
					count = count + 1;
					break;
				end
			end
			-- Check if we've converted them all yet.
			if (count == len2) then
				break;
			end
		end
	end
	EkWaitList_WaitFrame_Selected = sel;
end

function  EkWaitList_WaitFrame_Sort(sortType)
	-- --------
	-- Sort wait list.
	--
	-- Param: sortType == "pos".
	-- --------
	local list = EkWaitList_WaitList;
	local ch, chNum;

	EkWaitList_WaitFrame_SelToTemp();

	for i=1,5 do
		local text;
		ch = _G["EkWaitList_WaitFrame_ColumnHeader" .. i];
		EkWaitList_SetButtonTextColor(ch, 1, 1, 1, 1); -- white
--		ch:SetTextColor(1.0, 1.0, 1.0);
	end
		
	if (sortType == "name") then
		sort(list, EkWaitList_WaitFrame_SortByName);
		chNum = 2;
	elseif (sortType == "class") then
		sort(list, EkWaitList_WaitFrame_SortByClass);
		chNum = 3;
	elseif (sortType == "added") then
		sort(list, EkWaitList_WaitFrame_SortByAdded);
		chNum = 4;
	elseif (sortType == "percent") then
		if (EkWaitList_ShowRank == 1) then
			sort(list, EkWaitList_WaitFrame_SortByRank);
		else
			sort(list, EkWaitList_WaitFrame_SortByPercent);
		end
		chNum = 5;
	else
		sortType = "pos";
		sort(list, EkWaitList_WaitFrame_SortByPos);
		chNum = 1;
	end

	ch = _G["EkWaitList_WaitFrame_ColumnHeader" .. chNum];
	EkWaitList_SetButtonTextColor(ch, 1, 0.82, 0, 1); -- orange
--	ch:SetTextColor(1.0, 0.82, 0.0);

	EkWaitList_WaitFrame_TempToSel();

	EkWaitList_WaitFrame_Order = sortType;
	EkWaitList_WaitFrame_LastSort = sortType;
end

function EkWaitList_WaitFrame_SortByPos(val1, val2)
	-- ----------
	-- Sort the list of players by position.
	-- ----------
	local order, low1, low2;

	low1 = val1["pos"];
	low2 = val2["pos"];

	if ( low1 < low2 ) then
		order = -1;
	elseif ( low1 > low2 ) then
		order = 1;
	else
		order = 0;
	end

	if (EkWaitList_WaitFrame_Ascend) then
		if (order < 0) then
			return true;
		else
			return false;
		end
	else
		if (order > 0) then
			return true;
		else
			return false;
		end
	end
end

function EkWaitList_WaitFrame_SortByName(val1, val2)
	-- ----------
	-- Sort the list of players by name1.
	-- ----------
	local order, low1, low2;

	low1 = strlower_utf8(val1["name"]);
	low2 = strlower_utf8(val2["name"]);

	if ( low1 < low2 ) then
		order = -1;
	elseif ( low1 > low2 ) then
		order = 1;
	else
		order = 0;
	end

	if (EkWaitList_WaitFrame_Ascend) then
		if (order < 0) then
			return true;
		else
			return false;
		end
	else
		if (order > 0) then
			return true;
		else
			return false;
		end
	end
end

function EkWaitList_WaitFrame_SortByClass(val1, val2)
	-- ----------
	-- Sort the list of players by class.
	-- ----------
	local order, low1, low2;

	low1 = strlower(val1["class"]);
	low2 = strlower(val2["class"]);

	if ( low1 < low2 ) then
		order = -1;
	elseif ( low1 > low2 ) then
		order = 1;
	else
		if ( val1["pos"] < val2["pos"] ) then
			order = -1;
		elseif ( val1["pos"] > val2["pos"] ) then
			order = 1;
		else
			order = 0;
		end
	end

	if (EkWaitList_WaitFrame_Ascend) then
		if (order < 0) then
			return true;
		else
			return false;
		end
	else
		if (order > 0) then
			return true;
		else
			return false;
		end
	end
end

function EkWaitList_WaitFrame_SortByAdded(val1, val2)
	-- ----------
	-- Sort the list of players by local date/time added.
	-- ----------
	local order, low1, low2;

	if (val1.local_time < val2.local_time) then
		order = -1;
	elseif (val1.local_time > val2.local_time) then
		order = 1;
	else
		order = 0;
	end

	if (EkWaitList_WaitFrame_Ascend) then
		if (order < 0) then
			return true;
		else
			return false;
		end
	else
		if (order > 0) then
			return true;
		else
			return false;
		end
	end
end

function EkWaitList_WaitFrame_SortByPercent(val1, val2)
	-- ----------
	-- Sort the list of players by attendance percentage.
	-- ----------
	local order;

	if ( val1["percent"] < val2["percent"] ) then
		order = -1;
	elseif ( val1["percent"] > val2["percent"] ) then
		order = 1;
	else
		if ( val1["pos"] < val2["pos"] ) then
			order = -1;
		elseif ( val1["pos"] > val2["pos"] ) then
			order = 1;
		else
			order = 0;
		end
	end

	if (EkWaitList_WaitFrame_Ascend) then
		if (order < 0) then
			return true;
		else
			return false;
		end
	else
		if (order > 0) then
			return true;
		else
			return false;
		end
	end
end

function EkWaitList_WaitFrame_SortByRank(val1, val2)
	-- ----------
	-- Sort the list of players by guild rank.
	-- ----------
	local order;
	local rank1, rank2;

	rank1 = val1["rankIndex"];
	rank2 = val2["rankIndex"];

	-- If rankIndex is nil, then sort it to the end of the list (ie. consider it to be the largest value).
	if ( rank1 and (not rank2) ) then
		order = -1;
	elseif ( (not rank1) and rank2 ) then
		order = 1;
	elseif ( (not rank1) and (not rank2) ) then
		order = 0;
	elseif ( rank1 < rank2 ) then
		order = -1;
	elseif ( rank1 > rank2 ) then
		order = 1;
	else
		order = 0;
	end

	if (order == 0) then
		if ( val1["pos"] < val2["pos"] ) then
			order = -1;
		elseif ( val1["pos"] > val2["pos"] ) then
			order = 1;
		else
			order = 0;
		end
	end

	if (EkWaitList_WaitFrame_Ascend) then
		if (order < 0) then
			return true;
		else
			return false;
		end
	else
		if (order > 0) then
			return true;
		else
			return false;
		end
	end
end

function EkWaitList_WaitFrame_WaitTime(local_time)
	-- ----------
	-- Returns wait time in hours, minutes, seconds.
	-- ----------
	local hours, mins, secs;
	secs = math.abs(time() - local_time);
	hours = math.floor(secs / (60 * 60));
	secs = secs - (hours * 60 * 60);
	mins = math.floor(secs / 60);
	secs = secs - (mins * 60);
	return hours, mins, secs;
end

function EkWaitList_WaitFrame_ListUpdate()
	-- ----------
	-- Update the displayed waiting players.
	-- ----------
	local fs;
	local button;
	local list = EkWaitList_WaitList;
	local rec;
	local NumWait = #list;
	local WaitOffset = FauxScrollFrame_GetOffset(EkWaitList_WaitFrame_ListScrollFrame);
	local WaitIndex;
	local len, pos, msg;
	local sel = EkWaitList_WaitFrame_Selected;
	local ch, text;

	local showScrollBar = nil;
	if ( NumWait > EkWaitList_WaitFrame_NumToDisplay ) then
		showScrollBar = 1;
	end

	msg = string.format(EkWaitList_TEXT_Waitlist_Total_Waiting, NumWait);
	if (#sel > 0) then
		msg = msg .. "   " .. string.format(EkWaitList_TEXT_Waitlist_Total_Selected, #sel);
	end
	EkWaitList_WaitFrame_Totals:SetText(msg);

	if (EkWaitList_ShowWaitTime == 1) then
		text = EkWaitList_TEXT_Waitlist_Waited_Column_Title;
	else
		text = EkWaitList_TEXT_Waitlist_Added_Column_Title;
	end
	ch = EkWaitList_WaitFrame_ColumnHeader4;
	if (strsub(ch:GetText(), 1, 2) == "|c") then
		ch:SetText(strsub(ch:GetText(), 1, 10) .. text);
	else
		ch:SetText(text);
	end

	if (EkWaitList_ShowRank == 1) then
		text = EkWaitList_TEXT_Waitlist_Rank_Column_Title;
	else
		text = EkWaitList_TEXT_Waitlist_Percent_Column_Title;
	end
	ch = EkWaitList_WaitFrame_ColumnHeader5;
	if (strsub(ch:GetText(), 1, 2) == "|c") then
		ch:SetText(strsub(ch:GetText(), 1, 10) .. text);
	else
		ch:SetText(text);
	end

	for i=1, EkWaitList_WaitFrame_NumToDisplay, 1 do
		WaitIndex = WaitOffset + i;
		button = _G["EkWaitList_WaitFrame_Button"..i];
		button.WaitIndex = WaitIndex;

		if ( showScrollBar ) then
			button:SetWidth(298);
		else
			button:SetWidth(330);
		end

		if (WaitIndex > 0 and WaitIndex <= NumWait) then
			rec = list[WaitIndex];

			fs = _G["EkWaitList_WaitFrame_Button"..i.."Position"];
			fs:SetText("" .. rec["pos"]);
			fs:Show();

			fs = _G["EkWaitList_WaitFrame_Button"..i.."Name"];
			fs:SetText(rec["name"]);
			fs:Show();
	
			fs = _G["EkWaitList_WaitFrame_Button"..i.."Class"];
			fs:SetText(rec["class"]);
			fs:Show();

			fs = _G["EkWaitList_WaitFrame_Button"..i.."Added"];
			if (EkWaitList_ShowWaitTime == 1) then
				-- Wait time (elapsed).
				local hours, mins, secs = EkWaitList_WaitFrame_WaitTime(rec.local_time);
				if (hours > 99) then
					hours = 99;
					mins = 59;
					secs = 59;
				end
				fs:SetText(string.format("%02d:%02d:%02d", hours, mins, secs));
			else
				-- Time user was added to wait list.
				fs:SetText(date("%I:%M:%S %p", rec.local_time));
			end
			fs:Show();

			fs = _G["EkWaitList_WaitFrame_Button"..i.."Percent"];
			if (EkWaitList_ShowRank == 1) then
				if (rec["rankIndex"]) then
					fs:SetText("" .. rec["rankIndex"]);
				else
					fs:SetText("--");
				end
			else
				if (EkWaitList_PercentData) then
					fs:SetText("" .. rec["percent"]);
				else
					fs:SetText(" ");
				end
			end
			fs:Show();

			-- If need scrollbar resize columns
			if ( showScrollBar ) then
				fs:SetWidth(20);
			else
				fs:SetWidth(30);
			end

			-- Highlight the correct name
			len = #sel;
			pos = 0;
			for i=1, len, 1 do
				if ( sel[i] == WaitIndex ) then
					pos = i;
					break;
				end
			end
			if ( pos > 0 ) then
				button:LockHighlight();
			else
				button:UnlockHighlight();
			end

			button:Show();
		else
			button:Hide();
		end
	end

	-- ScrollFrame update
	FauxScrollFrame_Update(EkWaitList_WaitFrame_ListScrollFrame, NumWait, EkWaitList_WaitFrame_NumToDisplay, EkWaitList_WaitFrame_Height);

	local scrollFrame = EkWaitList_WaitFrame_ListScrollFrame;
	local scrollBar = _G[scrollFrame:GetName().."ScrollBar"];
	scrollBar:SetValue(scrollBar:GetValue());
end

function EkWaitList_WaitFrame_Column_SetWidth(frame, width)
	-- ----------
	-- Set width of a column.
	-- ----------
	frame:SetWidth(width);
	_G[frame:GetName().."Middle"]:SetWidth(width - 9);
end

function EkWaitList_WaitFrame_Column_Click(sortType)
	-- ----------
	-- User clicked on a column heading.
	-- ----------
	if ( sortType ) then
		if (sortType == EkWaitList_WaitFrame_LastSort) then
			if (EkWaitList_WaitFrame_Ascend) then
				EkWaitList_WaitFrame_Ascend = nil;
			else
				EkWaitList_WaitFrame_Ascend = 1;
			end
		end

		EkWaitList_WaitFrame_Sort(sortType);
		EkWaitList_WaitFrame_ListUpdate();
	end
	PlaySound("igMainMenuOptionCheckBoxOn");
end

function EkWaitList_WaitFrame_Button_OnDoubleClick(self, button)
	-- ----------
	-- User double clicked on a player in the wait list.
	-- ----------
	local sel = EkWaitList_WaitFrame_Selected; -- Table of selected subscripts
	local sub = self.WaitIndex; -- Subscript stored in this button

	if ( button == "LeftButton" ) then
		-- Create new selection table consisting of the player the user clicked on.
		sel = { sub };
		EkWaitList_WaitFrame_Selected = sel;

		-- Update display, and make sure menu shows the "Edit" button.
		EkWaitList_WaitFrame_MenuNum = 1;  -- WaitFrame main menu
		EkWaitList_WaitFrame_ShowMenu();

		-- Click on the edit button
		EkWaitList_WaitFrame_MenuButton_OnClick(6);
	end
end

function EkWaitList_WaitFrame_Button_OnClick(self, button)
	-- ----------
	-- User clicked on a player.
	-- ----------
	local sel = EkWaitList_WaitFrame_Selected; -- Table of selected subscripts
	local sub = self.WaitIndex; -- Subscript stored in this button
	local sub1, sub2, sub3, pos, len;

	if ( button == "LeftButton" ) then

		if ( #sel == 0 ) then
			-- Select a single item. Cancels any existing selection.
			sel = { sub };

		elseif ( IsShiftKeyDown() ) then
			-- -----
			-- Select all items between the start and end points.
			-- -----
			sub1 = sel[1];
			sub2 = sel[#sel];
			if ( sub < sub1 ) then
				sub1 = sub;
			else
				sub2 = sub;
			end
			sel = {};
			len = sub2 - sub1 + 1;
			sub3 = sub1;
			for i=1, len, 1 do
				sel[i] = sub3;
				sub3 = sub3 + 1;
			end

		elseif ( IsControlKeyDown() ) then
			-- -----
			-- User control clicked an item.
			-- If already selected, unselect it,
			-- otherwise select it and add it to the selection list.
			-- -----
			len = #sel;
			pos = 0;
			for i=1, len, 1 do
				if ( sel[i] == sub ) then
					-- Already in the table, so remove it.
					pos = i;
					table.remove(sel, i);
					break;
				elseif ( sel[i] > sub ) then
					-- Not in table, so insert it at proper spot.
					pos = i;
					table.insert(sel, i, sub);
					break;
				end
			end
			-- If it still is not in the table, then add it to the end.
			if ( pos == 0 ) then
				table.insert(sel, sub);
			end
		else
			-- Select a single item. Cancels any existing selection.
			sel = { sub };
		end

		EkWaitList_WaitFrame_Selected = sel;
		EkWaitList_WaitFrame_ListUpdate();

		EkWaitList_WaitFrame_MenuNum = 1;  -- WaitFrame main menu
		EkWaitList_WaitFrame_ShowMenu();
	end
end

function EkWaitList_WaitFrame_Button_OnEnter(self)
	-- ----------
	-- User moved pointer over a wait item.
	-- ----------
	local sel = EkWaitList_WaitFrame_Selected; -- Table of selected subscripts
	local sub = self.WaitIndex; -- Subscript stored in this button

	local xp = "LEFT";
	local yp = "BOTTOM";
	local xo = 0;
	local xthis, ythis = self:GetCenter();
	local xui, yui = UIParent:GetCenter();
	if (xthis < xui) then
		xp = "RIGHT";
		if (#EkWaitList_WaitList <= EkWaitList_WaitFrame_NumToDisplay) then
			xo = 0;
		else
			xo = 32;
		end
	end
	if (ythis < yui) then
--		yp = "TOP";
		yp = "";
		if (xthis < xui) then
			xp = "RIGHT";
		else
			xp = "LEFT";
		end
	end

	local rec = EkWaitList_WaitList[sub];
	local text, white;
	local pos, grec, disp;

	white = "|c00FFFFFF";
	text = "";

        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Name .. "|r " .. rec["name"] .. "\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Class .. "|r " .. rec["class"] .. "\n";

	pos = EkWaitList_IsNameInGuild(rec["name"]);
	if (pos > 0) then
		grec = EkWaitList_GuildInfo[pos];
	        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Rank .. "|r " .. grec["rankIndex"] .. ", " .. grec["rank"] .. "\n";
	end

	if (EkWaitList_PercentData) then
	        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Attendance .. "|r " .. rec["percent"] .. " %\n";
	end

        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Position .. "|r " .. rec["pos"] .. "\n";
        text = text .. "\n";

	disp = nil;
	if (rec["altname"] ~= "") then
	        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Name2 .. "|r " .. rec["altname"] .. "\n";
		disp = 1;
	end
	if (rec["comment"] ~= "") then
	        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Comment .. "|r " .. rec["comment"] .. "\n";
		disp = 1;
	end
	if (disp) then
	        text = text .. "\n";
	end

        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Added .. "|r\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Local_Date .. "|r " .. date("%Y/%m/%d", rec.local_time) .. "\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Local_Time .. "|r " .. date("%I:%M:%S %p", rec.local_time) .. "\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Server_Time .. "|r " .. date("%I:%M %p", rec.server_time) .. "\n";

	local hours, mins, secs = EkWaitList_WaitFrame_WaitTime(rec.local_time);
	if (hours > 999) then
		hours = 999;
		mins = 59;
		secs = 59;
	end
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Waited_Time .. "|r " .. string.format("%03d:%02d:%02d", hours, mins, secs) .. "\n";

        text = text .. "\n";

        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Click1 .. "|r " .. EkWaitList_TEXT_Player_Tooltip_Click2 .. "\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Ctrl_Click1 .. "|r " .. EkWaitList_TEXT_Player_Tooltip_Ctrl_Click2 .. "\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Shift_Click1 .. "|r " .. EkWaitList_TEXT_Player_Tooltip_Shift_Click2 .. "\n";
        text = text .. white .. EkWaitList_TEXT_Player_Tooltip_Double_Click1 .. "|r " .. EkWaitList_TEXT_Player_Tooltip_Double_Click2 .. "\n";

	EkWaitList_SetTooltip_Anchor(self, text, "ANCHOR_" .. yp .. xp, xo, 0, 1);
end

function EkWaitList_WaitFrame_SelectAll()
	-- ----------
	-- Select all players.
	-- ----------
	local sel = {};

	for i=1, #EkWaitList_WaitList do
		sel[i] = i;
	end

	EkWaitList_WaitFrame_Selected = sel;
end

function EkWaitList_WaitFrame_ViewButton_OnClick()
	-- ----------
	-- User clicked on the button to view the attendance percentage data.
	-- ----------
	EkWaitList_GuildRoster();

	if (EkImport_UIPercent) then
		EkImport_UIPercent(2);  -- 2==Toggle the window
	end
end

function EkWaitList_WaitFrame_ViewButton_OnEnter(self)
	-- ----------
	-- Mouse is over the button to view attendance percentage data.
	-- ----------
	EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Waitlist_View_Button_Tooltip1, EkWaitList_TEXT_Waitlist_View_Button_Tooltip2);
end

function EkWaitList_WaitFrame_ToggleButton_OnClick()
	-- ----------
	-- Toggle between attendance % and guild rank.
	-- ----------
	if (EkWaitList_ShowRank == 1) then
		EkWaitList_ShowRank = 0;
	else
		EkWaitList_ShowRank = 1;
	end
	EkWaitList_WaitFrame_ListUpdate();
end

function EkWaitList_WaitFrame_ToggleTimeButton_OnClick()
	-- ----------
	-- Toggle between added time and waited time.
	-- ----------
	if (EkWaitList_ShowWaitTime == 1) then
		EkWaitList_ShowWaitTime = 0;
	else
		EkWaitList_ShowWaitTime = 1;
	end
	EkWaitList_WaitFrame_ListUpdate();
end

function EkWaitList_WaitFrame_ShowMenu()
	-- ----------
	-- Show current menu
	-- ----------
	local menu = EkWaitList_WaitFrame_MenuNum;
	local sel  = EkWaitList_WaitFrame_Selected;
	local list = EkWaitList_WaitList;
	local sub;

	local mbut1 = EkWaitList_Frame_MenuButton1;
	local mbut2 = EkWaitList_Frame_MenuButton2;
	local mbut3 = EkWaitList_Frame_MenuButton3;
	local mbut4 = EkWaitList_Frame_MenuButton4;
	local mbut5 = EkWaitList_Frame_MenuButton5;
	local mbut6 = EkWaitList_Frame_MenuButton6;
	local mbut7 = EkWaitList_Frame_MenuButton7;
	local mbut8 = EkWaitList_Frame_MenuButton8;
	local mbut9 = EkWaitList_Frame_MenuButton9;

	local mbut21 = EkWaitList_Frame_MenuButton21;
	local mbut22 = EkWaitList_Frame_MenuButton22;
	local mbut23 = EkWaitList_Frame_MenuButton23;

	local msg = EkWaitList_WaitFrame_Message;
	local eb  = EkWaitList_WaitFrame_EB;

	local name, altname;

	-- -----
	-- EkWaitList_WaitFrame menus
	-- 
	-- 1 == Wait list: Main menu
	-- 2 == Wait list: Yes/No to remove player from list.
	-- 3 == Wait list: Whisper to name1/name2 name.
	-- 4 == Wait list: Invite to name1/name2 name.
	-- 5 == Wait list: Who name1/name2 name.
	-- 6 == Wait list: Yes/No to remove all of the players.
	-- 7 == Wait list: Send/Cancel to send wait list to a player.
	-- 8 == Wait list: Announce menu
	-- -----

	-- Send     Announce    Add
	-- Invite   Who         Edit
	-- Whisper  Remove all  Remove

	-- 7 8 9        7  8  9
	-- 4 5 6        4  5  6
	-- 1 2 3       21 22 23

	if (menu == 1) then
		-- -----
		-- Main menu
		-- -----
		msg:Hide();
		eb:Hide();

		mbut1:SetText(EkWaitList_TEXT_Menu1Button_Whisper);
		if ( #sel == 1 ) then
			mbut1:Enable();
		else
			mbut1:Disable();
		end
		mbut1:Show();

		if (#list == 0 or #sel ~= #list) then
			mbut2:SetText(EkWaitList_TEXT_Menu1Button_SelectAll);
		else
			mbut2:SetText(EkWaitList_TEXT_Menu1Button_UnselectAll);
		end
		if ( #list > 0 ) then
			mbut2:Enable();
		else
			mbut2:Disable();
		end
		mbut2:Show();

		mbut3:SetText(EkWaitList_TEXT_Menu1Button_Remove);
		if ( #sel > 0 ) then
			mbut3:Enable();
		else
			mbut3:Disable();
		end
		mbut3:Show();

		mbut4:SetText(EkWaitList_TEXT_Menu1Button_Invite);
		if ( #sel == 1 ) then
			mbut4:Enable();
		else
			mbut4:Disable();
		end
		mbut4:Show();

		mbut5:SetText(EkWaitList_TEXT_Menu1Button_Who);
		if ( #sel == 1 and	not EkWaitList_WaitFrame_WhoElapsed ) then
			mbut5:Enable();
		else
			mbut5:Disable();
		end
		mbut5:Show();

		mbut6:SetText(EkWaitList_TEXT_Menu1Button_Edit);
		if ( #sel == 1 ) then
			mbut6:Enable();
		else
			mbut6:Disable();
		end
		mbut6:Show();

		mbut7:SetText(EkWaitList_TEXT_Menu1Button_Send);
		if ( #list > 0 ) then
			mbut7:Enable();
		else
			mbut7:Disable();
		end
		mbut7:Show();

		mbut8:SetText(EkWaitList_TEXT_Menu1Button_Announce);
		mbut8:Enable();
		mbut8:Show();

		mbut9:SetText(EkWaitList_TEXT_Menu1Button_Add);
		mbut9:Enable();
		mbut9:Show();

		mbut21:Hide();
		mbut22:Hide();
		mbut23:Hide();

	elseif (menu == 2) then
		-- -----
		-- Yes/No to remove player from list.
		-- -----
		msg:SetJustifyH("CENTER");
		if ( #sel > 1 ) then
			msg:SetText(string.format(EkWaitList_TEXT_Menu2Msg_RemoveNumber, #sel));
		else
			sub = sel[1];
			name = EkWaitList_WaitList[sub]["name"];
			msg:SetText(string.format(EkWaitList_TEXT_Menu2Msg_RemoveName, name));
		end
		msg:Show();
		eb:Hide();

		mbut1:SetText(EkWaitList_TEXT_Menu2Button_Yes);
		mbut1:Enable();
		mbut1:Show();

		mbut2:Hide();

		mbut3:SetText(EkWaitList_TEXT_Menu2Button_No);
		mbut3:Enable();
		mbut3:Show();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		mbut21:Hide();
		mbut22:Hide();
		mbut23:Hide();

	elseif (menu == 3) then
		-- -----
		-- Whisper to name1/name2 name.
		-- -----
		sub = sel[1];
		name = EkWaitList_WaitList[sub]["name"];
		altname = EkWaitList_WaitList[sub]["altname"];

		mbut21.EkName = name;
		mbut22.EkName = altname;

		msg:SetText(EkWaitList_TEXT_Menu3Msg_Whisper);
		msg:SetJustifyH("CENTER");
		msg:Show();
		eb:Hide();

		mbut21:SetText(name);
		mbut21:Enable();
		mbut21:Show();

		if ( EkWaitList_IsEmpty(altname) ) then
			mbut22:Hide();
		else
			mbut22:SetText(altname);
			mbut22:Enable();
			mbut22:Show();
		end

		mbut23:SetText(EkWaitList_TEXT_Menu3Button_Cancel);
		mbut23:Enable();
		mbut23:Show();

		mbut1:Hide();
		mbut2:Hide();
		mbut3:Hide();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		if ( EkWaitList_IsEmpty(altname) ) then
			EkWaitList_WaitFrame_MenuButton_OnClick(21);
		end

	elseif (menu == 4) then
		-- -----
		-- Invite to name1/name2 name.
		-- -----
		sub = sel[1];
		name = EkWaitList_WaitList[sub]["name"];
		altname = EkWaitList_WaitList[sub]["altname"];

		mbut21.EkName = name;
		mbut22.EkName = altname;

		msg:SetText(EkWaitList_TEXT_Menu4Msg_Invite);
		msg:SetJustifyH("CENTER");
		msg:Show();
		eb:Hide();

		mbut21:SetText(name);
		mbut21:Enable();
		mbut21:Show();

		if ( EkWaitList_IsEmpty(altname) ) then
			mbut22:Hide();
		else
			mbut22:SetText(altname);
			mbut22:Enable();
			mbut22:Show();
		end

		mbut23:SetText(EkWaitList_TEXT_Menu4Button_Cancel);
		mbut23:Enable();
		mbut23:Show();

		mbut1:Hide();
		mbut2:Hide();
		mbut3:Hide();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		if ( EkWaitList_IsEmpty(altname) ) then
			EkWaitList_WaitFrame_MenuButton_OnClick(21);
		end

	elseif (menu == 5) then
		-- -----
		-- Who name1/name2 name.
		-- -----
		sub = sel[1];
		name = EkWaitList_WaitList[sub]["name"];
		altname = EkWaitList_WaitList[sub]["altname"];

		mbut21.EkName = name;
		mbut22.EkName = altname;

		msg:SetText(EkWaitList_TEXT_Menu5Msg_Who);
		msg:SetJustifyH("CENTER");
		msg:Show();
		eb:Hide();

		mbut21:SetText(name);
		mbut21:Enable();
		mbut21:Show();

		if ( EkWaitList_IsEmpty(altname) ) then
			mbut22:Hide();
		else
			mbut22:SetText(altname);
			mbut22:Enable();
			mbut22:Show();
		end

		mbut23:SetText(EkWaitList_TEXT_Menu5Button_Cancel);
		mbut23:Enable();
		mbut23:Show();

		mbut1:Hide();
		mbut2:Hide();
		mbut3:Hide();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		if ( EkWaitList_IsEmpty(altname) ) then
			EkWaitList_WaitFrame_MenuButton_OnClick(21);
		end

	elseif (menu == 6) then
		-- -----
		-- Yes/No to remove all of the players.
		-- -----
		msg:SetJustifyH("CENTER");
		msg:SetText(EkWaitList_TEXT_Menu6Msg_RemoveAll);
		msg:Show();
		eb:Hide();

		mbut1:SetText(EkWaitList_TEXT_Menu6Button_Yes);
		mbut1:Enable();
		mbut1:Show();

		mbut2:Hide();

		mbut3:SetText(EkWaitList_TEXT_Menu6Button_No);
		mbut3:Enable();
		mbut3:Show();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		mbut21:Hide();
		mbut22:Hide();
		mbut23:Hide();

	elseif (menu == 7) then
		-- -----
		-- Send/Cancel to send wait list to a player.
		-- -----
		msg:SetJustifyH("LEFT");
		msg:SetText(EkWaitList_TEXT_Menu7Msg_PlayerName);
		msg:Show();

		eb:SetWidth(150);
		eb:SetText(EkWaitList_SendWaitListTo);
		eb:HighlightText();
		eb.ekmode = 1;  -- edit
		eb.ekvalidate = 1;  -- validate as a player name
		eb:Show();

		mbut1:SetText(EkWaitList_TEXT_Menu7Button_Send);
		mbut1:Enable();
		mbut1:Show();

		mbut2:Hide();

		mbut3:SetText(EkWaitList_TEXT_Menu7Button_Cancel);
		mbut3:Enable();
		mbut3:Show();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		mbut21:Hide();
		mbut22:Hide();
		mbut23:Hide();

		eb:SetFocus();

	elseif (menu == 8) then
		-- -----
		-- Announce wait list to a channel.
		-- -----
		mbut1:SetText(EkWaitList_TEXT_Menu8Button_Channel);
		mbut1:Enable();
		mbut1:Show();

		mbut2:Hide();

		mbut3:SetText(EkWaitList_TEXT_Menu8Button_Cancel);
		mbut3:Enable();
		mbut3:Show();

		mbut4:SetText(EkWaitList_TEXT_Menu8Button_Officer);
		if (IsInGuild() and EkCanOfficerChat()) then
			mbut4:Enable();
		else
			mbut4:Disable();
		end
		mbut4:Show();

		mbut5:SetText(EkWaitList_TEXT_Menu8Button_Raid);
		if (GetNumRaidMembers() > 0) then
			mbut5:Enable();
		else
			mbut5:Disable();
		end
		mbut5:Show();

		mbut6:SetText(EkWaitList_TEXT_Menu8Button_Yell);
		mbut6:Enable();
		mbut6:Show();

		mbut7:SetText(EkWaitList_TEXT_Menu8Button_Guild);
		if (IsInGuild()) then
			mbut7:Enable();
		else
			mbut7:Disable();
		end
		mbut7:Show();

		mbut8:SetText(EkWaitList_TEXT_Menu8Button_Party);
		if (GetNumPartyMembers() > 0) then
			mbut8:Enable();
		else
			mbut8:Disable();
		end
		mbut8:Show();

		mbut9:SetText(EkWaitList_TEXT_Menu8Button_Say);
		mbut9:Enable();
		mbut9:Show();

		mbut21:Hide();
		mbut22:Hide();
		mbut23:Hide();

	elseif (menu == 9) then
		-- -----
		-- Announce/Cancel to announce wait list to a channel.
		-- -----
		msg:SetJustifyH("LEFT");
		msg:SetText(EkWaitList_TEXT_Menu9Msg_ChannelName);
		msg:Show();

		eb:SetWidth(150);
		eb:SetText(EkWaitList_AnnounceChannel);
		eb:HighlightText();
		eb.ekmode = 1;  -- edit
		eb.ekvalidate = 2;  -- validate as a channel name
		eb:Show();

		mbut1:SetText(EkWaitList_TEXT_Menu9Button_Announce);
		mbut1:Enable();
		mbut1:Show();

		mbut2:Hide();

		mbut3:SetText(EkWaitList_TEXT_Menu9Button_Cancel);
		mbut3:Enable();
		mbut3:Show();

		mbut4:Hide();
		mbut5:Hide();
		mbut6:Hide();

		mbut7:Hide();
		mbut8:Hide();
		mbut9:Hide();

		mbut21:Hide();
		mbut22:Hide();
		mbut23:Hide();

		eb:SetFocus();

	end

	if (EkWaitList_Frame_MenuButton_Over) then
		EkWaitList_Frame_MenuButton_OnEnter(EkWaitList_Frame_MenuButton_Over);
	else
		EkWaitList_Frame_MenuButton_OnLeave();
	end
end

function EkWaitList_WaitFrame_MenuButton_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in the current menu.
	-- ----------
	local menu = EkWaitList_WaitFrame_MenuNum;
	local name = "EkWaitList_WaitFrame_Menu" .. menu .. "_OnClick";
	local func = _G[name];
	if (func) then
		func(butNum);
	end
end

function EkWaitList_WaitFrame_MenuButton_OnEnter(butNum)
	-- ----------
	-- Mouse is over a menu button in the current menu.
	-- ----------
	local menu = EkWaitList_WaitFrame_MenuNum;
	local name = "EkWaitList_WaitFrame_Menu" .. menu .. "_OnEnter";
	local self = _G["EkWaitList_Frame_MenuButton" .. butNum];
	local func = _G[name];
	if (func) then
		func(self, butNum);
	end
end

function EkWaitList_WaitFrame_Menu1_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 1.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Whisper.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 3;  -- Wait list whisper menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 2) then
		-- -----
		-- Select/unselect all players.
		-- -----
		if (#EkWaitList_WaitFrame_Selected ~= #EkWaitList_WaitList) then
			-- Select all players.
			EkWaitList_WaitFrame_SelectAll();
		else
			-- Unselect all players.
			EkWaitList_WaitFrame_Selected = {};
		end
		EkWaitList_WaitFrame_ListUpdate();

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 3) then
		-- -----
		-- Remove player from list.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 2;  -- Yes/No menu to remove player from list.
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 4) then
		-- -----
		-- Invite.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 4;  -- Wait list invite menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 5) then
		-- -----
		-- Who.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 5;  -- Wait list who menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 6) then
		-- -----
		-- Edit player in the list.
		-- -----
		EkWaitList_WaitFrame_ShowEditPlayer();

	elseif (butNum == 7) then
		-- -----
		-- Send wait list to a player.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 7;  -- Wait list send menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 8) then
		-- -----
		-- Announce
		-- -----
		EkWaitList_WaitFrame_MenuNum = 8;  -- Announce menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 9) then
		-- -----
		-- Add player to the list.
		-- -----
		EkWaitList_WaitFrame_ShowAddPlayer();
	end
end

function EkWaitList_WaitFrame_Menu1_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 1.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Whisper.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Whisper_Tooltip1, EkWaitList_TEXT_Menu1Button_Whisper_Tooltip2);

	elseif (butNum == 2) then
		-- -----
		-- Remove all players.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_SelectAll_Tooltip1, EkWaitList_TEXT_Menu1Button_SelectAll_Tooltip2);

	elseif (butNum == 3) then
		-- -----
		-- Remove player from list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Remove_Tooltip1, EkWaitList_TEXT_Menu1Button_Remove_Tooltip2);

	elseif (butNum == 4) then
		-- -----
		-- Invite.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Invite_Tooltip1, EkWaitList_TEXT_Menu1Button_Invite_Tooltip2);

	elseif (butNum == 5) then
		-- -----
		-- Who.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Who_Tooltip1, EkWaitList_TEXT_Menu1Button_Who_Tooltip2);

	elseif (butNum == 6) then
		-- -----
		-- Edit player in the list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Edit_Tooltip1, EkWaitList_TEXT_Menu1Button_Edit_Tooltip2);

	elseif (butNum == 7) then
		-- -----
		-- Send wait list to player.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Send_Tooltip1, EkWaitList_TEXT_Menu1Button_Send_Tooltip2);

	elseif (butNum == 8) then
		-- -----
		-- Announce.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Announce_Tooltip1, EkWaitList_TEXT_Menu1Button_Announce_Tooltip2);

	elseif (butNum == 9) then
		-- -----
		-- Add player to the list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu1Button_Add_Tooltip1, EkWaitList_TEXT_Menu1Button_Add_Tooltip2);
	end
end

function EkWaitList_WaitFrame_Menu2_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 2.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Confirm deletion of player from list.
		-- -----
		if (#EkWaitList_WaitFrame_Selected == #EkWaitList_WaitList and #EkWaitList_WaitList > 1) then
			-- User is trying to remove all players.
			EkWaitList_WaitFrame_MenuNum = 6;  -- "Are you sure?"
			EkWaitList_WaitFrame_ShowMenu();
		else
			EkWaitList_WaitFrame_RemovePlayers(nil, nil);
			EkWaitList_WaitFrame_ListUpdate();

			EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
			EkWaitList_WaitFrame_ShowMenu();
		end

	elseif (butNum == 3) then
		-- -----
		-- Deny deletion of player from list.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	end
end

function EkWaitList_WaitFrame_Menu2_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 2.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Confirm deletion of player from list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu2Button_Yes_Tooltip1, EkWaitList_TEXT_Menu2Button_Yes_Tooltip2);

	elseif (butNum == 3) then
		-- -----
		-- Deny deletion of player from list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu2Button_No_Tooltip1, EkWaitList_TEXT_Menu2Button_No_Tooltip2);

	end
end

function EkWaitList_WaitFrame_Menu3_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 3.
	-- ----------
	if (butNum == 21) then
		-- -----
		-- Whisper to name1 name.
		-- -----
		local mbut21 = EkWaitList_Frame_MenuButton21;
		EkWaitList_WaitFrame_Whisper(mbut21.EkName);

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 22) then
		-- -----
		-- Whisper to name1 name.
		-- -----
		local mbut22 = EkWaitList_Frame_MenuButton22;
		EkWaitList_WaitFrame_Whisper(mbut22.EkName);

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 23) then
		-- -----
		-- Cancel whisper
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();
	end
end

function EkWaitList_WaitFrame_Menu3_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 3.
	-- ----------
	if (butNum == 21) then
		-- -----
		-- Whisper to player's name1 character.
		-- -----
		local mbut21 = EkWaitList_Frame_MenuButton21;
		EkWaitList_SetTooltip_Corner(self, string.format(EkWaitList_TEXT_Menu3Button_Name_Tooltip1, mbut21.EkName), string.format(EkWaitList_TEXT_Menu3Button_Name_Tooltip2, mbut21.EkName));

	elseif (butNum == 22) then
		-- -----
		-- Whisper to player's name2 character.
		-- -----
		local mbut22 = EkWaitList_Frame_MenuButton22;
		EkWaitList_SetTooltip_Corner(self, string.format(EkWaitList_TEXT_Menu3Button_Name_Tooltip1, mbut22.EkName), string.format(EkWaitList_TEXT_Menu3Button_Name_Tooltip2, mbut22.EkName));

	elseif (butNum == 23) then
		-- -----
		-- Cancel whisper.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu3Button_Cancel_Tooltip1, EkWaitList_TEXT_Menu3Button_Cancel_Tooltip2);
	end
end

function EkWaitList_WaitFrame_Menu4_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 4.
	-- ----------
	if (butNum == 21) then
		-- -----
		-- Invite name1 name.
		-- -----
		local mbut21 = EkWaitList_Frame_MenuButton21;
		EkWaitList_WaitFrame_Invite(mbut21.EkName);

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 22) then
		-- -----
		-- Invite name1 name.
		-- -----
		local mbut22 = EkWaitList_Frame_MenuButton22;
		EkWaitList_WaitFrame_Invite(mbut22.EkName);

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 23) then
		-- -----
		-- Cancel invite
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();
	end
end

function EkWaitList_WaitFrame_Menu4_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 4.
	-- ----------
	if (butNum == 21) then
		-- -----
		-- Invite the player's character.
		-- -----
		local mbut21 = EkWaitList_Frame_MenuButton21;
		EkWaitList_SetTooltip_Corner(self, string.format(EkWaitList_TEXT_Menu4Button_Name_Tooltip1, mbut21.EkName), string.format(EkWaitList_TEXT_Menu4Button_Name_Tooltip2, mbut21.EkName));

	elseif (butNum == 22) then
		-- -----
		-- Invite the player's character.
		-- -----
		local mbut22 = EkWaitList_Frame_MenuButton22;
		EkWaitList_SetTooltip_Corner(self, string.format(EkWaitList_TEXT_Menu4Button_Name_Tooltip1, mbut22.EkName), string.format(EkWaitList_TEXT_Menu4Button_Name_Tooltip2, mbut22.EkName));

	elseif (butNum == 23) then
		-- -----
		-- Cancel invite.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu4Button_Cancel_Tooltip1, EkWaitList_TEXT_Menu4Button_Cancel_Tooltip2);
	end
end

function EkWaitList_WaitFrame_Menu5_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 5.
	-- ----------
	if (butNum == 21) then
		-- -----
		-- WHO name1 name.
		-- -----
		local mbut21 = EkWaitList_Frame_MenuButton21;
		EkWaitList_WaitFrame_Who(mbut21.EkName);

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 22) then
		-- -----
		-- WHO name1 name.
		-- -----
		local mbut22 = EkWaitList_Frame_MenuButton22;
		EkWaitList_WaitFrame_Who(mbut22.EkName);

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 23) then
		-- -----
		-- Cancel who
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();
	end
end

function EkWaitList_WaitFrame_Menu5_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 5.
	-- ----------
	if (butNum == 21) then
		-- -----
		-- Show /WHO infor for the player's name1 character.
		-- -----
		local mbut21 = EkWaitList_Frame_MenuButton21;
		EkWaitList_SetTooltip_Corner(self, string.format(EkWaitList_TEXT_Menu5Button_Name_Tooltip1, mbut21.EkName), string.format(EkWaitList_TEXT_Menu5Button_Name_Tooltip2, mbut21.EkName));

	elseif (butNum == 22) then
		-- -----
		-- Show /WHO infor for the player's name2 character.
		-- -----
		local mbut22 = EkWaitList_Frame_MenuButton22;
		EkWaitList_SetTooltip_Corner(self, string.format(EkWaitList_TEXT_Menu5Button_Name_Tooltip1, mbut22.EkName), string.format(EkWaitList_TEXT_Menu5Button_Name_Tooltip2, mbut22.EkName));

	elseif (butNum == 23) then
		-- -----
		-- Cancel who.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu5Button_Cancel_Tooltip1, EkWaitList_TEXT_Menu5Button_Cancel_Tooltip2);
	end
end

function EkWaitList_WaitFrame_Menu6_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 6.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Confirm deletion of all players from list.
		-- -----
		EkWaitList_WaitFrame_RemovePlayers("all", nil);
		EkWaitList_WaitFrame_ListUpdate();

		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	elseif (butNum == 3) then
		-- -----
		-- Cancel remove all
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	end
end

function EkWaitList_WaitFrame_Menu6_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 6.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Confirm deletion of all players from list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu6Button_Yes_Tooltip1, EkWaitList_TEXT_Menu6Button_Yes_Tooltip2);

	elseif (butNum == 3) then
		-- -----
		-- Deny deletion of all players from list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu6Button_No_Tooltip1, EkWaitList_TEXT_Menu6Button_No_Tooltip2);

	end
end

function EkWaitList_WaitFrame_Menu7_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 7.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Confirm sending of wait list to player.
		-- -----
		EkWaitList_WaitFrame_Confirm_SendWaitList();

	elseif (butNum == 3) then
		-- -----
		-- Cancel sending of wait list.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();

	end
end

function EkWaitList_WaitFrame_Menu7_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 7.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Confirm sending of wait list to player.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu7Button_Send_Tooltip1, EkWaitList_TEXT_Menu7Button_Send_Tooltip2);

	elseif (butNum == 3) then
		-- -----
		-- Cancel sending of wait list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu7Button_Cancel_Tooltip1, EkWaitList_TEXT_Menu7Button_Cancel_Tooltip2);

	end
end

function EkWaitList_WaitFrame_Menu8_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 8.
	-- ----------
	if (butNum == 1) then
		EkWaitList_WaitFrame_MenuNum = 9;  -- Channel name menu
		EkWaitList_WaitFrame_ShowMenu();
		return;

	elseif (butNum == 3) then
		-- Cancel
	elseif (butNum == 4) then
		EkWaitList_Command_Announce("officer");
	elseif (butNum == 5) then
		EkWaitList_Command_Announce("raid");
	elseif (butNum == 6) then
		EkWaitList_Command_Announce("yell");
	elseif (butNum == 7) then
		EkWaitList_Command_Announce("guild");
	elseif (butNum == 8) then
		EkWaitList_Command_Announce("party");
	elseif (butNum == 9) then
		EkWaitList_Command_Announce("say");
	end
	EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
	EkWaitList_WaitFrame_ShowMenu();
end

function EkWaitList_WaitFrame_Menu8_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 8.
	-- ----------
	EkWaitList_HideTooltip();
end

function EkWaitList_WaitFrame_Menu9_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 9.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Announce wait list over channel.
		-- -----
		EkWaitList_WaitFrame_Confirm_AnnounceWaitList();

	elseif (butNum == 3) then
		-- -----
		-- Cancel announcing of wait list.
		-- -----
		EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
		EkWaitList_WaitFrame_ShowMenu();
	end
end

function EkWaitList_WaitFrame_Menu9_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 9.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Announce wait list over channel.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu9Button_Announce_Tooltip1, EkWaitList_TEXT_Menu9Button_Announce_Tooltip2);

	elseif (butNum == 3) then
		-- -----
		-- Cancel announcing of wait list.
		-- -----
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu9Button_Cancel_Tooltip1, EkWaitList_TEXT_Menu9Button_Cancel_Tooltip2);

	end
end

function EkWaitList_WaitFrame_Confirm_SendWaitList()
	-- ----------
	-- Confirm sending of wait list to a player.
	-- ----------
	local eb = EkWaitList_WaitFrame_EB;
	local name = eb:GetText();

	EkWaitList_SendWaitListTo = name;
	EkWaitList_Whisper_WaitList_Send(EkWaitList_SendWaitListTo);

	EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
	EkWaitList_WaitFrame_ShowMenu();
end

function EkWaitList_WaitFrame_Confirm_AnnounceWaitList()
	-- ----------
	-- Confirm announcing of wait list over a channel.
	-- ----------
	local eb = EkWaitList_WaitFrame_EB;
	EkWaitList_AnnounceChannel = eb:GetText();
	EkWaitList_Command_Announce(EkWaitList_AnnounceChannel);

	EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu
	EkWaitList_WaitFrame_ShowMenu();
end

function EkWaitList_WaitFrame_EB_EditStart()
	-- ----------
	-- Start editing the player name (or channel name).
	-- ----------
	local eb = EkWaitList_WaitFrame_EB;

	if ( eb.editing ) then
		return;
	end

	eb.editing = 1;
	eb:HighlightText();
	eb:SetFocus();
end

function EkWaitList_WaitFrame_EB_EditStop(cancel)
	-- ----------
	-- User has stopped editing the player name (or channel name).
	-- ----------
	local eb = EkWaitList_WaitFrame_EB;
	local value;

	if ( not eb.editing ) then
		return;
	end

	value = eb:GetText();

	eb:HighlightText(0, 0);
	eb.editing = nil;

	if ( cancel ) then
		EkWaitList_WaitFrame_MenuNum = 1;  -- WaitFrame main menu
		EkWaitList_WaitFrame_ShowMenu();
	end
end

function EkWaitList_WaitFrame_EB_ValidPlayer()
	-- ----------
	-- Validate the player name being edited.
	-- ----------
	local eb   = EkWaitList_WaitFrame_EB;
	local text = strlower_utf8(eb:GetText());
	local result, valid, msg;
	local status = EkWaitList_WaitFrame_EBStatus;
	local rec;

	result = 0;

	-- Don't allow a blank name.
	if ( EkWaitList_IsEmpty(text) ) then
		result = 1;  -- Name is blank.
	end

	if (result == 0) then
		if (EkWaitList_IsNameInGuild(text) == 0) then
			if (IsInGuild()) then
				result = 3;  -- Name is not in guild.
			end
		end
	end

	msg = nil;
	valid = false;

	if (result == 0) then
		valid = true;
	elseif (result == 1) then
		-- Cannot be blank.
	elseif (result == 3) then
		msg = EkWaitList_TEXT_List_EditBox_NotInGuild;
		valid = true;
	end

	if (msg) then
		status:SetText(msg);
		status:Show();
	else
		status:Hide();
	end

	return valid;
end

function EkWaitList_WaitFrame_EB_ValidChannel()
	-- ----------
	-- Validate the channel name being edited.
	-- ----------
	local eb   = EkWaitList_WaitFrame_EB;
	local text = strlower(eb:GetText());
	local result, valid, msg;
	local status = EkWaitList_WaitFrame_EBStatus;
	local rec;

	result = 0;

	-- Don't allow a blank name.
	if ( EkWaitList_IsEmpty(text) ) then
		result = 1;  -- Name is blank.
	end

	msg = nil;
	valid = false;

	if (result == 0) then
		valid = true;
	elseif (result == 1) then
		-- Cannot be blank.
	end

	if (msg) then
		status:SetText(msg);
		status:Show();
	else
		status:Hide();
	end

	return valid;
end

function EkWaitList_WaitFrame_EB_Changed(self)
	-- ----------
	-- The editbox contents have changd.
	-- ----------
	local mbut1 = EkWaitList_Frame_MenuButton1;

	local v = self.ekvalidate;
	if (not v) then
		return;
	end

	local valid;
	if (v == 1) then
		-- Validate player name
		valid = EkWaitList_WaitFrame_EB_ValidPlayer();

	elseif (v == 2) then
		valid = EkWaitList_WaitFrame_EB_ValidChannel();

	else
		valid = true;
	end

	if ( valid ) then
		mbut1:Enable();
	else
		mbut1:Disable();
	end
end

function EkWaitList_WaitFrame_EB_OnEnterPressed(self)
	-- ----------
	-- User pressed the enter key.
	-- ----------
	if (self.ekvalidate == 1) then
		if ( EkWaitList_WaitFrame_EB_ValidPlayer() ) then
			self:ClearFocus();
			EkWaitList_WaitFrame_Confirm_SendWaitList();
		end
	elseif (self.ekvalidate == 2) then
		if ( EkWaitList_WaitFrame_EB_ValidChannel() ) then
			self:ClearFocus();
			EkWaitList_WaitFrame_Confirm_AnnounceWaitList();
		end
	end
end

function EkWaitList_WaitFrame_EB_OnEnter(self)
	-- ----------
	-- Mouse is over the edit box.
	-- ----------
	if (self.ekvalidate == 1) then
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu7EB_Tooltip1, EkWaitList_TEXT_Menu7EB_Tooltip2);
	elseif (self.ekvalidate == 2) then
		EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_Menu9EB_Tooltip1, EkWaitList_TEXT_Menu9EB_Tooltip2);
	end
end

function EkWaitList_WaitFrame_EB_OnChar(self)
	-- ----------
	-- User typed a character in the edit box.
	-- ----------
	if (self.ekvalidate == 1) then
		EkWaitList_Name_AutoComplete(self);
	end
end


function EkWaitList_WaitFrame_RemovePlayerByName(name, why)
	-- ----------
	-- Remove a player name from the wait list.
	--
	-- name -- Must match the primary or secondary name stored in the wait list.
	--         Does not check against main names.
	--
	-- Returns number of players removed from wait list.
	-- ----------
	local list = EkWaitList_WaitList;
	local del_sel = {};
	local len;
	local lowername = strlower_utf8(name);

	if (strlen(name) == 0) then
		return 0;
	end

	len = #list;

	-- Create a selection list
	for i=1, len, 1 do
		if (strlower_utf8(list[i]["name"]) == lowername or strlower_utf8(list[i]["altname"]) == lowername) then
			table.insert(del_sel, i);
			break;
		end
	end

	-- Remove selected players from the wait list.
	return EkWaitList_WaitFrame_RemovePlayers2(del_sel, why);
end

function EkWaitList_WaitFrame_RemoveAllPlayers(why)
	-- ----------
	-- Remove all players from the wait list.
	--
	-- Returns number of players removed from wait list.
	-- ----------
	local list = EkWaitList_WaitList;
	local del_sel = {};
	local len;

	len = #list;

	-- Create a selection list with all items in it.
	for i=1, len, 1 do
		table.insert(del_sel, i);
	end

	-- Remove selected players from the wait list.
	return EkWaitList_WaitFrame_RemovePlayers2(del_sel, why);
end

function EkWaitList_WaitFrame_RemovePlayers(all, why)
	-- ----------
	-- Remove selected (or all) players from the wait list.
	--
	-- Returns number of players removed from wait list.
	-- ----------
	local count;

	if (all) then
		-- Remove all players from the wait list
		count = EkWaitList_WaitFrame_RemoveAllPlayers(why);
	else
		-- Remove selected players from the wait list
		count = EkWaitList_WaitFrame_RemovePlayers2(nil, why);
	end

	return count;
end

function EkWaitList_WaitFrame_RemovePlayers2(del_array, why)
	-- ----------
	-- Remove selected players from the wait list.
	--
	-- Returns number of players removed from wait list.
	-- ----------
	local del_sub, del_len, del_sel;
	local sel_sub, sel_len, sel_sel;
	local close_editpane = nil;
	local name, text, count;
	local d, s, a;
	local list = EkWaitList_WaitList;
	local msg;

	-- The selection array.
	sel_sel = EkWaitList_WaitFrame_Selected;
	sel_len = #sel_sel;

	-- The deletion array.
	if (del_array) then
		-- We were passed a deletion array (ie. we're not just
		-- using the selection array to perform the deletions).
		del_sel = del_array;
	else
		-- Creat a deletion list using the items in the selection array.
		del_sel = {};
		for i=1, sel_len, 1 do
			table.insert(del_sel, sel_sel[i]);
		end
	end
	del_len = #del_sel;

	-- Build a string containing names of those players being removed.
	text = "";
	count = 0;
	for i=1, del_len, 1 do
		del_sub = del_sel[i];
		name = list[del_sub]["name"];

		if ( text ~= "" ) then
			text = text .. ", ";
		end
		text = text .. name;

		count = count + 1;
	end

	if (count == 1) then
		-- Only a single name was deleted.
		local sub = del_sel[1];
		local alt = list[sub]["altname"];

		-- Removed name1
		-- Removed name1/name2

		-- Start out with the name.
		name = text;

		local main = EkWaitList_GetMainName(name);
		if (main and main ~= name) then
			text = text .. " [" .. main .. "]";
		end

		-- Add alt name if available.
		if (alt ~= "") then
			text = text .. " / " .. alt;

			local main = EkWaitList_GetMainName(alt);
			if (main and main ~= alt) then
				text = text .. " [" .. main .. "]";
			end
		end

		msg = string.format(EkWaitList_TEXT_Msg_Remove_Name, text);

	elseif (count > 0) then
		-- Deleted multiple names.
		msg = string.format(EkWaitList_TEXT_Msg_Remove_Count_Names, count, text);

	else
		-- No names were deleted.
		msg = string.format(EkWaitList_TEXT_Msg_Remove_Count, count);
	end

	if (why) then
		msg = msg .. " (" .. why .. ")";
	end

	EkWaitList_Print(msg .. ".");


	-- If the user is editing an item that we are going to remove, then
	-- set a flag so we can close the edit pane.
	-- When editing, the selection length is 1 (a selection length of 1 however,
	-- does not always mean the user is editing something).
	close_editpane = nil;
	if (sel_len == 1) then
		-- If we are deleting the subscript that the user might be editing, then set the flag.
		sel_sub = sel_sel[1];
		for i=1, del_len do
			if (del_sel[i] == sel_sub) then
				close_editpane = 1;
				break;
			end
		end
	end
	
	-- Remove the items from the main list.
	for i=del_len, 1, -1 do
		local sub = del_sel[i];
		local delpos = EkWaitList_WaitList[sub]["pos"];
		local pos;

		table.remove(EkWaitList_WaitList, sub);

		-- Adjust the position values to account for the removed one.
		for j=1, #EkWaitList_WaitList do
			pos = EkWaitList_WaitList[j]["pos"];
			if (pos > delpos) then
				EkWaitList_WaitList[j]["pos"] = pos - 1;
			end
		end
	end

	-- Adjust the values of selection array items to account for
	-- the deletion of items specified in the deletion array.

	d = 1;  -- deletion array subscript
	s = 1;  -- selection array subscript
	a = 0;  -- current amount to adjust selection array subscripts by

	while (d <= del_len and s <= sel_len) do
		if (del_sel[d] == sel_sel[s]) then
			-- Remove this item from selection array.
			table.remove(sel_sel, s);
			sel_len = sel_len - 1;

			d = d + 1;
			a = a + 1;

		elseif (del_sel[d] < sel_sel[s]) then
			-- Deleting an item not in the selection array.
			d = d + 1;
			a = a + 1;

		else
			-- Adjust values that we've passed in the selection array so far.
			while (del_sel[d] > sel_sel[s]) do
				sel_sel[s] = sel_sel[s] - a;
				s = s + 1;
				if (s > sel_len) then
					break;
				end
			end
		end
	end

	-- If there are still selection array items to examine, then
	-- we've run out of deletion array items.
	-- Adjust the rest of the values in the selection array.
	while (s <= sel_len) do
		sel_sel[s] = sel_sel[s] - a;
		s = s + 1;
	end

	EkWaitList_WaitFrame_Refresh_List(close_editpane);

	return count;
end

function EkWaitList_WaitFrame_Refresh_List(close_editpane)
	-- ----------
	-- Called after deleting something from the wait list, or when
	-- the wait list is replaced by a new one.
	-- ----------

	if (EkWaitList_Frame_GetTab() == EkWaitList_Frame_TabWait) then
		if (EkWaitList_Frame_:IsShown()) then
			if (EkWaitList_WaitFrame_Mode == 2) then
				-- The edit pane is open.
				-- If we need to close the edit pane
				if (close_editpane) then
					-- Switch to the wait list pane.
					EkWaitList_WaitFrame_Mode = 0;
					EkWaitList_Frame_GotoTab(EkWaitList_Frame_TabWait);
				end

			elseif (EkWaitList_WaitFrame_Mode == 0) then
				-- The wait list pane is open.
				EkWaitList_WaitFrame_ListUpdate();
			end

			if (EkWaitList_WaitFrame_Mode == 1 or EkWaitList_WaitFrame_Mode == 2) then
				-- Validate edit frame in case someone is adding/editing when deletion occurs.
				EkWaitList_EditFrame_Validate();
			end
		end
	end
end

function EkWaitList_WaitFrame_IsOnWaitList(name, startPos)
	-- ----------
	-- Test if specified name is on the wait list.
	--
	-- name -- name to search for.
	-- startPos -- Wait list position to start searching at.
	--
	-- Return1: a) nil if name was not found.
	--          b) Position within wait list (1 - array length).
	--
	-- Return2: Which wait list name matched the one specified (1==Name1, 2==Name2).
	--
	-- Return3: The Name1 name at the wait list position.
	--
	-- Return4: The Name2 name at the wait list position.
	--
	-- Return5: a) nil == We matched on the specified name rather than the main name.
	--          b) Main name of the specified name. This is the name that we actually matched.
	--
	-- Return6: a) nil == We matched on the wait list member's name rather than their main name.
	--          b) Main name of the wait list member's name. This is the name that we actually matched.
	-- ----------
	local plist = EkWaitList_WaitList;
	local pos, whichName;
	local main, name1, name2, name1Main, name2Main;
	local mainA, mainB;
	local lowMain, lowName1, lowName2, lowName1Main, lowName2Main;
	local lowName;

	if (startPos == nil) then
		startPos = 1;
	end

	lowName = strlower_utf8(name);
	if (EkWaitList_IsEmpty(lowName)) then
		-- Name not found.
		return nil;
	end

	-- Get main name of this character
	main = EkWaitList_GetMainName(name);
	if (main) then
		lowMain = strlower_utf8(main);
	end

	pos = nil;

	-- First pass: Don't check any main names.
	for i = startPos, #plist, 1 do

		name1 = plist[i]["name"];
		name2 = plist[i]["altname"]

		lowName1 = strlower_utf8(name1);
		lowName2 = strlower_utf8(name2);

		-- -----
		-- Compare name against name1 and name2.
		-- -----
		if (lowName == lowName1) then
			-- Name is on the wait list as name1.
			pos = i;
			whichName = 1;
			break;
		end
		if (lowName == lowName2) then
			-- Name is on the wait list as name2.
			pos = i;
			whichName = 2;
			break;
		end
	end

	if (pos) then
		return pos, whichName, plist[pos]["name"], plist[pos]["altname"];
	end

	-- Second pass: Check main names.
	for i = startPos, #plist, 1 do

		name1 = plist[i]["name"];
		name2 = plist[i]["altname"]

		lowName1 = strlower_utf8(name1);
		lowName2 = strlower_utf8(name2);

		name1Main = EkWaitList_GetMainName(name1);
		name2Main = EkWaitList_GetMainName(name2);

		if (name1Main) then
			lowName1Main = strlower_utf8(name1Main);
		end
		if (name2Main) then
			lowName2Main = strlower_utf8(name2Main);
		end

		-- -----
		-- Compare main against name1 and name2.
		-- -----
		if (lowMain) then
			if (lowMain == lowName1) then
				-- Name's main is on the wait list as name1.
				pos = i;
				whichName = 1;
				mainA = main;
				break;
			end
			if (lowMain == lowName2) then
				-- Name's main is on the wait list as name2.
				pos = i;
				whichName = 2;
				mainA = main;
				break;
			end
		end

		-- -----
		-- Compare name against name1's main and name2's main.
		-- -----
		if (lowName1Main and lowName == lowName1Main) then
			-- Name is on the wait list as name1's main.
			pos = i;
			whichName = 1;
			mainB = name1Main;
			break;
		end

		if (lowName2Main and lowName == lowName2Main) then
			-- Name is on the wait list as name2's main.
			pos = i;
			whichName = 2;
			mainB = name2Main;
			break;
		end


		-- -----
		-- Compare main against name1's main and name2's main.
		-- -----
		if (lowMain) then
			if (lowName1Main and lowMain == lowName1Main) then
				-- Name's main is on the wait list as name1's main.
				pos = i;
				whichName = 1;
				mainA = main;
				mainB = name1Main;
				break;
			end

			if (lowName2Main and lowMain == lowName2Main) then
				-- Name's main is on the wait list as name2's main.
				pos = i;
				whichName = 2;
				mainA = main;
				mainB = name2Main;
				break;
			end
		end

	end

	if (pos) then
		return pos, whichName, plist[pos]["name"], plist[pos]["altname"], mainA, mainB;
	end

	-- Name not found.
	return nil;
end

function EkWaitList_WaitFrame_IsInGroup(name)
	-- -----------
	-- Test if specified name is in the party/raid.
	--
	-- Return1: a) nil if name not found.
	--          b) Position in the raid where name was found (1 to number of raid members).
	--          c) Position in the party where name was found (0=Player, or 1 to number of party members).
	--
	-- Return2: Type of group that the name was found in ("raid" or "party").
	--
	-- Return3: Unit id for the found name (eg. "party1", "raid10", "player").
	--
	-- Return4: UnitName() of the unit id (ie. the name at the group position where we found a match),
	--          Note: This name may not equal the specified name (we may have matched on a main name).
	--
	-- Return5: a) nil == We matched on the specified name rather than the main name.
	--          b) Main name of the specified name. This is the name that we actually matched.
	--
	-- Return6: a) nil == We matched on the group member's name rather than their main name.
	--          b) Main name of the group member's name. This is the name that we actually matched.
	-- -----------
	local main, unitName, unitMain;
	local main1, main2;
	local lowMain, lowUnitName, lowUnitMain;
	local lowName;
	local numMembers, minCount, unitType, unitId;
	local pos, id;
	
	lowName = strlower_utf8(name);
	if (EkWaitList_IsEmpty(lowName)) then
		-- Name not found.
		return nil;
	end

	-- Get main name of this character
	main = EkWaitList_GetMainName(name);
	if (main) then
		lowMain = strlower_utf8(main);
	end

	numMembers = GetNumRaidMembers();
	if (numMembers == 0) then
		numMembers = GetNumPartyMembers();
		minCount = 0;
		unitType = "party";
	else
		minCount = 1;
		unitType = "raid";
	end

	pos = nil;

	-- First pass: Don't check any main names.
	-- Try for an exact match of the name we are looking for in case
	-- there are alternates in the raid.
	for i = minCount, numMembers do
		if (i == 0) then
			unitId = "player";
		else
			unitId = unitType .. i;
		end

		if (UnitExists(unitId)) then
			unitName = UnitName(unitId);
		else
			unitName = nil;
		end
		if (unitName) then
			lowUnitName = strlower_utf8(unitName);

			if (lowName == lowUnitName) then
				-- Name is in the raid as unitName.
				pos = i;
				id = unitId;
				break;
			end
		end
	end

	if (pos) then
		return pos, unitType, unitId, UnitName(unitId);
	end

	-- Second pass: Check main names.
	for i = minCount, numMembers do
		if (i == 0) then
			unitId = "player";
		else
			unitId = unitType .. i;
		end

		if (UnitExists(unitId)) then
			unitName = UnitName(unitId);
		else
			unitName = nil;
		end
		if (unitName) then
			lowUnitName = strlower_utf8(unitName);

			if (lowMain and lowMain == lowUnitName) then
				-- Name's main is in the raid as unitName.
				pos = i;
				id = unitId;
				main1 = main;
				break;
			end

			unitMain = EkWaitList_GetMainName(unitName);
			if (unitMain) then
				lowUnitMain = strlower_utf8(unitMain);
			end

			if (lowUnitMain) then
				if (lowName == lowUnitMain) then
					-- Name is in the raid as unitName's main.
					pos = i;
					id = unitId;
					main2 = unitMain;
					break;
				end
				if (lowMain and lowMain == lowUnitMain) then
					-- Name's main is in the raid as unitName's main.
					pos = i;
					id = unitId;
					main1 = main;
					main2 = unitMain;
					break;
				end
			end
		end
	end

	if (pos) then
		return pos, unitType, unitId, UnitName(unitId), main1, main2;
	end

	return nil;
end

function EkWaitList_WaitFrame_RemoveMembers()
	-- ----------
	-- If someone in the wait list is also in the party/raid, then remove them from the wait list.
	-- ----------
	local name;
	local numMembers, minMember, unitType, unitId;

	numMembers = GetNumRaidMembers();
	if (numMembers == 0) then
		minMember = 0;
		numMembers = GetNumPartyMembers();
		unitType = "party";  -- used with UnitName()
	else
		minMember = 1;
		unitType = "raid";
	end

	for r = minMember, numMembers do
		local isInGroup;

		if (r == 0) then
			unitId = "player";
		else
			unitId = unitType .. r;
		end
		if (UnitExists(unitId)) then
			name = UnitName(unitId);
		else
			name = nil;
		end
		if (name) then

			local waitSub, whichName, primary, secondary, mainA, mainB;
			repeat
				-- Test if the name is on the wait list.
				waitSub, whichName, primary, secondary, mainA, mainB = EkWaitList_WaitFrame_IsOnWaitList(name);

				if (waitSub) then
					-- Name is on the wait list.
	
					if (not isInGroup) then
						-- Only print this line once per raid member loop.
						local text = name;
						local main = EkWaitList_GetMainName(name);
						if (main and main ~= name) then
							text = text .. " [" .. main .. "]";
						end

						if (unitType == "party") then
							-- name is in the party
							isInGroup = string.format(EkWaitList_TEXT_Msg_RemoveMembers_NameIsInParty, text);
						else
							-- name is in the raid
							isInGroup = string.format(EkWaitList_TEXT_Msg_RemoveMembers_NameIsInRaid, text);
						end

						EkWaitList_Print(isInGroup);
					end
	
					local count = EkWaitList_WaitFrame_RemovePlayerByName(primary, nil);
					if (count == 0) then
						break;
					end
				end

			until waitSub == nil;
		end
	end
end

function EkWaitList_WaitFrame_AddPlayer(mode, name, tellName)
	-- ----------
	-- Add player to the wait list.
	--
	-- Param: mode -- 1 == Add by command (eg. /ekwl add Joe)
	--                2 == Add by whisper (eg. /tell Sue wl add)
	--
	-- Param: name -- name of the person to add (this name will be recorded in wait list attendance).
	-- Param: tellName -- name of the person to whisper to (if mode == 2).
	-- ----------
	local name1, name2;

	local addMode, valid, msg, result, pos, val1;
	local name0, mainA, mainB;

	name1 = EkWaitList_NormalizeName(name);
	name2 = "";
	addMode = true;

	result, pos, val1, name0, mainA, mainB = EkWaitList_EditFrame_Name_Valid(1, name1, name2, addMode);

	msg = nil;
	valid = false;

	if (result == 0) then
		valid = true;

	elseif (result == 1) then
		-- You must specify a name.
		msg = EkWaitList_TEXT_Msg_Add_Must_Specify_Name;

	elseif (result == 2) then
		-- The specified name contains a space.
		msg = EkWaitList_TEXT_Msg_Add_Contains_Space;

	elseif (result == 3) then
		-- The second name is the same as the first name.
		msg = EkWaitList_TEXT_Msg_Add_Second_Equals_First;

	elseif (result == 4) then
		if (mode == 1) then
			-- Note: name1 is not in the guild.
			msg = string.format(EkWaitList_TEXT_Msg_Add_Not_In_Guild, name1);
			valid = true;
		else
			if (EkWaitList_Whispers_wlNonGuild == 1) then
				valid = true;
			else
				-- You must be in the same guild as the person running the wait list in order to use the wait list add command.
				msg = EkWaitList_TEXT_Msg_Add_Must_Be_In_Guild;
			end
		end

	elseif (result == 5) then

		local pri = EkWaitList_WaitList[pos]["name"];
		local sec = EkWaitList_WaitList[pos]["altname"];

		local main1, main2;

		local text = pri;
		main1 = EkWaitList_GetMainName(pri);
		if (main1 and main1 ~= pri) then
			text = text .. " [" .. main1 .. "]";
		end
		if (sec ~= "") then
			text = text .. " / " .. sec;
			main2 = EkWaitList_GetMainName(sec);
			if (main2 and main2 ~= sec) then
				text = text .. " [" .. main2 .. "]";
			end
		end

		if (not main1) then
			main1 = "";
		end
		if (not main2) then
			main2 = "";
		end

		if (mode == 1 and pri ~= name1 and sec ~= name1 and main1 ~= name1 and main2 ~= name1) then
			local text = name1;
			local main = EkWaitList_GetMainName(name1);
			if (main and main ~= name1) then
				text = text .. " [" .. main .. "]";
			end
			EkWaitList_Print(string.format(EkWaitList_TEXT_Msg_Add_Searching_Name, text));
		end


		-- name is in the list
		msg = string.format(EkWaitList_TEXT_Msg_Add_Name_On_Waitlist, text);

	elseif (result == 6 or result == 7) then

		local text = name0;
		local main = EkWaitList_GetMainName(name0);
		if (main and main ~= name0) then
			text = text .. " [" .. main .. "]";
		end

		if (mode == 1 and name0 ~= name1 and main ~= name1) then
			local text = name1;
			local main = EkWaitList_GetMainName(name1);
			if (main and main ~= name1) then
				text = text .. " [" .. main .. "]";
			end
			EkWaitList_Print(string.format(EkWaitList_TEXT_Msg_Add_Searching_Name, text));
		end

		if (result == 6) then
			-- name is in the party
			msg = string.format(EkWaitList_TEXT_Msg_Add_In_Party, text);

		elseif (result == 7) then
			-- name is in the raid
			msg = string.format(EkWaitList_TEXT_Msg_Add_In_Raid, text);

		end
	else
		msg = string.format(EkWaitList_TEXT_Msg_Add_Unable_To_Add, name1);
	end

	if (msg) then
		if (mode == 1) then
			EkWaitList_Print(msg);
		else
			EkWaitList_SendWhisper(msg, tellName);
		end
	end

	if (valid) then
		-- Add the player to the wait list.
		local addMode, class, name2, comment, why;
		addMode = true;

		class = EkWaitList_TEXT_Class_Unknown;
		pos = EkWaitList_IsNameInGuild(name1);
		if (pos > 0) then
			rec = EkWaitList_GuildInfo[pos];
			class = rec["class"];
		end

		name2 = "";
		if (mode == 1) then
			comment = "";
			why = nil;
		else
			-- Added via whisper.;
			comment = EkWaitList_TEXT_Msg_Add_Via_Whisper;
			why = EkWaitList_TEXT_Msg_Add_Via_Whisper_Why;
		end

		EkWaitList_EditFrame_Accept3(addMode, name1, class, name2, comment, why)

		if (mode == 2) then
			-- name1 has been added to the wait list.
			msg = string.format(EkWaitList_TEXT_Msg_Add_Results, name1);
			EkWaitList_SendWhisper(msg, tellName);
		end

		-- If wait list window is open, then update it.
		if (EkWaitList_Frame_:IsShown()) then
			if (EkWaitList_Frame_GetTab() == EkWaitList_Frame_TabWait) then
				if (EkWaitList_WaitFrame_Mode == 0) then
					EkWaitList_WaitFrame_ListUpdate();

				elseif (EkWaitList_WaitFrame_Mode == 1 or EkWaitList_WaitFrame_Mode == 2) then
					-- Validate edit frame in case someone is adding/editing when deletion occurs.
					EkWaitList_EditFrame_Validate();
				end
			end
		end
	end
end

function EkWaitList_WaitFrame_RemovePlayer(mode, name)
	-- ----------
	-- Remove player from the wait list.
	--
	-- Param: mode -- 1 == Remove by command (eg. /ekwl remove Joe)
	--                2 == Remove by whisper (eg. /tell Sue wl remove)
	--
	-- Param: name -- (attendance) name of the person to remove.
	-- ----------
	local nameTemp, msg;

	nameTemp = EkWaitList_NormalizeName(name);

	local total = 0;
	local waitSub, whichName, primary, secondary, mainA, mainB;
	local removingMsg;

	repeat
		-- Test if the name is on the wait list.
		waitSub, whichName, primary, secondary, mainA, mainB = EkWaitList_WaitFrame_IsOnWaitList(nameTemp);

		if (waitSub) then
			-- Name is on the wait list.

			if (mode == 1 and not removingMsg) then
				-- Only print this once.

				-- The EkWaitList_IsOnWaitList() function will first attempt to match the given name,
				-- so if we don't see it in the returned primary and secondary values,
				-- then it couldn't be found.  Since the name that was requested to be removed
				-- was not found, display that name and its main in case the program does find
				-- other names with the same main name.

				if (nameTemp ~= primary and nameTemp ~= secondary) then
					local text = nameTemp;
					local main = EkWaitList_GetMainName(nameTemp);
					if (main and main ~= nameTemp) then
						text = text .. " [" .. main .. "]";
					end
					removingMsg = string.format(EkWaitList_TEXT_Msg_Remove_Searching_Name, text);
					EkWaitList_Print(removingMsg);
				else
					removingMsg = 1;
				end
			end

			local why;
			local count = EkWaitList_WaitFrame_RemovePlayerByName(primary, why);
			total = total + count;

			msg = nil;
			if (count > 0) then
				-- If whispered...
				if (mode == 2) then
					-- nameTemp has been removed from the wait list.
					local text = primary;
					local main = EkWaitList_GetMainName(primary);
					if (main and main ~= primary) then
						text = text .. " [" .. main .. "]";
					end
					if (secondary ~= "") then
						text = text .. " / " .. secondary;
						main = EkWaitList_GetMainName(secondary);
						if (main and main ~= secondary) then
							text = text .. " [" .. main .. "]";
						end
					end
					msg = string.format(EkWaitList_TEXT_Msg_Removed_Name, text);
				end
			else
				-- Unable to remove nameTemp from the wait list.
				msg = string.format(EkWaitList_TEXT_Msg_Removed_Unable, nameTemp);
			end
			if (msg) then
				if (mode == 1) then
					EkWaitList_Print(msg);
				else
					EkWaitList_SendWhisper(msg, name);
				end
			end
			if (count == 0) then
				break;
			end
		end

	until waitSub == nil;

	if (total == 0) then
		local text = nameTemp;
		local main = EkWaitList_GetMainName(nameTemp);
		if (main and main ~= nameTemp) then
			text = text .. " [" .. main .. "]";
		end

		-- nameTemp is not on the wait list.
		msg = string.format(EkWaitList_TEXT_Msg_Removed_NotOnWaitlist, text);

		if (mode == 1) then
			EkWaitList_Print(msg);
		else
			EkWaitList_SendWhisper(msg, name);
		end
	end
end

function EkWaitList_WaitFrame_CommentPlayer(name, comment)
	-- ----------
	-- Update player comment via whisper. (eg. /tell Sue wl status abc)
	--
	-- Param: name -- (attendance) name of the person to update.
	-- Param: comment -- 1) if nil then current comment is whispered back to the player.
	-- Param:            2) if not nil then update the player's comment.
	-- ----------
	local nameTemp, msg;

	nameTemp = EkWaitList_NormalizeName(name);

	-- Test if the name is on the wait list.
	local waitSub, whichName, primary, secondary, mainA, mainB = EkWaitList_WaitFrame_IsOnWaitList(nameTemp);

	if (waitSub) then
		-- Name is on the wait list.
		local list = EkWaitList_WaitList;

		local text = primary;
		local main = EkWaitList_GetMainName(primary);
		if (main and main ~= primary) then
			text = text .. " [" .. main .. "]";
		end
		if (secondary ~= "") then
			text = text .. " / " .. secondary;
			main = EkWaitList_GetMainName(secondary);
			if (main and main ~= secondary) then
				text = text .. " [" .. main .. "]";
			end
		end

		if (not comment or EkWaitList_IsEmpty(comment)) then
			comment = list[waitSub]["comment"] or "";

			-- The current status for %s is: %s
			msg = string.format(EkWaitList_TEXT_Msg_Comment_Current, text, comment);
		else
			-- Update comment.
			list[waitSub]["comment"] = comment;

			if (EkWaitList_Frame_GetTab() == EkWaitList_Frame_TabWait) then
				if (EkWaitList_Frame_:IsShown()) then
					if (EkWaitList_WaitFrame_Mode == 2) then
						-- The edit pane is open.

						-- Update the comment editbox if the name matches the one being edited.
						local ebName = strlower_utf8(EkWaitList_EditFrame_NameEB:GetText());
						local ebAltName = strlower_utf8(EkWaitList_EditFrame_AltNameEB:GetText());
						if (
							(ebName == strlower_utf8(name) and not EkWaitList_IsEmpty(ebName)) or
							(ebAltName == strlower_utf8(name) and not EkWaitList_IsEmpty(ebAltName))
						) then
							EkWaitList_EditFrame_CommentEB:SetText(comment);
						end
					end
				end
			end

			-- The status for %s has been changed to: %s
			msg = string.format(EkWaitList_TEXT_Msg_Comment_Ok, text, comment);
		end
	else
		-- nameTemp is not on the wait list.
		local text = nameTemp;
		local main = EkWaitList_GetMainName(nameTemp);
		if (main and main ~= nameTemp) then
			text = text .. " [" .. main .. "]";
		end
		msg = string.format(EkWaitList_TEXT_Msg_Comment_NotOnWaitlist, text);
	end
	EkWaitList_SendWhisper(msg, name);
end

function EkWaitList_WaitFrame_ShowAddPlayer()
	-- ----------
	-- Show the "add a player to the wait list" frame.
	-- ----------
	EkWaitList_GuildRoster();

	local ebName = EkWaitList_EditFrame_NameEB;
	local ebAltName = EkWaitList_EditFrame_AltNameEB;
	local ebComment = EkWaitList_EditFrame_CommentEB;

	ebName:SetText("");
	ebAltName:SetText("");
	ebComment:SetText("");
	EkWaitList_EditFrame_ClassDropDown_ID = 1; -- Default to "Unknown" class
	EkWaitList_EditFrame_ClassDropDown_Set(EkWaitList_EditFrame_ClassDropDown_ID);

	EkWaitList_WaitFrame_Mode = 1;  -- Add
	EkWaitList_WaitFrame_:Hide();
	EkWaitList_EditFrame_:Show();
end

function EkWaitList_WaitFrame_ShowEditPlayer()
	-- ----------
	-- Show the "edit a player in the wait list" frame.
	-- ----------
	EkWaitList_GuildRoster();

	local sel = EkWaitList_WaitFrame_Selected;
	local list = EkWaitList_WaitList;
	local sub;
	local rec;

	local ebName = EkWaitList_EditFrame_NameEB;
	local ebAltName = EkWaitList_EditFrame_AltNameEB;
	local ebComment = EkWaitList_EditFrame_CommentEB;

	sub = sel[1];
	rec = list[sub];

	ebName:SetText(rec["name"]);
	ebAltName:SetText(rec["altname"]);
	ebComment:SetText(rec["comment"]);

	local classList = EkWaitList_EditFrame_ClassDropDown_List;

	EkWaitList_EditFrame_ClassDropDown_ID = 1;  -- Default to "Unknown" class
	for i=1, #classList, 1 do
		if ( strlower(classList[i]) == strlower(rec["class"]) ) then
			EkWaitList_EditFrame_ClassDropDown_ID = i;
			break;
		end
	end

	EkWaitList_EditFrame_ClassDropDown_Set(EkWaitList_EditFrame_ClassDropDown_ID);

	EkWaitList_WaitFrame_Mode = 2;  -- Edit
	EkWaitList_WaitFrame_:Hide();
	EkWaitList_EditFrame_:Show();
end

function EkWaitList_WaitFrame_Whisper(name)
	-- ----------
	-- Send whisper to a player.
	-- ----------
	ChatFrame_SendTell(name);
end

function EkWaitList_WaitFrame_Invite(name)
	-- ----------
	-- Invite a player.
	-- ----------
	local invite = InviteUnit or InviteByName;  -- WoW 2.0 == InviteUnit, WoW 1.12 == InviteByName
	invite(name);
end

function EkWaitList_WaitFrame_Who(name)
	-- ----------
	-- Show /WHO info for a player.
	-- ----------
	local text;
	text = "n-" .. name;
	SendWho(text);
	WhoFrameEditBox:SetText(text);
	WhoFrameEditBox:ClearFocus();
	EkWaitList_WaitFrame_WhoElapsed = 6;  -- Time between /who's
end

-- *!*
-- -------------------------------------------------------------------------
-- EkWaitList_EditFrame (the "wait" tab: Add/Edit player)
-- -------------------------------------------------------------------------

EkWaitList_EditFrame_ClassDropDown_ID = 1; -- Class drop down list id number (default to 1 == "Unknown" class)
EkWaitList_EditFrame_MenuNum = 1;

-- Build sorted list of classes for drop down menu
EkWaitList_EditFrame_ClassDropDown_List = {};
for i = 2, #EkWaitList_ClassList do
	table.insert(EkWaitList_EditFrame_ClassDropDown_List, EkWaitList_ClassList[i]["name"]);
end
sort(EkWaitList_EditFrame_ClassDropDown_List);
-- Make sure the first item in the drop down menu is for the "Unknown" class
table.insert(EkWaitList_EditFrame_ClassDropDown_List, 1, EkWaitList_ClassList[1]["name"]); -- The "Unknown" class


function EkWaitList_EditFrame_OnShow()
	-- ----------
	-- Show the frame.
	-- ----------
	local eb, msg;

	if ( EkWaitList_WaitFrame_Mode == 1 ) then
		EkWaitList_EditFrame_TitleText:SetText(EkWaitList_TEXT_EditWindow_Title_Add);
	else
		EkWaitList_EditFrame_TitleText:SetText(EkWaitList_TEXT_EditWindow_Title_Edit);
	end

	msg = EkWaitList_EditFrame_Message;
	msg:SetTextColor(1, 1, 1);

	EkWaitList_Frame_MenuButton_HideAll();
	EkWaitList_EditFrame_ShowMenu();

	eb = EkWaitList_EditFrame_NameEB;
	eb:SetFocus();
end

function EkWaitList_EditFrame_Validate()
	-- ----------
	-- Validate data in the frame.
	-- ----------
	local mbut1 = EkWaitList_Frame_MenuButton1;
	local valid, valid1, valid2;

	valid1 = EkWaitList_EditFrame_NameEB_Valid();
	valid2 = EkWaitList_EditFrame_AltNameEB_Valid();

	if ( valid1 and valid2 ) then
		mbut1:Enable();
		valid = true;
	else
		mbut1:Disable();
		valid = false;
	end

	return valid;
end

function EkWaitList_EditFrame_Name_Valid(whichName, name1, name2, addMode)
	-- ----------
	-- Validate the player name to add to the wait list.
	--
	-- Param: whichName -- Which name we are validating: 1 == Name1, 2 == Name2.
	-- Param: name1 -- Name1
	-- Param: name2  -- Name2
	-- Param: addMode -- true == adding, false == editing.
	--
	-- Return1:  0 == Ok.
	--           1 == Name is blank.
	--           2 == Name contains a blank.
	--           3 == Name1 same as Name2.
	--           4 == Name is not in the guild.
	--           5 == Name is on the wait list.
	--           6 == Name is in the party.
	--           7 == Name is in the raid.
	--
	-- If return1 is 5, then:
	--    Return2: Position in wait list.
	--    Return3: Which name matched (1=primary, 2=secondary).
	--    Return4: The primary or secondary name (keep in mind it may have matched their main name instead).
	--    Return5: The primary or secondary main name (if the match was on the pri/sec main name), else nil.
	--    Return6: The main name (if the match was on the main name), else nil.
	--
	-- If return1 is 6, then:
	--    Return2: Position in the party (0==Player, 1 to number of party members).
	--    Return3: Unit Id ("player", "party1", etc).
	--    Return4: Unit name (keep in mind it may have matched their main name instead).
	--    Return5: The primary or secondary main name (if the match was on the pri/sec main name), else nil.
	--    Return6: The main name (if the match was on the main name), else nil.
	--
	-- If return1 is 7, then:
	--    Return2: Position in the raid (1 to number of raid members).
	--    Return3: Unit Id ("raid1", etc).
	--    Return4: Unit name (keep in mind it may have matched their main name instead).
	--    Return5: The primary or secondary main name (if the match was on the pri/sec main name), else nil.
	--    Return6: The main name (if the match was on the main name), else nil.
	-- ----------
	local lowName1 = strlower_utf8(name1);
	local lowName2 = strlower_utf8(name2);

	local plist = EkWaitList_WaitList;
	local sel = EkWaitList_WaitFrame_Selected;
	local sub, name;

	local waitSub, which, primary, secondary, mainA, mainB;
	local pos, unitType, unitId, unitName;

	if (EkWaitList_Test == 1) then
		-- All names are valid
		return 0;
	end

	if (whichName == 1) then
		name = lowName1;
	else
		name = lowName2;
	end

	-- -----
	-- Test for blanks.
	-- -----
	if ( EkWaitList_IsEmpty(name) ) then
		if (whichName == 1) then
			-- Don't allow a blank name1.
			return 1;  -- Name1 is blank.
		else
			-- Allow a blank name2.
			return 0;
		end
	end

	local pos1, pos2 = string.find(name, " ");
	if (pos1) then
		-- Don't allow a space in the name.
		return 2;
	end

	-- ----
	-- Invalid if alt name matches main name
	-- ----
	if ( lowName2 == lowName1 ) then
		return 3;  -- Name1 same as name2.
	end

	-- -----
	-- Check the wait list
	-- -----
	if ( #sel == 0 ) then
		sub = 0;
	else
		sub = sel[1];
	end

	if ( addMode ) then
		-- Adding. Name can't match anything in the list.
		sub = 0;  -- Pretend nothing is selected.
	else
		-- Editing. Name can't match anything in the list, except
		-- the one we are editing (ie. the one that is selected).
	end

	waitSub = 0;
	repeat
		-- Test if the name is on the wait list.
		waitSub, which, primary, secondary, mainA, mainB = EkWaitList_WaitFrame_IsOnWaitList(name, waitSub+1);

		if (waitSub) then
			-- Name is on the wait list.
			if (waitSub ~= sub) then
				-- Don't ignore this wait list entry.
				if (which == 1) then
					-- Matched the primary name, or the primary main name.
					return 5, waitSub, which, primary, mainA, mainB;
				else
					-- Matched the secondary name, or the secondary main name.
					return 5, waitSub, which, secondary, mainA, mainB;
				end
			end
		end
	until waitSub == nil;

	-- -----
	-- Check the party/raid.
	-- -----
	pos, unitType, unitId, unitName, mainA, mainB = EkWaitList_WaitFrame_IsInGroup(name);
	if (pos) then
		if (unitType == "party") then
			-- Name is in the party.
			return 6, pos, unitId, unitName, mainA, mainB;
		else
			-- Name is in the raid.
			return 7, pos, unitId, unitName, mainA, mainB;
		end
	end

	-- -----
	-- Check the guild.
	-- -----
	if (IsInGuild()) then
		local pos;
		pos = EkWaitList_IsNameInGuild(name);
		if (pos == 0) then
			return 4;  -- Name is not in (this) guild.
		end
	end

	return 0;
end


-- ----------
-- "Name"
-- ----------

function EkWaitList_EditFrame_NameEB_EditStart()
	-- ----------
	-- Start editing the player name.
	-- ----------
	local eb = EkWaitList_EditFrame_NameEB;

	if ( eb.editing ) then
		return;
	end

	eb.editing = 1;
	eb:HighlightText();
	eb:SetFocus();
end

function EkWaitList_EditFrame_NameEB_EditStop(cancel)
	-- ----------
	-- User has stopped editing the player name.
	-- ----------
	local eb, value;

	eb = EkWaitList_EditFrame_NameEB;

	if ( not eb.editing ) then
		return;
	end

	value = eb:GetText();

	eb:HighlightText(0, 0);
	eb.editing = nil;

	if ( cancel ) then
		EkWaitList_EditFrame_MenuNum = 1;  -- WaitEditFrame main menu
		EkWaitList_EditFrame_ShowMenu();
	end
end

function EkWaitList_EditFrame_NameEB_Valid()
	-- ----------
	-- Validate the player named being edited.
	-- ----------
	local ebMain = EkWaitList_EditFrame_NameEB;
	local ebAlt  = EkWaitList_EditFrame_AltNameEB;

	local main = ebMain:GetText();
	local alt = ebAlt:GetText();

	local addMode, valid, msg, result, pos, val1;
	local name, mainA, mainB;

	local status = EkWaitList_EditFrame_NameEBStatus;

	if ( EkWaitList_WaitFrame_Mode == 1 ) then
		-- Adding. Name can't match anything in the list.
		addMode = true;
	else
		addMode = false;
	end

	result, pos, val1, name, mainA, mainB = EkWaitList_EditFrame_Name_Valid(1, main, alt, addMode)

	msg = nil;
	valid = false;

	if (result == 0) then
		valid = true;

	elseif (result == 1) then
		-- This name is required
		msg = EkWaitList_TEXT_EditWindow_Valid_Required;

	elseif (result == 2) then
		-- Name contains a space
		msg = EkWaitList_TEXT_EditWindow_Valid_Contains_Space;

	elseif (result == 3) then
		-- This is the same as name 2
		msg = EkWaitList_TEXT_EditWindow_Valid_Same_As_Name2;

	elseif (result == 4) then
		-- Not in the guild
		msg = EkWaitList_TEXT_EditWindow_Valid_Not_In_Guild;
		valid = true;

	elseif (result == 5) then
		-- name is in the list
		msg = string.format(EkWaitList_TEXT_EditWindow_Valid_Name_On_WaitList, name);

	elseif (result == 6) then
		-- name is in the party
		msg = string.format(EkWaitList_TEXT_EditWindow_Valid_Name_In_Party, name);

	elseif (result == 7) then
		-- name is in the raid
		msg = string.format(EkWaitList_TEXT_EditWindow_Valid_Name_In_Raid, name);

	end

	if (msg) then
		status:SetText(msg);
		status:Show();
	else
		status:Hide();
	end

	return valid;
end


function EkWaitList_EditFrame_NameEB_Changed()
	-- ----------
	-- The editbox contents have changd.
	-- ----------
	EkWaitList_EditFrame_Validate();

	-- Update class.
	local ebMain = EkWaitList_EditFrame_NameEB;
	local main = ebMain:GetText();

	local class, pos, rec;

	-- Update the class.
	class = nil;
	pos = EkWaitList_IsNameInGuild(main);
	if (pos > 0) then
		rec = EkWaitList_GuildInfo[pos];
		class = strlower(rec["class"]);

		local classList = EkWaitList_EditFrame_ClassDropDown_List;

		EkWaitList_EditFrame_ClassDropDown_ID = 1; -- Default to "Unknown" class
		for i=1, #classList, 1 do
			if ( strlower(classList[i]) == class ) then
				EkWaitList_EditFrame_ClassDropDown_ID = i;
				break;
			end
		end
		EkWaitList_EditFrame_ClassDropDown_Set(EkWaitList_EditFrame_ClassDropDown_ID);
	end
end


function EkWaitList_EditFrame_NameEB_OnTab(eb)
	eb:ClearFocus();
	EkWaitList_EditFrame_Validate();
	if (IsShiftKeyDown()) then
		EkWaitList_EditFrame_CommentEB:SetFocus();
	else
		EkWaitList_EditFrame_AltNameEB:SetFocus();
	end
	EkWaitList_EditFrame_Validate();
end


-- ----------
-- "Class"
-- ----------

function EkWaitList_EditFrame_ClassDropDown_OnLoad()
	-- ----------
	-- Load the "class" dropdown menu.
	-- ----------
	local DD = EkWaitList_EditFrame_ClassDropDown;
	local id;

	if ( EkWaitList_EditFrame_ClassDropDown_ID ) then
		id = EkWaitList_EditFrame_ClassDropDown_ID;
	else
		id = 1;  -- Default to "Unknown" class
	end

	UIDropDownMenu_Initialize(DD, EkWaitList_EditFrame_ClassDropDown_Initialize);
	UIDropDownMenu_SetWidth(DD, 110);
	EkWaitList_EditFrame_ClassDropDown_Set(id);
end

function EkWaitList_EditFrame_ClassDropDown_Initialize()
	-- ----------
	-- Initialize the "class" dropdown menu.
	-- ----------
	local info;
	for key, val in pairs(EkWaitList_EditFrame_ClassDropDown_List) do
		info = {};
		info.text = val;
		info.func = EkWaitList_EditFrame_ClassDropDown_OnClick;
		UIDropDownMenu_AddButton(info);
	end
end

function EkWaitList_EditFrame_ClassDropDown_OnClick(self)
	-- ----------
	-- User has selected an item from the "players to save" dropdown menu.
	-- ----------
	EkWaitList_EditFrame_ClassDropDown_ID = self:GetID();
	EkWaitList_EditFrame_ClassDropDown_Set(EkWaitList_EditFrame_ClassDropDown_ID);
end

function EkWaitList_EditFrame_ClassDropDown_Set(id)
	-- ----------
	-- Set the current value of the "players to save" dropdown menu.
	-- ----------
	local DD = EkWaitList_EditFrame_ClassDropDown;
	UIDropDownMenu_SetSelectedID(DD, id);
	UIDropDownMenu_SetText(DD, EkWaitList_EditFrame_ClassDropDown_List[id]);
end

-- ----------
-- "Alt's name"
-- ----------

function EkWaitList_EditFrame_AltNameEB_EditStart()
	-- ----------
	-- Start editing the alt's name.
	-- ----------
	local eb = EkWaitList_EditFrame_AltNameEB;

	if ( eb.editing ) then
		return;
	end

	eb.editing = 1;
	eb:HighlightText();
	eb:SetFocus();
end

function EkWaitList_EditFrame_AltNameEB_EditStop(cancel)
	-- ----------
	-- User has stopped editing the alt's name.
	-- ----------
	local eb = EkWaitList_EditFrame_AltNameEB;
	local value;

	if ( not eb.editing ) then
		return;
	end

	value = eb:GetText();

	eb:HighlightText(0, 0);
	eb.editing = nil;

	if ( cancel ) then
		EkWaitList_EditFrame_MenuNum = 1;  -- WaitEditFrame main menu
		EkWaitList_EditFrame_ShowMenu();
	end
end

function EkWaitList_EditFrame_AltNameEB_Valid()
	-- ----------
	-- Validate the player named being edited.
	-- ----------
	local ebMain = EkWaitList_EditFrame_NameEB;
	local ebAlt  = EkWaitList_EditFrame_AltNameEB;

	local main = ebMain:GetText();
	local alt = ebAlt:GetText();

	local addMode, valid, msg, result, pos, val1;
	local name, mainA, mainB;

	local status = EkWaitList_EditFrame_AltNameEBStatus;

	if ( EkWaitList_WaitFrame_Mode == 1 ) then
		-- Adding. Name can't match anything in the list.
		addMode = true;
	else
		addMode = false;
	end

	result, pos, val1, name, mainA, mainB = EkWaitList_EditFrame_Name_Valid(2, main, alt, addMode);

	msg = nil;
	valid = false;

	if (result == 0) then
		valid = true;

	elseif (result == 2) then
		-- Name contains a space
		msg = EkWaitList_TEXT_EditWindow_Valid_Contains_Space;

	elseif (result == 3) then
		-- This is the same as name 1
		msg = EkWaitList_TEXT_EditWindow_Valid_Same_As_Name1;

	elseif (result == 4) then
		-- Not in the guild
		msg = EkWaitList_TEXT_EditWindow_Valid_Not_In_Guild;
		valid = true;

	elseif (result == 5) then
		-- name is in the list
		msg = string.format(EkWaitList_TEXT_EditWindow_Valid_Name_On_WaitList, name);

	elseif (result == 6) then
		-- name is in the party
		msg = string.format(EkWaitList_TEXT_EditWindow_Valid_Name_In_Party, name);

	elseif (result == 7) then
		-- name is in the raid
		msg = string.format(EkWaitList_TEXT_EditWindow_Valid_Name_In_Raid, name);

	end

	if (msg) then
		status:SetText(msg);
		status:Show();
	else
		status:Hide();
	end

	return valid;
end

function EkWaitList_EditFrame_AltNameEB_Changed()
	-- ----------
	-- The editbox contents have changd.
	-- ----------
	EkWaitList_EditFrame_Validate();
end

function EkWaitList_EditFrame_AltNameEB_OnTab(eb)
	-- ----------
	-- User pressed the tab key.
	-- ----------
	eb:ClearFocus();
	EkWaitList_EditFrame_Validate();
	if (IsShiftKeyDown()) then
		EkWaitList_EditFrame_NameEB:SetFocus();
	else
		EkWaitList_EditFrame_CommentEB:SetFocus();
	end
end

-- ----------
-- "Comment"
-- ----------

function EkWaitList_EditFrame_CommentEB_EditStart()
	-- ----------
	-- Start editing the alt's name.
	-- ----------
	local eb = EkWaitList_EditFrame_CommentEB;

	if ( eb.editing ) then
		return;
	end

	eb.editing = 1;
	eb:HighlightText();
	eb:SetFocus();
end

function EkWaitList_EditFrame_CommentEB_EditStop(cancel)
	-- ----------
	-- User has stopped editing the comment.
	-- ----------
	local eb = EkWaitList_EditFrame_CommentEB;
	local value;

	if ( not eb.editing ) then
		return;
	end

	value = eb:GetText();

	eb:HighlightText(0, 0);
	eb.editing = nil;

	if ( cancel ) then
		EkWaitList_EditFrame_MenuNum = 1;  -- WaitEditFrame main menu
		EkWaitList_EditFrame_ShowMenu();
	end
end

function EkWaitList_EditFrame_CommentEB_OnTab(eb)
	-- ----------
	-- User pressed the tab key.
	-- ----------
	eb:ClearFocus();
	if (IsShiftKeyDown()) then
		EkWaitList_EditFrame_AltNameEB:SetFocus();
	else
		EkWaitList_EditFrame_NameEB:SetFocus();
	end
end

-- ----------
-- The menu
-- ----------

function EkWaitList_EditFrame_ShowMenu()
	-- ----------
	-- Show menu
	-- ----------
	local eb = EkWaitList_EditFrame_NameEB;

	local mbut1 = EkWaitList_Frame_MenuButton1;
	local mbut3 = EkWaitList_Frame_MenuButton3;

	mbut1:SetText(EkWaitList_TEXT_EditWindow_Button_Ok);
	mbut1:Disable();
	mbut1:Show();

	mbut3:SetText(EkWaitList_TEXT_EditWindow_Button_Cancel);
	mbut3:Enable();
	mbut3:Show();

	EkWaitList_EditFrame_Validate();
end

function EkWaitList_EditFrame_MenuButton_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in the current menu.
	-- ----------
	local menu = EkWaitList_EditFrame_MenuNum;
	local name = "EkWaitList_EditFrame_Menu" .. menu .. "_OnClick";
	local func = _G[name];
	if (func) then
		func(butNum);
	end
end

function EkWaitList_EditFrame_MenuButton_OnEnter(butNum)
	-- ----------
	-- Mouse is over a menu button in the current menu.
	-- ----------
	local menu = EkWaitList_EditFrame_MenuNum;
	local name = "EkWaitList_EditFrame_Menu" .. menu .. "_OnEnter";
        local self = _G["EkWaitList_Frame_MenuButton" .. butNum];
	local func = _G[name];
	if (func) then
		func(self, butNum);
	end
end

function EkWaitList_EditFrame_Menu1_OnClick(butNum)
	-- ----------
	-- User clicked on a menu button in menu 1.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Ok add/edit of player.
		-- -----
		EkWaitList_EditFrame_Accept();

	elseif (butNum == 3) then
		-- -----
		-- Cancel add/edit of player.
		-- -----
		EkWaitList_EditFrame_Cancel();
	end
end

function EkWaitList_EditFrame_Menu1_OnEnter(self, butNum)
	-- ----------
	-- Mouse is over a menu button in menu 1.
	-- ----------
	if (butNum == 1) then
		-- -----
		-- Ok add/edit of player.
		-- -----
		if ( EkWaitList_WaitFrame_Mode == 1 ) then
			EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_EditWindow_Button_Ok_Add_Tooltip1, EkWaitList_TEXT_EditWindow_Button_Ok_Add_Tooltip2);
		else
			EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_EditWindow_Button_Ok_Edit_Tooltip1, EkWaitList_TEXT_EditWindow_Button_Ok_Edit_Tooltip2);
		end

	elseif (butNum == 3) then
		-- -----
		-- Cancel add/edit of player.
		-- -----
		if ( EkWaitList_WaitFrame_Mode == 1 ) then
			EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_EditWindow_Button_Cancel_Add_Tooltip1, EkWaitList_TEXT_EditWindow_Button_Cancel_Add_Tooltip2);
		else
			EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_EditWindow_Button_Cancel_Edit_Tooltip1, EkWaitList_TEXT_EditWindow_Button_Cancel_Edit_Tooltip2);
		end
	end
end

function EkWaitList_EditFrame_Accept()
	-- ----------
	-- Called from XML when user presses Enter,
	-- and from LUA when user clicks on the "ok" button.
	-- If data is valid, will accept the data and close window.
	-- ----------
	if (EkWaitList_EditFrame_Validate()) then
		EkWaitList_EditFrame_Accept2();
		return true;
	end

	return false;
end

function EkWaitList_EditFrame_Accept2()
	-- ----------
	-- OK add/edit of player (does not validate).
	-- ----------
	local ebName = EkWaitList_EditFrame_NameEB;
	local ebAltName = EkWaitList_EditFrame_AltNameEB;
	local ebComment = EkWaitList_EditFrame_CommentEB;

	local name1, name2, comment, class, addMode;

	name1 = ebName:GetText();
	name2 = ebAltName:GetText();
	comment = ebComment:GetText();
	class = EkWaitList_EditFrame_ClassDropDown_List[EkWaitList_EditFrame_ClassDropDown_ID];

	if ( EkWaitList_WaitFrame_Mode == 1 ) then
		addMode = true;
	else
		addMode = false;
	end

	EkWaitList_EditFrame_Accept3(addMode, name1, class, name2, comment, nil);

	EkWaitList_WaitFrame_Selected = {};

	EkWaitList_WaitFrame_Mode = 0;  -- Main
	EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu

	EkWaitList_EditFrame_:Hide();
	EkWaitList_WaitFrame_Sort(EkWaitList_WaitFrame_Order);
	EkWaitList_WaitFrame_:Show();
end

function EkWaitList_EditFrame_Accept3(addMode, name1, class, name2, comment, why)
	-- ----------
	-- Add/edit wait list player using specified values.
	-- ----------
	local list = EkWaitList_WaitList;
	local sel = EkWaitList_WaitFrame_Selected;
	local rec, sub;
	local percent, rankIndex;
	local pos, grec;

	local name, altName;
	local text;

	-- First char of player name is uppercase, rest is lower case.
	name = EkWaitList_NormalizeName(name1);
	altName = EkWaitList_NormalizeName(name2);

	percent = 0;
	rankIndex = nil;

	if ( addMode ) then
		local msg;

		-- Add
		rec = EkWaitList_WaitFrame_NewPlayer(#list + 1, name, class, altName, comment, percent, rankIndex);
		table.insert(list, rec);

		text = name;
		local main = EkWaitList_GetMainName(name);
		if (main and main ~= name) then
			text = text .. " [" .. main .. "]";
		end
		if (altName ~= "") then
			text = text .. " / " .. altName;
			main = EkWaitList_GetMainName(altName);
			if (main and main ~= altName) then
				text = text .. " [" .. main .. "]";
			end
		end

		-- Added name to the wait list
		msg = string.format(EkWaitList_TEXT_EditWindow_Ok_Add, text);

		if (why) then
			msg = msg .. " (" .. why .. ")";
		end
		EkWaitList_Print(msg .. ".");
	else
		-- Edit
		sub = sel[1];
		rec = list[sub];

		-- Change all but the time added and position.
		rec["name"] = name;
		rec["class"] = class;
		rec["altname"] = altName;
		rec["comment"] = comment;

		-- Updated wait list entry for name.
		EkWaitList_Print(string.format(EkWaitList_TEXT_EditWindow_Ok_Edit, name));
	end

	-- Get attendance percentage for the name.
	percent = EkWaitList_WaitFrame_LookupPercent(rec["name"]);
	rec["percent"] = percent;

	-- Get guild rank index for the name.
	rankIndex = nil;
	pos = EkWaitList_IsNameInGuild(rec["name"]);
	if (pos > 0) then
		grec = EkWaitList_GuildInfo[pos];
		rankIndex = grec["rankIndex"];
	end
	rec["rankIndex"] = rankIndex;

	EkWaitList_WaitFrame_Sort(EkWaitList_WaitFrame_Order);
end

function EkWaitList_EditFrame_Cancel()
	-- -----
	-- Cancel add/edit of player.
	-- -----
	EkWaitList_WaitFrame_Mode = 0;  -- Main
	EkWaitList_WaitFrame_MenuNum = 1;  -- Wait list main menu

	EkWaitList_EditFrame_:Hide();
	EkWaitList_WaitFrame_:Show();
end


-- *!*
-- -------------------------------------------------------------------------
-- EkWaitList_PromptFrame
-- -------------------------------------------------------------------------

EkWaitList_PromptFrame_Mode = "";

function EkWaitList_PromptFrame_OnShow()
	-- ----------
	-- Called when prompt frame is shown.
	-- ----------
	local frame = EkWaitList_PromptFrame_;
	local header = EkWaitList_PromptFrame_HeaderText;
	local info = EkWaitList_PromptFrame_Info;
	local timer = EkWaitList_PromptFrame_Timer;
	local button1 = EkWaitList_PromptFrame_Button1;
	local button2 = EkWaitList_PromptFrame_Button2;
	local disableText = EkWaitList_PromptFrame_DisableText;
	local disableCB = EkWaitList_PromptFrame_DisableCB;
	local disableRaidText = EkWaitList_PromptFrame_DisableRaidText;
	local disableRaidCB = EkWaitList_PromptFrame_DisableRaidCB;

	local height = 170;

	EkWaitList_PromptTimer = 9999;  -- 9999 == infinite timer
	EkWaitList_PromptDelay = nil;

	PlaySound("UChatScrollButton");

	timer:SetText("");
	disableText:SetText(EkWaitList_TEXT_PromptWindow_Disable_Prompt);  -- Disable this prompt
	disableText:Hide();

	disableCB:Hide();
	disableCB:SetChecked(0);

	if (EkWaitList_InRaid()) then
		-- Do not prompt again while in this raid.
		disableRaidText:SetText(EkWaitList_TEXT_PromptWindow_Not_Again_While);
	else
		-- Do not prompt again until I join a raid.
		disableRaidText:SetText(EkWaitList_TEXT_PromptWindow_Not_Again_Until);
	end
	disableRaidText:Hide();

	disableRaidCB:Hide();
	disableRaidCB:SetChecked(0);

	if (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_JOIN) then
		header:SetText("EkWaitList");
		-- "You have joined a raid.\n" .. "|c00FFFFFF" .. "Do you want to clear the wait list?|r"
		info:SetText(EkWaitList_TEXT_PromptWindow_Joined_Raid_Clear_Waitlist);
		button1:SetText(EkWaitList_TEXT_PromptWindow_Button_Clear);   -- Clear waitlist
		button2:SetText(EkWaitList_TEXT_PromptWindow_Button_Close);   -- Close
		frame:SetHeight(height - 40);
		frame:Show();

	elseif (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_SENT) then
		header:SetText("EkWaitList");
		-- "xxxxxxxxxxxx sent you a wait list.\n" .. "|c00FFFFFF" .. "Replace your wait list with theirs?|r"
		info:SetText( string.format( EkWaitList_TEXT_PromptWindow_Sent_You_A_Wait_List, EkWaitList_SentList_From ) );
		button1:SetText(EkWaitList_TEXT_PromptWindow_Button_Replace);   -- Replace waitlist
		button2:SetText(EkWaitList_TEXT_PromptWindow_Button_No);   -- No
		frame:SetHeight(height - 40);
		frame:Show();

	else
		EkWaitList_PromptTimer = 0;

	end
end

function EkWaitList_PromptFrame_OnHide()
	-- ----------
	-- Called when prompt frame is hidden.
	-- ----------
	local frame = EkWaitList_PromptFrame_;

	EkWaitList_PromptTimer = nil;
	EkWaitList_PromptDelay = EkWaitList_DefPromptDelay;
	EkWaitList_PromptFrame_Mode = "";

	PlaySound("UChatScrollButton");
end

function EkWaitList_PromptFrame_Button1_OnClick()
	-- ----------
	-- User clicked on button 1 of the prompt frame.
	-- ----------
	local frame = EkWaitList_PromptFrame_;

	EkWaitList_PromptFrame_UpdateVars();

	if (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_JOIN) then
		frame:Hide();
		EkWaitList_WaitFrame_RemovePlayers("all", nil);
		EkWaitList_WaitFrame_Refresh_List(close_editpane);

	elseif (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_SENT) then
		frame:Hide();
		EkWaitList_Whisper_SentList_ReplaceWaitList();
		EkWaitList_WaitFrame_Refresh_List(close_editpane);
	end
end

function EkWaitList_PromptFrame_Button2_OnClick()
	-- ----------
	-- User clicked on button 2 of the prompt frame.
	-- ----------
	local frame = EkWaitList_PromptFrame_;

	EkWaitList_PromptFrame_UpdateVars();

	if (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_SENT) then
		-- Reset the temp wait list variables.
		EkWaitList_Whisper_SentList_Reset();
	end

	frame:Hide();
end

function EkWaitList_PromptFrame_DisableCB_OnClick()
	-- ----------
	-- User clicked on the disable prompt checkbox.
	-- ----------
end

function EkWaitList_PromptFrame_DisableCB_OnEnter(self)
	-- ----------
	-- Mouse is over the disable prompt checkbox.
	-- ----------
	EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_PromptWindow_Disable_Prompt_Tooltip1, EkWaitList_TEXT_PromptWindow_Disable_Prompt_Tooltip2);
end

function EkWaitList_PromptFrame_DisableRaidCB_OnClick()
	-- ----------
	-- User clicked on the disable prompt while in this raid checkbox.
	-- ----------
end

function EkWaitList_PromptFrame_DisableRaidCB_OnEnter(self)
	-- ----------
	-- Mouse is over the disable prompt while in this raid checkbox.
	-- ----------
	EkWaitList_SetTooltip_Corner(self, EkWaitList_TEXT_PromptWindow_Not_Again_Tooltip1, EkWaitList_TEXT_PromptWindow_Not_Again_Tooltip2);
end

function EkWaitList_PromptFrame_UpdateVars()
	-- ----------
	-- Update variables based on status of the prompt check boxes.
	-- ----------
	local disCB = EkWaitList_PromptFrame_DisableCB;
	local raidCB = EkWaitList_PromptFrame_DisableRaidCB;

	local disChecked = disCB:GetChecked();
	local raidChecked = raidCB:GetChecked();

	if (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_JOIN) then
		if (raidChecked == 1) then
			EkWaitList_DisabledRaidPrompts[EkWaitList_PromptFrame_Mode] = 1;
		end

	elseif (EkWaitList_PromptFrame_Mode == EkWaitList_PROMPT_WAITLIST_SENT) then
		if (raidChecked == 1) then
			EkWaitList_DisabledRaidPrompts[EkWaitList_PromptFrame_Mode] = 1;
		end
	end

	EkWaitList_UIRefresh();
end

-- *!*
-- -------------------------------------------------------------------------
-- EkWaitList_Whispers
-- -------------------------------------------------------------------------

function EkWaitList_Whisper_WaitList_Commands(name)
	-- ----------
	-- Tell player what wait list whisper commands are available.
	-- ----------
	local cmds = {"Help", "Who", "Add", "Main", "Remove", "Comment"};  -- order, name, capitals are important.
	local cmd, msg, kw, lowCmd;

	-- Available wait list whisper commands:
	EkWaitList_SendWhisper(EkWaitList_TEXT_Whisper_Help_Available, name);

	-- EkWaitList_TEXT_Whisper_Help_Help
	-- EkWaitList_TEXT_Whisper_Help_Who
	-- EkWaitList_TEXT_Whisper_Help_Add
	-- EkWaitList_TEXT_Whisper_Help_Add2
	-- EkWaitList_TEXT_Whisper_Help_Main
	-- EkWaitList_TEXT_Whisper_Help_Remove
	-- EkWaitList_TEXT_Whisper_Help_Comment
	-- EkWaitList_TEXT_Whisper_Help_Comment2

	-- Handle each command
	for i = 1, #cmds do
		cmd = cmds[i];
		lowCmd = strlower(cmd);
		kw = EkWaitList_Whispers_waitlist[lowCmd]["keyword"];

		if (EkWaitList_Whispers_waitlist[lowCmd]["enabled"] == 1) then
			-- Main command
			msg = EkWaitList_Whispers_command;
			if (kw ~= "") then
				msg = msg .. " " .. kw;
			end
			msg = msg .. " -- " .. _G["EkWaitList_TEXT_Whisper_Help_" .. cmd];

			EkWaitList_SendWhisper(msg, name);

			if (lowCmd == "add") then
				-- Handle special variation of the add command syntax: wl add <name>

				msg = EkWaitList_Whispers_command;
				if (kw ~= "") then
					msg = msg .. " " .. kw;
				end
				msg = msg .. " <" .. EkWaitList_TEXT_Help_Text_Name .. "> -- " .. _G["EkWaitList_TEXT_Whisper_Help_" .. cmd .. "2"];

				EkWaitList_SendWhisper(msg, name);
			elseif (lowCmd == "comment") then
				-- Handle special variation of the comment command syntax: wl status <text>

				msg = EkWaitList_Whispers_command;
				if (kw ~= "") then
					msg = msg .. " " .. kw;
				end
				msg = msg .. " <" .. EkWaitList_TEXT_Help_Text_Text .. "> -- " .. _G["EkWaitList_TEXT_Whisper_Help_" .. cmd .. "2"];

				EkWaitList_SendWhisper(msg, name);
			end
		end
	end

	-- How to
	EkWaitList_SendWhisper(EkWaitList_TEXT_Whisper_Help_HowTo, name);
end

function EkWaitList_Whisper_WaitList_Config()
	-- ----------
	-- Configure wait list whisper commands based on saved user config.
	-- ----------
	local commands = EkWaitList_Whispers_waitlist;
	local config = EkWaitList_Whispers_wlConfig;

	for c,d in pairs(commands) do
		if (config[c]) then
			-- Get user configuration.
			d["enabled"] = config[c]["enabled"];
		else
			-- Default to the value assigned in the hard coded table.
			-- If key is missing, then default to enabled mode.
			if (not d["enabled"]) then
				d["enabled"] = 1;
			end
		end
	end

	-- Remove old commands and settings from user config table.
	for k,v in pairs(config) do
		local found = nil;
		for c,d in pairs(commands) do
			if (c == k) then
				found = 1;
				break;
			end
		end
		if (not found) then
			config[k] = nil;
		end
	end
end

function EkWaitList_GetSortedByPosition()
	-- ----------
	-- Returns array of names on the wait list, sorted by position.
	-- ----------
	local count, rec;
	local tempList;

	-- First build a temporary subset copy of the wait list.
	tempList = {};
	count = #EkWaitList_WaitList;
	for i=1,count do
		rec = EkWaitList_WaitList[i];
		tempList[i] = {["name"] = rec["name"], ["pos"] = rec["pos"]};
	end

	-- Sort the temporary list by position.
	sort(tempList, function (a, b)
				if (a["pos"] < b["pos"]) then
					return true;
				else
					return false;
				end
			end)

	return tempList;
end

function EkWaitList_GetWhoIsOnWaitList()
	-- ----------
	-- Build a string containing the names of those people
	-- who are on the wait list, or text indicating that
	-- there is no one on the wait list.
	-- ----------
	local count, names, msg;
	local tempList;

	-- First build a temporary subset copy of the wait list.
	tempList = EkWaitList_GetSortedByPosition();

	-- Next build a string containing all the names (in wait list position sequence).
	count = #tempList;
	names = "";
	for i=1,count do
		if (names ~= "") then
			names = names .. ", ";
		end
		-- No space between the period and the name, to avoid breaking
		-- the string between the period and the name when it gets broadcast.
		names = names .. i .. "." .. tempList[i]["name"];
	end

	-- Compose the final message.
	if (count == 0) then
		-- There is no one on the waitlist.
		msg = EkWaitList_TEXT_Whisper_Who_No_One;

	elseif (count == 1) then
		-- There is 1 name on the waitlist: names. 
		msg = EkWaitList_TEXT_Whisper_Who_One_Name .. " " .. names .. ".";

	else
		-- There are count names on the waitlist: names.;
		msg = string.format(EkWaitList_TEXT_Whisper_Who_Many_Names, count) .. " " .. names .. ".";
	end

	return msg;
end

function EkWaitList_Whisper_WaitList_Who(tellName)
	-- ----------
	-- List people on the wait list via a whisper.
	-- ----------
	local msg;

	-- Build a string containing the names of those people
	-- who are on the wait list, or text indicating that
	-- there is no one on the wait list.
	msg = EkWaitList_GetWhoIsOnWaitList();

	-- Respond to the /tell with the wait list.
	EkWaitList_SendWhisper(msg, tellName);
end

function EkWaitList_Whisper_WaitList_Add(tellName, addName)
	-- ----------
	-- Add player to the wait list via a whisper.
	-- ----------
	local name;

	-- If user specified a name to add...
	if (addName and not EkWaitList_IsEmpty(addName)) then

		-- Is the name in the guild?
		local pos = EkWaitList_IsNameInGuild(addName);
		if (pos == 0) then
			-- ---
			-- The name to add is not in the guild.
			-- ---
			-- Only allow the name to be added if it is the same
			-- as the person doing the whispering.
			if (strlower_utf8(tellName) ~= strlower_utf8(addName)) then
				-- Cannot add someone else's name.
				if (IsInGuild()) then
					EkWaitList_SendWhisper(EkWaitList_TEXT_Msg_Add_OnlyYourName_Guild, tellName);
				else
					EkWaitList_SendWhisper(EkWaitList_TEXT_Msg_Add_OnlyYourName_NotGuild, tellName);
				end
				return;
			end
			-- Ok to use the addName.
		else
			-- ---
			-- The name to add is someone in the guild.
			-- ---
			-- Only allow this name if it belongs to the player doing
			-- the whispering (ie. if the main name of the player who whispered,
			-- and the main name of the name to add, are the same).
			local main1 = EkWaitList_GetMainName(tellName);
			local main2 = EkWaitList_GetMainName(addName);
			if (main1 and main2) then
				if (strlower_utf8(main1) ~= strlower_utf8(main2)) then
					EkWaitList_SendWhisper(EkWaitList_TEXT_Msg_Add_OnlyYourName_Guild, tellName);
					return;
				end
				-- Ok to use the addName.
			else
				-- Unable to determine a main name, so use the whisper name.
				addName = tellName;
			end
		end
	else
		-- Use the name of the person doing the whispering.
		addName = tellName;
	end

	EkWaitList_WaitFrame_AddPlayer(2, addName, tellName);
end

function EkWaitList_Whisper_WaitList_Main(tellName)
	-- ----------
	-- Add main player to the wait list via a whisper.
	-- ----------

	-- Get the main name of the person doing the whispering.
	local addName = EkWaitList_GetMainName(tellName);
	if (not addName) then
		-- Unable to determine a main name, so use the whisper name.
		addName = tellName;
	end

	EkWaitList_WaitFrame_AddPlayer(2, addName, tellName);
end

function EkWaitList_Whisper_WaitList_Remove(tellName)
	-- ----------
	-- Remove player from the wait list via a whisper.
	-- ----------
	EkWaitList_WaitFrame_RemovePlayer(2, tellName);
end

function EkWaitList_Whisper_WaitList_Comment(tellName, comment)
	-- ----------
	-- Update player's comment via a whisper.
	-- ----------
	EkWaitList_WaitFrame_CommentPlayer(tellName, comment);
end

function EkWaitList_Whisper_WaitList_Send(tellName)
	-- ----------
	-- Send the wait list to the specified player via whispers.
	-- ----------

	-- Sending wait list to tellName.
	EkWaitList_Print(string.format(EkWaitList_TEXT_Msg_Send_WaitList_To, tellName));
	EkWaitList_Whisper_SentList_Send_Msg_WD(tellName);
end

function EkWaitList_Whisper_SentList_Receive_Msg(fromName, cmd, msg)
	-- ----------
	-- Receive an incoming message.
	--
	-- fromName -- The name of the person the message is from.
	-- cmd -- The command code.
	-- msg -- The remainder of the message.
	-- ----------
	local pos1, pos2, version, data;

	pos1, pos2, version, data = string.find(msg, "^(%d+)%s*(.*)$");
	if (not pos1) then
		return;
	end

	rec = {};

	if (cmd == "WD") then
		EkWaitList_Whisper_SentList_Receive_Msg_WD(fromName, version, data);
	end
end

function EkWaitList_Whisper_SentList_Send_Msg_WD(toName)
	-- ----------
	-- Send wait list data messages.
	--
	-- toName -- Name of the person to send the data to.
	-- ----------

	-- <EkWaitList> *WD* Ver Max Num Pos Name Class Local Server Rank Att Name2 Comments

	-- Note: The data may not be sent in position sequence (depends on current sort order).

	local rec, msg, class, rank, name2, numItems, classes;
	local ver;

	numItems = #EkWaitList_WaitList;
	for i = 1, numItems do
		rec = EkWaitList_WaitList[i];

		-- Convert localized class name to a non-localized numeric version.
		class = nil;
		classes = EkWaitList_ClassList;
		for c = 1, #classes do
			if (classes[c]["name"] == rec.class) then
				class = classes[c]["id"];
				break;
			end
		end
		if (not class) then
			-- Use the "Unknown" class.
			class = 1;
		end

		if (rec.rankIndex) then
			rank = rec.rankIndex;
		else
			rank = "-";
		end

		if (rec.altname ~= "") then
			name2 = rec.altname;
		else
			name2 = "*";
		end

		ver = "1";
		msg = "*WD*"
			.. " " .. ver
			.. " " .. numItems
			.. " " .. i
			.. " " .. rec.pos
			.. " " .. rec.name
			.. " " .. class
			.. " " .. rec.local_time
			.. " " .. rec.server_time
			.. " " .. rank
			.. " " .. rec.percent
			.. " " .. name2
			.. " " .. rec.comment;

		EkWaitList_SendWhisper(msg, toName, nil);
	end
end

function EkWaitList_Whisper_SentList_Receive_Msg_WD(fromName, version, data)
	-- ----------
	-- Parse an incoming "WD" message (contains wait list data).
	--
	-- fromName -- The name of the person the message is from.
	-- version -- The version number of the message.
	-- data -- The remainder of the message.
	-- ----------
	local pos1, pos2, numItems, num, pos, name, class, local_time, server_time, rank, percent, name2, comment;
	local locClass, classes;
	local rec = {};

	-- If we already have a wait list being built, or waiting to be used...
	if (EkWaitList_SentList_WaitList) then
		-- If the person that sent this message is not the one that started the temp wait list...
		if (EkWaitList_SentList_From ~= fromName) then
			return;
		end
		-- If we have already received as many messages as we are supposed to...
		if (EkWaitList_SentList_Count <= 0) then
			return;
		end
	end

	if (version == "1") then
		pos1, pos2, numItems, num, pos, name, class, local_time, server_time, rank, percent, name2, comment = 
			string.find(data, "^(%d+) (%d+) (%d+) (%S+) (%d+) (%d+) (%d+) (%S+) (%S+) (%S+)%s*(.*)$");

		if (not pos1) then
			return;
		end

		numItems = tonumber(numItems);
		num = tonumber(num);
		pos = tonumber(pos);

		class = tonumber(class);
		if (not class) then
			class = 1;  -- The "Unknown" class
		end

		-- Convert non-localized numeric class into localized version.
		locClass = nil;
		classes = EkWaitList_ClassList;
		for c = 1, #classes do
			if (classes[c]["id"] == class) then
				locClass = classes[c]["name"];
				break;
			end
		end
		if (not locClass) then
			-- Use the "Unknown" class.
			locClass = classes[1]["name"];
		end

		local_time = tonumber(local_time);
		server_time = tonumber(server_time);

		-- Test for no rank.
		if (rank == "-") then
			rank = nil;
		else
			rank = tonumber(rank);
		end

		percent = tonumber(percent);

		-- Test for no name2.
		if (name2 == "*") then
			name2 = "";
		end
	else
		-- Unknown version
		return;
	end

	if (not numItems or numItems == 0) then
		return;
	end

	if (not num or num == 0) then
		return;
	end

	if (not pos) then
		pos = 1;
	end

	if (not local_time) then
		local_time = time();
	end

	if (not server_time) then
		server_time = time();
	end

	if (not percent) then
		percent = 0;
	end

	rec.pos = pos;
	rec.name = name;
	rec.class = locClass;
	rec.local_time = local_time;
	rec.server_time = server_time;
	rec.rankIndex = rank;
	rec.percent = percent;
	rec.altname = name2;
	rec.comment = comment;

	-- If we haven't started a temp wait list yet, and this is the first record...
	if (not EkWaitList_SentList_WaitList and num == 1) then
		-- Start a new temporary wait list.
		EkWaitList_SentList_WaitList = {};
		EkWaitList_SentList_From = fromName;
		EkWaitList_SentList_Timer = EkWaitList_SentList_TimerDefault;
		EkWaitList_SentList_Count = numItems;
	end

	-- If we still have some records to read...
	if (EkWaitList_SentList_WaitList and EkWaitList_SentList_Count > 0) then

		-- Add this record to the temp wait list
		tinsert(EkWaitList_SentList_WaitList, rec);

		-- One less record to read.
		EkWaitList_SentList_Count = EkWaitList_SentList_Count - 1;

		if (EkWaitList_SentList_Count <= 0) then
			-- This should be the last item in the list.

			-- Set flag so that a prompt window will ask user if they want to use the wait list.
			if (EkWaitList_PromptFrame_Mode ~= EkWaitList_PROMPT_WAITLIST_SENT) then
				EkWaitList_ShowPrompts[EkWaitList_PROMPT_WAITLIST_SENT] = 1;
			end

			-- Turn off the WD message timeout countdown timer.
			EkWaitList_SentList_Timer = nil;
		end
	end
end

function EkWaitList_Whisper_SentList_ReplaceWaitList()
	-- ----------
	-- Replace wait list with the one that was sent to us.
	-- ----------
	local rec, newRec;

	-- Clear the wait list and copy the new data into it.
	EkWaitList_WaitList = {};

	for i = 1, #EkWaitList_SentList_WaitList do
		rec = EkWaitList_SentList_WaitList[i];
		newRec = {};

		for k, v in pairs(rec) do
			newRec[k] = v;
		end

		tinsert(EkWaitList_WaitList, newRec);
	end

	-- Unselect all data and redisplay the wait list.
	EkWaitList_WaitFrame_Selected = {};
	EkWaitList_WaitFrame_Refresh_List(1);

	-- Reset the temp wait list variables.
	EkWaitList_Whisper_SentList_Reset();
end

function EkWaitList_Whisper_SentList_Reset()
	-- ----------
	-- Reset the variables related to the temp wait list.
	-- ----------
	EkWaitList_SentList_WaitList = nil;
	EkWaitList_SentList_From = nil;
	EkWaitList_SentList_Timer = nil;
	EkWaitList_SentList_Count = 0;
end

-- ----------
-- EkCheck interface routines.
-- ----------

function EkWaitList_EkCheck_CreateTooltipText(index, total, data)
	-- ----------
	-- User moved pointer over a line in the list.
	--
	-- index -- position of the item in the list
	-- total -- number of items in the list
	-- data -- Array of data
	--
	-- 	data[]
	-- 	---------------
	-- 	[1] == EkCheck: Player name
	-- 	[2] == EkCheck: Uppercase english class string (ie. non-localized) (eg. "PRIEST")
	-- 	[3] == EkCheck: 0==Addon not loaded, 1==Addon loaded.
	-- 	[4] == EkCheck: 0==Player has not responded to the check, 1==Player has responded to the check.
	-- 	[5] == EkCheck: Player class (localized)
	-- 	[6] to [10] == EkCheck: Reserved
	--
	-- 	[11] == EkWaitList: Version string
	--
	-- Returns:
	--	a) nil -- if no tooltip should be generated.
	--	b) String containing text to appear in the tooltip.
	-- ----------
--	local text;
--	local white = "|c00FFFFFF";
--	return text;

	return nil;
end

function EkWaitList_EkCheck_CreateResponse(data)
	-- ----------------
	-- Create addon specific portion of response string.
	--
	-- data -- Array of data provided by EkCheck.
	--
	-- 	data[]
	-- 	--------
	-- 	[1] == Name of the player that initiated the check.
	-- 	[2] == Name of the addon being checked for.
	--
	-- Returns:
	-- 	a) nil or "" == No addon specific response string.
	--	b) Addon specific response string.
	-- ----------------
	local resp;

	-- Version
	resp = "v" .. EkWaitList_Version;

	-- Return the response string.
	return resp;
end

function EkWaitList_EkCheck_ParseResponse(text, data)
	-- ----------------
	-- Parse response text.
	--
	-- text -- The addon specific portion of the response.
	-- data -- Array of data provided by EkCheck.
	--
	-- 	data[]
	-- 	---------------
	-- 	[1] == Player name
	-- 	[2] == Uppercase english class string (ie. non-localized) (eg. "PRIEST")
	-- 	[3] == 0==Addon not loaded, 1==Addon loaded.
	-- 	[4] == 0==Player has not responded to the check, 1==Player has responded to the check.
	-- 	[5] == Player class (localized)
	--
	-- Returns:
	--	a) nil -- Invalid response
	--      b) Array containing addon specific data (to be used for the check window, tooltip, etc).
	-- ----------------
	local strgmatch = string.gmatch or string.gfind;
	local msg;
	local version;

	version = "?";

	msg = strlower(text);

	for k, v in strgmatch(msg, "(%a)(%S+)") do
		if (k == "v") then
			version = v;
		end
	end

	return { version };
end

