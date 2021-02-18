Config = {}
Config.DrawDistance = 100.0

Config.EnablePlayerManagement = true
Config.EnableVaultManagement = true
Config.Locale = 'en'

Config.AuthorizedVehicles = {
	{ name = 'benson',  label = 'Fridge Truck' },
	{ name = 'mule',  label = 'Transport Truck' },
	{ name = 'pounder',  label = 'Large Truck' },
	{ name = 'stretch',  label = 'Limo' },
	{ name = 'tourbus',  label = 'Tour Bus' }
}

Config.Blips = {
	{coords = vector3(129.2, -1299.3, 29.5), sprite = 121, color = 27, name = 'Vanilla Unicorn'},
	{coords = vector3(-560.2, 286.8, 82.2), sprite = 93, color = 5, name = 'Tequi-La-La'},
	{coords = vector3(-823.8, -1222.5, 7.4), sprite = 614, color = 7, name = 'Club Galaxy'},
	{coords = vector3(-1389.5, -584.8, 30.2), sprite = 93, color = 5, name = 'Bahama Mamas'}
}

Config.Zones = {

	Cloakrooms = {
		Pos   = { x = 105.111, y = -1303.221, z = 27.788 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 255, g = 187, b = 255 },
		Type  = 27,
	},

	Cloakrooms2 = {
		Pos   = { x = -558.04, y = 277.85, z = 81.18 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 255, g = 187, b = 255 },
		Type  = 27,
	},

	Vaults = {
		Pos   = { x = 93.406, y = -1291.753, z = 28.288 },
		Size  = { x = 1.3, y = 1.3, z = 1.0 },
		Color = { r = 30, g = 144, b = 255 },
		Type  = 23,
	},

	Vaults2 = {
		Pos   = { x = -573.11, y = 293.23, z = 78.18 },
		Size  = { x = 1.3, y = 1.3, z = 1.0 },
		Color = { r = 30, g = 144, b = 255 },
		Type  = 23,
	},

	Fridge = {
		Pos   = { x = 135.478, y = -1288.615, z = 28.289 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 248, g = 248, b = 255 },
		Type  = 23,
	},

	Fridge2 = {
		Pos   = { x = -561.79, y = 289.82, z = 81.18 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 248, g = 248, b = 255 },
		Type  = 23,
	},

	Fridge3 = {
		Pos   = { x = -1580.1, y = -3018.0, z = -80.0 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 248, g = 248, b = 255 },
		Type  = 23,
	},

	Fridge4 = {
		Pos   = { x = -1386.5, y = -607.2, z = 29.4 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 248, g = 248, b = 255 },
		Type  = 23,
	},

	Vehicles = {
		Pos          = { x = 137.177, y = -1278.757, z = 28.371 },
		SpawnPoint   = { x = 138.436, y = -1263.095, z = 28.626 },
		Size         = { x = 1.8, y = 1.8, z = 1.0 },
		Color        = { r = 255, g = 255, b = 0 },
		Type         = 23,
		Heading      = 207.43,
	},

	Vehicles2 = {
		Pos          = { x = -564.65, y = 302.08, z = 82.15 },
		SpawnPoint   = { x = -552.3, y = 303.3, z = 83.2 },
		Size         = { x = 1.8, y = 1.8, z = 1.0 },
		Color        = { r = 255, g = 255, b = 0 },
		Type         = 23,
		Heading      = 265.0,
	},

	VehicleDeleters = {
		Pos   = { x = 133.203, y = -1265.573, z = 28.396 },
		Size  = { x = 3.0, y = 3.0, z = 0.2 },
		Color = { r = 255, g = 255, b = 0 },
		Type  = 1,
	},

	BossActions = {
		Pos   = { x = 94.951, y = -1294.021, z = 28.268 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 0, g = 100, b = 0 },
		Type  = 1,
	},

	BossActions2 = {
		Pos   = { x = -568.63, y = 291.14, z = 78.18 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Color = { r = 0, g = 100, b = 0 },
		Type  = 1,
	},

	Flacons = {
		Pos   = { x = -882.458, y = -1156.955, z = 4.172 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 238, g = 0, b = 0 },
		Type  = 23,
		Items = {
			{ name = 'jager',      label = 'Jägermeister',  price = 3 },
			{ name = 'vodka',      label = 'Vodka',         price = 4 },
			{ name = 'rhum',       label = 'Rum',          price = 2 },
			{ name = 'whisky',     label = 'Whiskey',        price = 7 },
			{ name = 'tequila',    label = 'Tequila',       price = 2 },
			{ name = 'martini',    label = 'Martini', price = 5 }
		},
	},

	NoAlcool = {
		Pos   = { x = 396.716, y = -804.235, z = 28.289 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 238, g = 110, b = 0 },
		Type  = 23,
		Items = {
			{ name = 'soda',        label = 'Soda',         price = 4 },
			{ name = 'jusfruit',    label = 'Juice', price = 3 },
			{ name = 'icetea',      label = 'Ice Tea',    price = 4 },
			{ name = 'energy',      label = 'Energy Drink', price = 7 },
			{ name = 'drpepper',    label = 'Dr. Pepper',   price = 2 },
			{ name = 'limonade',    label = 'Limonade',     price = 1 }
		},
	},

	Apero = {
		Pos   = { x = 62.520, y = -1727.954, z = 28.5749 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 142, g = 125, b = 76 },
		Type  = 23,
		Items = {
			{ name = 'bolcacahuetes',   label = 'Bowl of peanuts',    price = 7 },
			{ name = 'bolnoixcajou',    label = 'Bowl of cashews', price = 10 },
			{ name = 'bolpistache',     label = 'Bowl of pistachios',      price = 15 },
			{ name = 'bolchips',        label = 'Chips',         price = 5 },
			{ name = 'saucisson',       label = 'Bratwurst',            price = 25 },
			{ name = 'grapperaisin',    label = 'Grapes',     price = 15 }
		},
	},

	Ice = {
		Pos   = { x = 967.419, y = -1620.567, z = 29.110 },
		Size  = { x = 1.6, y = 1.6, z = 1.0 },
		Color = { r = 255, g = 255, b = 255 },
		Type  = 23,
		Items = {
			{ name = 'ice',     label = 'Ice',       price = 1 }
		},
	},
}

Config.TeleportZones = {
	EnterBuilding = {
		Pos       = { x = 132.608, y = -1293.978, z = 28.269 },
		Size      = { x = 1.2, y = 1.2, z = 0.1 },
		Color     = { r = 128, g = 128, b = 128 },
		Marker    = 1,
		Blip      = false,
		Name      = "Bar : entrée",
		Type      = "teleport",
		Hint      = "Press ~INPUT_PICKUP~ to enter the bar.",
		Teleport  = { x = 126.742, y = -1278.386, z = 28.569 }
	},

	ExitBuilding = {
		Pos       = { x = 132.517, y = -1290.901, z = 28.269 },
		Size      = { x = 1.2, y = 1.2, z = 0.1 },
		Color     = { r = 128, g = 128, b = 128 },
		Marker    = 1,
		Blip      = false,
		Name      = "Bar : sortie",
		Type      = "teleport",
		Hint      = "Press ~INPUT_PICKUP~ to leave the bar.",
		Teleport  = { x = 131.175, y = -1295.598, z = 28.569 },
	}
}
