--[[
givelight_cv = CreateConVar( "sv_givelight", "0", { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "Toggles spawing with the flashlight." )

shl_convar = CreateConVar( "sv_shoulderlight", "0", { FCVAR_ARCHIVE, FCVAR_DONTRECORD, FCVAR_REPLICATED }, "Toggles drawing the flashlight on pressing the flashlight bind." )

if (CLIENT) then
	fltexturevar = CreateConVar( "cl_flashlight_texture", "effects/flashlight001", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "Path to flashlight texture, set in the options menu." )
	flashlight_r = CreateConVar( "cl_flashlight_r", "255", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "0-255 Flashlight color's red component, set in the options menu." )
	flashlight_g = CreateConVar( "cl_flashlight_g", "255", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "0-255 Flashlight color's green component, set in the options menu." )
	flashlight_b = CreateConVar( "cl_flashlight_b", "255", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "0-255 Flashlight color's blue component, set in the options menu." )
	flrefresh = CreateConVar( "cl_flashlight_allow_refresh", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "Toggles allowing refresh of the flashlight with reload." )
end

function GiveLight( ply )
	local gvlight = givelight_cv:GetBool()
	if ( not gvlight ) then return end
	ply:Give("weapon_flashlight")
end
hook.Add( "PlayerLoadout", "FlashlighLoadout", GiveLight)

if (CLIENT) then
	function FlashlightBind( ply, bind, pressed )
		local shld = shl_convar:GetBool()
		if not pressed then return false end

		if (bind == "impulse 100") then
			if ( not shld ) then
				RunConsoleCommand( "use", "weapon_flashlight" )
				return true
			else
				RunConsoleCommand( "impulse", "100" )
				return true
			end
		end
	end
	hook.Add( "PlayerBindPress", "SWEP FlashlightBind", FlashlightBind )

	local function LightOptions( CPanel )

		-- HEADER
		CPanel:AddControl( "Header", { Description = "Server Settings" }  )

		CPanel:AddControl( "Checkbox", { Label = "Spawn With Flashlight", Command = "sv_givelight" } )

		CPanel:AddControl( "Checkbox", { Label = "Use Engine Flashlight on Bind Press", Command = "sv_shoulderlight" } )

		CPanel:AddControl( "Header", { Description = "Client Settings" }  )

		CPanel:AddControl( "Checkbox", { Label = "Refresh Light on Reload", Command = "cl_flashlight_allow_refresh" } )

		local MatSelect = CPanel:MatSelect( "cl_flashlight_texture", nil, true, 0.33, 0.33 )

		for k, v in pairs( list.Get( "FlashlightTextures" ) ) do
			MatSelect:AddMaterial( v.Name or k, k )
		end

		CPanel:AddControl( "Color",  { Label	= "Flashlight Color",
			Red			= "cl_flashlight_r",
			Green		= "cl_flashlight_g",
			Blue		= "cl_flashlight_b",
			ShowAlpha	= 0,
			ShowHSV		= 1,
			ShowRGB 	= 1,
			Multiplier	= 255 } )
	end

	hook.Add( "PopulateToolMenu", "AddFLMenu", function()
		spawnmenu.AddToolMenuOption( "Options", "Flashlight", "FlashlightSettings", "Settings", "", "", LightOptions )
	end )
end


list.Set( "FlashlightTextures", "effects/flashlight001", { Name = "Default" } )
list.Set( "FlashlightTextures", "effects/flashlight/flashlight001_l4d2", { Name = "Left 4 Dead" } )
list.Set( "FlashlightTextures", "effects/flashlight/flashlight_trinity", { Name = "Trinity Renderer" } )
list.Set( "FlashlightTextures", "effects/flashlight/flashlight001_ronster", { Name = "Ronster's Flashlight" } )
list.Set( "FlashlightTextures", "effects/flashlight/flashlight_horrible", { Name = "Horrible Flashlight" } )
]]--