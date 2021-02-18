Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }

Config.ReviveReward               = 700  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'en'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 5 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 15 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = true

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoints = {
	{ coords = vector3(1841.3, 3668.8, 32.6), heading = 50.0 },
	{ coords = vector3(-247.4, 6331.4, 31.4), heading = 50.0 },
	{ coords = vector3(341.7, -1396.6, 31.5), heading = 50.0 }
}

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(307.7, -1433.4, 28.9),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			vector3(270.5, -1363.0, 23.5)
		},

		Pharmacies = {
			vector3(230.1, -1366.1, 38.5)
		},

		Vehicles = {
			{
				Spawner = vector3(307.7, -1433.4, 30.0),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(297.2, -1429.5, 29.8), heading = 227.6, radius = 4.0 },
					{ coords = vector3(294.0, -1433.1, 29.8), heading = 227.6, radius = 4.0 },
					{ coords = vector3(309.4, -1442.5, 29.8), heading = 227.6, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(317.5, -1449.5, 46.5),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(313.5, -1465.1, 46.5), heading = 142.7, radius = 10.0 },
					{ coords = vector3(299.5, -1453.2, 46.5), heading = 142.7, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(294.7, -1448.1, 29.0),
				To = { coords = vector3(272.8, -1358.8, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(275.3, -1361, 23.5),
				To = { coords = vector3(295.8, -1446.5, 28.9), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = { coords = vector3(333.1, -1434.9, 45.5), heading = 138.6 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = { coords = vector3(249.1, -1369.6, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = { coords = vector3(238.6, -1368.4, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(237.4, -1373.8, 26.0),
				To = { coords = vector3(251.9, -1363.3, 38.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(256.5, -1357.7, 36.0),
				To = { coords = vector3(235.4, -1372.8, 26.3), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		}
	},

	Pillbox = {

		Blip = {
			coords = vector3(292.3, -583.6, 43.2),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			vector3(325.0, -580.5, 42.3)
		},

		Pharmacies = {
			vector3(310.4, -599.1, 42.3)
		},

		Vehicles = {
			{
				Spawner = vector3(299.7, -579.5, 43.3),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(286.0, -595.7, 43.1), heading = 338.6, radius = 4.0 },
					{ coords = vector3(290.3, -597.3, 43.2), heading = 338.6, radius = 4.0 },
					{ coords = vector3(294.4, -585.6, 43.2), heading = 338.6, radius = 4.0 },
					{ coords = vector3(289.9, -583.9, 43.2), heading = 338.6, radius = 4.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(344.3, -580.7, 74.2),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(352.0, -588.2, 74.2), heading = 344.1, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(360.1, -585.0, 27.7),
				To = { coords = vector3(336.9, -591.4, 43.3), heading = 67.3 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(339.3, -592.5, 42.3),
				To = { coords = vector3(356.2, -597.1, 28.8), heading = 253.5 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(319.7, -579.9, 43.3),
				To = { coords = vector3(339.9, -586.7, 74.2), heading = 249.1 },
				Marker = { type = 34, x = 1.0, y = 1.0, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = true },
				Prompt = 'Press ~INPUT_CONTEXT~ to fast travel to the roof.'
			},

			{
				From = vector3(339.3, -583.9, 74.2),
				To = { coords = vector3(320.2, -577.1, 43.3), heading = 255.1 },
				Marker = { type = 42, x = 1.0, y = 1.0, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = true },
				Prompt = 'Press ~INPUT_CONTEXT~ to fast travel to the hospital.'
			}
		}
	},

	Station23 = {

		Blip = {
			coords = vector3(197.7, -1651.6, 29.8),
			sprite = 436,
			scale  = 1.2,
			color  = 47
		},

		AmbulanceActions = {
			vector3(197.7, -1651.6, 28.8)
		},

		Pharmacies = {
			vector3(198.03, -1646.4, 28.8)
		},

		Vehicles = {
			{
				Spawner = vector3(200.7, -1657.5, 29.8),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(190.9, -1662.1, 29.8), heading = 141.2, radius = 4.0 },
					{ coords = vector3(194.9, -1664.5, 29.8), heading = 139.6, radius = 4.0 },
					{ coords = vector3(197.8, -1667.1, 29.8), heading = 141.1, radius = 4.0 }
				}
			}
		},

		Helicopters = {
		},

		FastTravels = {
		},

		FastTravelsPrompt = {
		}
	},

	Station90 = {

		Blip = {
			coords = vector3(1703.0, 3601.4, 35.5),
			sprite = 436,
			scale  = 1.2,
			color  = 47
		},

		AmbulanceActions = {
			vector3(1703.0, 3601.4, 34.5)
		},

		Pharmacies = {
			vector3(1707.37, 3595.3, 34.56)
		},

		Vehicles = {
			{
				Spawner = vector3(1704.5, 3594.5, 35.56),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(1698.5, 3583.7, 35.5), heading = 207.8, radius = 4.0 }
				}
			}
		},

		Helicopters = {
		},

		FastTravels = {
		},

		FastTravelsPrompt = {
		}
	},

	Station1 = {

		Blip = {
			coords = vector3(-379.0, 6118.6, 31.8),
			sprite = 436,
			scale  = 1.2,
			color  = 47
		},

		AmbulanceActions = {
			vector3(-379.0, 6118.6, 30.8)
		},

		Pharmacies = {
			vector3(-371.37, 6101.3, 30.46)
		},

		Vehicles = {
			{
				Spawner = vector3(-377.6, 6124.5, 31.44),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(-371.9, 6130.7, 31.4), heading = 53.2, radius = 4.0 }
				}
			}
		},

		Helicopters = {
		},

		FastTravels = {
		},

		FastTravelsPrompt = {
		}
	},

	Sandy = {

		Blip = {
			coords = vector3(1827.0, 3666.1, 34.3),
			sprite = 61,
			scale  = 1.2,
			color  = 2
		},

		AmbulanceActions = {
			vector3(1830.1, 3677.0, 33.3)
		},

		Pharmacies = {
			vector3(1836.7, 3688.2, 33.3)
		},

		Vehicles = {
			{
				Spawner = vector3(1830.1, 3694.0, 34.2),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 100, g = 50, b = 200, a = 100, rotate = true },
				SpawnPoints = {
					{ coords =vector3(1833.6, 3697.3, 34.2), heading = 293.3, radius = 4.0 },
					{ coords = vector3(1841.4, 3704.0, 33.7), heading = 353.9, radius = 4.0 },
					{ coords = vector3(1817.1, 3687.5, 34.2), heading = 296.9, radius = 4.0 },
					{ coords = vector3(1804.8, 3680.3, 34.2), heading = 296.9, radius = 4.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(344.3, -580.7, 74.2),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 100, g = 150, b = 150, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(352.0, -588.2, 74.2), heading = 344.1, radius = 10.0 }
				}
			}
		},

		FastTravels = {
			{
				From = vector3(360.1, -585.0, 27.7),
				To = { coords = vector3(336.9, -591.4, 43.3), heading = 67.3 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(339.3, -592.5, 42.3),
				To = { coords = vector3(356.2, -597.1, 28.8), heading = 253.5 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(319.7, -579.9, 43.3),
				To = { coords = vector3(339.9, -586.7, 74.2), heading = 249.1 },
				Marker = { type = 34, x = 1.0, y = 1.0, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = true },
				Prompt = 'Press ~INPUT_CONTEXT~ to fast travel to the roof.'
			},

			{
				From = vector3(339.3, -583.9, 74.2),
				To = { coords = vector3(320.2, -577.1, 43.3), heading = 255.1 },
				Marker = { type = 42, x = 1.0, y = 1.0, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = true },
				Prompt = 'Press ~INPUT_CONTEXT~ to fast travel to the hospital.'
			}
	 	}
	}

}

Config.AuthorizedVehicles = {

	volunteer = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000}
	}, recruit = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000}
	}, basic = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, paramedic = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, lieutenant = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, asstcaptain = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, captain = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, asstsupchief = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, supchief = {
		{model = 'ambulance', label = 'E 450', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}, boss = {
		{model = 'ambulance', label = 'Ambulance Van', price = 5000},
		{model = 'duty', label = 'F 450', price = 6000},
		{model = 'firetruk', label = 'FireTruck', price = 25000}
	}

}

Config.AuthorizedHelicopters = {

	volunteer = {
		
	}, recruit = {
		
	}, basic = {
		
	}, paramedic = {
		
	}, lieutenant = {
		{ model = 'mh65c', label = 'mh65-c', price = 10000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}, asstcaptain = {
		{ model = 'mh65c', label = 'mh65-c', price = 10000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}, captain = {
		{ model = 'mh65c', label = 'mh65-c', price = 10000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}, asstsupchief = {
		{ model = 'mh65c', label = 'mh65-c', price = 10000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}, supchief = {
		{ model = 'mh65c', label = 'mh65-c', price = 10000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}, boss = {
		{ model = 'mh65c', label = 'mh65-c', price = 10000 },
		{ model = 'seasparrow', label = 'Sea Sparrow', price = 250000 }
	}

}
