include ('shared.lua')



--[Shows a help menu when you press F1]--
function GM:ShowHelp(ply)

local SCREEN_W = 1280;
local SCREEN_H = 720;
local X_MULTIPLIER = ScrW() / SCREEN_W
local Y_MULTIPLIER = ScrH() / SCREEN_H


local frame = vgui.Create( "DFrame" )
frame:SetTitle("Help Menu")
frame:SetSize( (ScrW()/3)*2, (ScrH()/3) *2)
frame:SetSizable( true )
frame:Center()
frame:MakePopup()


local richtext = vgui.Create( "RichText", frame)
richtext:Dock( FILL )


richtext:InsertColorChange( 255, 255, 224, 255 )
richtext:AppendText( "Welcome to Horror Escape!\n\n" )

richtext:InsertColorChange( 192, 192, 192, 255 )
richtext:AppendText( "This gamemode is still in the making.\n" )

richtext:InsertColorChange( 192, 192, 192, 255 )
richtext:AppendText( "There will be more info here in the future. \n\n\n\n" )

/*
net.Start("activeplayers")
net.WriteString("activeplayers")
net.SendToServer()
*/
richtext:InsertColorChange( 255, 255, 224, 255 )
richtext:AppendText( "Players connected: " .. #player.GetAll() .. "\n\n\n\n\n")

richtext:InsertColorChange( 255, 255, 224, 255 )
richtext:AppendText( "Author: Ohm\n\n" )

--[Because why the hell not]--
richtext:InsertColorChange( 255, 64, 64, 255 )
richtext:AppendText( "#ServerBrowser_ESRBNotice" )

local DButton = vgui.Create("DButton", frame)
DButton:SetPos (10, 420)
DButton:SetText ("Choose a team")
DButton:SetSize (80, 50)

function DButton.DoClick()
	self:ShowTeam()
end

local DButton = vgui.Create("DButton", frame)
DButton:SetPos (120, 420)
DButton:SetText ("Wiki")
DButton:SetSize (80, 50)

function DButton.DoClick()
	
local frame = vgui.Create( "DFrame" )
frame:SetTitle( "HTML Example" )
frame:SetSize( ScrW() * 0.75, ScrH() * 0.75 )
frame:Center()
frame:MakePopup()

local html = vgui.Create( "HTML", frame )
html:Dock( FILL )
html:OpenURL( "wiki.garrysmod.com" )

end	





end

