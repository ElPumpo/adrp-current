Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.EnablePlayerManagement     = true -- If set to true, you need esx_addonaccount, esx_billing and esx_society
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = true
Config.ResellPercentage           = 50
Config.Locale                     = 'en'

Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.AvailableTrucks = {
	{model = 'packer', price = 450000},
	{model = 'hauler', price = 120000},
	{model = 'hauler2', price = 1500000},
	{model = 'phantom', price = 2000000},
	{model = 'phantom3', price = 2200000},
}

Config.Zones = {
	Clocking = {
		Pos  = { x = -1181.579, y = -1712.626, z = 3.420},
		Size = { x = 1.5, y = 1.5, z = 1.0 },
		Type = 1
	},

	TruckShop = {
		Pos = vector3(149.2, -3210.6, 5.9),
		Size = vector3(1.0, 1.0, 1.0),
		Type = 20
	},

	TruckShopInside = {
		Pos = vector3(139.6, -3201.2, 5.9),
		Size = vector3(1.0, 1.0, 1.0),
		Type = -1,
		Heading = 266.4
	},

	ShopEntering = {
		Pos   = { x = -1174.500, y = -1700.187, z = 3.41 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = 1
	},

	ShopInside = {
		Pos     = { x = -1169.447, y = -1715.775, z = 4.74 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 304.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -28.637, y = -1085.691, z = 25.565 },
		Size    = { x = 1.5, y = 1.5, z = 1.0 },
		Heading = 90.0,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -1171.036, y = -1699.025, z = 3.420 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	},

	--[[
		ResellVehicle = {
			Pos   = { x = -1135.488, y = -1694.973, z = 3.264 },
			Size  = { x = 3.0, y = 3.0, z = 1.0 },
			Type  = 1
		}
	]]
}
