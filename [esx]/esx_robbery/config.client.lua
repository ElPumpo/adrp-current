Config = {}

--[[ Layout
	["Name Of Store"] = {
		name="Name Of Store",
		blip=500,  -- THE BLIP TO USE
		blipColor=6,  -- THE COLOR OF BLIP
		blipSize=0.6, -- THE SIZE OF BLIP
		x=-706.03717041016, y=-915.42755126953, z=19.215593338013, -- THE POSITION OF THE PLACE
		beingRobbed=false, -- IF IT'S BEING ROBBED
		timeToRob = 90, --HOW LONG IT TAKES TO ROB
		isSafe=false, --IF ITS A SAFE OR A REGISTER/BOOTH
		copsNeeded = 2 -- HOW MANY COPS ARE REQUIRED TO ROB THIS ONE
	},
]]

Config.RobbableSpots = {
	--24/7s
	["Little Seoul 24/7 Register #1"]={
		name="Little Seoul 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=-705.5, y=-915.4, z=19.2,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Little Seoul 24/7 Register #2"]={
		name="Little Seoul 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=-705.5, y=-913.4, z=19.2,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Little Seoul 24/7 Safe"]={
		name="Little Seoul 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-709.66131591797, y=-904.18121337891, z=19.215612411499,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Innocence Blvd 24/7 Register #1"]={
		name="Innocence Blvd 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=24.487377166748, y=-1347.4102783203, z=29.497039794922,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Innocence Blvd 24/7 Register #2"]={
		name="Innocence Blvd 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=24.396217346191, y=-1344.9005126953, z=29.497039794922,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Innocence Blvd 24/7 Safe"]={
		name="Innocence Blvd 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=28.2, y=-1339.1, z=29.4,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Mirror Park 24/7 Register #1"]={
		name="Mirror Park 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1165.6, y=-324.4, z=69.2,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Mirror Park 24/7 Register #2"]= {
		name = "Mirror Park 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1165.0, y=-322.6, z=69.2,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Mirror Park 24/7 Safe"]= {
		name = "Mirror Park 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=1159.55859375, y=-314.06265258789, z=69.205062866211,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Downtown Vinewood 24/7 Register #1"]= {
		name = "Downtown Vinewood 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=372.0, y=326.3, z=103.5,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Downtown Vinewood 24/7 Register #2"]= {
		name = "Downtown Vinewood 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=372.6, y=328.7, z=103.5,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Downtown Vinewood 24/7 Safe"]= {
		name = "Downtown Vinewood 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=378.17330932617, y=333.39218139648, z=103.56636810303,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Rockford Dr 24/7 Register #1"]= {
		name = "Rockford Dr 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x = -1818.3, y = 793.4, z = 138.1,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Rockford Dr 24/7 Register #2"]= {
		name = "Rockford Dr 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=-1819.8, y=795.0, z=138.0,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Rockford Dr 24/7 Safe"]= {
		name = "Rockford Dr 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-1829.2971191406, y=798.80505371094, z=138.19258117676,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Route 68 24/7 Register #1"]= {
		name = "Route 68 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=549.7, y=2669.0, z=42.1,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Route 68 24/7 Register #2"]= {
		name = "Route 68 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=549.5, y=2671.4, z=42.1,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Route 68 24/7 Safe"]= {
		name = "Route 68 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=546.40972900391, y=2662.7551269531, z=42.156536102295,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["South Senora Fwy 24/7 Register #1"]= {
		name = "South Senora Fwy 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=2677.9, y=3279.2, z=55.2,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["South Senora Fwy 24/7 Register #2"]= {
		name = "South Senora Fwy 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=2675.8, y=3280.3, z=55.2,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["South Senora Fwy 24/7 Safe"]= {
		name = "South Senora Fwy 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=2672.9831542969, y=3286.49609375, z=55.241149902344,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["North Senora Fwy 24/7 Register #1"]= {
		name = "North Senora Fwy 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1727.3, y=6415.2, z=35.0,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["North Senora Fwy 24/7 Register #2"]= {
		name = "North Senora Fwy 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1728.6, y=6417.4, z=35.0,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["North Senora Fwy 24/7 Safe"]= {
		name = "North Senora Fwy 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=1735.1063232422, y=6420.5053710938, z=35.0,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Great Ocean Hwy 24/7 Register #1"]= {
		name = "Great Ocean Hwy 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x = -3244.6, y = 999.9, z = 12.8,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Great Ocean Hwy 24/7 Register #2"]= {
		name = "Great Ocean Hwy 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x = -3242.3, y = 999.6, z = 12.8,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Great Ocean Hwy 24/7 Safe"]= {
		name = "Great Ocean Hwy 24/7 Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-3249.799, y=1004.263, z=12.830,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	["Algonquin 24/7 Register"]= {
		name = "Algonquin 24/7 Register",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=1392.8, y=3606.8, z=34.9,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["GrapeSeed 24/7 Register #1"]= {
		name = "GrapeSeed 24/7 Register #1",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x = 1696.1, y = 4923.0, z = 42.0,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["GrapeSeed 24/7 Register #2"]= {
		name = "GrapeSeed 24/7 Register #2",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x = 1697.9, y = 4921.8, z = 42.0,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["GrapeSeed 24/7 Vault"]= {
		name = "GrapeSeed 24/7 Vault",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1707.7, y=4920.2, z=42.0,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 4
	},

	--LIQUIOR STORES
	["Route 68 Liquor Store Register"]= {
		name = "Route 68 Liquor Store Register",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1165.9, y=2710.9, z=38.1,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Route 68 Liquor Store Safe"]= {
		name = "Route 68 Liquor Store Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=1169.2316894531, y=2717.8447265625, z=37.157691955566,
		beingRobbed=false,
		timeToRob =360,
		isSafe=true,
		copsNeeded = 4
	},

	["El Rancho Blvd Liquor Store Register"]= {
		name = "El Rancho Blvd Liquor Store Register",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=1134.0, y=-982.5, z=46.4,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["El Rancho Blvd Liquor Store Safe"]= {
		name = "El Rancho Blvd Liquor Store Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=1126.8385009766, y=-980.08166503906, z=45.415802001953,
		beingRobbed=false,
		timeToRob =360,
		isSafe=true,
		copsNeeded = 4
	},

	["Prosperity Liquor Store Register"]= {
		name = "Prosperity Liquor Store Register",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=-1486.0, y=-377.9, z=40.1,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Prosperity Liquor Store Safe"]= {
		name = "Prosperity Liquor Store Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-1479.0145263672, y=-375.44979858398, z=39.1633644104,
		beingRobbed=false,
		timeToRob =360,
		isSafe=true,
		copsNeeded = 4
	},

	["Great Ocean Hwy Liquor Store Register"]= {
		name = "Great Ocean Hwy Liquor Store Register",
		blip=500,
		blipColor=6,
		blipSize=0.6,
		x=-2966.1, y=390.9, z=15.0,
		beingRobbed=false,
		timeToRob = 90,
		isSafe=false,
		copsNeeded = 4
	},

	["Great Ocean Hwy Liquor Store Safe"]= {
		name = "Great Ocean Hwy Liquor Store Safe",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-2959.6789550781, y=387.15994262695, z=14.043292999268,
		beingRobbed=false,
		timeToRob =360,
		isSafe=true,
		copsNeeded = 4
	},

	-- BANK BOOTHS
	["Pacific Standard Bank Booth #1"]= {
		name = "Pacific Standard Bank Booth #1",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=242.81385803223, y=226.59515380859, z=106.28727722168,
		beingRobbed=false,
		timeToRob = 120,
		isSafe=false,
		copsNeeded = 4
	},

	["Pacific Standard Bank Booth #2"]= {
		name = "Pacific Standard Bank Booth #2",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=247.9873046875, y=224.75602722168, z=106.28736877441,
		beingRobbed=false,
		timeToRob = 120,
		isSafe=false,
		copsNeeded = 4
	},

["Pacific Standard Bank Booth #3"]= {
	name = "Pacific Standard Bank Booth #3",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=252.95489501953, y=222.85342407227, z=106.28684234619,
		beingRobbed=false,
		timeToRob = 120,
		isSafe=false,
		copsNeeded = 4
	},

		--BANKS

	["Route 68 Fleeca Bank Vault"]={
		name="Route 68 Fleeca Bank Vault",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=1175.8201904297, y=2711.6484375, z=38.088001251221,
		beingRobbed=false,
		timeToRob = 300,
		isSafe=true,
		copsNeeded = 6
	},

	["Pacific Standard Bank Vault"]={
		name="Pacific Standard Bank Vault",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=254.30894470215, y=225.26997375488, z=101.8756942749,
		beingRobbed=false,
		timeToRob = 360,
		isSafe=true,
		copsNeeded = 6
	},

	["Legion Fleeca Bank Vault"]={
		name="Legion Fleeca Bank Vault",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=147.43576049805, y=-1044.9503173828, z=29.368032455444,
		beingRobbed=false,
		timeToRob = 300,
		isSafe=true,
		copsNeeded = 6
	},

	["Great Ocean Hwy Fleeca Bank Vault"]={
		name="Great Ocean Hwy Fleeca Bank Vault",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-2957.548, y=481.472, z=15.697,
		beingRobbed=false,
		timeToRob = 300,
		isSafe=true,
		copsNeeded = 6
	},

	["Fleeca Bank on Blvd Del Perro, Rockford Hills"]={
		name="Fleeca Bank on Blvd Del Perro, Rockford Hills",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-1211.2392578125, y=-335.38189697266, z=37.78101348877,
		beingRobbed=false,
		timeToRob = 300,
		isSafe=true,
		copsNeeded = 6
	},

	["Hawick Ave Fleeca Bank Vault in Alta at Meteor St"]={
		name="Hawick Ave Fleeca Bank Vault in Alta at Meteor St",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=311.76455688477, y=-283.31527709961, z=54.16475677490,
		beingRobbed=false,
		timeToRob = 300,
		isSafe=true,
		copsNeeded = 6
	},

	["Blaine County Savings Vault"]={
		name="Blaine County Savings Vault",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-106.25449371338, y=6478.3061523438, z=31.626726150513,
		beingRobbed=false,
		timeToRob = 420,
		isSafe=true,
		copsNeeded = 7
	},

	["Fleeca Bank on Hawick Ave in Burton Vault"]={
		name="Fleeca Bank on Hawick Ave in Burton Vault",
		blip=500,
		blipColor=6,
		blipSize=0.8,
		x=-353.359, y=-54.395, z=49.036,
		beingRobbed=false,
		timeToRob = 300,
		isSafe=true,
		copsNeeded = 6
	}

	-- ["Union Depository Vault"]={
	-- 	name="Union Depository Vault",
	-- 	blip=500,
	-- 	blipColor=6,
	-- 	blipSize=0.8,
	-- 	x=0.255, y=-657.935, z=16.130,
	-- 	beingRobbed=false,
	-- 	timeToRob = 830,
	-- 	isSafe=true,
	-- 	copsNeeded = 7
	-- }
}
