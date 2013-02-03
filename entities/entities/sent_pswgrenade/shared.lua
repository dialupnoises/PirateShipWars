//moo
//ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName		= "Pirate Grenade"
ENT.Author			= "Night-Eagle, Metroid48"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""


/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function ENT:OnRemove()
end

function ENT:PhysicsUpdate()
end

function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .2 + (data.OurOldVelocity * -.4) //.4 .6
	phys:ApplyForceCenter(impulse)
end

function ENT:Initialize()

	self.Entity:SetModel("models/powdergrenade/powdergrenade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	
	// Don't collide with the player
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	self.timer = CurTime() + 3
end

function ENT:Think()
	if self.timer < CurTime() then
		if (SERVER) then
			local range = 512
			local damage = 0
			local pos = self.Entity:GetPos()
			local eowner = self.eOwner
			
			//self.Entity:EmitSound(Sound("weapons/hegrenade/explode"..math.random(3,5)..".wav"))
			self.Entity:Remove()
			
			orgin_ents = ents.FindInSphere( pos, 150 )
			for a=1, #orgin_ents do
				if orgin_ents[a]:GetClass() == "player" then
					if ( orgin_ents[a]:Team() != self.eOwner:Team() ) or ( orgin_ents[a] == self.eOwner ) then
						expdmg = 150 - pos:Distance( orgin_ents[a]:GetPos() )
						orgin_ents[a]:TakeDamage( expdmg, eowner )
					end
				end
			end
		end
		if (CLIENT) then
			local pos = self.Entity:GetPos()
			Explosion( pos, EyeAngles():Forward(), Color( 190, 40, 0, 255 ),  0 );
		end
	end
end
