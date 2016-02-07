include('shared.lua')

--[[---------------------------------------------------------
   Name: gamemode:ShowTeam()
   Desc:
-----------------------------------------------------------]]

function GM:ShowTeam()
	
	if (IsValid(self.TeamSelectFrame)) then return end

	self.TeamSelectFrame = vgui.Create("DFrame")
	self.TeamSelectFrame:SetTitle("Select Monster or Survivor")

	-- Right side of the spawn menu
	local RightPanel = vgui.Create("DPanel", self.TeamSelectFrame)
	RightPanel:SetPos(10, 30)
	RightPanel:SetSize(ScrW() /4 , ScrH() - 50)
	--RightPanel:SetBackgroundColor(Color(100,0,0,255))

	local MonsterButton = vgui.Create("DButton", RightPanel)
	local w, h = RightPanel:GetSize()
	MonsterButton:SetPos(0, 0)
	MonsterButton:SetSize(w, (h/2)*(1/3))
	MonsterButton:SetText("Monsters")

	local SurvivorButton = vgui.Create("DButton", RightPanel) 
	local w, h = RightPanel:GetSize()
	SurvivorButton:SetPos(0, (h/2)*(1/3))
	SurvivorButton:SetSize(w, (h/2)*(1/3))
	SurvivorButton:SetText("Survivors")

	local SpectatorButton = vgui.Create("DButton",RightPanel)
	local w, h = RightPanel:GetSize()
	SpectatorButton:SetPos(0, ((h/2)*(1/3))*2)
	SpectatorButton:SetSize(w, (h/2)*(1/3))
	SpectatorButton:SetText("Spectators")

	local SelectPanel = vgui.Create("DPanel", RightPanel)
	local w, h = RightPanel:GetSize()
	--TextPanel:SetPos(h/2, w/2)
	SelectPanel:SetSize(w,h/2)
	SelectPanel:SetBackgroundColor(Color(100,0,0,255))
	SelectPanel:AlignBottom(0)


--[[
	local Description = vgui.Create("DLabel", TextPanel)
	Description:SetSize(TextPanel:GetSize())
	Description:SetText("HEI")
]]--



	local ModelSelect = vgui.Create("DModelPanel", self.TeamSelectFrame)
	ModelSelect:SetPos(ScrW() /4, 30)
	ModelSelect:SetSize((ScrW()/4) * 3, ScrH() - 50)
	ModelSelect:SetLookAt(Vector(0,0,60))
	ModelSelect:SetCamPos(Vector(30,0,65))

	
	
	ModelSelect:SetModel("models/player/kleiner.mdl")
	ModelSelect:GetEntity():SetEyeTarget(ModelSelect:GetCamPos() - Vector(0,0,5))

	function ModelSelect:LayoutEntity(Entity) return end
	function ModelSelect.DoClick() self:HideTeam() end


	self.TeamSelectFrame:SetSize(ScrW(), ScrH())
	self.TeamSelectFrame:Center()
	self.TeamSelectFrame:MakePopup()
	self.TeamSelectFrame:SetKeyboardInputEnabled(false)

end


--[[--------------------------------------------------------
function GM:ShowTeam()

	if (IsValid(self.TeamSelectFrame)) then return end

	-- Simple team selection box
	self.TeamSelectFrame = vgui.Create("DFrame")
	self.TeamSelectFrame:SetTitle("Pick Team")

	local AllTeams = team.GetAllTeams()
	local y = 30
	for ID, TeamInfo in pairs (AllTeams) do

		if (ID ~= TEAM_CONNECTING and ID ~= TEAM_UNASSIGNED) then

			local Team = vgui.Create("DButton", self.TeamSelectFrame)
			function Team.DoClick() self:HideTeam() RunConsoleCommand("changeteam", ID) end
			Team:SetPos(10, y)
			Team:SetSize(130, 20)
			Team:SetText(TeamInfo.Name)

			if (IsValid(LocalPlayer()) and LocalPlayer():Team() == ID) then
				Team:SetDisabled(true)
			end

			y = y + 30

		end

	end

	if (GAMEMODE.AllowAutoTeam) then

		local Team = vgui.Create("DButton", self.TeamSelectFrame)
		function Team.DoClick() self:HideTeam() RunConsoleCommand("autoteam") end
		Team:SetPos(10, y)
		Team:SetSize(130, 20)
		Team:SetText("Auto")
		y = y + 30

	end

	self.TeamSelectFrame:SetSize(150, y)
	self.TeamSelectFrame:Center()
	self.TeamSelectFrame:MakePopup()
	self.TeamSelectFrame:SetKeyboardInputEnabled(false)

end
-----------------------------------------------------]]


--[[---------------------------------------------------------
   Name: gamemode:HideTeam()
   Desc:
-----------------------------------------------------------]]



function GM:HideTeam()

	if (IsValid(self.TeamSelectFrame)) then
		self.TeamSelectFrame:Remove()
		self.TeamSelectFrame = nil
	end

end
