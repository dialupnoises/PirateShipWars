////
//Lag Reduction (I hope...)
////
/*function GM:Move(pl, movedata)
	if PirateData[pl:EntIndex()].parented then
		pl:SetParent()
		PirateData[pl:EntIndex()].parented = false
	end
end

function GM:FinishMove(pl, movedata)
	if ships then
		if !PirateData[pl:EntIndex()].parented then
			if pl:Team()==TEAM_RED then
				pl:SetParent(ents.FindByName("ship1keel")[1])
				Msg("SettingParent\n")
			elseif pl:Team()==TEAM_BLUE then
				pl:SetParent(ents.FindByName("ship2keel")[1])
				Msg("SettingParent\n")
			end
		end
	end
end*/

/*	if pl:IsAdmin() then
		pl:GodDisable()
		if string.find(pl:GetName(), "[godmode]") then
			pl:GodEnable()
		end
	end*/
	
/*function GM:PlayerUse(pl, ents)
	local name = ents:GetName()
	if name=="ship2drivebutton" then
		if pl:Team()==TEAM_BLUE then
			PirateData[pl:EntIndex()].driving=!PirateData[pl:EntIndex()].driving
			shipfunctions(pl, PirateData[pl:EntIndex()].driving, ents)
			return true
		else
			pl:PrintMessage(HUD_PRINTTALK, "Don't jack their ship!")
			return false
		end
	elseif name=="ship1drivebutton" then
		if pl:Team()==TEAM_RED then
			PirateData[pl:EntIndex()].driving=!PirateData[pl:EntIndex()].driving
			shipfunctions(pl, PirateData[pl:EntIndex()].driving, ents)
			return true
		else
			pl:PrintMessage(HUD_PRINTTALK, "Don't jack their ship!")
			return false
		end
	end
end*/

//Masts functions
function masts (activator, caller, entity)//(entity, caller, activator)//activator,caller,entity
	
//Red Ship
	if entity:GetName() == "s1pole" then
		if string.find(activator:GetClass(), "func_physbox") && ents.FindByName("ship1weldpolefront") then
			ents.GetByName( "ship1weldpolefront" ):Fire("Break", "", 0)
		end
	end
	
	if entit:GetName() == "s1polebreak" && !starting then
		ents.GetByName( "ship1polefront" ):Remove()
	end
	
	if entity:GetName() == "s1main" then
		if string.find(activator:GetClass(), "func_physbox") && ents.FindByName("ship1weldmastfront") then
			ents.GetByName( "ship1weldmastfront" ):Fire("Break", "", 0)
		end
	end
	
	if entity:GetName() == "s1mainbreak" && !starting then
		ents.GetByName( "ship1mastfront" ):Remove()
	end
	
	if entity:GetName() == "s1rear" then
		if string.find(activator:GetClass(), "func_physbox") && ents.FindByName("ship1weldmastback") then
			ents.GetByName( "ship1weldmastback" ):Fire("Break", "", 0)
		end
	end
	
	if entity:GetName() == "s1rearbreak" && !starting then
		ents.GetByName( "ship1mastback" ):Remove()
	end
	
//Blue Ship
	if entity:GetName() == "s2pole" then
		if string.find(activator:GetClass(), "func_physbox") && ents.FindByName("ship2weldpolefront") then
			ents.GetByName( "ship2weldpolefront" ):Fire("Break", "", 0)
		end
	end
	
	if entity:GetName() == "s2polebreak" && !starting then
		ents.GetByName( "ship2polefront" ):Remove()
	end
	
	if entity:GetName() == "s2main" then
		if string.find(activator:GetClass(), "func_physbox") && ents.FindByName("ship2weldmastfront") then
			ents.GetByName( "ship2weldmastfront" ):Fire("Break", "", 0)
		end
	end
	
	if entity:GetName() == "s2mainbreak" && !starting then
		ents.GetByName( "ship2mastfront" ):Remove()
	end
	
	if entity:GetName() == "s2rear" then
		if string.find(activator:GetClass(), "func_physbox") && ents.FindByName("ship2weldmastback") then
			ents.GetByName( "ship2weldmastback" ):Fire("Break", "", 0)
		end
	end
	
	if entity:GetName() == "s2rearbreak" && !starting then
		ents.GetByName( "ship2mastback" ):Remove()
	end
	
end
//hook.Add("EntityTakeDamage", "mastsFTW", masts)

//Functions such as cannons, stearing wheels, and healers
function shipfunctions (activator, arg, entity)//(entity, caller, activator) //activator, caller, entity

//Red Ship
	if entity:GetName() == "s1heal" then
		if activator:Team()==TEAM_RED then
			PirateData[activator:EntIndex()].Heal = true
		end
	end
	
	if entity:GetName() == "s1heal2" then
		if activator:Team()==TEAM_RED then
			PirateData[activator:EntIndex()].Heal = false
		end
	end
	
	if entity:GetName() == "ship1drivebutton"&&arg then
		if activator:Team() == TEAM_RED then
			activator:SetParent(ents.FindByName("ship1keel")[1])
			Msg("SettingParent\n")
			captain( activator, activator:Team(), 1 );
		end				
	end
	
	if entity:GetName() == "ship1drivebutton"&&!arg then
		if activator:Team() == TEAM_RED then
			activator:SetParent()
			captain( activator, activator:Team(), 2 );
		end
	end
	
	if entity:GetName() == "s1cannonfront" then
		if string.find ( activator:GetClass(), "func_tank" ) then
		s1frontuser:SelectWeapon("weapon_sabre");
//		_PlayerHolsterWeapon(s1frontuser);
		else
		s1frontuser = activator;
		end
	end
	
	if entity:GetName() == "s1cannonback" then
		if string.find ( activator:GetClass(), "func_tank" ) then
		s1backuser:SelectWeapon("weapon_sabre");
//		_PlayerHolsterWeapon(s1backuser);
		else
		s1backuser = activator;
		end
	end
	
//Blue Ship
	if entity:GetName() == "s2heal" then
		if activator:Team()==TEAM_BLUE then
			PirateData[activator:EntIndex()].Heal = true
		end
	end
	
	if entity:GetName() == "s2heal2" then
		if activator:Team()==TEAM_BLUE then
			PirateData[activator:EntIndex()].Heal = false
		end
	end
	
	if entity:GetName() == "ship2drivebutton"&&arg then
		if activator:Team() == TEAM_BLUE then
			activator:SetParent(ents.FindByName("ship1keel")[1])
			Msg("SettingParent\n")
			captain( activator, activator:Team(), 1 );
		end				
	end
	
	if entity:GetName() == "ship2drivebutton"&&!arg then
		if activator:Team() == TEAM_BLUE then
			activator:SetParent()
			captain( activator, activator:Team(), 2 );
		end
	end
	
	if entity:GetName() == "s2cannonfront" then
		if string.find ( activator:GetClass(), "func_tank" ) then
		s2frontuser:SelectWeapon("weapon_sabre");
//		_PlayerHolsterWeapon(s2frontuser);
		else
		s2frontuser = activator;
		end
	end
	
	if entity:GetName() == "s2cannonback" then
		if string.find ( activator:GetClass(), "func_tank" ) then
		s2backuser:SelectWeapon("weapon_sabre");
//		_PlayerHolsterWeapon(s2backuser);
		else
		s2backuser = activator;
		end
	end
end
//hook.Add("EntityTakeDamage", "shipFunctionsFTW", shipfunctions)

/*	if attacker:IsValid() && string.find(attacker:GetName(), "cannon") && string.find(attacker:GetName(), "ball") then
//		if !exploded[attacker:EntIndex()] then
//			exploded[attacker:EntIndex()]=1
//		end
//		if exploded[attacker:EntIndex()]<=2 then
			local pos = attacker:GetPos()
			local damage = 0.01
			for k,v in pairs(ents.FindInSphere(pos,75)) do
				if v:IsPlayer() then
					local health = v:Health()
					local dist = v:GetPos():Distance(pos)
					local tempDam=0
					if dist=0 then
						tempDam = damage
					else
					tempDam = damage/dist
					end
					v:SetHealth(health-teampDam)
				end
			end
			util.BlastDamage(attacker, attacker,pos,10,damage)
			local effectData = EffectData()
			effectData:SetStart(pos)
			effectData:SetOrigin(pos)
			effectData:SetScale(1)
			effectData:SetRadius(75)
			util.Effect("Explosion", effectData)
//			exploded[attacker:EntIndex()]=3
//		end
	attacker:Remove()
	end*/
	
	/*	if attacker:IsValid() && string.find(attacker:GetName(), "cannon") && string.find(attacker:GetName(), "ball") then
//		if !exploded[attacker:EntIndex()] then
//			exploded[attacker:EntIndex()]=1
//		end
//		if exploded[attacker:EntIndex()]<=2 then
			local pos = attacker:GetPos()
			local damage =0.25
			for k,v in pairs(ents.FindInSphere(pos,75)) do
				if v:IsPlayer() then
					local health = v:Health()
					local dist = v:GetPos():Distance(pos)
					local tempDam=0
					if dist=0 then
						tempDam = damage
					else
					tempDam = damage/dist
					end
					v:SetHealth(health-teampDam)
				end
			end
			util.BlastDamage(attacker, attacker,pos,10,damage)
			local effectData = EffectData()
			effectData:SetStart(pos)
			effectData:SetOrigin(pos)
			effectData:SetScale(1)
			effectData:SetRadius(50)
//			util.Effect("effect_cannon", effectData)
//			exploded[attacker:EntIndex()]=3
//		end*/
/*		if cannonExplosive then
			cannonExplosive:SetPos(attacker:GetPos())
			cannonExplosive:Fire("Explode","",0)
			cannonExplosive:SetPos(Vector(0,0,0))
			attacker:Remove()
		end
	end*/