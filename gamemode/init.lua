--PirateShip Wars
--Originally made in Gmod 9 by EmpV
--Remade for Gmod 13 by VertisticINC

Msg("\nLoading PirateShip Wars server files\n")

include("shared.lua")
include("mapcycle.lua") --Donated by UberMensch
include("explosion.lua")
include("pirateSpeak.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("postprocess.lua")
AddCSLuaFile("explosion.lua")

--Var define
ships = false
PirateData = {}
canSpawn = false
exploded = {}
shipdata = {}
shipdata[TEAM_RED] = {}
shipdata[TEAM_RED].name = "Red"
shipdata[TEAM_RED].n = 35
shipdata[TEAM_BLUE] = {}
shipdata[TEAM_BLUE].name = "Blue"
shipdata[TEAM_BLUE].n = 35
cannonExplosive = nil
mastsBroken = {}
roundsDone = 0

CreateConVar("psw_noDoors", "0", FCVAR_NOTIFY)
CreateConVar("psw_weaponMusket", "1", FCVAR_NOTIFY)
CreateConVar("psw_weaponGrenade", "0", FCVAR_NOTIFY)
CreateConVar("psw_weaponPistol", "1", FCVAR_NOTIFY)
CreateConVar("psw_weaponSabre", "1", FCVAR_NOTIFY)

--[[resource.AddFile("materials/VGUI/help/pswHelp.vtf")
resource.AddFile("materials/VGUI/help/pswHelp.vmt")
resource.AddFile("materials/VGUI/hud/blood.vtf")
resource.AddFile("materials/VGUI/hud/blood.vmt")
resource.AddFile("materials/VGUI/hud/blueblood.vtf")
resource.AddFile("materials/VGUI/hud/blueblood.vmt")
resource.AddFile("materials/VGUI/hud/blueskull.vtf")
resource.AddFile("materials/VGUI/hud/blueskull.vmt")
resource.AddFile("materials/VGUI/hud/Skull.vtf")
resource.AddFile("materials/VGUI/hud/Skull.vmt")]]--

--[[	cannonExplosive = ents.Create("env_explosion")
	cannonExplosive:SetKeyValue("iRadiusOverride", 75)
	cannonExplosive:SetKeyValue("rendermode", 5)
	cannonExplosive:SetKeyValue("fireballsprite", "sprites/splodesprite")
	cannonExplosive:SetKeyValue("iMagnitude",10)
	cannonExplosive:SetKeyValue("spawnflags",0)
	cannonExplosive:SetPos(Vector(0,0,0))
	cannonExplosive:Spawn()]]--


for k,v in pairs(player.GetAll()) do
	v.heal = false
	v.lastpos = nil
	v.kd = 0
	v.lastspawn = nil
	v.parented = false
end

-------
--Menus
-------

function GM:ShowHelp(ply)

	ply:ConCommand("_doHelp")
--	umsg.Start("HelpMenu", ply)
--	umsg.Short( 7 )
--	umsg.End()
	
end

function GM:ShowTeam(ply)

	ply:ConCommand("_doTeam")
--[[	umsg.Start("TeamMenu", ply)
	umsg.Short( 8 )
	umsg.End()]]--
	
end

---------------------------------
--General player console commands
---------------------------------

function switchTheTeam(pl,saywhat,pblc)

	--Msg("Switch hook init.\n")

	local text=string.Explode(" ",saywhat)
	
	if text[1]=="!switch" then
		local rr = team.NumPlayers(TEAM_RED)
		local bb = team.NumPlayers(TEAM_BLUE)
		
		local targ=tonumber(text[2])
		
		if targ==TEAM_BLUE then
		
			if rr+1<=bb-1||bb==0 then
			
				pl:SetTeam(TEAM_BLUE)
				pl:KillSilent( ) 
				pl:AddDeaths( -1 )
				
			end
			
		elseif targ==TEAM_RED then
			if bb+1<=rr-1||rr==0 then
				pl:SetTeam(TEAM_RED)
				pl:KillSilent() 
				pl:AddDeaths( -1 )
			end
		--[[elseif targ==TEAM_SPECTATE then
			pl:SetTeam(TEAM_SPECTATE)
			pl:KillSilent()
			pl:AddDeaths(-1)
			pl:Spectate(5)
			Msg("Switch player "..pl:Name().." to team Spectator\n")
			pl:PrintMessage(HUD_PRINTTALK, "Switching to team Spectator\n")
			return]]--
		end
		Msg("Switch player "..pl:Name().." to team "..shipdata[targ].name..".\n")
		pl:PrintMessage(HUD_PRINTTALK,"Switching to team "..shipdata[targ].name..".\n")
		return ""
	end
end

function playerSaid(ply, msg, pblc)
	if string.Explode(" ",msg)[1] == "!switch" then return switchTheTeam(ply, msg, pblc) end
	return chatConvertPirate(ply, msg)
end
hook.Add("PlayerSay","switchAttack",playerSaid)
--concommand.Add("psw_switch", teamSwitch)

---------------------
--Main function hooks
---------------------

--Spawn Function

function GM:PlayerSpawn( ply )

	if canSpawn then
		
		ply:Spectate(0)
		ply:UnSpectate()
		ply:Freeze(false)
		ply:GodDisable()
		ply:SprintDisable()
		ply.temp = 98.6
		--lua_run_cl Msg("angles = "..tostring(LocalPlayer():GetAngles()).."\n")
		pang = ply:GetAngles()
		ply:SetAngles(Angle(0, pang.y, 0))
		
		--playerTalk( ply:GetAngles() )
		
		GAMEMODE:PlayerLoadout( ply )
		GAMEMODE:PlayerSetModel( ply )
		GAMEMODE:SetPlayerSpeed( ply, 250, 300 )
		
	else
	
		ply:SetTeam(TEAM_SPECTATE)
		ply:Spectate(5)
		
		if ply.lastpos then
		
			ply:SetPos( ply.lastpos )
			ply.lastpos = nil
			
		end
		
	end
	
end

function GM:PlayerDeath( Victim, Inflictor, Attacker ) 
   
	-- Don't spawn for at least 2 seconds 
	Victim.NextSpawnTime = CurTime() + 2 
   
	-- Convert the inflictor to the weapon that they're holding if we can. 
	-- This can be right or wrong with NPCs since combine can be holding a  
	-- pistol but kill you by hitting you with their arm. 
	
	if ( !Attacker:IsPlayer() ) && ( Attacker:GetOwner() ) then
		
		if Attacker:GetOwner():IsValid() then
			if Attacker:GetOwner():IsPlayer() then
				Attacker = Attacker:GetOwner()
			end
		end
		
	end
	
	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then 
	 
		Inflictor = Inflictor:GetActiveWeapon() 
		if ( Inflictor == NULL ) then Inflictor = Attacker end 
	 
	end 
	 
	if (Attacker == Victim) then 
	 
		umsg.Start( "PlayerKilledSelf" ) 
			umsg.Entity( Victim ) 
		umsg.End() 
		 
		MsgAll( Attacker:Nick() .. " suicided!\n" ) 
		 
	return end 
   
	if ( Attacker:IsPlayer() ) then 
	 
		umsg.Start( "PlayerKilledByPlayer" ) 
		 
			umsg.Entity( Victim ) 
			umsg.String( Inflictor:GetClass() ) 
			umsg.Entity( Attacker ) 
		 
		umsg.End() 
		 
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. "\n" ) 
		 
	return end 
	 
	umsg.Start( "PlayerKilled" ) 
	 
		umsg.Entity( Victim ) 
		umsg.String( Inflictor:GetClass() ) 
		umsg.String( Attacker:GetClass() ) 
	
	umsg.End() 
	
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" ) 
	
 end 

function enableSpawning()
	
	canSpawn = true
	
	for k,v in pairs(player.GetAll()) do
	
		v:KillSilent( ) 
		v:AddDeaths( -1 )
	end
	
end
timer.Simple(3, enableSpawning)

function GM:PlayerSelectSpawn( ply ) --Returns correct spawn point for team
	
	ply:UnSpectate()
	local bb = team.NumPlayers(TEAM_BLUE)
	local rr = team.NumPlayers(TEAM_RED)

	if ply:Team()== TEAM_SPECTATE then
	
		if bb==rr then
		
			ply:SetTeam(TEAM_RED)
			
		elseif bb>rr then
		
			ply:SetTeam(TEAM_RED)
			
		else
			
			ply:SetTeam(TEAM_BLUE)
			
		end
	
		ply:Spectate(0)
		ply:UnSpectate()
	
	end
	
	if bb > (rr + 1) then
	
		ply:SetTeam(TEAM_RED)
		
	elseif (rr > bb + 1) then
	
		ply:SetTeam(TEAM_BLUE)
		
	end


	local tempTable = nil
	
	if ply:Team()==TEAM_BLUE then --Defines player spawns
		
		tempTable = ents.FindByClass("info_player_deathmatch")
		
	else
		
		tempTable = ents.FindByClass("info_player_start")
		
	end

	local cnt = #tempTable
	local nearest = nil

	if !cnt then return ply end
	
	local chosen = false
	
	for k,v in pairs(tempTable) do
		
		nearest = ents.FindInSphere(v:GetPos(), 10)
		sang = v:GetAngles()
		v:SetAngles(Angle(0, sang.y, 0))
		
		if v:IsValid() && v:IsInWorld() then
		
			local blk = false
			newTarget = v
			
			for i,o in pairs(nearest) do
			
				if o:GetClass()=="trigger_teleport" then
					if ents.GetByName(o:GetKeyValues().target, true) then
						newTarget = ents.GetByName(o:GetKeyValues().target, true)
					end
				end
				
			end
			
			for o,l in pairs(ents.FindInSphere( ( newTarget:GetPos() or v ) ,150)) do
			
				if l:IsValid() && l:IsPlayer() then
				
					blk = true
					
				end
				
			end
			
			if !blk then
			
				if !ply.lastspawn then
				
					chosen = true
					ply.lastspawn = v
					return v
					
				elseif ply.lastspawn ~= v then
				
					chosen = true
					ply.lastspawn = v
					return v
					
				end
				
			end
			
		end
		
	end
	
	if !chosen then
	
		return ply
		
	end
	
end

function GM:PlayerInitialSpawn( ply )
	
	ply:PrintMessage(HUD_PRINTTALK, "Seein' errors? Need help? Press F1.  Change Team? Press F2")
--	ply:PrintMessage(HUD_PRINTCENTER, "Seein' errors? Need help? Press F1")
  	ply:ConCommand("_doInfo")
	
	ply.heal = false
	ply.lastpos = nil
	ply.kd = 0
	ply.lastspawn = nil
	ply.parented = false
	ply:Freeze(true)
	
	if canSpawn then
	
		--[[
		local bb = team.NumPlayers(TEAM_BLUE)
		local rr = team.NumPlayers(TEAM_RED)
		ply:Spectate(0)
		ply:UnSpectate()
		
		if bb == rr then
		
			ply:SetTeam(math.random(1,2))
			
		elseif bb > rr then
		
			ply:SetTeam(TEAM_RED)
			
		else
		
			ply:SetTeam(TEAM_BLUE)
			
		end
		
	else
	]]--
		ply:SetTeam(TEAM_SPECTATE)
		ply:Spectate(5)
		
	end
	
end

--Give weapons

function GM:PlayerLoadout( ply )

--	GAMEMODE:PlayerSetModel( pl )
--	spawn = GAMEMODE:PlayerSelectSpawn( pl )
--	pl:SetPos(spawn:GetPos())
--	GAMEMODE:PlayerSpawn( pl )

	if ply:Team() == TEAM_SPECTATE then return end
	
	if ply:Team() == TEAM_BLUE || ply:Team() == TEAM_RED then
		
		if GetConVarNumber("psw_weaponMusket")>=1 then
			ply:Give("weapon_pmusket")
			ply:GiveAmmo(3,"buckshot",false)
		end
		
		if GetConVarNumber("psw_weaponPistol")>=1 then
			ply:Give("weapon_ppistol")
			ply:GiveAmmo(4,"weapon_ppistol",false)
		end
		
		
		if GetConVarNumber("psw_weaponSabre")>=1 then
			ply:Give("weapon_sabre")
			ply:GiveAmmo(3,"buckshot",false)
		end
		
		if GetConVarNumber("psw_weaponGrenade")>=1 then
			ply:Give("weapon_grenade")
		end
		
	end
	
end

--SetPlayerModel

function GM:PlayerSetModel( ply )
	
	if ply:Team() == TEAM_SPECTATE then return end
	
	if ply:Team() == TEAM_BLUE then
		
		ply:SetModel( "models/player/pirate/pirate_blue.mdl" )
		
	else
		
		ply:SetModel( "models/player/pirate/pirate_redd.mdl" )
		
	end
	
end

--Called on team kill
function killedTooMuch( att )
	
	if att:IsAdmin() then return false end
	if shipdata[TEAM_RED].sinking||shipdata[TEAM_BLUE].sinking then return false end
	
	local kds = att.kd
	if kds==2 then
		att:PrintMessage(HUD_PRINTCENTER, "You're team killing!")
	elseif kds>=5 then
		if !starting then
			if ASS_VERSION then
				ASS_BanPlayer( att, att:UniqueID( ), ( 7.5 * 60 ), "Automated temporary ban" )
 			else
				game.ConsoleCommand( "banid 7.5 "..tostring( att:UserID() ).." kick\n" )
			end
		end
	end
end 

--Player Death Hook
function plyDeath( ply, ent, att )
	
	ply:AddDeaths(1)
	ply.heal = false
	ply.parented = false
	ply.driving = false
	
	if att:IsPlayer() then
		if ply:Team() ~= att:Team() then
			
			team.AddScore(att:Team(), 1)
			att:AddFrags(1)
			att:GiveAmmo(1, "weapon_pmusket",false)
			
		elseif ply ~= att then
			att.kd = (att.kd + 1)
			killedTooMuch(att)
		end
	end

	if !canSpawn||shipdata[TEAM_RED].sinking||shipdata[TEAM_BLUE].sinking then
		ply:AddFrags(1)
		ply.lastpos = ply:GetPos()+Vector(0,0,700)
		ply:SetTeam(TEAM_SPECTATE)
		--ply:Freeze(true)
	end
	
end
hook.Add( "PlayerDeath", "changeTheirTeam", plyDeath )

---------------------------------
--Main gamemode-related functions
---------------------------------

--Simple function to print a message to the chat area for all players
function playerTalk( message )
	
	if message then
	
		local msg = tostring(message)
		
		for o,k in pairs(player.GetAll()) do
		
			k:PrintMessage( HUD_PRINTTALK, msg )
			
		end
		
	end
	
end

--Command to turn on or off leeches
function cc_leeches( ply, command, args )

	if(starting) then
	
		for k,v in pairs(ents.FindByName("leeches")) do
		
			if args[1] == "0" then
			
				v:Fire("Disable","",0)
				
			else
			
				v:Fire("Enable","",0)
				
			end
			
		end
		
	end
	
end
concommand.Add( "psw_leeches", cc_leeches )

--Spawns ships at map/round start
function GM:Think() --gamerulesThink()
	for k, v in pairs(player.GetAll()) do
	       
	    if v:Alive( ) && !( v:Team()== TEAM_SPECTATE ) then
	        
			if v:WaterLevel() then
				dmg = ( 2 * v:WaterLevel() * (CurTime() - lastthink) )
				v.temp = v.temp - dmg
				
				if v.temp < 70 then
					
					v:SetHealth( (v:Health() - dmg)  )
					
				end
				
			else
				v.temp = v.temp + ( 4 * (CurTime() - lastthink) )
				
	        end
			
--[[			--VIEW SNIPPING
			if v:OnGround() then --DETECT SHIP
				tracedata = {}
				tracedata.start = pos
				tracedata.endpos = Vector( 0, 0, 90 )
				tracedata.filter = self.Owner
				local trace = util.TraceLine(tracedata)
				
				if trace.HitNonWorld then
				
					target = trace.Entity
					Msg(target:GetClass() .. "\n")
					Msg(v:GetAngles() .. "\n")
				
				end
			end]]--
			
		end
		
	end
	
	if !ships then
		spawnships()
		ships = true
	end
	
	lastthink = CurTime()
	
end

function checkSpec()
	if canSpawn then
		for k,v in pairs(player.GetAll()) do
			v:UnSpectate()
			v:Freeze(false)
		end
	end
end

timer.Create("GetOuttaSpec", 5, 0, checkSpec)

function GM:Initialize() --gamerulesStartMap()
end

--SpawnShips
function spawnships()
	for k,v in pairs(ents.FindByName("spawnbutton")) do
		v:Fire("Press", "", 0)
	end
	
	shipdata[TEAM_RED].sinking = false
	shipdata[TEAM_BLUE].sinking = false
	shipdata[TEAM_RED].disabled = false
	shipdata[TEAM_BLUE].disabled = false
	starting=true

	for k,v in pairs(player.GetAll()) do
		v.kd = ( v.kd - 1 )
		if v.kd < 0 then
			v.kd = 0
		end
	end
	
	timer.Simple(4,getshipparts)
	timer.Create("healtimer", 1, 0, healer)
	timer.Simple(60,roundstart)
	
end

function roundstart()
	
	starting = false;
	
end

function healer()
--[[	for k,v in pairs(player.GetAll()) do
		if PirateData[v:EntIndex()].Heal && v:Health() < 100  then
			v:SetHealth(v:Health() + (101 - v:Health())* .75)
		end				
	end]]--
end

function findpartowner(ent, isstringbool)
	if isstringbool then
		entstring = ent
	else
		entstring = ent:GetName()
	end

	if string.find(entstring, "ship1") || string.find(entstring,"s1") then
		return 1
	end
	if string.find(entstring, "ship2") || string.find(entstring,"s2") then
		return 2
	end
end

function masts( mastid, owner )
	
	if mastid == "s" .. owner .. "polebreak" && !starting then
		--ents.FindByName( "ship" .. owner .. "polefront" )[1]:Remove()
		ents.FindByName( "ship" .. owner .. "polefront" )[1]:Fire("Kill", "", 0)
		teamropes = ents.FindByName( "ship" .. owner .. "rope" )
		for a=1, #teamropes do
			teamropes[a]:Remove()
		end
	end
	
	if mastid == "s" .. owner .. "mainbreak" && !starting then
	
		--ents.FindByName( "ship" .. owner .. "mastfront" )[1]:Remove()
		ents.FindByName( "ship" .. owner .. "mastfront" )[1]:Fire("Kill", "", 0)
		teamropes = ents.FindByName( "ship" .. owner .. "rope" )
		for a=1, #teamropes do
			teamropes[a]:Remove()
		end
		
	end
	
	if mastid == "s" .. owner .. "rearbreak" && !starting then
	
		--ents.FindByName( "ship" .. owner .. "mastback" )[1]:Remove()
		ents.FindByName( "ship" .. owner .. "mastback" )[1]:Fire("Kill", "", 0)
		teamropes = ents.FindByName( "ship" .. owner .. "rope" )
		for a=1, #teamropes do
			teamropes[a]:Remove()
		end
		
	end

end

function healer()
--[[	for k,v in pairs(player.GetAll()) do
		if PirateData[v:EntIndex()].Heal && v:Health() < 100  then
			v:SetHealth(v:Health() + (101 - v:Health())* .75)
		end				
	end]]--
end

function getshipparts() --GETS ENTITY ID'S FROM ALL SHIP PARTS AND SET MASSES.
	for v=1, 2 do
		
		shipdata[v][3] = ents.GetByName("ship" .. v .. "bottom2left");
		shipdata[v][4] = ents.GetByName("ship" .. v .. "bottom2right");
		shipdata[v][5] = ents.GetByName("ship" .. v .. "bottom3left");
		shipdata[v][6] = ents.GetByName("ship" .. v .. "bottom3right");
		shipdata[v][8] = ents.GetByName("ship" .. v .. "bottom4right");
		shipdata[v][9] = ents.GetByName("ship" .. v .. "keel2");
		shipdata[v][11] = ents.GetByName("ship" .. v .. "sinker2");
		
		shipdata[v][13] = ents.GetByName("ship" .. v .. "polefront");
		shipdata[v][14] = ents.GetByName("ship" .. v .. "mastfront");
		shipdata[v][15] = ents.GetByName("ship" .. v .. "mastback");
		shipdata[v][16] = ents.GetByName("ship" .. v .. "door");
		shipdata[v][17] = ents.GetByName("ship" .. v .. "explosive");
		shipdata[v][18] = ents.GetByName("ship" .. v .. "keel");
		
		ents.GetByName("ship" .. v .. "explosive", true):SetModel("models/props_c17/woodbarrel001.mdl")
		
		shipdata[v][3]:EnableDrag(false);
		shipdata[v][4]:EnableDrag(false);
		shipdata[v][5]:EnableDrag(false);
		shipdata[v][6]:EnableDrag(false);
		shipdata[v][8]:EnableDrag(false);
		shipdata[v][9]:EnableDrag(false);
		shipdata[v][11]:EnableDrag(false);
		
		shipdata[v][13]:EnableDrag(false);
		shipdata[v][14]:EnableDrag(false);
		shipdata[v][15]:EnableDrag(false);
		shipdata[v][16]:EnableDrag(false);
		shipdata[v][17]:EnableDrag(false);
		shipdata[v][18]:EnableDrag(false);
		
		shipdata[v][3]:SetMass(40000);
		shipdata[v][4]:SetMass(40000);
		shipdata[v][5]:SetMass(40000);
		shipdata[v][6]:SetMass(40000);
		shipdata[v][8]:SetMass(35000);
		mastsBroken["ship" .. v .. "mastfront"] = false
		mastsBroken["ship" .. v .. "mastback"] = false
		mastsBroken["ship" .. v .. "polefront"] = false

		if GetConVarNumber("psw_noDoors")>=1 then
			ents.GetByName("ship" .. v .. "door", true):Remove()
			ents.GetByName("ship" .. v .. "barrelexplode", true):Remove()
			ents.GetByName("ship" .. v .. "explosive", true):Remove()
			ents.GetByName("s" .. v .. "smoke", true):Remove()
		end
	end
	
end


function detectBreakage(pent, info)
	local caller = info:GetInflictor()
	local attacker = info:GetAttacker()
	local amount = info:GetDamage()
	if pent:IsPlayer() then return false end
	
	if attacker:IsPlayer() && string.find(pent:GetName(), "ship") then
		if attacker:Team() == TEAM_RED && string.find(pent:GetName(), "ship1") then return false end
		if attacker:Team() == TEAM_BLUE && string.find(pent:GetName(), "ship2") then return false end
		if pent:GetClass() != "prop_physics_multiplayer" && pent:GetClass() != "func_breakable" then
			return false
		end
		if starting then
			return false
		end
	end
	
	local ent = pent:GetPhysicsObject()
	owner = findpartowner(pent)
	
	if owner then
		if pent:GetName() == "ship" .. owner .. "polefront" then
			if string.find(caller:GetClass(), "func_physbox") && ents.FindByName( "ship" .. owner .. "weldpolefront" )[1] then
				ents.FindByName( "ship" .. owner .. "weldpolefront" )[1]:Fire("Break", "", 1)
				mastid="s" .. owner .. "polebreak"
				timer.Simple(40, function() masts(mastid, owner) end)
			end
		end
		if pent:GetName() == "ship" .. owner .. "mastfront" then 
			if string.find(caller:GetClass(), "func_physbox") && ents.FindByName( "ship" .. owner .. "weldmastfront" )[1] then
				ents.FindByName( "ship" .. owner .. "weldmastfront" )[1]:Fire("Break", "", 1)
				mastid="s" .. owner .. "mainbreak"
				timer.Simple(40, function() masts(mastid, owner) end)
			end
		end
		
		if pent:GetName() == "ship" .. owner .. "mastback" then
			if string.find(caller:GetClass(), "func_physbox") && ents.FindByName( "ship" .. owner .. "weldmastback" )[1] then
				ents.FindByName( "ship" .. owner .. "weldmastback" )[1]:Fire("Break", "", 1)
				mastid="s" .. owner .. "rearbreak"
				timer.Simple(40, function() masts(mastid, owner) end)
			end
		end
		
		if string.find(pent:GetName(), "ship" .. owner .. "explosive" ) then
			shipbarrel( owner, pent )
		elseif string.find(pent:GetName(), "ship") then
			if ent && ent:GetMass()>amount+5 then
				ent:SetMass(ent:GetMass()-amount)
			else
				ent:SetMass(5)
			end
			sink(owner)
		end
	end

--	return true

end

hook.Add("EntityTakeDamage", "pirateBreaks", detectBreakage)

function shipbarrel( prt )
	
	if !shipdata[prt].disabled then
	
		playerTalk(string.upper( shipdata[prt].name ) .. " PIRATE SHIP DISABLED")
		shipdata[prt].disabled = true
		
		local thrusters={"ship"..prt.."backwardthruster","ship"..prt.."forwardthruster","ship"..prt.."rightthruster","ship"..prt.."leftthruster","ship"..prt.."forwardthruster1"}
		
		for k,v in pairs(thrusters) do
			for i,l in pairs(ents.FindByName(v)) do
				l:Remove()
			end
		end
		
	end
	
end

function sink(v) --Sink function, called when a piece of a ship breaks
	if !shipdata[v].sinking then
		if shipdata[v][8] ~= nil && shipdata[v][8]:GetMass() > 9000 then
			shipdata[v][8]:SetMass(shipdata[v][8]:GetMass()-1000)
			if shipdata[v][11]:GetMass() < 40000 then
				shipdata[v][11]:SetMass(shipdata[v][11]:GetMass()+2000)
			end
		end
		if shipdata[v][3] ~= nil && shipdata[v][3]:GetMass() > 2000 then
			shipdata[v][3]:SetMass(shipdata[v][3]:GetMass()-1000)
			shipdata[v][4]:SetMass(shipdata[v][4]:GetMass()-1000)
			shipdata[v][5]:SetMass(shipdata[v][5]:GetMass()-1000)
			shipdata[v][6]:SetMass(shipdata[v][6]:GetMass()-1000)
		else
			shipbarrel(v)
			if shipdata[v][3] ~= nil && shipdata[v][3]:GetMass() > 14000 then
				shipdata[v][8]:SetMass(1000)
				shipdata[v][9]:SetMass(25000)
				shipdata[v][3]:SetMass(shipdata[v][3]:GetMass() - 1000)
				shipdata[v][4]:SetMass(shipdata[v][4]:GetMass() - 1000)
				shipdata[v][5]:SetMass(1000)
				shipdata[v][6]:SetMass(1000)
				shipdata[v][11]:SetMass(15000)
			else
				if !shipdata[opposingTeam(v)].sinking then
					shipdata[v].n = 35
					shipdata[v].sinking = true
					sinktimer = timer.Create("SinkTimer", 1, shipdata[v].n, function() CountDown(v) end)--timer.Simple(n1, CountDown)
					winner()
				end
			end
		end
	end
end

function CountDown(v)
	if shipdata[v].n == 30 then
		canSpawn=false
	end
	if shipdata[v].n == 7 && shipdata[v].sinking then
		timer.Stop("healtimer")--Not sure, maybe timer.Pause
		for k,v in pairs(player.GetAll()) do
			v:StripWeapons()
			v:Spectate(OBS_MODE_ROAMING)
			v:SetTeam(TEAM_SPECTATE)
		end
	end
	if shipdata[v].n == 5 && shipdata[v].sinking then	
		spawnships();
	end
	if shipdata[v].n == 1 then
		roundsDone = roundsDone+1
		if roundsDone == 4 then
			playerTalk("Last round before map restart!")
		end
		if roundsDone == 5 then
			playerTalk("Restarting map!")
			Msg("Restarting map\n")
			UMS_MapCycle.DoNextMap()
		end
		--Updates scores and respawbn players
		team.AddScore(opposingTeam( v ),30)
		
		--PlayerFreezeAll(false);
		timer.Remove("SinkTimer")
		canSpawn=true
		
		for k,v in pairs(player.GetAll()) do
		
			v:UnSpectate()
			
			v:KillSilent()
			v:Respawn()
			v:ConCommand("r_cleardecals")
			start(v);
			
		end	
		
	end	
	
	shipdata[v].n = shipdata[v].n - 1
	
	if ( shipdata[v].sinking ) then
	
		if shipdata[v][3]:GetMass() > 400 then
		
			shipdata[v][3]:SetMass( shipdata[v][3]:GetMass() - 200 )
			shipdata[v][4]:SetMass( shipdata[v][4]:GetMass() - 200 )
			
		end	
		
		shipdata[v][8]:SetMass(1000)
		
		if shipdata[v][11]:GetMass() <= 40000 then		
		
			shipdata[v][5]:SetMass(500);
			shipdata[v][6]:SetMass(500);
			shipdata[v][11]:SetMass( shipdata[v][11]:GetMass() + 1000 ); 
			
		end
		
		if shipdata[v][11]:GetMass() > 40000 then
		
			shipdata[v][5]:SetMass(1000)
			shipdata[v][6]:SetMass(1000)
		
			if shipdata[v][9]:GetMass() > 2000 then
			
				shipdata[v][9]:SetMass(shipdata[v][9]:GetMass()-1000)
				
			end
			
		elseif shipdata[v][11]:GetMass() > 49000 then
			shipdata[v][10]:SetMass(35000)
			shipdata[v][9]:SetMass(2000)
			shipdata[v][3]:SetMass(1000)
			shipdata[v][4]:SetMass(1000)	
			
		end
		
	end
	
end

function start(ply)

	ply:PrintMessage(HUD_PRINTCENTER,"Sink the enemy pirate ship!!!")
	
end

--Select a captain
function captain(userid, team, id) --Run by steering wheel

	local colour = Color(0,0,0,255)
	local suppl = ""
	
	if team == TEAM_RED then
	
		colour = Color(255,30,30,255)
		local suppl = "Red"
		
	else
	
		colour = Color(30,30,255,255)
		local suppl = "Blue"
		
	end
	
	local text = ""
	
	if id == 1 then
	
		text = suppl.." Captain: "..userid:Name()
		
	else
	
		text = "No "..suppl.." Captain."
		
	end
	
	for k,v in pairs(player.GetAll()) do
	
		if v:Team()==team then
		
			v:PrintMessage(HUD_PRINTCENTER, text)
			
		end
		
	end
	
end

--Anounce winner
function winner()

	local text=""
	
	if shipdata[TEAM_RED].sinking then
	
		text="The Blue Pirates Win!"
		
	end
	
	if shipdata[TEAM_BLUE].sinking then
	
		text="The Red Pirates Win!"
		
	end
	
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTCENTER, text)
	end
end

function opposingTeam( teamnum )
	if 1 then return 2 else return 1 end
end

function ents.GetByName( name, returnent )
	if returnent then return ents.FindByName( name )[1] end
	physent = ents.FindByName( name )[1]:GetPhysicsObject()
    return physent;
end

function DisableNoclip(pl)
	return false
end

function GM:PlayerConnect(name, addr)
	for k,v in pairs(player.GetAll()) do
		v:PrintMessage(HUD_PRINTTALK, "Player "..name.." has joined the game.")
	end
end
hook.Add("PlayerNoClip", "DisableNoclip", DisableNoclip)