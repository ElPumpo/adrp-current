Config               = {}

Config.DrawDistance  = 25
Config.Size          = { x = 1.0, y = 1.0, z = 1.0 }
Config.Color         = { r = 0, g = 128, b = 255 }
Config.Type          = 29

Config.Locale        = 'en'

Config.LicenseEnable = true -- only turn this on if you are using esx_license
Config.LicensePrice  = 30000

Config.Zones = {

	GunShop = {
		Legal = true,

		Items1 = {
			{name = 'WEAPON_PETROLCAN', price = 500, label = 'Gas Can'},
			{name = 'WEAPON_WRENCH', price = 500, label = 'Wrench'},
			{name = 'WEAPON_GOLFCLUB', price = 500, label = 'Golf Club'},
			{name = 'WEAPON_FIREEXTINGUISHER', price = 500, label = 'Fire Extinguiser'},
			{name = 'WEAPON_BAT', price = 500, label = 'Baseball Bat'},
			{name = 'GADGET_PARACHUTE', price = 500, label = 'Parachute'},
			{name = 'WEAPON_BALL', price = 500, label = 'Baseball'},
			{name = 'WEAPON_MARKSMANPISTOL', price = 15000, label = 'Marksman Pistol'},
			{name = 'WEAPON_DAGGER', price = 500, label = 'Dagger'},
			{name = 'WEAPON_HAMMER', price = 500, label = 'Hammer'},
			{name = 'WEAPON_CROWBAR', price = 500, label = 'Crow Bar'},
			{name = 'WEAPON_SNSPISTOL', price = 1500, label = 'SNS Pistol'},
			{name = 'WEAPON_PISTOL', price = 1000, label = 'Pistol'},
			{name = 'WEAPON_PISTOL50', price = 6000, label = 'Pistol 50'},
			{name = 'WEAPON_HEAVYPISTOL', price = 5000, label = 'Pistol Heavy'},
			{name = 'WEAPON_VINTAGEPISTOL', price = 8000, label = 'Pistol Vintage'},
			{name = 'WEAPON_FLARE', price = 1000, label = 'Flare'},
			{name = 'WEAPON_FLAREGUN', price = 1500, label = 'Flare Gun'}
		},

		Items2 = {
			{name = 'WEAPON_DBSHOTGUN', price = 30000, label = ' Double Shotguns'},
			{name = 'WEAPON_HEAVYSHOTGUN', price = 50000, label = ' Heavy Shotguns'}
		},

		Items3 = {
			{name = 'WEAPON_MARKSMANRIFLE', price = 75000, label = 'Rifle Marksmen'},
			{name = 'WEAPON_SPECIALCARBINE', price = 80000, label = 'Rifle Special Carbine'},
			{name = 'WEAPON_FIREWORK', price = 500000, label = 'Fireworks Launcher'}
		},

		Locations = {
			vector3(-662.1, -935.3, 21.8),
			vector3(810.2, -2157.3, 29.6),
			vector3(1693.4, 3759.5, 34.7),
			vector3(-330.2, 6083.8, 31.4),
			vector3(252.3, -50.0, 69.9),
			vector3(22.0, -1107.2, 29.8),
			vector3(2567.6, 294.3, 108.7),
			vector3(-1117.5, 2698.6, 18.5),
			vector3(-3171.5, 1087.6, 21.84),
			vector3(-1306.15, -393.76, 36.7),
			vector3(842.4, -1033.4, 28.1)
		}
	},

	BlackWeashop = {
		Legal = false,

		Items = {
			{name = 'WEAPON_PETROLCAN', price = 500, label = 'Gas Can'}
		},

		Locations = {
			vector3(885.2, -3201.0, -98.2)
		}
	}

}

Config.Attachments = {
	{weapon = 'WEAPON_SMG', components = {0, 15000, 20000, 10000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_PISTOL', components = {0, 10000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_COMBATPISTOL', components = {0, 15000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_APPISTOL', components = {0, 45000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_PISTOL50', components = {0, 15000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_SNSPISTOL', components = {0, 2000, 10000}},
	{weapon = 'WEAPON_HEAVYPISTOL', components = {0, 10000, 10000, 50000, 125000}},
	{weapon = 'WEAPON_VINTAGEPISTOL', components = {0, 15000, 50000}},
	{weapon = 'WEAPON_MICROPISTOL', components = {0, 20000, 10000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_ASSAULTSMG', components = {0, 20000, 10000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_MINISMG', components = {0, 20000}},
	{weapon = 'WEAPON_MACHINEPISTOL', components = {0, 25000, 40000, 50000}},
	{weapon = 'WEAPON_COMBATPDW', components = {0, 15000, 20000, 10000, 20000, 10000}},
	{weapon = 'WEAPON_PUMPSHOTGUN', components = {10000, 50000, 100000}},
	{weapon = 'WEAPON_SAWOFFSHOTGUN', components = {10000, 50000}},
	{weapon = 'WEAPON_ASSAULTSHOTGUN', components = {0, 100000, 10000, 50000, 20000}},
	{weapon = 'WEAPON_BULLPUPSHOTGUN', components = {10000, 50000, 20000}},
	{weapon = 'WEAPON_HEAVYSHOTGUN', components = {0, 30000, 50000, 10000, 50000, 20000}},
	{weapon = 'WEAPON_ASSAULTRIFLE', components = {0, 35000, 45000, 10000, 10000, 50000, 20000, 100000}},
	{weapon = 'WEAPON_CARBINERIFLE', components = {0, 25000, 35000, 10000, 1000, 50000, 45000, 100000}},
	{weapon = 'WEAPON_ADVANCEDRIFLE', components = {0, 25000, 10000, 10000, 50000, 100000}},
	{weapon = 'WEAPON_SPECIALCARBINE', components = {0, 25000, 50000, 10000, 10000, 50000, 20000, 100000}},
	{weapon = 'WEAPON_BULLPUPRIFLE', components = {0, 25000, 10000, 10000, 50000, 20000, 100000}},
	{weapon = 'WEAPON_COMPACTRIFLE', components = {0, 20000, 50000}},
	{weapon = 'WEAPON_BULLPUPRIFLE', components = {0, 50000, 20000, 100000}},
	{weapon = 'WEAPON_COMBATMG', components = {0, 75000, 25000, 20000, 100000}},
	{weapon = 'WEAPON_GUSENBERG', components = {0, 1000}},
	{weapon = 'WEAPON_SNIPERRIFLE', components = {25000, 35000, 50000, 100000}},
	{weapon = 'WEAPON_HEAVYSNIPER', components = {25000, 35000}},
	{weapon = 'WEAPON_MARKSMANRIFLE', components = {0, 53000, 10000, 20000, 50000, 20000, 100000}},
	{weapon = 'WEAPON_BULLPUPRIFLE', components = {0, 25000, 10000, 10000, 50000, 20000, 100000}},
	{weapon = 'WEAPON_PISTOL_MK2', components = {0, 20000, 10000, 15000, 50000, 20000, nil, nil, nil, nil, 15000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 100000}},
	{weapon = 'WEAPON_SMG_MK2', components = {0, 30000, 10000, 50000, 20000, 20000, 20000, 15000, nil, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 10000, 20000}},
	{weapon = 'WEAPON_COMBATMG_MK2', components = {0, 85000, 10000, nil, 20000, 20000, 25000, 25000, nil, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 20000, 30000}},
	{weapon = 'WEAPON_ASSAULTRIFLE_MK2', components = {0, 35000, 10000, nil, 50000, 20000, 20000, 15000, 25000, nil, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 10000, 25000}},
	{weapon = 'WEAPON_CARBINERIFLE_MK2', components = {0, 35000, 10000, nil, 50000, 20000, 20000, 15000, 25000, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 20000, 30000}},
	{weapon = 'WEAPON_HEAVYSNIPER_MK2', components = {0, 75000, 10000, nil, 50000, 20000, 20000, nil, 20000, nil, nil, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 46000, 100000, 10000, 25000}},
	{weapon = 'WEAPON_SPECIALCARBINE_MK2', components = {0, 55000, 10000, nil, 50000, 20000, 20000, 15000, 20000, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 20000, 30000}},
	{weapon = 'WEAPON_SNSPISTOL_MK2', components = {0, 20000, 10000, 30000, 50000, 20000, nil, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 75000, 100000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000}},
	{weapon = 'WEAPON_REVOLVER_MK2', components = {10000, nil, nil, 20000, nil, nil, nil, nil, nil, nil, 20000, 10000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000}},
	{weapon = 'WEAPON_BULLPUPRIFLE_MK2', components = {0, 35000, 10000, nil, 50000, 20000, 20000, 15000, 25000, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 20000, 30000}},
	{weapon = 'WEAPON_PUMPSHOTGUN_MK2', components = {nil, nil, nil, nil, nil, 10000, 50000, 20000, 20000, 15000, 25000, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 20000}},
	{weapon = 'WEAPON_MARKSMANRIFLE_MK2', components = {0, 40000, 10000, 50000, 20000, 20000, 25000, nil, nil, nil, nil, nil, nil, nil, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 50000, 75000, 100000, 35000, 26000, 45000, 50000, 45000, 50000, 50000, 20000, 30000}},
}
