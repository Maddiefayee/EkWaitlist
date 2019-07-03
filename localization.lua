
-- Localization file for EkWaitList
-- Language: English


-- Recent changes:
--v8.2
-- Updated Interface and Version to current.
-- Solved GitHub Issue #1
-- Added Demon Hunter Class
-- v5.01
-- - Added  : EkWaitList_TEXT_Class_Monk
--
-- v1.34:
--   Added  : EkWaitList_TEXT_Help_Text_Text
--   Added  : EkWaitList_TEXT_Channel_Reply
--   Added  : EkWaitList_TEXT_Whisper_Comment
--   Added  : EkWaitList_TEXT_Msg_Who_NoLastWhisper
--   Added  : EkWaitList_TEXT_Whisper_Help_Comment
--   Added  : EkWaitList_TEXT_Whisper_Help_Comment2
--   Added  : EkWaitList_TEXT_Whisper_Help_HowTo
--   Added  : EkWaitList_TEXT_Options_Whispers_Comment
--   Added  : EkWaitList_TEXT_Options_Whispers_Comment_Tooltip1
--   Added  : EkWaitList_TEXT_Options_Whispers_Comment_Tooltip2
--   Changed: EkWaitList_TEXT_Player_Tooltip_Comment
--   Added  : EkWaitList_TEXT_Msg_Comment_Name
--   Added  : EkWaitList_TEXT_Msg_Comment_Current
--   Added  : EkWaitList_TEXT_Msg_Comment_NotOnWaitlist
--   Changed: EkWaitList_TEXT_EditWindow_Comments
--   Changed: EkWaitList_TEXT_EditWindow_Comments_Tooltip1
--
-- v1.30:
-- - Added  : EkWaitList_TEXT_Class_DeathKnight
-- - Added  : EkWaitList_TEXT_Player_Tooltip_Waited_Time
-- - Added  : EkWaitList_TEXT_Waitlist_Added_Column_Tooltip1
-- - Added  : EkWaitList_TEXT_Waitlist_Added_Column_Tooltip2
-- - Added  : EkWaitList_TEXT_Waitlist_Waited_Column_Title 
-- - Added  : EkWaitList_TEXT_Waitlist_Waited_Column_Button_Tooltip1
-- - Added  : EkWaitList_TEXT_Waitlist_Waited_Column_Button_Tooltip2
-- - Changed: EkWaitList_TEXT_Waitlist_Added_Column_Tooltip2
-- - Added  : EkWaitList_TEXT_Options_Show_Tooltips
-- - Added  : EkWaitList_TEXT_Options_Show_Tooltips_Tooltip1
-- - Added  : EkWaitList_TEXT_Options_Show_Tooltips_Tooltip2
-- - Added  : EkWaitList_TEXT_Options_Show_At_Cursor
-- - Added  : EkWaitList_TEXT_Options_Show_At_Cursor_Tooltip1
-- - Added  : EkWaitList_TEXT_Options_Show_At_Cursor_Tooltip2



-- Commands used with the slash command.
EkWaitList_TEXT_Command_Add = "add";
EkWaitList_TEXT_Command_Remove = "remove";
EkWaitList_TEXT_Command_ReloadUI = "rui";
EkWaitList_TEXT_Command_Reset = "reset";
EkWaitList_TEXT_Command_Announce = "who";
EkWaitList_TEXT_Command_Announce2 = "ann";
EkWaitList_TEXT_Command_Announce3 = "announce";
EkWaitList_TEXT_Command_Help = "help";

-- Text used in the description of the add and remove commands, as in "add <name>".
EkWaitList_TEXT_Help_Text_Name = "name";

-- Text used in the description of the comment command, as in "status <text>".
EkWaitList_TEXT_Help_Text_Text = "text";

-- Text used in the description of the announce command, as in "who <channel>".
EkWaitList_TEXT_HELP_Text_Channel = "channel";

-- Help text for the commands.
EkWaitList_TEXT_Help_Add = "Open the 'add a player to the wait list' window.";
EkWaitList_TEXT_Help_AddName = "Add specified player to the wait list.";
EkWaitList_TEXT_Help_Remove = "Remove specified player from the wait list.";
EkWaitList_TEXT_Help_ReloadUI = "Reload your user interface.";
EkWaitList_TEXT_Help_Reset = "Reset window position.";
EkWaitList_TEXT_Help_Announce = "Announce who is on the wait list. You can use any channel name or number that you have already joined, or one of the following keywords:";
EkWaitList_TEXT_Help_Help = "Display this command summary.";
EkWaitList_TEXT_Help_Window = "Toggle the EkWaitList window.";

-- Keywords used by the "/ekwl who" command. Must be in lowercase and unique.
EkWaitList_TEXT_Channel_Guild 	= {"g", "guild"};
EkWaitList_TEXT_Channel_Officer = {"o", "officer"};
EkWaitList_TEXT_Channel_Party 	= {"p", "party"};
EkWaitList_TEXT_Channel_Raid  	= {"r", "raid"};
EkWaitList_TEXT_Channel_Say   	= {"s", "say"};
EkWaitList_TEXT_Channel_Yell 	= {"y", "yell"};
EkWaitList_TEXT_Channel_Reply 	= {"reply"};

-- The whisper commands.
EkWaitList_TEXT_Whisper_Help = "";
EkWaitList_TEXT_Whisper_Who = "who";
EkWaitList_TEXT_Whisper_Add = "add";
EkWaitList_TEXT_Whisper_Main = "main";
EkWaitList_TEXT_Whisper_Remove = "remove";
EkWaitList_TEXT_Whisper_Comment = "status";

-- Class names
EkWaitList_TEXT_Class_Unknown = "Unknown";
EkWaitList_TEXT_Class_DeathKnight = "Death Knight";
EkWaitList_TEXT_Class_Druid = "Druid";
EkWaitList_TEXT_Class_Hunter = "Hunter";
EkWaitList_TEXT_Class_Mage = "Mage";
EkWaitList_TEXT_Class_Monk = "Monk";
EkWaitList_TEXT_Class_Paladin = "Paladin";
EkWaitList_TEXT_Class_Priest = "Priest";
EkWaitList_TEXT_Class_Rogue = "Rogue";
EkWaitList_TEXT_Class_Shaman = "Shaman";
EkWaitList_TEXT_Class_Warlock = "Warlock";
EkWaitList_TEXT_Class_Warrior = "Warrior";
EkWaitList_TEXT_Class_DemonHunter= "Demon Hunter"; -- 7/3/2019

-- Miscellaneous messages
EkWaitList_TEXT_Msg_Invalid_Command = "Invalid command. For help type: %s";
EkWaitList_TEXT_Msg_First_Run = "First run detected.";
EkWaitList_TEXT_Msg_To_Open_Window = "To open the window use %s, or %s.";
EkWaitList_TEXT_Msg_Window_Reset = "The window location has been reset.";

-- Messages related to announcing who is on the wait list to a channel.
EkWaitList_TEXT_Msg_Who_NoKeywordSpecified = "No keyword, channel name, or channel number was specified.";
EkWaitList_TEXT_Msg_Who_InvalidChannel = "Invalid or unjoined chat channel";
EkWaitList_TEXT_Msg_Who_NoLastWhisper = "You currently have no one to reply to.";

-- -----
-- Whisper related messages
-- -----

-- Text sent when someone asks for a list of the whisper commands.
EkWaitList_TEXT_Whisper_Help_Available = "Available wait list whisper commands:";
EkWaitList_TEXT_Whisper_Help_Help = "Display available commands.";
EkWaitList_TEXT_Whisper_Help_Who = "Who is on the wait list.";
EkWaitList_TEXT_Whisper_Help_Add = "Add your current character.";
EkWaitList_TEXT_Whisper_Help_Add2 = "Add one of your characters.";
EkWaitList_TEXT_Whisper_Help_Main = "Add your main character.";
EkWaitList_TEXT_Whisper_Help_Remove = "Remove yourself.";
EkWaitList_TEXT_Whisper_Help_Comment = "Show your status text.";
EkWaitList_TEXT_Whisper_Help_Comment2 = "Change your status text.";
EkWaitList_TEXT_Whisper_Help_HowTo = "Whisper one of the commands shown above to the person in charge of the wait list. For example, to add yourself to Tom's wait list type: /w tom wl add";

-- Text sent when someone asks who is on the wait list.
EkWaitList_TEXT_Whisper_Who_No_One = "There is no one on the waitlist.";
EkWaitList_TEXT_Whisper_Who_One_Name = "There is 1 name on the waitlist:";
EkWaitList_TEXT_Whisper_Who_Many_Names = "There are %d names on the waitlist:";

-- -----
-- Window
-- -----
EkWaitList_TEXT_Window_Click_To_Drag = "Click to drag";

EkWaitList_TEXT_Window_Tab_Wait = "Wait list";
EkWaitList_TEXT_Window_Tab_Wait_Tooltip2 = "Wait list.";

EkWaitList_TEXT_Window_Tab_Options = "Options";
EkWaitList_TEXT_Window_Tab_Options_Tooltip2 = "Configure options.";

-- -----
-- Options window
-- -----
EkWaitList_TEXT_Options_Page1_Tab = "Page 1";
EkWaitList_TEXT_Options_Page2_Tab = "Page 2";

EkWaitList_TEXT_Options_Movable_Window = "Movable window.";
EkWaitList_TEXT_Options_Movable_Tooltip1 = "Movable window";
EkWaitList_TEXT_Options_Movable_Tooltip2 = "If checked, this will make the window movable. You can move it by clicking on the window title and dragging the window around.  If unchecked, the window will act like a standard UI panel.";

EkWaitList_TEXT_Options_Remove_Upon_Join = "Remove player when they join the party/raid.";
EkWaitList_TEXT_Options_Remove_Upon_Join_Tooltip1 = "Automatic player removal";
EkWaitList_TEXT_Options_Remove_Upon_Join_Tooltip2 = "If checked, this will make the addon automatically remove a player from the wait list when they join the party/raid.  If not checked, then you will need to remove the player from the wait list manually.";

EkWaitList_TEXT_Options_Search_Guild_Notes = "Search guild notes for main character names.";
EkWaitList_TEXT_Options_Search_Guild_Notes_Tooltip1 = "Search guild notes for main names";
EkWaitList_TEXT_Options_Search_Guild_Notes_Tooltip2 = "Check this box if you are using the public or officer guild note to store the name of a player's main character.\n\nIf a character does not have a main name in their note, then the addon will use that character's name as the main name.";

EkWaitList_TEXT_Options_Main_Name_Location = "Main name is in the:";
EkWaitList_TEXT_Options_Main_Name_Location_Tooltip1 = "Main name is stored in";
EkWaitList_TEXT_Options_Main_Name_Location_Tooltip2 = "Select whether the main character's name is stored in the public note or the officer note.";

EkWaitList_TEXT_Options_Public_Note = "public note";
EkWaitList_TEXT_Options_Officer_Note = "officer note";

EkWaitList_TEXT_Options_Main_Name_Starts = "Main name starts with:";
EkWaitList_TEXT_Options_Main_Name_Starts_Tooltip1 = "Main name starts with";
EkWaitList_TEXT_Options_Main_Name_Starts_Tooltip2 = "This is the optional text used to mark the start of the main character's name in the guild note.\n\nFor example, if you are using [ as the start text and ] as the end text, then the main name would look like this: [Joe]\n\nBy using appropriate start and/or end text, the main name can be placed anywhere in the guild note.";

EkWaitList_TEXT_Options_Main_Name_Ends = "Main name ends with:";
EkWaitList_TEXT_Options_Main_Name_Ends_Tooltip1 = "Main name ends with";
EkWaitList_TEXT_Options_Main_Name_Ends_Tooltip2 = "This is the optional text used to mark the end of the main character's name in the guild note.\n\nFor example, if you are using [ as the start text and ] as the end text, then the main name would look like this: [Joe]\n\nBy using appropriate start and/or end text, the main name can be placed anywhere in the guild note.";

EkWaitList_TEXT_Options_Show_Tooltips = "Show help tooltips";
EkWaitList_TEXT_Options_Show_Tooltips_Tooltip1 = "Show help tooltips.";
EkWaitList_TEXT_Options_Show_Tooltips_Tooltip2 = "This will enable the display of help tooltips. They will be shown in the default location for game tooltips (the lower right hand corner of the screen) unless you choose to display them by the mouse pointer instead.";

EkWaitList_TEXT_Options_Show_At_Cursor = "Show tooltips by the mouse pointer";
EkWaitList_TEXT_Options_Show_At_Cursor_Tooltip1 = "Location of help tooltips";
EkWaitList_TEXT_Options_Show_At_Cursor_Tooltip2 = "This will display the help tooltips by the mouse pointer rather than at the default location for game tooltips (the lower right corner of the screen).";

EkWaitList_TEXT_Options_Allow_Whispers = "Allow wait list whisper commands.";
EkWaitList_TEXT_Options_Allow_Whispers_Tooltip1 = "Wait list whispers";
EkWaitList_TEXT_Options_Allow_Whispers_Tooltip2 = "This will enable/disable the wait list whisper system, allowing you to quickly turn it on/off without changing each individual whisper command."

EkWaitList_TEXT_Options_Incoming_Whispers = "Display incoming whisper commands.";
EkWaitList_TEXT_Options_Incoming_Whispers_Tooltip1 = "Display incoming whispers";
EkWaitList_TEXT_Options_Incoming_Whispers_Tooltip2 = "This will make the addon display the wait list whisper commands sent to you by other players.";

EkWaitList_TEXT_Options_Outgoing_Whispers = "Display outgoing whisper text.";
EkWaitList_TEXT_Options_Outgoing_Whispers_Tooltip1 = "Display outgoing whispers";
EkWaitList_TEXT_Options_Outgoing_Whispers_Tooltip2 = "This will make the addon display the text whispered to other players in response to their wait list whisper commands.";

EkWaitList_TEXT_Options_Anyone_Can_Use_Add = "Anyone can add themself to the list.";
EkWaitList_TEXT_Options_Anyone_Can_Use_Add_Tooltip1 = "Anyone can add themself to the list";
EkWaitList_TEXT_Options_Anyone_Can_Use_Add_Tooltip2 = "This will allow anyone to add themself to the wait list by whispering the wait list add or main commands.  If this box is not checked, then only the people in your own guild are allowed to whisper the wait list add and main commands.";

EkWaitList_TEXT_Options_Whispers_Commands = "Commands:";

EkWaitList_TEXT_Options_Whispers_Help = "Show available commands";
EkWaitList_TEXT_Options_Whispers_Help_Tooltip1 = "Show available commands";
EkWaitList_TEXT_Options_Whispers_Help_Tooltip2 = "This command will allow a player to find out what wait list whisper commands can be used.";

EkWaitList_TEXT_Options_Whispers_Who = "Show who is on the list";
EkWaitList_TEXT_Options_Whispers_Who_Tooltip1 = "Who is on wait list";
EkWaitList_TEXT_Options_Whispers_Who_Tooltip2 = "This command will allow a player to find out who is on the wait list.";

EkWaitList_TEXT_Options_Whispers_Add = "Add player";
EkWaitList_TEXT_Options_Whispers_Add_Tooltip1 = "Add player to the wait list";
EkWaitList_TEXT_Options_Whispers_Add_Tooltip2 = "This command will allow a player to add themself to the wait list. They can also optionally specify the name of one of their characters in order to add that character to the wait list.";

EkWaitList_TEXT_Options_Whispers_Main = "Add main player";
EkWaitList_TEXT_Options_Whispers_Main_Tooltip1 = "Add main player to the wait list";
EkWaitList_TEXT_Options_Whispers_Main_Tooltip2 = "This command will allow a player to add the name of their main character to the wait list.  If they don't have a main character name then their current character's name will be used instead.";

EkWaitList_TEXT_Options_Whispers_Remove = "Remove player";
EkWaitList_TEXT_Options_Whispers_Remove_Tooltip1 = "Remove player from wait list";
EkWaitList_TEXT_Options_Whispers_Remove_Tooltip2 = "This command will allow a player to remove themself from the wait list.";

EkWaitList_TEXT_Options_Whispers_Comment = "View/change status text";
EkWaitList_TEXT_Options_Whispers_Comment_Tooltip1 = "View/change status text";
EkWaitList_TEXT_Options_Whispers_Comment_Tooltip2 = "This command will allow a player to view or change their wait list status text.";

-- -----
-- Wait list window
-- -----

-- Column headings
EkWaitList_TEXT_Waitlist_Position_Column_Title = "No.";
EkWaitList_TEXT_Waitlist_Position_Column_Tooltip1 = "Position column";
EkWaitList_TEXT_Waitlist_Position_Column_Tooltip2 = "Click on this column to sort the list by position, in either ascending or descending order.";

EkWaitList_TEXT_Waitlist_Name_Column_Title = "Name";
EkWaitList_TEXT_Waitlist_Name_Column_Tooltip1 = "Name column";
EkWaitList_TEXT_Waitlist_Name_Column_Tooltip2 = "Click on this column to sort the list by name, in either ascending or descending order.";

EkWaitList_TEXT_Waitlist_Class_Column_Title = "Class";
EkWaitList_TEXT_Waitlist_Class_Column_Tooltip1 = "Class column";
EkWaitList_TEXT_Waitlist_Class_Column_Tooltip2 = "Click on this column to sort the list by class, in either ascending or descending order.";

EkWaitList_TEXT_Waitlist_Added_Column_Title = "Added";
EkWaitList_TEXT_Waitlist_Added_Column_Tooltip1 = "Added column";
EkWaitList_TEXT_Waitlist_Added_Column_Tooltip2 = "Click on this column to sort the list by when (in local time) the player was added to the wait list, in either ascending or descending order.";

EkWaitList_TEXT_Waitlist_Waited_Column_Title = "Waited";
EkWaitList_TEXT_Waitlist_Waited_Column_Tooltip1 = "Waited column";
EkWaitList_TEXT_Waitlist_Waited_Column_Tooltip2 = "Click on this column to sort the list by how long the player was been on the wait list, in either ascending or descending order.";

EkWaitList_TEXT_Waitlist_Rank_Column_Title = "Rank";
EkWaitList_TEXT_Waitlist_Rank_Column_Tooltip1 = "Rank column";
EkWaitList_TEXT_Waitlist_Rank_Column_Tooltip2 = "Click on this column to sort the list by the player's guild rank, in either ascending or descending order.";

-- Tooltips for button that toggles between added time and waited time.
EkWaitList_TEXT_Waitlist_Added_Column_Button_Tooltip1 = "Added/Waited time";
EkWaitList_TEXT_Waitlist_Added_Column_Button_Tooltip2 = "Click on this button to toggle between showing the added time or the waited time. The waited time is displayed as hours : minutes : seconds.";

-- Text shown at bottom of wait list window scroll area
EkWaitList_TEXT_Waitlist_Total_Waiting = "Total waiting = %d.";
EkWaitList_TEXT_Waitlist_Total_Selected = "Total selected = %d.";

-- Text used in the player's tooltip.
EkWaitList_TEXT_Player_Tooltip_Name = "Name:";
EkWaitList_TEXT_Player_Tooltip_Class = "Class:";
EkWaitList_TEXT_Player_Tooltip_Rank = "Rank:";
EkWaitList_TEXT_Player_Tooltip_Position = "Wait list position:";
EkWaitList_TEXT_Player_Tooltip_Name2 = "Name 2:";
EkWaitList_TEXT_Player_Tooltip_Comment = "Status:";
EkWaitList_TEXT_Player_Tooltip_Added = "-- Added --";
EkWaitList_TEXT_Player_Tooltip_Local_Date = "Local date:";
EkWaitList_TEXT_Player_Tooltip_Local_Time = "Local time:";
EkWaitList_TEXT_Player_Tooltip_Server_Time = "Server time:";
EkWaitList_TEXT_Player_Tooltip_Waited_Time = "Wait time:";
EkWaitList_TEXT_Player_Tooltip_Click1 = "Click:";
EkWaitList_TEXT_Player_Tooltip_Click2 = "Select item.";
EkWaitList_TEXT_Player_Tooltip_Ctrl_Click1 = "Ctrl Click:";
EkWaitList_TEXT_Player_Tooltip_Ctrl_Click2 = "Toggle select.";
EkWaitList_TEXT_Player_Tooltip_Shift_Click1 = "Shift Click:";
EkWaitList_TEXT_Player_Tooltip_Shift_Click2 = "Select range.";
EkWaitList_TEXT_Player_Tooltip_Double_Click1 = "Double Click:";
EkWaitList_TEXT_Player_Tooltip_Double_Click2 = "Edit.";

-- Buttons at bottom of the wait list window.
EkWaitList_TEXT_Menu1Button_Whisper = "Whisper";
EkWaitList_TEXT_Menu1Button_Whisper_Tooltip1 = "Whisper player";
EkWaitList_TEXT_Menu1Button_Whisper_Tooltip2 = "Sends a whisper to the selected player.";

EkWaitList_TEXT_Menu1Button_SelectAll = "Select all";
EkWaitList_TEXT_Menu1Button_UnselectAll = "Unselect all";
EkWaitList_TEXT_Menu1Button_SelectAll_Tooltip1 = "Select/Unselect all";
EkWaitList_TEXT_Menu1Button_SelectAll_Tooltip2 = "Selects/Unselects all of the players in the wait list.\n\n".. "|c00FFFFFF" .. "To select players:\n\nClick:|r Select the player on the line you click on.\n\n" .. "|c00FFFFFF" .. "Control click:|r The player on the clicked line will be added to, or removed from, the group of selected players.\n\n" .. "|c00FFFFFF" .. "Shift click:|r Select all players between the clicked line and a previously selected line.\n";

EkWaitList_TEXT_Menu1Button_Remove = "Remove";
EkWaitList_TEXT_Menu1Button_Remove_Tooltip1 = "Remove";
EkWaitList_TEXT_Menu1Button_Remove_Tooltip2 = "Removes the selected players from the wait list.";

EkWaitList_TEXT_Menu1Button_Invite = "Invite";
EkWaitList_TEXT_Menu1Button_Invite_Tooltip1 = "Invite player";
EkWaitList_TEXT_Menu1Button_Invite_Tooltip2 = "Invites the selected player.";

EkWaitList_TEXT_Menu1Button_Who = "Who";
EkWaitList_TEXT_Menu1Button_Who_Tooltip1 = "Who player";
EkWaitList_TEXT_Menu1Button_Who_Tooltip2 = "Shows /who information for the selected player.";

EkWaitList_TEXT_Menu1Button_Edit = "Edit";
EkWaitList_TEXT_Menu1Button_Edit_Tooltip1 = "Edit player";
EkWaitList_TEXT_Menu1Button_Edit_Tooltip2 = "Edits the selected player's wait list information.";

EkWaitList_TEXT_Menu1Button_Send = "Send list";
EkWaitList_TEXT_Menu1Button_Send_Tooltip1 = "Send wait list";
EkWaitList_TEXT_Menu1Button_Send_Tooltip2 = "Sends a copy of your current wait list to a player.  The person you send it to should also have EkWaitList installed.  The information is sent using whispers.";

EkWaitList_TEXT_Menu1Button_Announce = "Announce";
EkWaitList_TEXT_Menu1Button_Announce_Tooltip1 = "Announce wait list";
EkWaitList_TEXT_Menu1Button_Announce_Tooltip2 = "Announces who is on the wait list to guild chat, officer chat, party chat, raid chat, say, yell, or a specific chat channel.";

EkWaitList_TEXT_Menu1Button_Add = "Add";
EkWaitList_TEXT_Menu1Button_Add_Tooltip1 = "Add player";
EkWaitList_TEXT_Menu1Button_Add_Tooltip2 = "Adds a player to the wait list.";

EkWaitList_TEXT_Menu2Button_Yes = "Yes";
EkWaitList_TEXT_Menu2Button_Yes_Tooltip1 = "Remove: Yes";
EkWaitList_TEXT_Menu2Button_Yes_Tooltip2 = "Removes the selected players from the wait list. Click on the 'No' button if you do not want to remove them.";

EkWaitList_TEXT_Menu2Msg_RemoveNumber = "Remove the %d selected players?";
EkWaitList_TEXT_Menu2Msg_RemoveName = "Remove %s?";
EkWaitList_TEXT_Menu2Button_No = "No";
EkWaitList_TEXT_Menu2Button_No_Tooltip1 = "Remove: No";
EkWaitList_TEXT_Menu2Button_No_Tooltip2 = "Do not remove the player from the wait list.";

EkWaitList_TEXT_Menu3Msg_Whisper = "Send whisper to which character?";
EkWaitList_TEXT_Menu3Button_Name_Tooltip1 = "Whisper: %s";
EkWaitList_TEXT_Menu3Button_Name_Tooltip2 = "Sends a whisper to %s.";
EkWaitList_TEXT_Menu3Button_Cancel = "Cancel";
EkWaitList_TEXT_Menu3Button_Cancel_Tooltip1 = "Whisper: Cancel";
EkWaitList_TEXT_Menu3Button_Cancel_Tooltip2 = "Do not send a whisper.";

EkWaitList_TEXT_Menu4Msg_Invite = "Send invite to which character?";
EkWaitList_TEXT_Menu4Button_Name_Tooltip1 = "Invite: %s";
EkWaitList_TEXT_Menu4Button_Name_Tooltip2 = "Invites %s to join the party/raid.";
EkWaitList_TEXT_Menu4Button_Cancel = "Cancel";
EkWaitList_TEXT_Menu4Button_Cancel_Tooltip1 = "Invite: Cancel";
EkWaitList_TEXT_Menu4Button_Cancel_Tooltip2 = "Do not send an invite.";

EkWaitList_TEXT_Menu5Msg_Who = "Show /who information for which character?";
EkWaitList_TEXT_Menu5Button_Name_Tooltip1 = "Who: %s";
EkWaitList_TEXT_Menu5Button_Name_Tooltip2 = "Shows /who information for %s.";
EkWaitList_TEXT_Menu5Button_Cancel = "Cancel";
EkWaitList_TEXT_Menu5Button_Cancel_Tooltip1 = "Who: Cancel";
EkWaitList_TEXT_Menu5Button_Cancel_Tooltip2 = "Do not display /who information.";

EkWaitList_TEXT_Menu6Msg_RemoveAll = "Are you sure you want to remove ALL players?";

EkWaitList_TEXT_Menu6Button_Yes = "Yes";
EkWaitList_TEXT_Menu6Button_Yes_Tooltip1 = "Remove all: Yes";
EkWaitList_TEXT_Menu6Button_Yes_Tooltip2 = "Removes all of the players from the wait list. Click on the 'No' button if you do not want to remove them."

EkWaitList_TEXT_Menu6Button_No = "No";
EkWaitList_TEXT_Menu6Button_No_Tooltip1 = "Remove all: No";
EkWaitList_TEXT_Menu6Button_No_Tooltip2 = "Do not remove all of the players from the wait list.";

EkWaitList_TEXT_Menu7EB_Tooltip1 = "Send wait list to";
EkWaitList_TEXT_Menu7EB_Tooltip2 = "Enter the name of the player you want to send a copy of the wait list to.";

EkWaitList_TEXT_Menu7Msg_PlayerName = "Name of player";

EkWaitList_TEXT_Menu7Button_Send = "Send list";
EkWaitList_TEXT_Menu7Button_Send_Tooltip1 = "Send wait list to player";
EkWaitList_TEXT_Menu7Button_Send_Tooltip2 = "This will send the contents of your current wait list to the player that you have specified.  The player you send it to should also be using the EkWaitList addon.";

EkWaitList_TEXT_Menu7Button_Cancel = "Cancel";
EkWaitList_TEXT_Menu7Button_Cancel_Tooltip1 = "Cancel";
EkWaitList_TEXT_Menu7Button_Cancel_Tooltip2 = "Do not send the wait list to the specified player.";

EkWaitList_TEXT_Menu8Button_Guild = "Guild";
EkWaitList_TEXT_Menu8Button_Party = "Party";
EkWaitList_TEXT_Menu8Button_Say = "Say";
EkWaitList_TEXT_Menu8Button_Officer = "Officer";
EkWaitList_TEXT_Menu8Button_Raid = "Raid";
EkWaitList_TEXT_Menu8Button_Yell = "Yell";
EkWaitList_TEXT_Menu8Button_Channel = "Channel";
EkWaitList_TEXT_Menu8Button_Cancel = "Cancel";

EkWaitList_TEXT_Menu9EB_Tooltip1 = "Channel name";
EkWaitList_TEXT_Menu9EB_Tooltip2 = "Enter the channel name or number that you want to announce the wait list over.";

EkWaitList_TEXT_Menu9Msg_ChannelName = "Channel name";

EkWaitList_TEXT_Menu9Button_Announce = "Announce";
EkWaitList_TEXT_Menu9Button_Announce_Tooltip1 = "Announce wait list";
EkWaitList_TEXT_Menu9Button_Announce_Tooltip2 = "This will announce the wait list over the channel that you have specified.";

EkWaitList_TEXT_Menu9Button_Cancel = "Cancel";
EkWaitList_TEXT_Menu9Button_Cancel_Tooltip1 = "Cancel";
EkWaitList_TEXT_Menu9Button_Cancel_Tooltip2 = "Do not announce the wait list over the specified channel.";

-- -----
-- Edit box text at bottom of list window.
-- -----
EkWaitList_TEXT_List_EditBox_NotInGuild = "Not in the guild";

-- -----
-- Messages related to sending wait list to another player.
-- -----
EkWaitList_TEXT_Msg_Send_WaitList_To = "Sending wait list to %s.";

-- -----
-- Messages related to removing a player from the wait list.
-- -----
EkWaitList_TEXT_Msg_Remove_Name = "Removed %s";
EkWaitList_TEXT_Msg_Remove_Count_Names = "Removed %d players (%s)";
EkWaitList_TEXT_Msg_Remove_Count = "Removed %d players";

EkWaitList_TEXT_Msg_Remove_Searching_Name = "Searching for %s...";

EkWaitList_TEXT_Msg_RemoveMembers_NameIsInParty = "%s is in the party.";
EkWaitList_TEXT_Msg_RemoveMembers_NameIsInRaid = "%s is in the raid.";

EkWaitList_TEXT_Msg_Removed_Name = "Removed %s.";
EkWaitList_TEXT_Msg_Removed_Unable = "Unable to remove %s.";
EkWaitList_TEXT_Msg_Removed_NotOnWaitlist = "%s is not on the wait list.";

-- -----
-- Messages related to updating a player's comment.
-- -----
EkWaitList_TEXT_Msg_Comment_Ok = "The status for %s has been changed to: %s";
EkWaitList_TEXT_Msg_Comment_Current = "The current status for %s is: %s";
EkWaitList_TEXT_Msg_Comment_NotOnWaitlist = "%s is not on the wait list.";

-- -----
-- Messages related to adding a person to the wait list
-- -----
EkWaitList_TEXT_Msg_Add_Must_Specify_Name = "You must specify a name.";
EkWaitList_TEXT_Msg_Add_Contains_Space = "The specified name contains a space.";
EkWaitList_TEXT_Msg_Add_Second_Equals_First = "The second name is the same as the first name.";
EkWaitList_TEXT_Msg_Add_Name_On_Waitlist = "%s is already on the wait list.";
EkWaitList_TEXT_Msg_Add_Not_In_Guild = "Note: %s is not in the guild.";
EkWaitList_TEXT_Msg_Add_Must_Be_In_Guild = "You must be in the same guild as the person running the wait list in order to use the add command.";
EkWaitList_TEXT_Msg_Add_In_Raid = "%s is already in the raid.";
EkWaitList_TEXT_Msg_Add_In_Party = "%s is already in the party.";
EkWaitList_TEXT_Msg_Add_Unable_To_Add = "Unable to add %s to the wait list.";
EkWaitList_TEXT_Msg_Add_Searching_Name = "Searching for %s...";

EkWaitList_TEXT_Msg_Add_OnlyYourName_NotGuild = "You can only add your own character's name.";
EkWaitList_TEXT_Msg_Add_OnlyYourName_Guild = "You can only add the name of one of your own characters.";

-- Comment used when someone adds themself to the wait list via a whisper command.
EkWaitList_TEXT_Msg_Add_Via_Whisper = "Added via whisper.";
EkWaitList_TEXT_Msg_Add_Via_Whisper_Why = "Whisper";

-- Results message when someone is added to the wait list.
EkWaitList_TEXT_Msg_Add_Results = "%s has been added to the wait list.";

-- -----
-- Edit window
-- -----
EkWaitList_TEXT_EditWindow_Name = "Name:";
EkWaitList_TEXT_EditWindow_Name_Tooltip1 = "Name of player.";
EkWaitList_TEXT_EditWindow_Name_Tooltip2 = "Enter the name of the player you want to add to the wait list. This is a required item.";

EkWaitList_TEXT_EditWindow_Class = "Class:";
EkWaitList_TEXT_EditWindow_Class_Tooltip1 = "Class";
EkWaitList_TEXT_EditWindow_Class_Tooltip2 = "Select the player's class. This is an optional item.";

EkWaitList_TEXT_EditWindow_Name2 = "Name 2:";
EkWaitList_TEXT_EditWindow_Name2_Tooltip1 = "Other (contact) name.";
EkWaitList_TEXT_EditWindow_Name2_Tooltip2 = "Enter the name of the other character that the player will be playing while waiting to join the raid.  This is an optional item.";

EkWaitList_TEXT_EditWindow_Comments = "Status:";
EkWaitList_TEXT_EditWindow_Comments_Tooltip1 = "Status";
EkWaitList_TEXT_EditWindow_Comments_Tooltip2 = "Enter comments about the player. This is an optional item.";

-- Edit window titles
EkWaitList_TEXT_EditWindow_Title_Add = "Add player to wait list";
EkWaitList_TEXT_EditWindow_Title_Edit = "Edit player on wait list";

-- Validation text displayed under name and name2 edit boxes
EkWaitList_TEXT_EditWindow_Valid_Required = "This name is required";
EkWaitList_TEXT_EditWindow_Valid_Contains_Space = "Name contains a space";
EkWaitList_TEXT_EditWindow_Valid_Same_As_Name1 = "This is the same as name 1";
EkWaitList_TEXT_EditWindow_Valid_Same_As_Name2 = "This is the same as name 2";
EkWaitList_TEXT_EditWindow_Valid_Not_In_Guild = "Not in the guild";
EkWaitList_TEXT_EditWindow_Valid_Name_On_WaitList = "%s is on the list";
EkWaitList_TEXT_EditWindow_Valid_Name_In_Raid = "%s is in the raid";
EkWaitList_TEXT_EditWindow_Valid_Name_In_Party = "%s is in the party";

-- Messages when OK'ing the add/edit.
EkWaitList_TEXT_EditWindow_Ok_Add = "Added %s to the wait list";
EkWaitList_TEXT_EditWindow_Ok_Edit = "Updated wait list entry for %s.";

-- Buttons at bottom of the edit window.
EkWaitList_TEXT_EditWindow_Button_Ok = "Ok";
EkWaitList_TEXT_EditWindow_Button_Ok_Add_Tooltip1 = "Add: Ok";
EkWaitList_TEXT_EditWindow_Button_Ok_Add_Tooltip2 = "Adds the player to the wait list.";
EkWaitList_TEXT_EditWindow_Button_Ok_Edit_Tooltip1 = "Edit: Ok";
EkWaitList_TEXT_EditWindow_Button_Ok_Edit_Tooltip2 = "Keeps any changes you have made to this player.";

EkWaitList_TEXT_EditWindow_Button_Cancel = "Cancel";
EkWaitList_TEXT_EditWindow_Button_Cancel_Add_Tooltip1 = "Add: Cancel";
EkWaitList_TEXT_EditWindow_Button_Cancel_Add_Tooltip2 = "Do not add the player to the wait list."
EkWaitList_TEXT_EditWindow_Button_Cancel_Edit_Tooltip1 = "Edit: Cancel";
EkWaitList_TEXT_EditWindow_Button_Cancel_Edit_Tooltip2 = "Do not keep any changes you have made.";

-- -----
-- Prompt window
-- -----

EkWaitList_TEXT_PromptWindow_Disable_Prompt = "Disable this prompt.";
EkWaitList_TEXT_PromptWindow_Disable_Prompt_Tooltip1 = "Disable this prompt";
EkWaitList_TEXT_PromptWindow_Disable_Prompt_Tooltip2 = "This will disable this prompt so that it will not appear again.  It can be re-enabled by toggling the EkWaitList option related to this prompt.";

EkWaitList_TEXT_PromptWindow_Not_Again_While = "Do not prompt again while in this raid.";
EkWaitList_TEXT_PromptWindow_Not_Again_Until = "Do not prompt again until I join a raid.";
EkWaitList_TEXT_PromptWindow_Not_Again_Tooltip1 = "Do not prompt again while...";
EkWaitList_TEXT_PromptWindow_Not_Again_Tooltip2 = "This will temporarily disable this prompt while you are in a raid.  If you are not in a raid, then it will disable the prompt until you join a raid.";

EkWaitList_TEXT_PromptWindow_Joined_Raid_Clear_Waitlist = "You have joined a raid.\n" .. "|c00FFFFFF" .. "Do you want to clear the wait list?|r";
EkWaitList_TEXT_PromptWindow_Button_Clear = "Clear waitlist";
EkWaitList_TEXT_PromptWindow_Button_Close = "Close";

EkWaitList_TEXT_PromptWindow_Sent_You_A_Wait_List = "%s has sent you a wait list.\n" .. "|c00FFFFFF" .. "Do you want to replace your wait list?|r"
EkWaitList_TEXT_PromptWindow_Button_Replace = "Replace";
EkWaitList_TEXT_PromptWindow_Button_No = "No";

-- -----
-- Attendance percentages
-- -----

-- Date/time the attendance data is as of.
EkWaitList_TEXT_Msg_Attendance_As_Of = "Attendance percentage data as of\n";

-- View button on the wait list window
EkWaitList_TEXT_Waitlist_View_Button = "View";
EkWaitList_TEXT_Waitlist_View_Button_Tooltip1 = "View data";
EkWaitList_TEXT_Waitlist_View_Button_Tooltip2 = "View the attendance percentage data.";

-- Attendance percentage column title and tooltip.
EkWaitList_TEXT_Waitlist_Percent_Column_Title = "Att.%";
EkWaitList_TEXT_Waitlist_Percent_Column_Tooltip1 = "Attendance % column";
EkWaitList_TEXT_Waitlist_Percent_Column_Tooltip2 = "Click on this column to sort the list by the player's attendance percentage, in either ascending or descending order.";

-- Tooltips for button that toggles between guild rank and attendance percentage.
EkWaitList_TEXT_Waitlist_Rank_Column_Button_Tooltip1 = "Attendance/Rank";
EkWaitList_TEXT_Waitlist_Rank_Column_Button_Tooltip2 = "Click on this button to toggle between showing the attendance percentage or the guild rank.";

-- Text for a line in the player's tooltip that shows their attendance percentage.
EkWaitList_TEXT_Player_Tooltip_Attendance = "Attendance:";

-- -----
-- EkCheck column headling.
-- -----
EkWaitList_TEXT_EkCheck_Version = "Version";

-- -----
-- Key bindings
-- -----
BINDING_HEADER_EKWAITLIST = "EkWaitList";
BINDING_NAME_EKWAITLIST_TOGGLE = "Toggle current window"; 
