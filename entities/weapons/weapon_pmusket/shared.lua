--local modelDefined = false

if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if (CLIENT) then
	SWEP.PrintName			= "Musket"
	SWEP.Author				= "UberMensch"
	SWEP.Slot				= 3
	SWEP.SlotPos			= 1
	SWEP.IconLetter			= "c"
	
	killicon.Add("weapon_pmusket", "deathnotify/pistol_kill", Color(255,255,255,255))
end

SWEP.HoldType				= "shotgun" --maybe server-only

SWEP.ViewModel				= "models/brownbess/v_brownbess.mdl"
SWEP.WorldModel				= "models/brownbess/w_brownbess.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= true
SWEP.Spawnable				= true
SWEP.ViewModelFlip			= false

SWEP.Primary.Sound			= Sound("Weapon_shotgun.double")
SWEP.Primary.Recoil			= 1.4
SWEP.Primary.Damage			= 150
SWEP.Primary.NumShots			= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize			= 1
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip		= 2
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 13337
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "melee"

function SWEP:Deploy()
		if self.Owner:Team() == TEAM_BLUE then
			self.Owner:GetViewModel():SetModel("models/charleville/v_charleville.mdl")
--			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		else
			self.Owner:GetViewModel():SetModel("models/brownbess/v_brownbess.mdl")
--			self.Owner:GetViewModel():SetModelScale(Vector(-1,1,1))
		end
	return true
end

--[[function SWEP:PrimaryAttack()
	local cp1 = { ["entity"] = self.Weapon, ["attachtype"] = PATTACH_ABSORIGIN_FOLLOW}
	self.Weapon:CreateParticleEffect("env_fire_small_smoke", {cp1})
end]]--

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire(CurTime() + 0.50)--75
	--Do nothing if you're dead
	if !self.Owner:Alive() then return end
	--Start trace function to find if there is anything within 100 units infront of you
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start +(self.Owner:GetAimVector()*100)
	tr.filter = self.Owner
	local trace = util.TraceLine(tr)
	--Make sure we hit something
	if trace.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		if trace.Entity:IsPlayer() || trace.Entity:IsNPC() then --Hit a person/npc >:D
			bloody = true
		end
		self.Weapon:EmitSound("physics/flesh/flesh_impact_bullet"..math.random(3,5)..".wav")	

		bullet = {} --Credit here goes to Feihc for his primary fire script of his lightsaber swep
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 0
		bullet.Damage = 40

		self.Owner:FireBullets(bullet)

	else --We missed :(a
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)--misscenter
		self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	end
	
	if self.Owner then
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end
	
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )	end

function SWEP:DrawHUD()

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0
	local scale = 10 * self.Primary.Cone
	
	-- Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))
	
	surface.SetDrawColor( 0, 255, 0, 255 )
	
	-- Draw an awesome crosshair
	local gap = 40 * scale
	local length = gap + 20 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

end

function SWEP:OnDrop()
	self.Weapon:Remove()
end