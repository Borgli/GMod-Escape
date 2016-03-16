include ('shared.lua')



--[Shows a help menu when you press F1]--
function GM:ShowHelp(ply)

local SCREEN_W = 1280;
local SCREEN_H = 720;
local X_MULTIPLIER = ScrW() / SCREEN_W
local Y_MULTIPLIER = ScrH() / SCREEN_H


local frame = vgui.Create( "DFrame" )
frame:SetTitle("Help Menu")
frame:SetSize( 500 * X_MULTIPLIER, 250 * Y_MULTIPLIER )
frame:Center()
frame:MakePopup()


local richtext = vgui.Create( "RichText", frame)
richtext:Dock( FILL )


richtext:InsertColorChange( 255, 255, 224, 255 )
richtext:AppendText( "Welcome to Horror Escape!\n\n" )

richtext:InsertColorChange( 192, 192, 192, 255 )
richtext:AppendText( "This gamemode is still in the making.\n" )

richtext:InsertColorChange( 192, 192, 192, 255 )
richtext:AppendText( "There will be more info here in the future. \n\n\n\n\n\n\n\n\n" )

richtext:InsertColorChange( 255, 255, 224, 255 )
richtext:AppendText( "Author: Ohm\n\n\n" )

--[Because why the hell not]--
richtext:InsertColorChange( 255, 64, 64, 255 )
richtext:AppendText( "#ServerBrowser_ESRBNotice" )



end

