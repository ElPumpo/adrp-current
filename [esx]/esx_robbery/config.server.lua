Config = {}

--[[ Layout
	["Name"] = {
		name="Name",
		currentMoney=500, -- starting money
		maxMoney=5000, -- maximum money the store can hold
		moneyRengerationRate=100, -- how much money is gained Per Minute
		takesMoneyToBankOnMax=true, -- If the place transfers money to bank every 30 minutes
		isBank=false, -- is the place a bank
		bankToDeliverTo="Legion Fleeca Bank Vault" -- what bank to deliver to if the takesMoenyToBank is true
	},
]]

Config.RobbableSpots = {
	["Little Seoul 24/7 Register #1"] = {
		name = "Little Seoul 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Little Seoul 24/7 Register #2"] = {
		name = "Little Seoul 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Little Seoul 24/7 Safe"] = {
		name = "Little Seoul 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Algonquin 24/7 Register"] = {
		name = "Algonquin 24/7 Register",
		currentMoney=100,
		maxMoney=10000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Route 68 Fleeca Bank Vault",
	},

	["Mirror Park 24/7 Register #1"] = {
		name = "Mirror Park 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="East Hawick Fleeca Bank Vault",
	},

	["Mirror Park 24/7 Register #2"] = {
		name = "Mirror Park 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="East Hawick Fleeca Bank Vault",
	},

	["Mirror Park 24/7 Safe"] = {
		name = "Mirror Park 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="East Hawick Fleeca Bank Vault",
	},

	["Downtown Vinewood 24/7 Register #1"] = {
		name = "Downtown Vinewood 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Pacific Standard Bank Vault",
	},

	["Downtown Vinewood 24/7 Register #2"] = {
		name = "Downtown Vinewood 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Pacific Standard Bank Vault",
	},

	["Downtown Vinewood 24/7 Safe"] = {
		name = "Downtown Vinewood 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Pacific Standard Bank Vault",
	},

	["Great Ocean Hwy 24/7 Safe"] = {
		name = "Great Ocean Hwy 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Pacific Standard Bank Vault",
	},

	["Rockford Dr 24/7 Register #1"] = {
		name = "Rockford Dr 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Rockford Dr 24/7 Register #2"] = {
		name = "Rockford Dr 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Rockford Dr 24/7 Safe"] = {
		name = "Rockford Dr 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["GrapeSeed 24/7 Register #1"] = {
		name = "GrapeSeed 24/7 Register #1",--start here dummy for grapeseed
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["GrapeSeed 24/7 Register #2"] = {
		name = "GrapeSeed 24/7 Register #2",--start here dummy for grapeseed
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["GrapeSeed 24/7 Vault"] = {
		name = "GrapeSeed 24/7 Vault",--start here dummy for grapeseed
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["South Senora Fwy 24/7 Register #1"] = {
		name = "South Senora Fwy 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Route 68 Fleeca Bank Vault",
	},

	["South Senora Fwy 24/7 Register #2"] = {
		name = "South Senora Fwy 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Route 68 Fleeca Bank Vault",
	},

	["South Senora Fwy 24/7 Safe"] = {
		name = "South Senora Fwy 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Route 68 Fleeca Bank Vault",
	},

	["North Senora Fwy 24/7 Register #1"] = {
		name = "North Senora Fwy 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Blaine County Savings Vault",
	},

	["North Senora Fwy 24/7 Register #2"] = {
		name = "North Senora Fwy 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Blaine County Savings Vault",
	},

	["North Senora Fwy 24/7 Safe"] = {
		name = "North Senora Fwy 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Blaine County Savings Vault",
	},

	["Route 68 24/7 Register #1"] = {
		name = "Route 68 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Route 68 24/7 Register #2"] = {
		name = "Route 68 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Route 68 24/7 Safe"] = {
		name = "Route 68 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Innocence Blvd 24/7 Register #1"] = {
		name = "Innocence Blvd 24/7 Register #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Innocence Blvd 24/7 Register #2"] = {
		name = "Innocence Blvd 24/7 Register #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Innocence Blvd 24/7 Safe"] = {
		name = "Innocence Blvd 24/7 Safe",
		currentMoney=100,
		maxMoney=25000,
		moneyRengerationRate=350, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	--- Liquor STORES
	["Prosperity Liquor Store Register"] = {
		name = "Prosperity Liquor Store Register",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=200, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="West Hawick Fleeca Bank Vault",
	},

	["Prosperity Liquor Store Safe"] = {
		name = "Prosperity Liquor Store Safe",
		currentMoney=100,
		maxMoney=30000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="West Hawick Fleeca Bank Vault",
	},

	["El Rancho Blvd Liquor Store Register"] = {
		name = "El Rancho Blvd Liquor Store Register",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=200, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Fleeca Bank on Blvd Del Perro, Rockford Hills"] = {
		name = "Fleeca Bank on Blvd Del Perro, Rockford Hills",
		currentMoney=100,
		maxMoney=20000,
		moneyRengerationRate=200, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=true,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["El Rancho Blvd Liquor Store Safe"] = {
		name = "El Rancho Blvd Liquor Store Safe",
		currentMoney=100,
		maxMoney=30000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Legion Fleeca Bank Vault",
	},

	["Great Ocean Hwy Liquor Store Register"] = {
		name = "Great Ocean Hwy Liquor Store Register",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=200, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Great Ocean Hwy Liquor Store Safe"] = {
		name = "Great Ocean Hwy Liquor Store Safe",
		currentMoney=100,
		maxMoney=30000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Great Ocean Hwy Fleeca Bank Vault",
	},

	["Route 68 Liquor Store Register"] = {
		name = "Route 68 Liquor Store Register",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=200, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Route 68 Fleeca Bank Vault",
	},

	["Route 68 Liquor Store Safe"] = {
		name = "Route 68 Liquor Store Safe",
		currentMoney=100,
		maxMoney=30000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=true,
		isBank=false,
		bankToDeliverTo="Route 68 Fleeca Bank Vault",
	},

	-- bank booths
	["Pacific Standard Bank Booth #1"] = {
		name = "Pacific Standard Bank Booth #1",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Pacific Standard Bank Booth #2"] = {
		name = "Pacific Standard Bank Booth #2",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Pacific Standard Bank Booth #3"] = {
		name = "Pacific Standard Bank Booth #3",
		currentMoney=100,
		maxMoney=5000,
		moneyRengerationRate=100, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	-- BANKS
	["East Hawick Fleeca Bank Vault"] = {
		name = "East Hawick Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["East Hawick Fleeca Bank Vault"] = {
		name = "East Hawick Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Route 68 Fleeca Bank Vault"] = {
		name = "Route 68 Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Hawick Fleeca Bank Vault"] = {
		name = "Hawick Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["West Hawick Fleeca Bank Vault"] = {
		name = "West Hawick Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Legion Fleeca Bank Vault"] = {
		name = "Legion Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Great Ocean Hwy Fleeca Bank Vault"] = {
		name = "Great Ocean Hwy Fleeca Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Fleeca Bank on Hawick Ave in Burton Vault"] = {
		name = "Fleeca Bank on Hawick Ave in Burton Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=500, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Pacific Standard Bank Vault"] = {
		name = "Pacific Standard Bank Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=1000, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo = "None"
	},

	["Blaine County Savings Vault"] = {
		name = "Blaine County Savings Vault",
		currentMoney=100,
		maxMoney=200000,
		moneyRengerationRate=1000, -- Per Minute
		takesMoneyToBankOnMax=false,
		isBank=true,
		bankToDeliverTo="None"
	}

	-- ["Union Depository Vault Cage #1"] = {
	-- 	name = "Union Depository Vault Cage #1",
	-- 	currentMoney=100,
	-- 	maxMoney=1800000,
	-- 	moneyRengerationRate=2000, -- Per Minute
	-- 	takesMoneyToBankOnMax=false,
	-- 	isBank=true,
	-- 	bankToDeliverTo="None"
	-- }
}