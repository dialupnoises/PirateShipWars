//SENT Cannon for pirate ship wars gamemode
//SENT made by Metroid48

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

cannonLength = 10//75

function ENT:SpawnFunction( ply, tr )
	
	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create("sent_cannon")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	self.Entity = ent
	
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel("models/pirateshipwars/cannon_barrel.mdl")//"models/bg_sea/us_navalcannon.mdl")//cannon/main.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetOwner(nil)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	phys:EnableGravity(false)
	phys:EnableDrag(false)
	
	self.startAngles=self.Entity:GetAngles()
	self.fired=false
	self.fireTime=nil
	self.nextUse=0
	self.MaxPit=-25
	self.MinPit=10
	self.MaxYaw=40
	
	self.angs = self.startAngles
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
end

/*function ENT:PhysicsCollide(data,physobj)

end*/

function ENT:OnTakeDamage(dmginfo)
	return false
end

/*function doAim()
	if !self.Entity:GetOwner():IsValid() then return end
	local aim=self.Entity:GetOwner():GetAimVector():Angle()
//	local aimed=self.Entity:GetAngles()
	
	local pitAim=aim.p
	local yawAim=aim.y
//	local diff=aim-self.Angles
//	local yawAim=diff.y //L/R
//	local pitAim=diff.p //U/D
	
	if pitAim<self.MaxPit then
		pitAim=self.MaxPit
	elseif pitAim>0 then
		pitAim=0
	end
	
	if yawAim<self.startAngles.y-self.MaxYaw then
		yawAim=self.startAngles.y-self.MaxYaw
	elseif yawAim>self.MaxYaw-self.startAngles.y then
		yawAim=self.MaxYaw-self.startAngles.y
	end
	
	self.angs = Angle(pitAim,yawAim,0)
end*/

function msgBinds()
	local ang=ents.FindByClass("sent_cannon")[1]:GetAngles()//.angs
	Msg("P: "..ang.p.." Y: "..ang.y.." R: "..ang.r.."\n")
end
concommand.Add("msgAngs",msgBinds)

function ENT:PhysicsSimulate(phys, deltatime)
//	local phys = self.Entity:GetPhysicsObject()
//	if phys:IsValid() then
		
//		phys:Wake()
		
		local sm = {}
			sm.secondstoarrive		= 1
			sm.pos					= self.Entity:GetPos()
			sm.angle				= self.angs
			sm.maxangular			= 5000
			sm.maxangulardamp		= 10000
			sm.maxspeed				= 1000000
			sm.maxspeeddamp			= 10000
			sm.dampfactor			= 0.8
			sm.teleportdistance		= 20
			sm.deltatime			= deltatime
		phys:ComputeShadowControl(sm)
		
//	end
end

function ENT:Think()
	if self.fired then
		if CurTime()>self.fireTime then
			self.fired=false
			self.fireTime=nil
		end
	end

	if !self.Entity:GetOwner():IsValid() then
		self.Entity:NextThink(CurTime()+0.5)
		return false
	else
		
		if !self.Entity:GetOwner():IsPlayer() then return end
		
		if (self.Entity:GetOwner():KeyPressed(IN_USE)) then
			self.nextUse = CurTime()+3
			self.Entity:GetOwner():SetPos(self.Entity:GetPos()+self.Entity:GetForward() *-75)
			self.Entity:GetOwner():UnSpectate()
			self.Entity:GetOwner():SetParent()
			self.Entity:GetOwner():SetMoveType(2)
			self.Entity:GetOwner():SetGravity(1)
			
			self.Entity:GetOwner():SetOwner()
			self.Entity:SetOwner(nil)
			
			return
		end
		
		if self.Entity:GetOwner():KeyDown(IN_ATTACK) then
			if !self.fired then
				self.fired = true
				self.fireTime=CurTime()+7
				
				local cball = ents.Create("sent_cannonball")
				cball:SetPos(self.Entity:GetPos()+self.Entity:GetForward()*cannonLength)
				cball:SetAngles(self.Entity:GetAngles())
				cball:SetOwner(self.Entity)
				cball:Spawn()
				cball:Activate()
				cball:GetPhysicsObject():SetVelocity(self.Entity:GetForward() * 9999)
			end
		end
		
		if self.Entity:GetOwner():KeyDown(IN_USE) then
			if self.nextUse<=CurTime() then
				self.nextUse = CurTime()+3
				self.Entity:GetOwner():SetPos(self.Entity:GetPos()+self.Entity:GetForward()*-5)
				self.Entity:GetOwner():SetParent()
				self.Entity:GetOwner():SetAngles(Angle(0,0,0))
				self.Entity:GetOwner():SetMoveType(2)
				self.Entity:GetOwner():SetGravity(1)
			end
		end
		
		if !self.Entity:GetOwner():IsValid() then return end
		local aim=self.Entity:GetOwner():GetAimVector():Angle()
//		local aimed=self.Entity:GetAngles()
		
		local pitAim=aim.p
		local yawAim=aim.y
//		local diff=aim-self.Angles
//		local yawAim=diff.y //L/R
//		local pitAim=diff.p //U/D
		
		if pitAim>self.MinPit then
			pitAim=self.MinPit
		elseif pitAim<self.MaxPit then
			pitAim=self.MaxPit
		end
		
		if yawAim<-self.MaxYaw then
			yawAim=-self.MaxYaw
		elseif yawAim>self.MaxYaw then
			yawAim=self.MaxYaw
		end
		
		local pit=pitAim
		local yaw=self.startAngles.y+yawAim
		
		self.angs = Angle(pit,yaw,0)
	end
end

function ENT:Use(activator, caller)
		if self.nextUse>CurTime() then return end
		self.nextUse = CurTime()+3
		
		if activator:IsPlayer() then
//			if !activator:KeyPressed(IN_USE) then return end
			activator:SetPos(self.Entity:GetPos())
			activator:SetAngles(self.Entity:GetForward())
			if self.Entity:GetParent():IsValid() then
				activator:SetParent(self.Entity:GetParent())
			end
			activator:SetMoveType(0)
			activator:SetGravity(0)
			self.Entity:SetOwner(activator)
			local phys=self.Entity:GetPhysicsObject()
			phys:EnableDrag(false)
//		end
	end
end

