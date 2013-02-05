--File containing pirate speak synonyms and other various language modifications
--Written by Metroid48, with many references to sites like yarr.org.uk/talk

pirateSpeak = pirateSpeak or {}

pirateSpeak["you"] = "ye"

pirateSpeak["my"] = "me"
pirateSpeak["am"] = "be"
pirateSpeak["are"] = "be"
pirateSpeak["were"] = "be"
pirateSpeak["your"] = "yer"
pirateSpeak["is"] = "be"
pirateSpeak["not"] = "ne'er"
pirateSpeak["will"] = "be"

pirateSpeak["stop that"] = "belay that"
pirateSpeak["officer"] = "bosun"
pirateSpeak["get out of my way"] = "gangway"
pirateSpeak["good luck"] = "godspeed"
pirateSpeak["food"] = "grub"
pirateSpeak["whipping"] = "flogging"

pirateSpeak["rowboat"] = "jollyboat"
pirateSpeak["dinghy"] = "jollyboat"

pirateSpeak["government approval"] = "letters of marque"

pirateSpeak["lungs"] = "lights"

pirateSpeak["do not surrender"] = "no quarter"
pirateSpeak["keep fighting"] = "no quarter"

pirateSpeak["diseased"] = "poxed"

pirateSpeak["strange"] = "rum"

pirateSpeak["telescope"] = "spyglass"

pirateSpeak["fire"] = "man the cannons"

pirateSpeak["she's"] = "she be"
pirateSpeak["he's"] = "he be"
pirateSpeak["there's"] = "there be"
pirateSpeak["here's"] = "here be"
pirateSpeak["haven't"] = "\'ave ne\'er"
pirateSpeak["you'll"] = "ye be"
pirateSpeak["i'm"] = "i be"
pirateSpeak["i've"] = "i \'ave"
pirateSpeak["you're"] = "ye be"

pirateSpeak["do"] = "doin\'"
pirateSpeak["build"] = "buildin\'"
pirateSpeak["drive"] = "drivin\'"
pirateSpeak["say"] = "sayin\'"

pirateSpeak["yes"] = "aye"
pirateSpeak["yah"] = "aye"
pirateSpeak["ya"] = "aye"

pirateSpeak["of"] = "o\'"
pirateSpeak["and"] = "an'"

pirateSpeak["hey"] = "ahoy"
pirateSpeak["hi"] = "ahoy"

pirateSpeak["stop"] = "Avast"

pirateSpeak["treasure"] = "booty"
pirateSpeak["riches"] = "booty"
pirateSpeak["money"] = "doubloons"

pirateSpeak["corpse"] = "black spot"

pirateSpeak["deserter"] = "buccanneer"
pirateSpeak["desertor"] = "buccanneer"

pirateSpeak["insane"] = "addled"
pirateSpeak["stupid"] = "addled"

pirateSpeak["by god"] = "begad"

pirateSpeak["omg"] = "shiver me timers!"
pirateSpeak["oh my god"] = "by the Powers!"
pirateSpeak["o my god"] = "by the Powers!"
pirateSpeak["oh my gosh"] = "by the Powers!"
pirateSpeak["o my gosh"] = "by the Powers!"

pirateSpeak["ship"] = "furner"

pirateSpeak["person"] = "gentleman o\' fortune"
pirateSpeak["people"] = "gentlemen o\' fortune"
pirateSpeak["ppl"] = "gentlemen o\' fortune"

pirateSpeak["sailor"] = "jack"

pirateSpeak["flag"] = "Jolly Roger"

pirateSpeak["drink"] = "grog"
pirateSpeak["wine"] = "grog"
pirateSpeak["woman"] = "lass"

pirateSpeak["noob"] = "sprog"
pirateSpeak["mingebag"] = "sprog"
pirateSpeak["minge"] = "sprog"

pirateSpeak["friend"] = "matey"

pirateSpeak["idiot"] = "sprog"
pirateSpeak["moron"] = "scurvy dog"
pirateSpeak["bitch"] = "scallywag"
pirateSpeak["asshole"] = "scallywag"
pirateSpeak["ass"] = "scallywag"
pirateSpeak["buffoon"] = "squiffy"
pirateSpeak["lowlife"] = "scum"

pirateSpeak["dammit"] = "blimey"
pirateSpeak["damn it"] = "blimey"
pirateSpeak["damnit"] = "blimey"

pirateSpeak["genocide"] = "dead men tell no tails"

pirateSpeak["quickly"] = "smartly"

pirateSpeak["after"] = "aft"

pirateSpeak["forward"] = "fore"
pirateSpeak["front"] = "fore"

pirateSpeak["left"] = "port"
pirateSpeak["right"] = "starboard"

pirateSpeak["eyes"] = "deadlights"
pirateSpeak["eye"] = "deadlight"

pirateSpeak["captain"] = "Jack o\' Staves"
pirateSpeak["an executioner"] = "a Jack Ketch"
pirateSpeak["executioner"] = "Jack Ketch"

pirateSpeak["young sailor"] = "lad"
pirateSpeak["young boy"] = "lad"

pirateSpeak["young girl"] = "lass"
pirateSpeak["girl"] = "lass"
pirateSpeak["woman"] = "lass"

pirateSpeak["supplier"] = "sutler"
pirateSpeak["merchant"] = "sutler"

pirateSpeak["children"] = "sprogs"

pirateSpeak["cannons"] = "six pounders"

pirateSpeak["lean"] = "careen"
pirateSpeak["cheat"] = "hornswaggle"

pirateSpeak["clean up"] = "titivate"

pirateSpeak["set sail"] = "weigh anchor"
pirateSpeak["pursue"] = "chase"
pirateSpeak["sink"] = "scuttle"
pirateSpeak["gain"] = "overhaul"

pirateSpeak["turn around"] = "heave to"

pirateSpeak["vile"] = "scurvy"
pirateSpeak["mean"] = "scurvy"
pirateSpeak["vulgar"] = "scruvy"

pirateSpeak["there"] = "thar"
pirateSpeak["lol"] = "Yo-Ho-Ho"
pirateSpeak["lolz"] = "Yo-Ho-Ho"

pirateSpeak["piracy"] = "sweet trade"
pirateSpeak["fighting"] = "swashbuckling"

pirateSpeak["chaos"] = "ruckus"

pirateSpeak["drunk"] = "loaded to the Gunwales"

pirateSpeak["punish"] = "keelhaul"

pirateSpeak["hell"] = "Davy Jones\' Locker"
pirateSpeak["graveyard"] = "Davy Jones\' Locker"
pirateSpeak["heaven"] = "Fiddlers Green"

--pirateSpeak["pirate"] = "Corsair"

pirateSpeak["never"] = "no nay ne\'er"
pirateSpeak["have"] = "\'ave"

--[[
Extra rules to take note of:

-Pirates speak in present tense only. They do not use 'are' or 'am' or 'were', but they use 'be'.
-Pirates always drop the 'g' at the end of a verb with ING. For example, rowin' sailin' fightin' buildin'
-Pirates often (not always) drop the 'v' in the middle of some words, but not at start or end. For example, ne'er victory 
-OF is actually o'

Now, for the function call :D
]]--

function chatConvertPirate(ply, saywhat)
	local pirateSay = saywhat
	if string.sub(pirateSay,1,1)!="/" then
		return pirateSay
	end
	pirateSay=string.sub(pirateSay,2)
	--Dictionary replacement
	for k,v in pairs(pirateSpeak) do
--	Msg("K: "..k.."\n")
		for i=0, 3 do
			if string.find(string.lower(pirateSay), k) then
--				Msg("FOUND\n")
				local pos = string.find(string.lower(pirateSay), k)
				local startingSpaceChar = string.sub(pirateSay,pos-1,pos-1)
				if !string.find(startingSpaceChar, "%a") then
					local endingSpace = string.find(pirateSay, " ", pos+1)
					local s = pirateSay
					--if endingSpace!=nil then
					s = string.sub(pirateSay,pos,pos+string.len(k)-1)--local s = string.sub(pirateSay, pos, endingSpace-1)
					--else
					--	local s = string.sub(pirateSay, pos)
					--end
					local other = string.find(s, "%p",pos+1)
					--if other!=nil then
						s = string.sub(s,1,other)
					--end

					--More vars
					local firstLower = (string.lower(string.Left(s,1))==string.Left(s,1))
					local allUpper = (string.upper(s)==s)
					
					local text=v
					if allUpper then
						text=string.upper(text)
					elseif !firstLower then
						text=string.upper(string.sub(text,1,1))..string.sub(text,2)
					end
					
					local tempText=string.Replace(string.lower(pirateSay), k, text)
					if endingSpace!=nil||other!=nil then
						pirateSay=string.sub(pirateSay,0,pos-1)..string.sub(tempText,pos,pos+string.len(text)-1)..string.sub(pirateSay,pos+string.len(k))
					else
						pirateSay=string.sub(pirateSay,0,pos-1)..string.sub(tempText,pos,pos+string.len(text)-1)
					end
--					Msg("txt: "..text.."\n")
				end
			end
		end
	end
	--G replace in ing words
--[[	while string.find(string.lower(pirateSay), "ing") do
		local pos = string.find(string.lower(pirateSay), "ing")
--		local s = string.sub(pirateSay,pos,pos+3)
		local allUpper = (string.upper(s)==s)
--		local punc = string.sub(pirateSay,pos,pos)--local punc = string.sub(pirateSay,pos+4,pos+4)
		
		local text="in'"--..punc
		if allUpper then
			text="IN'"--..punc
		end
		pirateSay=string.sub(pirateSay,0,pos)..string.sub(string.Replace(string.lower(pirateSay),"ing", text),pos,pos+3)..string.sub(pirateSay,pos+3)
	end]]--
	
	return pirateSay
end
--hook.Add( "PlayerSay", "pirateSpeak", chatConvertPirate )
