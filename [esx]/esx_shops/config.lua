Config = {}

Config.DrawDistance = 100
Config.Size         = {x = 1.0, y = 1.0, z = 1.0}
Config.Color        = {r = 0, g = 128, b = 255}
Config.Type         = 20
Config.Locale = 'en'

Config.Zones = {
	TwentyFourSeven = {
		Items = {},
		Pos = {
			{x = 373.875,   y = 325.896,  z = 102.566, robbable = true},
			{x = 2557.458,  y = 382.282,  z = 107.622},
			{x = -3038.939, y = 585.954,  z = 6.908},
			{x = -3241.927, y = 1001.462, z = 11.830, robbable = true},
			{x = 547.431,   y = 2671.710, z = 41.156, robbable = true},
			{x = 1961.464,  y = 3740.672, z = 31.343},
			{x = 2678.916,  y = 3280.671, z = 54.241, robbable = true},
			{x = 1729.216,  y = 6414.131, z = 34.037, robbable = true}
		}
	},

	RobsLiquor = {
		Items = {},
		Pos = {
			{x = 1135.808,  y = -982.281,  z = 45.415, robbable = true},
			{x = -1222.915, y = -906.983,  z = 11.326},
			{x = 1110.915, y = 211.383,  z = -49.326},
			{x = -2345.915, y = 3233.383,  z = 34.326},
			{x = -1487.553, y = -379.107,  z = 39.163, robbable = true},
			{x = -2968.243, y = 390.910,   z = 14.043, robbable = true},
			{x = 1166.024,  y = 2708.930,  z = 37.157, robbable = true},
			{x = 1392.562,  y = 3604.684,  z = 33.980, robbable = true}
		}
	},

	LTDgasoline = {
		Items = {},
		Pos = {
			{x = -48.519,   y = -1757.514, z = 28.421},
			{x = 1163.373,  y = -323.801,  z = 68.205, robbable = true},
			{x = -707.501,  y = -914.260,  z = 18.215, robbable = true},
			{x = -1820.523, y = 792.518,   z = 137.118, robbable = true},
			{x = 1698.388,  y = 4924.404,  z = 41.063, robbable = true}
		}
	},

	Prison = {
		Items = {},
		Pos = {
			{x = 1746.184, y = 2580.788, z = 44.569},
		}
	},
}

Config.BlackZones = {

	BlackMarket = {
		Items = {},
		GangItems = {
			{label = "pocketknife", price = 10000},
			{label = "zipties", price = 5000},
		},
		Pos = {
			{x = 602.797,   y = -435.87, z = 24.8451},
			{x = -2019.997,   y = 538.47, z = 110.8451},
			{x = 28.997,   y = 3665.47, z = 40.8451},
			{x = 1433.997,   y = 6355.47, z = 23.8451},
			{x = 485.997,   y = 4766.47, z = -58.9451},
		}
	}
}
