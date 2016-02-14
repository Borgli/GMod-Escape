include('shared.lua')

--[[---------------------------------------------------------
	Name: gamemode:PlayerInitialSpawn()
	Desc: Called just before the player's first spawn
-----------------------------------------------------------]]
-- First time player spawns on server
function GM:PlayerInitialSpawn(pl)
   	print("Inside GM:PlayerInitialSpawn!")
    pl:SetTeam(TEAM_UNASSIGNED)
    table.insert(ACTIVE_PLAYERS, pl);
end



--[[---------------------------------------------------------
	Name: gamemode:PlayerAuthed()
	Desc: Player's STEAMID has been authed
-----------------------------------------------------------]]
function GM:PlayerAuthed(ply, SteamID, UniqueID)
	print("Inside GM:PlayerAuthed!")
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanPickupWeapon()
	Desc: Called when a player tries to pickup a weapon.
		return true to allow the pickup.
-----------------------------------------------------------]]
function GM:PlayerCanPickupWeapon(player, entity)
	return false

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanPickupItem()
	Desc: Called when a player tries to pickup an item.
		 return true to allow the pickup.
-----------------------------------------------------------]]
function GM:PlayerCanPickupItem(player, entity)
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerUnfreeze()
	Desc: Can the player unfreeze this entity & physobject
-----------------------------------------------------------]]
function GM:CanPlayerUnfreeze(ply, entity, physobject)
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerDisconnected()
	Desc: Player has disconnected from the server.
-----------------------------------------------------------]]
function GM:PlayerDisconnected(player)
	print("Removed ACTIVE_PLAYERS!")
   table.remove( ACTIVE_PLAYERS, table.KeyFromValue( ACTIVE_PLAYERS, player ) );
   if (table.HasValue(CURRENT_ALIVE,player)) then
   	table.remove( CURRENT_ALIVE, table.KeyFromValue( CURRENT_ALIVE, player ) );
   end

   DetectEndRound();
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSay()
	Desc: A player (or server) has used say. Return a string
		 for the player to say. Return an empty string if the
		 player should say nothing.
-----------------------------------------------------------]]
function GM:PlayerSay(player, text, teamonly)

	return text

end


--[[---------------------------------------------------------
	Name: gamemode:PlayerDeathThink(player)
	Desc: Called when the player is waiting to respawn
-----------------------------------------------------------]]
function GM:PlayerDeathThink(pl, newteam)

	if (pl.NextSpawnTime and pl.NextSpawnTime > CurTime()) then return
	end

	if (pl:KeyPressed(IN_ATTACK) or pl:KeyPressed(IN_ATTACK2) or pl:KeyPressed(IN_JUMP)) then

		pl:Spawn()

	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerUse(player, entity)
	Desc: A player has attempted to use a specific entity
		Return true if the player can use it
------------------------------------------------------------]]
function GM:PlayerUse(pl, entity)

	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSilentDeath()
	Desc: Called when a player dies silently
-----------------------------------------------------------]]
function GM:PlayerSilentDeath(Victim)

	Victim.NextSpawnTime = CurTime() + 2
	Victim.DeathTime = CurTime()

end

-- Pool network strings used for PlayerDeaths.
util.AddNetworkString("PlayerKilled")
util.AddNetworkString("PlayerKilledSelf")
util.AddNetworkString("PlayerKilledByPlayer")

--[[---------------------------------------------------------
	Name: gamemode:PlayerDeath()
	Desc: Called when a player dies.
-----------------------------------------------------------]]
function GM:PlayerDeath(ply, inflictor, attacker)

	-- Don't spawn for at least 2 seconds
	--ply.NextSpawnTime = CurTime() + 2
	--ply.DeathTime = CurTime()

	if (IsValid(attacker) and attacker:GetClass() == "trigger_hurt") then attacker = ply end

	if (IsValid(attacker) and attacker:IsVehicle() and IsValid(attacker:GetDriver())) then
		attacker = attacker:GetDriver()
	end

	if (not IsValid(inflictor) and IsValid(attacker)) then
		inflictor = attacker
	end

	-- Convert the inflictor to the weapon that they're holding if we can.
	-- This can be right or wrong with NPCs since combine can be holding a
	-- pistol but kill you by hitting you with their arm.
	if (IsValid(inflictor) and inflictor == attacker and (inflictor:IsPlayer() or inflictor:IsNPC())) then

		inflictor = inflictor:GetActiveWeapon()
		if (not IsValid(inflictor)) then inflictor = attacker end

	end

	if (attacker == ply) then

		net.Start("PlayerKilledSelf")
		net.WriteEntity(ply)
		net.Broadcast()

		MsgAll(attacker:Nick() .. " suicided \n")

		return end

	if (attacker:IsPlayer()) then

		net.Start("PlayerKilledByPlayer")

		net.WriteEntity(ply)
		net.WriteString(inflictor:GetClass())
		net.WriteEntity(attacker)

		net.Broadcast()

		MsgAll(attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. inflictor:GetClass() .. "\n")

		return end

	net.Start("PlayerKilled")

	net.WriteEntity(ply)
	net.WriteString(inflictor:GetClass())
	net.WriteString(attacker:GetClass())

	net.Broadcast()

	MsgAll(ply:Nick() .. " was killed by " .. attacker:GetClass() .. "\n")

	table.remove( CURRENT_ALIVE, table.KeyFromValue( CURRENT_ALIVE, ply ) );

DetectEndRound( );


end


--[[---------------------------------------------------------
	Name: gamemode:PlayerSpawnAsSpectator()
	Desc: Player spawns as a spectator
-----------------------------------------------------------]]
function GM:PlayerSpawnAsSpectator(pl)
	print("Spectate!")
	pl:StripWeapons()

	if (pl:Team() == TEAM_UNASSIGNED) then

		pl:Spectate(OBS_MODE_ROAMING)
		return

	end

	pl:SetTeam(TEAM_SPECTATOR)
	pl:Spectate(OBS_MODE_ROAMING)

end



--[[---------------------------------------------------------
	Name: gamemode:PlayerSpawn()
	Desc: Called when a player spawns
-----------------------------------------------------------]]
function GM:PlayerSpawn(pl)
   print("GM:PlayerSpawn called!")
	
	-- If the player doesn't have a team in a TeamBased game
	-- then spawn him as a spectator
	if (GAMEMODE.TeamBased and (pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_UNASSIGNED)) then
		GAMEMODE:PlayerSpawnAsSpectator(pl)
		return
	end
	-- Stop observer mode
	pl:UnSpectate()
	player_manager.OnPlayerSpawn(pl)
	--player_manager.RunClass(pl, "Spawn")

	-- Call item loadout function
	hook.Call("PlayerLoadout", GAMEMODE, pl)

	-- Set player model
	hook.Call("PlayerSetModel", GAMEMODE, pl)
	pl:SetupHands()
end
	
--[[---------------------------------------------------------
	Name: gamemode:PlayerSetModel()
	Desc: Set the player's model
-----------------------------------------------------------]]
function GM:PlayerSetModel(pl)

   print("GM:PlayerSetModel called!")
   pl:SetModel(Model(pl:GetInfo("cl_playermodel")))

	--local model = player_manager.TranslatePlayerModel("joker")
	--[[local model = "models/player/bobert/joker.mdl"
	util.PrecacheModel(model)
	pl:SetModel(model)]]--
	--pl:SetModel(Model("models/player/bobert/joker.mdl"))
	--player_manager.RunClass(pl, "SetModel")
	--pl:SetModel(Model("models/narry/shrek_playermodel_v1.mdl"))
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSetHandsModel()
	Desc: Sets the player's view model hands model
-----------------------------------------------------------]]
function GM:PlayerSetHandsModel(pl, ent)

	local info = player_manager.RunClass(pl, "GetHandsModel")
	if (not info) then
		local playermodel = player_manager.TranslateToPlayerModelName(pl:GetModel())
		info = player_manager.TranslatePlayerHands(playermodel)
	end

	if (info) then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerLoadout()
	Desc: Give the player the default spawning weapons/ammo
-----------------------------------------------------------]]
function GM:PlayerLoadout(pl)

	player_manager.RunClass(pl, "Loadout")

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSelectTeamSpawn(player)
	Desc: Find a spawn point entity for this player's team
-----------------------------------------------------------]]
function GM:PlayerSelectTeamSpawn(TeamID, pl)

	local SpawnPoints = team.GetSpawnPoints(TeamID)
	if (not SpawnPoints or table.Count(SpawnPoints) == 0) then return end

	local ChosenSpawnPoint = nil

	for i = 0, 6 do

		local ChosenSpawnPoint = table.Random(SpawnPoints)
		if (hook.Call("IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == 6)) then
			return ChosenSpawnPoint
		end

	end

	return ChosenSpawnPoint

end


--[[---------------------------------------------------------
	Name: gamemode:IsSpawnpointSuitable(player)
	Desc: Find out if the spawnpoint is suitable or not
-----------------------------------------------------------]]
function GM:IsSpawnpointSuitable(pl, spawnpointent, bMakeSuitable)

	local Pos = spawnpointent:GetPos()

	-- Note that we're searching the default hull size here for a player in the way of our spawning.
	-- This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	-- (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox(Pos + Vector(-16, -16, 0), Pos + Vector(16, 16, 64))

	if (pl:Team() == TEAM_SPECTATOR) then return true end

	local Blockers = 0

	for k, v in pairs(Ents) do
		if (IsValid(v) and v ~= pl and v:GetClass() == "player" and v:Alive()) then

			Blockers = Blockers + 1

			if (bMakeSuitable) then
				v:Kill()
			end

		end
	end

	if (bMakeSuitable) then return true end
	if (Blockers > 0) then return false end
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSelectSpawn(player)
	Desc: Find a spawn point entity for this player
-----------------------------------------------------------]]
function GM:PlayerSelectSpawn(pl)

	if (GAMEMODE.TeamBased) then

		local ent = GAMEMODE:PlayerSelectTeamSpawn(pl:Team(), pl)
		if (IsValid(ent)) then return ent end

	end

	-- Save information about all of the spawn points
	-- in a team based game you'd split up the spawns
	if (not IsTableOfEntitiesValid(self.SpawnPoints)) then

		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass("info_player_start")
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_deathmatch"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_combine"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_rebel"))

		-- CS Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_counterterrorist"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_terrorist"))

		-- DOD Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_axis"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_allies"))

		-- (Old) GMod Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("gmod_player_start"))

		-- TF Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_teamspawn"))

		-- INS Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("ins_spawnpoint"))

		-- AOC Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("aoc_spawnpoint"))

		-- Dystopia Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("dys_spawn_point"))

		-- PVKII Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_pirate"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_viking"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_knight"))

		-- DIPRIP Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("diprip_start_team_blue"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("diprip_start_team_red"))

		-- OB Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_red"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_blue"))

		-- SYN Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_coop"))

		-- ZPS Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_human"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_zombie"))

		-- ZM Maps
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_deathmatch"))
		self.SpawnPoints = table.Add(self.SpawnPoints, ents.FindByClass("info_player_zombiemaster"))

	end

	local Count = table.Count(self.SpawnPoints)

	if (Count == 0) then
		Msg("[PlayerSelectSpawn] Errornot  No spawn pointsnot \n")
		return nil
	end

	-- If any of the spawnpoints have a MASTER flag then only use that one.
	-- This is needed for single player maps.
	for k, v in pairs(self.SpawnPoints) do

		if (v:HasSpawnFlags(1) and hook.Call("IsSpawnpointSuitable", GAMEMODE, pl, v, true)) then
			return v
		end

	end

	local ChosenSpawnPoint = nil

	-- Try to work out the best, random spawnpoint
	for i = 1, Count do

		ChosenSpawnPoint = table.Random(self.SpawnPoints)

		if (IsValid(ChosenSpawnPoint) and ChosenSpawnPoint:IsInWorld()) then
			if (not((ChosenSpawnPoint == pl:GetVar("LastSpawnpoint") or ChosenSpawnPoint == self.LastSpawnPoint) and Count > 1)) then

				if (hook.Call("IsSpawnpointSuitable", GAMEMODE, pl, ChosenSpawnPoint, i == Count)) then

					self.LastSpawnPoint = ChosenSpawnPoint
					pl:SetVar("LastSpawnpoint", ChosenSpawnPoint)
					return ChosenSpawnPoint

				end
			end

		end

	end

	return ChosenSpawnPoint

end

--[[---------------------------------------------------------
	Name: gamemode:WeaponEquip(weapon)
	Desc: Player just picked up (or was given) weapon
-----------------------------------------------------------]]
function GM:WeaponEquip(weapon)
end

--[[---------------------------------------------------------
	Name: gamemode:ScalePlayerDamage(ply, hitgroup, dmginfo)
	Desc: Scale the damage based on being shot in a hitbox
		 Return true to not take damage
-----------------------------------------------------------]]
function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)

	-- More damage if we're shot in the head
	if (hitgroup == HITGROUP_HEAD) then

		dmginfo:ScaleDamage(2)

	end

	-- Less damage if we're shot in the arms or legs
	if (hitgroup == HITGROUP_LEFTARM or
			hitgroup == HITGROUP_RIGHTARM or
			hitgroup == HITGROUP_LEFTLEG or
			hitgroup == HITGROUP_RIGHTLEG or
			hitgroup == HITGROUP_GEAR) then

		dmginfo:ScaleDamage(0.25)

	end

	if (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then
		dmginfo:ScaleDamage(1)
	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerDeathSound()
	Desc: Return true to not play the default sounds
-----------------------------------------------------------]]
function GM:PlayerDeathSound()
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:SetupPlayerVisibility()
	Desc: Add extra positions to the player's PVS
-----------------------------------------------------------]]
function GM:SetupPlayerVisibility(pPlayer, pViewEntity)
	--AddOriginToPVS(vector_position_here)
end

--[[---------------------------------------------------------
	Name: gamemode:OnDamagedByExplosion(ply, dmginfo)
	Desc: Player has been hurt by an explosion
-----------------------------------------------------------]]
function GM:OnDamagedByExplosion(ply, dmginfo)
	ply:SetDSP(35, false)
end

--[[---------------------------------------------------------
	Name: gamemode:CanPlayerSuicide(ply)
	Desc: Player typed KILL in the console. Can they kill themselves?
-----------------------------------------------------------]]
function GM:CanPlayerSuicide(ply)
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerLeaveVehicle()
-----------------------------------------------------------]]
function GM:PlayerLeaveVehicle(ply, veichle)
end

--[[---------------------------------------------------------
	Name: gamemode:CanExitVehicle()
	Desc: If the player is allowed to leave the vehicle, return true
-----------------------------------------------------------]]
function GM:CanExitVehicle(veichle, passenger)
	return true
end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSwitchFlashlight()
	Desc: Return true to allow action
-----------------------------------------------------------]]
function GM:PlayerSwitchFlashlight(ply, SwitchOn)
	return ply:CanUseFlashlight()
end

    -- Creates a new round
function GM:NEW_ROUND( )
 	assert(ACTIVE_PLAYERS,"No ACTIVE_PLAYERS!")

 	local pl = ACTIVE_PLAYERS
 	CURRENT_ALIVE = {}

 	for i = 1, #pl do
 		if (pl[i]:Team() == TEAM_UNASSIGNED) then
 			pl[i]:PrintMessage(HUD_PRINTCENTER, "Please choose a team to join next round! (Press F2)")
 		elseif (pl[i]:Team() == TEAM_SPECTATOR) then
 			pl[i]:PrintMessage(HUD_PRINTCENTER, "Please choose a team to join next round! (Press F2)")
 		else
			pl[i]:PrintMessage(HUD_PRINTCENTER, "New round!")
			pl[i]:UnSpectate()
			pl[i]:Spawn()
			table.insert(CURRENT_ALIVE, pl[i])
 		end
 	end

	if (#CURRENT_ALIVE < 1) then
		PrintMessage(HUD_PRINTCENTER, "Choose a team for game to start!")
		timer.Create("tryagain",1,0,function() timer.Stop("tryagain") self:NEW_ROUND() end)
	end
end

--Detects if the round is over or not

function DetectEndRound( )
	assert(CURRENT_ALIVE,"No CURRENT_ALIVE in DetectEndRound!")

   if (table.Count(CURRENT_ALIVE) < 2) then hook.Call( "GAME_OVER", GAMEMODE ) end;
end

-- Ends the round and initializes a new one.

function GM:GAME_OVER( )
	PrintMessage(HUD_PRINTCENTER, "Game over!")
    for k, v in pairs( player.GetAll( ) ) do
        v:Spectate( OBS_MODE_CHASE ) -- when you spawn them call UnSpectate( ) on them
    end

    if (not timer.Exists("nextround")) then
    	timer.Create("nextround", 10, 0, function( )
       	hook.Call( "NEW_ROUND", GAMEMODE )
    	end )
  	end

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerSpray()
	Desc: Return true to prevent player spraying
-----------------------------------------------------------]]
function GM:PlayerSpray(ply)

	return false

end

--[[---------------------------------------------------------
	Name: gamemode:OnPlayerHitGround()
	Desc: Return true to disable default action
-----------------------------------------------------------]]
function GM:OnPlayerHitGround(ply, bInWater, bOnFloater, flFallSpeed)

	-- Apply damage and play collision sound here
	-- then return true to disable the default action
	--MsgN(ply, bInWater, bOnFloater, flFallSpeed)
	--return true

end

--[[---------------------------------------------------------
	Name: gamemode:GetFallDamage()
	Desc: return amount of damage to do due to fall
-----------------------------------------------------------]]
function GM:GetFallDamage(ply, flFallSpeed)

	if(GetConVarNumber("mp_falldamage") > 0) then -- realistic fall damage is on
	return (flFallSpeed - 526.5) * (100 / 396) -- the Source SDK value
	end

	return 10

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanSeePlayersChat()
	Desc: Can this player see the other player's chat?
-----------------------------------------------------------]]
function GM:PlayerCanSeePlayersChat(strText, bTeamOnly, pListener, pSpeaker)

	if (bTeamOnly) then
		if (not IsValid(pSpeaker) or not IsValid(pListener)) then return false end
		if (pListener:Team() ~= pSpeaker:Team()) then return false end
	end

	return true

end

local sv_alltalk = GetConVar("sv_alltalk")

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanHearPlayersVoice()
	Desc: Can this player see the other player's voice?
		Returns 2 bools.
		1. Can the player hear the other player
		2. Can they hear them spacially
-----------------------------------------------------------]]
function GM:PlayerCanHearPlayersVoice(pListener, pTalker)

	local alltalk = sv_alltalk:GetInt()
	if (alltalk >= 1) then return true, alltalk == 2 end

	return pListener:Team() == pTalker:Team(), false

end

--[[---------------------------------------------------------
	Name: gamemode:NetworkIDValidated()
	Desc: Called when Steam has validated this as a valid player
-----------------------------------------------------------]]
function GM:NetworkIDValidated(name, steamid)

	-- MsgN("GM:NetworkIDValidated", name, steamid)

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerShouldTaunt(ply, actid)
-----------------------------------------------------------]]
function GM:PlayerShouldTaunt(ply, actid)

	-- The default behaviour is to always let them act
	-- Some gamemodes will obviously want to stop this for certain players by returning false
	return true

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerStartTaunt(ply, actid, length)
-----------------------------------------------------------]]
function GM:PlayerStartTaunt(ply, actid, length)
end

--[[---------------------------------------------------------
	Name: gamemode:AllowPlayerPickup(ply, object)
-----------------------------------------------------------]]
function GM:AllowPlayerPickup(ply, object)

	-- Should the player be allowed to pick this object up (using ENTER)?
	-- If no then return false. Default is HELL YEAH

	return true

end

--[[---------------------------------------------------------
	These are buttons that the client is pressing. They're used
	in Sandbox mode to control things like wheels, thrusters etc.
-----------------------------------------------------------]]
function GM:PlayerButtonDown(ply, btn) end
function GM:PlayerButtonUp(ply, btn) end

--[[---------------------------------------------------------
	Name: gamemode:PlayerRequestTeam()
	Desc: Player wants to change team
-----------------------------------------------------------]]
function GM:PlayerRequestTeam(ply, teamid)
	print("PlayerRequestTeam was called by " .. ply:Nick())

	-- No changing teams if not teambasednot 
	if (not GAMEMODE.TeamBased) then return end

	-- This team isn't joinable
	if (not team.Joinable(teamid)) then
		ply:ChatPrint("You can't join that team")
		return end

	-- This team isn't joinable
	if (not GAMEMODE:PlayerCanJoinTeam(ply, teamid)) then
		-- Messages here should be outputted by this function
		return end

	print("Player " .. ply:Nick() .. " joined team " .. team.GetName(teamid))
	GAMEMODE:PlayerJoinTeam(ply, teamid)

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerJoinTeam()
	Desc: Make player join this team
-----------------------------------------------------------]]
function GM:PlayerJoinTeam(ply, teamid)
--[[--------------------------------------------------------------------
	local iOldTeam = ply:Team()

	if (ply:Alive()) then
		if (iOldTeam == TEAM_SPECTATOR or iOldTeam == TEAM_UNASSIGNED) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end

	ply:SetTeam(teamid)
	ply.LastTeamSwitch = RealTime()

	GAMEMODE:OnPlayerChangedTeam(ply, iOldTeam, teamid)
--]]--------------------------------------------------------------------
	ply:Kill()
	ply:SetTeam(teamid)

end


--[[---------------------------------------------------------
	Name: gamemode:OnPlayerChangedTeam(ply, oldteam, newteam)
-----------------------------------------------------------]]
function GM:OnPlayerChangedTeam(ply, oldteam, newteam)

	-- Here's an immediate respawn thing by default. If you want to
	-- re-create something more like CS or some shit you could probably
	-- change to a spectator or something while dead.

	--[[----------------------------------------------------------------
	if (newteam == TEAM_SPECTATOR) then

		-- If we changed to spectator mode, respawn where we are
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos(Pos)

	elseif (oldteam == TEAM_SPECTATOR) then

		-- If we're changing from spectator, join the game
		ply:Spawn()

	else

		-- If we're straight up changing teams just hang
		-- around until we're ready to respawn onto the
		-- team that we chose

	end
	--]]---------------------------------------------------------------
	PrintMessage(HUD_PRINTTALK, Format("%s joined '%s'", ply:Nick(), team.GetName(newteam)))

end

--[[---------------------------------------------------------
	Name: gamemode:PlayerCanJoinTeam(ply, teamid)
	Desc: Allow mods/addons to easily determine whether a player
		can join a team or not
-----------------------------------------------------------]]
function GM:PlayerCanJoinTeam(ply, teamid)
	--[[
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if (ply.LastTeamSwitch and RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint(Format("Please wait %i more seconds before trying to change team again", (TimeBetweenSwitches - (RealTime() - ply.LastTeamSwitch) + 1 )))
		return false
	end

	-- Already on this teamnot 
	if (ply:Team() == teamid) then
		ply:ChatPrint("You're already on that team")
		return false
	end
	]]--
	ply:PrintMessage(HUD_PRINTTALK,"Changes will take effect next round!")
	return true

end


concommand.Add("changeteam", function(pl, cmd, args) hook.Call("PlayerRequestTeam", GAMEMODE, pl, tonumber(args[ 1 ])) end)
