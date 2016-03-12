include ('shared.lua')


--[Shows a help menu when you press F1]--


function GM:ShowHelp(ply)

local Frame = vgui.Create( "DFrame" )
	Frame:SetTitle( "Help Menu" )
	Frame:SetPos( 5, 5 )
	Frame:SetSize( 300, 150 )

local Button = vgui.Create( "DButton", Frame )
	Button:SetText( "Button1" )
	Button:SetTextColor( Color( 255, 255, 255 ) )
	Button:SetPos( 100, 100 )
	Button:SetSize( 100, 30 )
	Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end

	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()

end