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
	function SpectatorButton.DoClick() self:HideTeam() RunConsoleCommand("changeteam", TEAM_SPECTATOR) end

	local SelectPanel = vgui.Create("DScrollPanel", RightPanel)
	local w, h = RightPanel:GetSize()
	--TextPanel:SetPos(h/2, w/2)
	SelectPanel:SetSize(w,h/2)
	SelectPanel:SetBackgroundColor(Color(100,0,0,255))
	SelectPanel:AlignBottom(0)
	
	
	--self:ClickMonsters(SelectPanel);

	function MonsterButton.DoClick() self:ClickMonsters(SelectPanel) end
	function SurvivorButton.DoClick() self:ClickSurvivors(SelectPanel) end

--[[
	local Description = vgui.Create("DLabel", TextPanel)
	Description:SetSize(TextPanel:GetSize())
	Description:SetText("HEI")
]]--

	self.ModelSelect = vgui.Create("DModelPanel", self.TeamSelectFrame)
	self.ModelSelect:SetPos(ScrW() /4, 30)
	self.ModelSelect:SetSize((ScrW()/4) * 3, ScrH() - 50)
	self.ModelSelect:SetLookAt(Vector(0,0,60))
	self.ModelSelect:SetCamPos(Vector(30,0,65))

	


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

function GM:ClickSurvivors(SelectPanel)
	local SurvivorModels = {
		"models/player/breen.mdl",
		"models/player/kleiner.mdl",
		"models/player/alyx.mdl",
		"models/player/barney.mdl"
	}
	self:DisplayModelList(SelectPanel, SurvivorModels)
end

function GM:ClickMonsters(SelectPanel)
	local MonsterModels = {
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl",
		"models/player/kleiner.mdl"

	}
	self:DisplayModelList(SelectPanel, MonsterModels)
end

function GM:DisplayModelList(SelectPanel, models)
	local x = 0
	local y = 0
	
	local w, h = SelectPanel:GetSize()
	SelectPanel:Clear()
	for i = 1, #models do
		local SelectModel = vgui.Create("DModelPanel",SelectPanel)
		--SelectModel:SetPos(x/3 , h/3 * (y % 3))
		SelectModel:SetPos(w/3 * x, h/3 * y)
		SelectModel:SetSize(w/3,h/3)
		if x == 2 then
			x = 0
			y = y + 1
		else
			x = x + 1
		end
		SelectModel:SetLookAt(Vector(0,0,60))
		SelectModel:SetCamPos(Vector(30,0,65))
		SelectModel:SetModel(models[i])
		SelectModel:GetEntity():SetEyeTarget(SelectModel:GetCamPos() - Vector(0,0,5))

		function SelectModel:LayoutEntity(entity) return end
		function SelectModel.DoClick() self:DisplaySelectedModel(models[i]) end
	end
end

function GM:DisplaySelectedModel(model)
	if (not IsValid(self.ModelSelect)) then
		self.ModelSelect = vgui.Create("DModelPanel", self.TeamSelectFrame)
		self.ModelSelect:SetPos(ScrW() /4, 30)
		self.ModelSelect:SetSize((ScrW()/4) * 3, ScrH() - 50)
		self.ModelSelect:SetLookAt(Vector(0,0,60))
		self.ModelSelect:SetCamPos(Vector(30,0,65))
	end

	self.ModelSelect:SetModel(model)
	self.ModelSelect:GetEntity():SetEyeTarget(self.ModelSelect:GetCamPos() - Vector(0,0,5))

	function self.ModelSelect:LayoutEntity(entity) return end

end

function GM:HideTeam()

	if (IsValid(self.TeamSelectFrame)) then
		self.TeamSelectFrame:Remove()
		self.TeamSelectFrame = nil
	end

end
