AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_hudpickup.lua")
AddCSLuaFile("cl_spawnmenu.lua")
AddCSLuaFile("cl_deathnotice.lua")
AddCSLuaFile("cl_pickteam.lua")
AddCSLuaFile("cl_voice.lua")

AddCSLuaFile("obj_player_extend.lua")
AddCSLuaFile("gravitygun.lua")
AddCSLuaFile("player_shd.lua")
AddCSLuaFile("animations.lua")
AddCSLuaFile("player_class/player_default.lua")
AddCSLuaFile("player_class/player_survivor.lua")
AddCSLuaFile("player_class/player_monster.lua")
AddCSLuaFile("util.lua")

-- Disabled flashlight because it's bugged.
--AddCSLuaFile("flashlight_init.lua")

include("shared.lua")
include("player.lua")
include("npc.lua")
include("variable_edit.lua")
include("resources.lua")

GM.PlayerSpawnTime = {}

--[[---------------------------------------------------------
   Name: gamemode:Initialize()
   Desc: Called immediately after starting the gamemode
-----------------------------------------------------------]]
function GM:Initialize()
	hook.Call()
end

--[[---------------------------------------------------------
   Name: gamemode:InitPostEntity()
   Desc: Called as soon as all map entities have been spawned
-----------------------------------------------------------]]
function GM:InitPostEntity()
end

--[[---------------------------------------------------------
   Name: gamemode:Think()
   Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think()
end

--[[---------------------------------------------------------
   Name: gamemode:ShutDown()
   Desc: Called when the Lua system is about to shut down
-----------------------------------------------------------]]
function GM:ShutDown()
end

--[[---------------------------------------------------------
   Name: gamemode:DoPlayerDeath()
   Desc: Carries out actions when the player dies
-----------------------------------------------------------]]
function GM:DoPlayerDeath(ply, attacker, dmginfo)

	ply:CreateRagdoll()
	local ragdoll = ply:GetRagdollEntity();
	ragdoll:EmitSound(Sound("wilhelm.wav"));

	ply:AddDeaths(1)

	if (attacker:IsValid() and attacker:IsPlayer()) then

		if (attacker == ply) then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end

	end

end

--[[---------------------------------------------------------
   Name: gamemode:EntityTakeDamage(ent, info)
   Desc: The entity has received damage
-----------------------------------------------------------]]
function GM:EntityTakeDamage(ent, info)
end

--[[---------------------------------------------------------
   Name: gamemode:CreateEntityRagdoll(entity, ragdoll)
   Desc: A ragdoll of an entity has been created
-----------------------------------------------------------]]
function GM:CreateEntityRagdoll(entity, ragdoll)
end

-- Set the ServerName every 30 seconds in case it changes..
-- This is for backwards compatibility only - client can now use GetHostName()
local function HostnameThink()

	SetGlobalString("ServerName", GetHostName())

end

timer.Create("HostnameThink", 30, 0, HostnameThink)

--[[---------------------------------------------------------
	Show the default team selection screen
-----------------------------------------------------------]]
function GM:ShowTeam(ply)

	if (not GAMEMODE.TeamBased) then return end

	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if (ply.LastTeamSwitch and RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint(Format("Please wait %i more seconds before trying to change team again", (TimeBetweenSwitches - (RealTime() - ply.LastTeamSwitch)) + 1))
		return false
	end

	-- For clientside see cl_pickteam.lua
	ply:SendLua("GAMEMODE:ShowTeam()")

end

--
-- CheckPassword(steamid, networkid, server_password, password, name)
--
-- Called every time a non-localhost player joins the server. steamid is their 64bit
-- steamid. Return false and a reason to reject their join. Return true to allow
-- them to join.
--
function GM:CheckPassword(steamid, networkid, server_password, password, name)

	-- The server has sv_password set
	if (server_password ~= "") then

		-- The joining clients password doesn't match sv_password
		if (server_password ~= password) then
			return false, "#GameUI_ServerRejectBadPassword"
		end

	end

	--
	-- Returning true means they're allowed to join the server
	--
	return true

end
