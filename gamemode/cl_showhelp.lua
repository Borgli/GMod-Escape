include ('shared.lua')


--[Shows a help menu when you press F1]--


function GM:ShowHelp(ply)

local frame = vgui.Create( "DFrame" )
frame:SetSize( 500, 250 )
frame:Center()
frame:MakePopup()

local richtext = vgui.Create( "RichText", frame)
richtext:Dock( FILL )


richtext:InsertColorChange( 255, 255, 224, 255 )
richtext:AppendText( "Welcome to Horror Escape!\n\n" )

richtext:InsertColorChange( 192, 192, 192, 255 )
richtext:AppendText( "There will be more info here later \n\n\n\n\n\n\n\n\n\n\n\n\n" )

richtext:InsertColorChange( 255, 64, 64, 255 )
richtext:AppendText( "#ServerBrowser_ESRBNotice" )

end

