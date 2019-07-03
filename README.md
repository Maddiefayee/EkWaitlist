EkWaitList - A World of Warcraft addon

Addon: **EkWaitList**\
 Author: Dargen\
 Guild: Eternal Keggers\
 Server: Norgannon\
 \

* * * * *

**Description:**

EkWaitList is a wait list addon that will let you maintain a list of
people in the same order that they were added to the list. You can also
sort the list by name, class, guild rank, or the time they were added to
the list. If you are in a party or raid when someone on the wait list
joins the party/raid, then they can be automatically be removed from the
wait list.

You can update the list manually, or have people send special whisper
commands to the person in charge of the wait list. These special whisper
commands allow people to add themselves to the wait list, to remove
themselves from the wait list, and to see who is currently on the wait
list. You can choose whether to accept whispers only from guild members,
or from anyone.

EkWaitList can also make use of main character names stored in guild
notes to allow people to whisper from either their main or alternate
characters, and remove the correct player from the wait list when they
join a party/raid.

The addon allows you to send (via whispers) a copy of the wait list data
to someone else that also has EkWaitList installed. The main purpose for
this is to provide a way for the wait list to be given to someone else
when the person currently in charge of the wait list has to leave.

The only person that has to have the addon installed is the person in
charge of the wait list. EkWaitList does not use a communcations
channel, nor does it track whether a player is online/offline or what
zone they are in.

If you have the EkRaidAttend addon installed, then EkWaitList can
provide the names of the people on the wait list to EkRaidAttend so that
it can record their names in attendance lists. EkRaidAttend is not
required to run EkWaitList.

NOTE: The game does not save any addon information until you logout or
reload your user interface. This is the case for every addon that you
have. Because of this, there is a risk that you might lose the
information in the wait list if you get disconnected or your game
crashes. To avoid this you may want to periodically logout or reload
your user interface. You can reload your UI at any time with the
following command: /ekwaitlist rui

* * * * *

**Command summary:**

You can use either **/ekwl**, or **/ekwaitlist**, to begin any of these
commands:

-   **/ekwl add** -- Open the 'add a player to the wait list' window.
-   **/ekwl add &ltname\>** -- Add the specified player to the wait
    list.
-   **/ekwl remove &ltname\>** -- Remove the specified player from the
    wait list.
-   **/ekwl rui** -- Reload your user interface.
-   **/ekwl reset** -- Reset window position.
-   **/ekwl who &ltchannel\>** -- Announce who is on the wait list. You
    can use any channel name or number that you have already joined, or
    one of the following keywords: g, guild, o, officer, p, party, r,
    raid, s, say, y, yell. If you omit the channel and are in a guild,
    then it will announce to guild chat by default.
-   **/ekwl help/?** -- Displays this command summary.
-   **/ekwl** -- Toggles the EkWaitList window.

\

**Wait list whisper commands**

These are the commands that players can whisper to the person in charge
of the wait list. You can enable/disable each whisper command from the
EkWaitList options windows.

-   **wl** -- Display the available wait list whisper commands.
-   **wl who** -- Display who is on the wait list.
-   **wl add** -- Add your current character to the wait list.
-   **wl add &ltname\>** -- Add one of your characters to the wait list.
-   **wl main** -- Add your main character to the wait list.
-   **wl remove** -- Remove yourself from the wait list.

Some examples:

-   If Jane was in charge of the wait list and you wanted to add
    yourself to it, you would use the following command: **/tell jane wl
    add**
-   To remove yourself from Jane's wait list you would type: **/tell
    jane wl remove**

* * * * *

**Main/alternate character names**

To find out which characters belong to the same player, the addon will
look in a character's public or officer guild note for the name of the
main character. There is an option in the EkWaitList UI that lets you
tell the addon whether you are storing the main character names in the
public guild note or in the officer guild note.

The main character name can be located anywhere in the guild note, as
long as the addon can find it. The addon searches for the main character
name by looking for specific text before and/or after the name. There
are options available in the EkWaitList UI that allow you to specify the
text (if any) that precedes the main character name in the guild note,
and the text (if any) that follows the main character name in the guild
note. Each main character name must be spelled correctly and follow the
correct format.

Here are some examples of different ways to specify the main character's
name in a guild note. The guild note in the examples below are for an
alternate character named Joe, who has a main character named Tom. In
this example, "[" and "]" are used around the main character name to
identify it as such.

-   Example 1: [Tom]
-   Example 2: [Tom]This is Joe's guild note
-   Example 3: This is Joe's [Tom] guild note
-   Example 4: This is Joe's guild note [Tom]

It is not necessary to put the main character's name in their own guild
note. If the addon cannot find a name in a character's guild note, then
it assumes that they are the main character.

Although the name of the main character can be put anywhere in the guild
note, you might find it convenient to put it at the start of the note.
This way all of the characters belonging to a player will be grouped
together if you sort the guild list by the note column.

Main character names are used by the addon to correctly update the wait
list when dealing with players on alternate characters. For example, it
can detect if a main character joins the party/raid when their alternate
name is on the wait list.

The addon will work even if you do not put main character names in
players guild notes. It will just assume that every character is a main
character.

* * * * *

**The Wait List window**

This window allows you to maintain a list of people that are waiting to
join the party/raid. You can specify a main name, a class, an second
name (that the person will play while waiting for a spot to open), and a
comment. Only the main name is required.

The list keeps track of when the person was added to the wait list, and
what position they are in the list. Their position in the list
corresponds to the order in which they were added to the list. You can
also sort the list in ascending or descending order by clicking on any
of the column headings.

You can select one name by clicking on it once. If you control click on
a name, you will add it to the current selection (or remove it from the
current selection if it is already selected). If you shift click on a
name, you will select all names between the name you click on and
another already selected name. The **"Select all"** button will let you
quickly select all of the names.

You can send an invite to the selected player, send them a whisper, or
display /who information about them.

When you join a new raid, if you have any names in the wait list then
the addon will ask if you want to clear the waitlist. It does this in
case you have old names in the wait list from a previous raid.

Players that join the party/raid can be automatically removed from the
wait list by the addon. There is an option to enable/disable automatic
removal.

The addon allows players to whisper certain commands to the person in
charge of the wait list. With them they can view the available commands
(**wl**), view who is on the wait list (**wl who**), add their current
character to the wait list (**wl add**), add any one of their characters
to the wait list (**wl add &ltname\>**), add their main character to the
wait list (**wl main**), or remove themself from the wait list (**wl
remove**). Each whisper command can be enabled/disabled in the options
window, or you can disable the entire wait list whisper system. You can
also configure whether or not you will see the incoming and outgoing
wait list whispers in your chat window.

You can send a copy of your wait list to someone else by using the
**"Send"** button on the wait list window. The information is sent via
whispers to the person you specify. The person you send the wait list to
should also have the EkWaitList addon installed.

You can use the **"Announce"** button to tell everyone in a chat channel
who is on the wait list. The names can be send to guild chat, officer
chat, party chat, raid chat, say, yell, and any named or numbered chat
channel that you are already joined to.

* * * * *

**The Options window**

**Make this window movable**

The EkWaitList window can operate like a standard UI window such as the
social window (friends, guild, etc) or you can turn on this option to
move it anywhere on the screen.

**Allow wait list whisper commands**

This option will enable/disable the wait list whisper system, allowing
you to quickly turn it on/off without changing each individual whisper
command. When this option is enabled, players will be able to view the
wait list, add themselves to the wait list, or remove themselves from
the wait list, simply by whispering certain commands to the person in
charge of the wait list.

-   **Display incoming whisper commands**

    This option will make the addon display the wait list whisper
    commands sent to you by other players. Turn this option off if you
    don't want to see their wait list whisper commands in your chat
    window.

-   **Display outgoing whisper text**

    This option will make the addon display the text whispered to other
    players in response to their wait list whisper commands. Turn this
    option off if you don't want to see the whispers the addon sends to
    them in your chat window.

-   **Anyone can add themself to the list**

    This option will allow anyone to add themself to the wait list by
    whispering the "wl add" or "wl main" commands. If this option is not
    checked, then only the people in your own guild are allowed to
    whisper the "wl add" and "wl main" commands.

-   **Show available commands (wl)**

    Enabling this option allows the players to whisper the command
    (**wl**) that will let them find out what the available wait list
    commands are.

-   **Show who is on the list (wl who)**

    Enabling this option allows the players to whisper the command (**wl
    who**) that will let them find out who is on the wait list.

-   **Add a player (wl add) (wl add &ltname\>)**

    Enabling this option allows players to whisper the command (**wl
    add**) in order to add themselves to the wait list.

    The player does not have to type their own name. The addon can tell
    who sent the whisper and add the correct person automatically.

    If you do type a name after the "wl add" command then that name (if
    it is one of your own characters) will be added to the wait list
    instead of your current character's name. In order for the addon to
    know if the name you specify is one of your own characters, your
    guild must be using the [main] name format in the guild notes for
    alternate characters.

-   **Add main player (wl main)**

    Enabling this option allows players to whisper the command (**wl
    main**) in order to add their main character to the wait list. If a
    character does not have a main name (such as when they are not in
    your guild), then their current character name will be used instead.

-   **Remove player (wl remove)**

    Enabling this option allows the players to whisper the command (**wl
    remove**) that will let them remove themselves from the wait list.

    Note: The player does not have to type their own name. The addon can
    tell who sent the whisper and remove the correct person
    automatically.

**Remove player when they join the party/raid**

If this option is selected, then the addon will automatically remove a
player from the wait list when they join the party/raid. If not
selected, then you will need to remove the player from the wait list
manually.

**Search guild notes for main character names**

If you select this option, then the addon will search through a player's
public or officer guild note to try and find the name of their main
character. This main character name is used to identify which characters
belong to the same player. This information can be used to correctly
update the wait list when dealing with main and alternate characters.

This is an example of a guild note that contains a main character name,
and uses the "[" and "]" characters to start and end the name: **abc
[Joe] def**. If a character does not have a main name included in their
guild note, then the addon will automatically use the character's name
as their main name.

-   **Which guild note is the main name stored in**

    The character's main name can be stored in either the public or
    officer guild note. The main name can be placed anywhere in the note
    as long as the addon is able to locate it. To locate it, the addon
    requires that you surround the name with special text.

-   **The text that appears before the main name**

    This option will let you specify the text that will appear in the
    guild note before the name of the main character. The default text
    for this is "[" (without the quotes). This text can be 0 or more
    characters in length.

-   **The text that appears after the main name**

    This option will let you specify the text that will appear in the
    guild note after the name of the main character. The default text
    for this is "]" (without the quotes). This text can be 0 or more
    characters in length.

* * * * *

**Change History**

**Version 1.12 changes (Aug 23, 2006):**

-   Fixed bug: When sending the wait list to another person, the guild
    ranks were not transferring correctly.
-   Made some changes to avoid a possible error at login time that could
    occur if the client thinks that there are guild members and the
    guild member information is not yet available.

**Version 1.11 changes (Aug 22, 2006):**

-   Added a "Remove player when they join the party/raid" option. If
    this option is enabled, then a player that is on the wait list will
    automatically be removed from it when they join the party/raid. If
    the option is disabled, then the player will have to be removed
    manually from the wait list. This option is enabled by default.
-   Automatic removal of players should now work when you are in a party
    that is not part of a raid.
-   Added a "/ekwl who &ltchannel\>" command. This will announce who is
    on the wait list to the specified channel. You can specify a channel
    name or number that you are already joined to, or one of the
    following keywords: g, guild, o, officer, p, party, r, raid, s, say,
    y, yell. If channel is omitted and you are in a guild, then guild
    chat will be used by default.
-   Added an "Announce" button to the wait list window. This will do the
    same thing as the new "/ekwl who" command.
-   Added a keybinding to toggle the wait list window.
-   You can now specify a name when using the "wl add" whisper command
    (for example: wl add joe). This allows you to add any of your own
    characters to the wait list, regardless of which character you are
    currently playing as. In order for the addon to know what the names
    of your other characters are, your guild has to be using the [main]
    name format in guild notes for alternate characters.
-   Added a "wl main" whisper command. This is just like the "wl add"
    command except that it will only add the name of your main character
    to the wait list. If you don't have a main character name then it
    will use your current character's name instead.
-   Changed UI version to 11200 to match the WoW 1.12 patch.

**Version 1.0 changes (Jun 19, 2006):**

-   Initial release.
-   The code for most of this addon was originally part of EkRaidAttend
    2.0 (released Dec 27, 2005) through 2.3 (released May 29, 2006)
    until EkRaidAttend was split into separate addons.
-   The wait list whisper command that shows the available commands
    ("wl"), can now be enabled and disabled if desired (default is
    enabled).
-   Added a "Send" button that will allow you to send the wait list data
    (via whispers) to another person with the EkWaitList addon
    installed.

