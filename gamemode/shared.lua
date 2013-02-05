--PirateShip Wars
--Originally made in Gmod 9 by EmpV
--Fixed for Gmod 13 by VertisticINC

GM.Name		= "PirateShipWars 13"
GM.Author	= "EmpV"
GM.Email	= ""
GM.Website	= ""

--Team setup
TEAM_RED	= 1
TEAM_BLUE	= 2
TEAM_JOINING	= 3
TEAM_SPECTATE	= 4

team.SetUp(TEAM_RED, "Red Pirates", Color(240,40,40,255) )
team.SetUp(TEAM_BLUE, "Blue Pirates", Color(40,40,240,255) ) --RGBA
team.SetUp(TEAM_JOINING, "Joining", Color(75,75,75,100) )
team.SetUp(TEAM_SPECTATE, "Spectating", Color(50,50,50,255) )

resource.AddFile("resource/akbar.ttf")