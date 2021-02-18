Config = {}
Config.DrawDistance = 100.0
Config.MarkerType = 1
Config.MarkerSize = {x = 1.5, y = 1.5, z = 1.0}
Config.MarkerColor = {r = 50, g = 50, b = 204}
Config.EnablePlayerManagement = true
Config.EnableLicenses = true
Config.Locale = 'en'

Config.CopBlip = {
	police = {color = 26, label = 'LSPD'},
	sheriff = {color = 9, label = 'BSCO'},
	state = {color = 6, label = 'SAHP'},
	securoserv = {color = 43, label = 'Securo Serv'},
	usmarshal = {color = 50, label = 'US Marshal'},
	dod = {color = 12, label = 'DOD'},
	fib = {color = 38, label = 'FIB'},
	doj = {color = 23, label = 'DOJ'}
}

Config.Blips = {
	vector3(473.0, -989.9, 23.9),
	vector3(1853.8, 3686.7, 30.7),
	vector3(-445.4, 6011.6, 31.7),
	vector3(110.3, -751.2, 45.8)
}

Config.PoliceStations = {
	LSPD = {
		EvidenceLocker = {
			vector3(473.0, -989.9, 24.9),
			vector3(1855.7, 3699.4, 33.3),
			vector3(-438.7, 6010.7, 27.0),
			vector3(121.7, -738.5, 242.2)
		},

		FingerPrinting = {
			vector3(461.320, -987.613, 23.9),
			vector3(-442.7, 6011.3, 27.0),
			vector3(124.0, -727.4, 241.5),
			vector3(1848.7, 3681.2, 29.3)
		},

		Cloakrooms = {
			vector3(452.6, -992.8, 30.6),
			vector3(-456.9, 6013.9, 31.7),
			vector3(572.270, -202.562, 42.2),
			vector3(118.4, -729.3, 242.2),
			vector3(-2349.7, 3267.7, 32.0),
			vector3(1850.6, 3693.8, 34.3)
		},

		Armories = {
			vector3(451.7, -980.1, 30.6),
			vector3(-437.4, 6001.4, 31.7),
			vector3(-574.4, -200.4, 42.7),
			vector3(120.6, -725.8, 242.2),
			vector3(-2357.8, 3254.8, 32.2),
			vector3(1845.9, 3692.8, 34.3)
		},

		Vehicles = {
			{
				Spawner = vector3(454.6, -1017.4, 28.4),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(438.4, -1018.3, 27.7), heading = 90.0, radius = 6.0 },
					{ coords = vector3(441.0, -1024.2, 28.3), heading = 90.0, radius = 6.0 },
					{ coords = vector3(453.5, -1022.2, 28.0), heading = 90.0, radius = 6.0 },
					{ coords = vector3(450.9, -1016.5, 28.1), heading = 90.0, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(-1788.6, 3091.73, 32.8),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(-1741.4, 3072.1, 32.84), heading = 101.3, radius = 6.0 },
					{ coords = vector3(-1739.3, 3063.9, 32.84), heading = 97.7, radius = 6.0 },
				}
			},

			{
				Spawner = vector3(-236.3, -2662.6, 6.0),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(-224.9, -2654.6, 6.0), heading = 357.6, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(-1616.2, -3143.3, 13.9),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(-1627.2, -3146.7, 13.9), heading = 329.6, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(3322.8, 5159.0, 18.4),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(3328.5, 5152.6, 18.3), heading = 125.3, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(-698.2, -1403.6, 5.1),
				InsideShop = vector3(228.5, -993.5, -99.5),
				SpawnPoints = {
					{ coords = vector3(-688.0, -1412.8, 5.0), heading = 87.1, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(1868.0, 3696.5, 33.9),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(1872.5, 3689.9, 32.9), heading = 214.1, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(-562.0, -141.5, 38.3),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(-560.5, -146.6, 38.1), heading = 239.4, radius = 6.0 },
					{ coords = vector3(-556.8, -144.9, 38.2), heading = 240.7, radius = 6.0 },
					{ coords = vector3(-552.5, -143.6, 38.2), heading = 243.5, radius = 6.0 },
					{ coords = vector3(-548.5, -141.8, 38.3), heading = 238.9, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(-463.158, 6017.352, 31.34),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(-475.9, 6031.784, 31.34), heading = 219.6, radius = 6.0 }
				}
			},

			{
				Spawner = vector3(136.3, -736.7, 33.1),
				InsideShop = vector3(228.5, -993.5, -99.0),
				SpawnPoints = {
					{ coords = vector3(124.3, -728.3, 33.1), heading = 246.0, radius = 6.0 },
					{ coords = vector3(131.1, -722.9, 33.1), heading = 246.0, radius = 6.0 },
					{ coords = vector3(140.4, -729.6, 33.1), heading = 246.0, radius = 6.0 },
					{ coords = vector3(154.5, -738.8, 33.1), heading = 332.0, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(461.1, -981.5, 43.6),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(156.5, -759.8, 266.8),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(146.8, -757.4, 263.0), heading = 331.0, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-1834.2, 3008.8, 32.8),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(-1831.6, 2977.12, 32.8), heading = 238.8, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-1670.0, -3111.2, 13.9),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(-1655.0, -3147.82, 13.9), heading = 325.8, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(3094.4, -4724.1, 15.2),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(3089.1, -4787.5, 15.2), heading = 22.4, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-752.7, -1506.7, 5.0),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(-745.3, -1468.5, 5.0), heading = 320.2, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-965.5, -2987.9, 13.9),
				InsideShop = vector3(-2000.5, 3194.1, 32.8),
				SpawnPoints = {
					{ coords = vector3(-972.8, -3001.0, 13.9), heading = 57.2, radius = 10.0 }
				}
			}
		},

		Boats = {
			{
				Spawner = vector3(-1592.2, 5212.4, 4.0), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(-1607.7, 5219.3, 1.5), heading = 116.0, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(1485.2, 3779.4, 32.0), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(1471.7, 3788.3, 29.5), heading = 38.0, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-1893.5, -3195.7, 13.9), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(-1905.5, -3253.3, 1.5), heading = 141.1, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(3840.3, 4464.6, 2.6), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(3849.4, 4474.4, 1.5), heading = 316.1, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(3097.7, -4803.4, 2.0), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(3093.6, -4813.2, 1.0), heading = 185.7, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(2824.2, -674.1, 1.1), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(2846.5, -671.2, 1.0), heading = 273.0, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(774.7, -2923.5, 5.9), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(771.03, -2907.1, 1.0), heading = 4.1, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-243.3, -2696.7, 6.0), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(-230.9, -2702.3, 1.0), heading = 217.1, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-3424.5, 981.3, 8.3), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(-3423.2, 993.0, 1.0), heading = 26.1, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-273.0, 6641.4, 7.3), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(-287.2, 6643.0, 1.0), heading = 77.5, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(1323.0, 6632.4, 1.6), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(1324.7, 6647.0, 1.0), heading = 356.4, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-1801.2, -1227.8, 1.6), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(-1795.2, -1231.8, 1.0), heading = 320.4, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(3373.2, 5183.4, 1.5), 
				InsideShop = vector3(3484.3, 5188.9, 0.7),
				SpawnPoints = {
					{ coords = vector3(3371.0, 5177.8, 1.5), heading = 273.0, radius = 10.0 },
					{ coords = vector3(3371.9, 5190.3, 1.5), heading = 273.0, radius = 10.0 },
					{ coords = vector3(3388.3, 5180.9, 1.5), heading = 273.0, radius = 10.0 }
				}
			},

			{
				Spawner = vector3(-806.1, -1496.1, 1.6),
				InsideShop = vector3(-814.2, -1461.2, 0.5),
				SpawnPoints = {
					{ coords = vector3(-810.4, -1466.8, 1.6), heading = 108.99, radius = 10.0 },
					{ coords = vector3(-832.8, -1493.5, 1.6), heading = 108.99, radius = 10.0 }
				}
			}
		},

		BossActions = {
			vector3(448.4, -973.2, 30.6),
			vector3(1851.22, 3691.11, 33.2),
			vector3(-449.092, 6011.054, 30.300)
		}
	}
}
