//SENT Cannon for pirate ship wars gamemode
//SENT made by Metroid48

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local autoDeleteTime=5

function ENT:SpawnFunction( ply, tr )
	
	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create("sent_cannonball")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self.Entity:SetModel("models/pirateshipwars/cannonballs.mdl")//"models/props_interiors/pot02a.mdl")//"models/bg_sea/rudder.mdl")//cannon/ball.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
//	self.Entity:SetOwner(nil)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	phys:EnableGravity(true)
	phys:EnableDrag(true)
	
	self.createTime=CurTime()+autoDeleteTime
	self.exploded=false
	local ss=5
	local es=50//10
	local t=5
	local trail=util.SpriteTrail(self.Entity,0,Color(255,255,255,255),false,ss,es,t,1/((ss+es)*0.5),"trails/smoke.vmt")
	
end

function ENT:PhysicsCollide(data,physobj)
	if self.Entity:GetOwner():IsValid() then
		if physobj==self.Entity:GetOwner():GetPhysicsObject() then
			return false
		end
	end
	return true
end

function ENT:OnTakeDamage(dmginfo)
	return false
end

function ENT:Touch(ents)
	if self.Entity:GetOwner():IsValid() then
		if self.Entity:GetOwner()==ents then return false end
		
		if !self.exploded then
			//Effect
			//util damage
			self.exploded=true
		else
			self.Entity:Remove()
		end
	end
end

function ENT:Think()
	if self.createTime<CurTime() then
		self.Entity:Remove()
	end
end
