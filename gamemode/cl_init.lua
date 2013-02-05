--PirateShip Wars
--Originally made in Gmod 9 by EmpV
--Remade for Gmod 13 by VertisticINC

Msg("\nLoading client-side PirateShip Wars.\n")

include("shared.lua")
--include("postprocess.lua") --Doesn't work and I can't be assed to fuck with it right now.
include("explosion.lua")

--------------------
--Language additions
--------------------

--language.Add( "#func_physbox", "Cannonball LOLZ" )
language.Add( "func_physbox", "Cannonball" )
language.Add( "env_explosion", "Ship Explosion" )
language.Add( "func_breakable", "Ship" )
language.Add( "worldspawn", "Ship" )
language.Add( "trigger_hurt", "Davy Jones Locker" )

CreateClientConVar("pw_HUDEnabled", "1", false, false)

PSW_CONTENT_ID = 124918666

-------
--Menus
-------

helpVis = false

function helpMenu()
	helpVis=!helpVis
	Msg("Val: "..tostring(helpVis).."\n")
end
concommand.Add("_doHelp", helpMenu)

function drawTehHelp()
	if helpVis then
		--Msg("Drawing")
		surface.SetDrawColor(255,255,255,255)
		local ids=surface.GetTextureID('VGUI/help/pswHelp')
		surface.SetTexture(ids)
		surface.DrawTexturedRect(ScrW()*0.5-320,ScrH()*0.5-240,640,480)
	end
end
hook.Add("HUDPaint","drawz",drawTehHelp)

WelcomeFrame = vgui.Create('DFrame')
WelcomeFrame:SetSize(386, 350)
WelcomeFrame:Center()
WelcomeFrame:SetTitle('Welcome to Pirate Ship Wars!')
WelcomeFrame:SetSizable(true)

WelcomeLabel = vgui.Create('DLabel')
WelcomeLabel:SetParent(WelcomeFrame)
WelcomeLabel:SetPos(40, 40)
WelcomeLabel:SetText('Pirate Ship Wars')
WelcomeLabel:SizeToContents()

AuthorLabel = vgui.Create('DLabel')
AuthorLabel:SetParent(WelcomeFrame)
AuthorLabel:SetPos(40, 80)
AuthorLabel:SetText('Gamemode by EmpV, Metroid48, Termy58, et al.\nFixed for Gmod13 by VertisticINC and CommunistPancake')
AuthorLabel:SizeToContents()

CustomContentWarning = vgui.Create('DLabel')
CustomContentWarning:SetParent(WelcomeFrame)
CustomContentWarning:SetPos(40, 119)
CustomContentWarning:SetText("You don't have the custom content for this gamemode installed!")
CustomContentWarning:SizeToContents()

OpenWorkshopButton = vgui.Create('DButton')
OpenWorkshopButton:SetParent(WelcomeFrame)
OpenWorkshopButton:SetSize(306, 46)
OpenWorkshopButton:SetPos(40, 135)
OpenWorkshopButton:SetText('Install Content')
OpenWorkshopButton.DoClick = function() steamworks.ViewFile(PSW_CONTENT_ID) end

PlayGamemodeButton = vgui.Create('DButton')
PlayGamemodeButton:SetParent(WelcomeFrame)
PlayGamemodeButton:SetSize(150, 50)
PlayGamemodeButton:SetPos(118, 230)
PlayGamemodeButton:SetText('Play!')
PlayGamemodeButton.DoClick = function() 
	WelcomeFrame:SetVisible(false)
end

function showInfoMenu(msg)
	isSubscribed = steamworks.IsSubscribed(PSW_CONTENT_ID)
	if isSubscribed then
		OpenWorkshopButton:SetVisible(false)
		CustomContentWarning:SetVisible(false)
	end
	WelcomeFrame:SetVisible(true)
	WelcomeFrame:MakePopup()
end
concommand.Add("_doInfo", showInfoMenu)

teamVis = false

ChangeTeamFrame = vgui.Create('DFrame')
ChangeTeamFrame:SetSize(350, 273)
ChangeTeamFrame:Center()
ChangeTeamFrame:SetTitle('Choose a Team!')
ChangeTeamFrame:SetSizable(true)
ChangeTeamFrame:SetDeleteOnClose(false)
ChangeTeamFrame:SetVisible(false)

SpectatorButton = vgui.Create('DButton')
SpectatorButton:SetParent(ChangeTeamFrame)
SpectatorButton:SetSize(310, 60)
SpectatorButton:SetPos(20, 195)
SpectatorButton:SetText('Spectator')
SpectatorButton.DoClick = function() LocalPlayer():ConCommand("say !switch "..tostring(TEAM_SPECTATE)) end

RedLabel = vgui.Create('DLabel')
RedLabel:SetParent(ChangeTeamFrame)
RedLabel:SetPos(20, 30)
RedLabel:SetText('Red Team')
RedLabel:SizeToContents()
RedLabel:SetTextColor(Color(165, 42, 42, 255))

BlueLabel = vgui.Create('DLabel')
BlueLabel:SetParent(ChangeTeamFrame)
BlueLabel:SetPos(190, 30)
BlueLabel:SetText('Blue Team')
BlueLabel:SizeToContents()
BlueLabel:SetTextColor(Color(100, 149, 237, 255))

RedButton = vgui.Create('DImageButton')
RedButton:SetParent(ChangeTeamFrame)
RedButton:SetSize(128, 128)
RedButton:SetPos(20, 60)
RedButton:SetImage('VGUI/hud/Skull')
RedButton:SizeToContents()
RedButton.DoClick = function() LocalPlayer():ConCommand("say !switch "..tostring(TEAM_RED)) end

BlueButton = vgui.Create('DImageButton')
BlueButton:SetParent(ChangeTeamFrame)
BlueButton:SetSize(128, 128)
BlueButton:SetPos(190, 60)
BlueButton:SetImage('VGUI/hud/blueskull')
BlueButton:SizeToContents()
BlueButton.DoClick = function() LocalPlayer():ConCommand("say !switch "..tostring(TEAM_BLUE)) end

function teamMenu( msg ) --F2
--	if msg:ReadShort()!=8 then return end
	teamVis = !teamVis
	if !teamVis then
		ChangeTeamFrame:SetVisible(true)
		ChangeTeamFrame:MakePopup()
	else
		ChangeTeamFrame:SetVisible(false)
	end
end
concommand.Add("_doTeam",teamMenu)
--usermessage.Hook("TeamMenu", teamMenu)

function pswhud()
	if GetConVarNumber("pw_HUDEnabled")>=1 then
		if LocalPlayer():Team() == TEAM_RED then
			surface.SetDrawColor( 255, 255, 255, 255 )
			local tid = surface.GetTextureID( 'VGUI/hud/blood' )
			surface.SetTexture( tid )
			surface.DrawTexturedRect( 20, ScrH() - 130, 312, 128 )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			local tid = surface.GetTextureID( 'VGUI/hud/blueblood' )
			surface.SetTexture( tid )
			surface.DrawTexturedRect( 20, ScrH() - 130, 312, 128 )
		end
		
		if LocalPlayer():Alive() then
			draw.RoundedBox( 10, 105, ScrH() - 107.5, 220, 35, Color( 20, 20, 20, 150 ) )
			
			if LocalPlayer():Health() > 10 then
				if LocalPlayer():Team() == TEAM_RED then
					draw.RoundedBox( 10, 110, ScrH() - 105, ( 210 * ( LocalPlayer():Health() / 100 ) ), 30, Color( 130, 30, 30, 140 ) )
				else
					draw.RoundedBox( 10, 110, ScrH() - 105, ( 210 * ( LocalPlayer():Health() / 100 ) ), 30, Color( 30, 30, 130, 140 ) )
				end
			else --Added to prevent the bar from screwing
				surface.SetFont("psw") 
				surface.SetTextPos( 110, ScrH() - 107.5 )
				surface.SetTextColor( 170, 50, 50, 245 )
				surface.DrawText( "Aye ye hit" ) --Piratey
			end
		
		end
		
		if LocalPlayer():Team() == TEAM_RED then
			surface.SetDrawColor( 255, 255, 255, 255 )
			local tid = surface.GetTextureID( 'VGUI/hud/Skull' )
			surface.SetTexture( tid )
			surface.DrawTexturedRect( 20, ScrH() - 130, 99, 90 )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			local tid = surface.GetTextureID( 'VGUI/hud/blueskull' )
			surface.SetTexture( tid )
			surface.DrawTexturedRect( 20, ScrH() - 130, 99, 90 )
		end

		if table.Count(LocalPlayer():GetWeapons()) > 0 then
			curwep = LocalPlayer():GetActiveWeapon()
			if curwep and curwep ~= "nil" and curwep ~= nil and curwep:IsValid() then
				if curwep:GetPrimaryAmmoType() then
					ammotype = curwep:GetPrimaryAmmoType()
				else
					ammotype = false
				end
				if ammotype and ammotype ~= -1 then
					ammo = LocalPlayer():GetAmmoCount( ammotype )
					strammo = curwep:Clip1() .. " / " .. ammo
					if ammo == 0 and curwep:Clip1() == 0 then strammo = "0 / 0" end
					
					surface.SetDrawColor( 255, 255, 255, 255 )
					local tid = surface.GetTextureID( 'VGUI/hud/gunhud' )
					surface.SetTexture( tid )
					surface.DrawTexturedRect( ScrW() - 354, ScrH() - 160, 356, 151 )

					surface.SetFont("psw") 
					surface.SetTextPos( ScrW() - 200, ScrH() - 100)
					surface.SetTextColor( 170, 50, 50, 245 )
					surface.DrawText( strammo ) --Piratey
				end
			end
		end
	end
end
hook.Add("HUDPaint", "pswhud", pswhud);

function pswhide( name )
	if (name == "CHudHealth" or name == "CHudBattery" or name == "CHudAmmo" or name == "CHudSecondaryAmmo") then
		return false
	end
end
hook.Add( "HUDShouldDraw", "HideThings", pswhide ) 

function GM:CreateMove( CMD )
	if LocalPlayer():KeyDown( IN_DUCK ) then CMD:SetUpMove( 0 ) end
end

function GM:CalcView( ply, origin, angles, fov ) 
	shit = {}
	shit.origin = origin
	shit.angles = Angle( angles.p, angles.y, 0 )
 	return shit	
end

function DisableNoclip(pl)
	return false
end

function GM:Initialize()
	surface.CreateFont("psw", {
		size = 40,
		weight = 400,
		antialias = false,
		additive = false,
		font = "akbar"})
	WelcomeLabel:SetFont("psw")
	BlueLabel:SetFont("psw") 
	RedLabel:SetFont("psw") 
	WelcomeLabel:SizeToContents()
	BlueLabel:SizeToContents()
	RedLabel:SizeToContents()
	PrecacheParticleSystem("env_fire_small_smoke")
	--initPP()
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip)