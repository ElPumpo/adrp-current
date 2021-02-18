petrolCanPrice = 30

lang = "en"

settings = {}
settings["en"] = {
	openMenu = "Press ~INPUT_CONTEXT~ to access the ~o~Gas Station~s~.",
	electricError = "~r~You have an electric vehicle.",
	buyFuel = "buy fuel",
	liters = "Liters",
	percent = "percent",
	confirm = "Confirm",
	fuelStation = "Gas Station",
	boatFuelStation = "Fuel station | Boat",
	avionFuelStation = "Fuel station | Plane",
	heliFuelStation = "Fuel station | Helicopter",
	getJerryCan = "Press ~INPUT_CONTEXT~ to buy a ~y~Petrol Can~s~ for ~g~$"..petrolCanPrice.."~s~.",
	refeel = "Press ~INPUT_CONTEXT~ to ~y~Refuel the Vehicle~s~.",
	YouHaveBought = "You have bought ",
	fuel = " liters of fuel",
	price = "price"
}

electricityPrice = 1 -- NOT RANOMED !!

randomPrice = false --Random the price of each stations
price = 5 --If random price is on False, set the price here for 1 liter

-- Vehicles which doesn't need fuel

blacklistedModels = {
	'BMX',
	'CRUISER',
	'TRIBIKE2',
	'FIXTER',
	'SCORCHER',
	'TRIBIKE3',
	'TRIBIKE'
}

electric_model = {
	'VOLTIC',
	'SURGE',
	'DILETTANTE',
	'KHAMELION',
	'CADDY',
	'CADDY2',
	'AIRTUG'
}

plane_model = {
	'BESRA',
	'CARGOPLANE',
	'CUBAN800',
	'DODO',
	'DUSTER',
	'HYDRA',
	'JET',
	'LUXOR',
	'LUXOR2',
	'STUNT',
	'MAMMATUS',
	'MILJET',
	'NIMBUS',
	'LAZER',
	'SHAMAL',
	'TITAN',
	'VELUM',
	'VELUM2',
	'VESTRA',
	'EA18',
	'F22',
	'F15',
	'F14',
	'GF14',
	'F16',
	'STRIKEFORCE',
	'EA18',
	'F22',
	'VTOL',
	'CL415',
	'WP3'
}

heli_model = {
	'ANNIHILATOR',
	'BUZZARD',
	'BUZZARD2',
	'CARGOBOB',
	'CARGOBOB2',
	'CARGOBOB3',
	'FROGGER',
	'FROGGER2',
	'MAVERICK',
	'POLMAV',
	'SAVAGE',
	'SKYLIFT',
	'SVOLITO',
	'SVOLITO2',
	'SWIFT',
	'SWIFT2',
	'VALKYRIE',
	'VALKYRIE2',
	'VOLATUS',
	'AS350',
	'ANSLEYHAWK',
	'MH65C',
	'MH6',
	'MH65C2',
	'JAYHAWK',
	'AHX',
	'VIPER2'
}
