//local modelDefined = false

if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if (CLIENT) then
	SWEP.PrintName			= "Pistol"
	SWEP.Author				= "PirateShip Wars GM9 / Metroid48 / Termy58"
//	SWEP.Contact			= "metroid48@gmail.com"
//	SWEP.Instructions		= "Aim at enemy."
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawCrosshair		= false
	
	killicon.Add("weapon_sabre", "deathnotify/pistol_kill", Color(255,255,255,255))
	SWEP.WepSelectIcon = surface.GetTextureID("gmod/SWEP/pistol_select")
	SWEP.BounceWeaponIcon = false 
	SWEP.DrawWeaponInfoBox = false
end

SWEP.HoldType				= "pistol" //maybe server-only

SWEP.ViewModel				= "models/pistol_a/v_pistol_a.mdl"
SWEP.WorldModel				= "models/pistol_a/w_pistol_a.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= true
SWEP.Spawnable				= true
SWEP.ViewModelFlip			= false

SWEP.Primary.Sound			= Sound("Weapon_shotgun.single")
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 90
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone			= 0.05
SWEP.Primary.ClipSize			= 1
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip		= 2
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= 2
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Deploy()
		if self.Owner:Team() == TEAM_BLUE then
			self.Owner:GetViewModel():SetModel("models/pistol_a/v_pistol_a.mdl")
//			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		else
			self.Owner:GetViewModel():SetModel("models/pistol_a/v_pistol_b.mdl")
//			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		end
	return true
end

function SWEP:OnDrop()
	self.Weapon:Remove()
end

function SWEP:DrawHUD()

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	local scale = 10 * self.Primary.Cone
	
	// Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	
	surface.SetDrawColor( 0, 255, 0, 255 )
	
	// Draw an awesome crosshair
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

end