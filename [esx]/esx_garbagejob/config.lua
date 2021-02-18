Config = {}

Config.DrawDistance = 100

Config.MaxDelivery = 4
Config.MissingTruckPrice = 3000
Config.BagPay = 150
Config.Locale = 'en'

Config.Trucks = {
	'trash',
	'trash2',
	'biff',
	--'scrap'
}

Config.JobLocations = {
	{
		vehicles = {
			{
				coords = vector3(-316.1, -1536.0, 26.6),
				spawnPoint = {coords = vector3(-328.5, -1520.9, 27.5), heading = 270.0},
				scale = vector3(3.0, 3.0, 1.0),
				color = {r = 204, g = 204, b = 0, a = 100},
				type  = 1
			}
		},

		cloakroom = vector3(-321.7, -1545.9, 30.0)
	}
}

Config.DumpstersAvailable = {
	'prop_dumpster_01a',
	'prop_dumpster_02a',
	'prop_dumpster_02b',
	'prop_dumpster_3a',
	'prop_dumpster_4a',
	'prop_dumpster_4b',
	'prop_skip_01a',
	'prop_skip_02a',
	'prop_skip_06a',
	'prop_skip_05a',
	'prop_skip_03',
	'prop_skip_10a'
}

Config.Deliveries = {
	--------------------------------------- Los Santos
	Delivery1LS = {coords = vector3(114.8, -1462.3, 29.2), pay = 202}, -- fleeca2
	Delivery2LS = {coords = vector3(-6.0, -1566.2, 29.2), pay = 202}, -- blainecounty
	Delivery3LS = {coords = vector3(-1.8, -1729.5, 29.3), pay = 202}, -- PrincipalBank
	Delivery4LS = {coords = vector3(159.0, -1816.6, 27.9), pay = 316}, -- route68e
	Delivery5LS = {coords = vector3(358.9, -1805.0, 28.9), pay = 316}, -- littleseoul
	Delivery6LS = {coords = vector3(481.3, -1274.8, 29.6), pay = 202}, -- grovestreetgas
	Delivery7LS = {coords = vector3(254.7, -985.3, 29.1), pay = 316}, -- fleecacarpark
	Delivery8LS = {coords = vector3(240.0, -826.9, 30.0), pay = 316}, -- Mt Haan Dr Radio Tower
	Delivery9LS = {coords = vector3(342.7, -1036.4, 29.1), pay = 202}, -- Senora Way Fuel Depot
	Delivery10LS = {coords = vector3(462.1, -949.5, 27.9), pay = 202},
------------------------------------------- 2nd Patrol -- Palomino Noose HQ
	Delivery1BC = {coords = vector3(317.5, -737.9, 29.2), pay = 202}, -- El Burro Oil plain
	Delivery2BC = {coords = vector3(410.2, -795.3, 29.2), pay = 316}, -- Orchardville ave
	Delivery3BC = {coords = vector3(398.3, -716.3, 29.2), pay = 316}, -- Elysian Fields
	Delivery4BC = {coords = vector3(443.9, -574.3, 28.4), pay = 316}, -- Carson Ave
	Delivery5BC = {coords = vector3(-1332.5, -1198.4, 4.6), pay = 316}, -- Carson Ave
	Delivery6BC = {coords = vector3(-45.4, -191.3, 52.1), pay = 316}, -- Dutch London
	Delivery7BC = {coords = vector3(-31.9, -93.4, 57.2), pay = 316}, -- Autopia Pkwy
	Delivery8BC = {coords = vector3(283.1, -164.8, 60.0), pay = 316}, -- Miriam Turner Overpass
	Delivery9BC = {coords = vector3(455.4, -66.4, 74.1), pay = 316}, -- Exceptionalist Way
	Delivery10BC = {coords = vector3(441.8, 125.9, 99.8), pay = 316},
	ReturnTruck = {coords = vector3(-335.2, -1529.5, 27.5), pay = 0},
	CancelMission = {coords = vector3(-314.6, -1514.5, 26.6), pay = 0}
}