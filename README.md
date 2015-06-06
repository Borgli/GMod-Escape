# secretOHMproject
Repository for the Ohm project known as "horror escape"

##How to install:

Clone the repo into `\Steam\steamapps\common\GarrysMod\garrysmod\gamemodes\` 

##Quick info:

"init.lua" - lua file that is executed by the server when it starts.
"cl_init.lua" - lua file that is executed by the client when it connects.
"shared.lua" - file shared by the server and the client.

##TODO-list:
- Fix flashlight world model and primary attack
- Add survivor player models.
- Separate from workshop so we don't have to download everything from a pack when we use a small part.
- Design monster
- Add monster client overlay (effects)
- Make round system. (Implemented, but full of bugs)
- Fix spawn. Die -> spectator mode until next round. Leave a ragdoll. (Implemented, but full of bugs)
- Make map key entities and make them work with locked doors.

## Maps:
- slender_infirmary: http://steamcommunity.com/sharedfiles/filedetails/?id=188570584

## Monsters

- Robert (placeholdername)
	Runs fast while invisible, but slower than normal while visible. 30 second cooldown.
	Cannot attack while invisible. (Disabled)
	Footstep-noise while invisible.
