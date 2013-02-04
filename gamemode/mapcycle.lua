--[[t
=====================
== Mapcycle script ==
======By UberMensch==
]]--

if UMS_MapCycle then return false end --If someone already has this installed

UMS_MapCycle = {};
UMS_MapCycle.MapCycleFile = "./mapcycle.txt";
UMS_MapCycle.CMap = game.GetMap();
 
function UMS_MapCycle.ReadCycleFile( UMS_MapCycleFile )
 
    if( file.Exists( UMS_MapCycle.MapCycleFile, "GAME" ) ) then
   
        local maps = file.Read( UMS_MapCycle.MapCycleFile );
       
        UMS_MapCycle.Maps = string.Explode( "\n", maps );
 
        local count = #UMS_MapCycle.Maps;
        UMS_MapCycle.Maps[count] = nil;
		pswrepeatmap = false
               
    else
		
		pswrepeatmap = true
        --Error( "Map Cycle File Missing" );
        --return;
       
   end
   
end

function UMS_MapCycle.DoNextMap()
	
	if pswrepeatmap then
		game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" );
	else
		
	    for K, V in pairs( UMS_MapCycle.Maps ) do
	        if( V == game.GetMap() ) then
	            UMS_MapCycle.Key = K + 1;
	        end
	        if( K == #UMS_MapCycle.Maps ) then
	            UMS_MapCycle.Key = 1;
	        end
	    end
	   
	   UMS_MapCycle.NextMap = UMS_MapCycle.Maps[UMS_MapCycle.Key];
	   
	    game.ConsoleCommand( "changelevel " .. UMS_MapCycle.NextMap .. "\n" );
		
	end
 
end

UMS_MapCycle.ReadCycleFile( UMS_MapCycle.MapCycleFile ); 