# Horror Escape
Repository for the project known as "horror escape".
This is a game mode for the game Garry's Mod.

## How to install:

Clone the repo into `\Steam\steamapps\common\GarrysMod\garrysmod\gamemodes\` 

## Quick info:

"init.lua" - lua file that is executed by the server when it starts.
"cl_init.lua" - lua file that is executed by the client when it connects.
"shared.lua" - file shared by the server and the client.

## Issues:
- Round system is bugged and needs refining.
- Welcome screen not yet working, but is being worked on.

## New TODO:
- Create welcome screen.
- Scorescreen.
- Partly alpha blood overlay for survivors.
- Night vision for monster.
- Flashlight for survivors.
- Hand model for monster.
- Weapon for monster.
- Logic for keys, can be inside buckets, shelves etc. (Okayish hidden).
- Monster ability to easy kill, and counter ability for survivors.
  * Mad, constant laugh from Joker.
  * Low, scared sound from survivor when close to monster?
  * When Joker sees something, tag and freeze enemy (with cooldown) with line.
  * When Joker looks at someone with cursor, make outline around and 
    make target freezable.
  * After Joker has killed someone, make them smile with button.
- Footsteps from survivors and monster (different sounds).
- Fix flashlight model and system.
- Improve monster client overlay.
- Fix round system.
- Spectator mode when dead.
- Make map key entities and make them work with locked doors.
- Separate from workshop so we don't have to download everything from a pack when we use a small part.

## Maps:
- slender_infirmary: http://steamcommunity.com/sharedfiles/filedetails/?id=188570584

## Monsters

- Robert (placeholdername)
	Runs fast while invisible, but slower than normal while visible. 30 second cooldown.
	Cannot attack while invisible. (Disabled)
	Footstep-noise while invisible.
