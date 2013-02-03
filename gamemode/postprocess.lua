--PirateShip Wars Post Processing
--Made by Metroid48 and Termy58

--if (SERVER) then return end --Shouldn't need this line, this file is never included by the server.

local MySelf = LocalPlayer()
local health = MySelf:Health()
local lastHealth = 100
local lastDiff = 0
local scale = 0

function resetBlur(pl)
--	if pl==MySelf then
		MySelf:ConCommand("pp_motionblur 0")
		scale = 0
		lastHealth = MySelf:Health()
--	end
end
concommand.Add("psw_blurReset", resetBlur)
--hook.Add("PlayerSpawn", "PSWBlurReset", resetBlur)

function doProcessing()
	if MySelf:Health() == nil then return end
--	local damaged = false
	local diff = lastHealth-MySelf:Health()
	if diff>1 then
--		damaged = true
		if scale==0 then
			MySelf:ConCommand("pp_motionblur 1")
		end
		scale=scale+(diff/90)
	elseif scale!=0 then
		scale=scale-0.25
		if scale<0 then
			scale=0
		end
	end
	if scale>1 then
		scale=1
	end
	if scale<=0 then
		MySelf:ConCommand("pp_motionblur 0")
	end
	local tempDraw = 0.15+(scale*0.5)
	local tempAdd = 0.1-(scale*0.04)
	MySelf:ConCommand("pp_motionblur_drawalpha "..tostring(tempDraw))
	MySelf:ConCommand("pp_motionblur_addalpha "..tostring(tempAdd))
--	Msg(tostring(scale).."\n")
	lastHealth = MySelf:Health()	
	lastDiff = diff
end
timer.Create("PostProccessTimer", 0.5, 0, doProcessing)

--[[function cancelBlur()
	timer.Remove("PostProccessTimer")
	MySelf:ConCommand("pp_motionblur 0")
end
concommand.Add("psw_blurOff", cancelBlur)

function startBlur()
	timer.Create("PostProccessTimer",0.5,0,doProcessing)
end
concommand.Add("psw_blurOn", startBlur)]]--

--[[local wasInWater = false
local coldScale = 0--Goes up to 100
local w1 = 0

function resetCold()
	coldScale = 0
	wasInWater=false
end

function doCold()
	local wl = MySelf:WaterLevel() --0-none, 1-a third, 2-two thirds, 3-submerged
	if !wasInWater then
		if w1>0 then
			coldScale=coldScale+15
			wasInWater=true
		end
	else
		if w1>0 then
			coldScale=coldScale+(w1*3)
			
		else
			
		end
	end
end
timer.Create("PostProccessColdTimer",0.5,0,doCold)
]]--