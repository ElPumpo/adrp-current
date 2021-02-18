Config = {}

Config.Locale = 'en'

Config.Races = {
	{
		coords = vector3(3320.47, 5166.27, 20.0),
		rewards = { min = 250, max = 20000, black = false },
		vehicle = 'sanchez',
		blip = { sprite = 315, color = 7 },
		forceFirstPerson = true,
		timerTilStart = 1000 * 60 * 1,
		timerTilDnf = 30,
		players = { min = 3, max = 13 },

		CheckPoints = {
			{coords = vector3(3259.45, 5174.63, 19.70), rotationZ = 0.0, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3183.48, 5252.34, 27.27), rotationZ = 57.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3141.41, 5342.76, 28.84), rotationZ = -15.5, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3293.13, 5417.28, 15.22), rotationZ = -74.6, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3344.94, 5559.97, 19.35), rotationZ = -3.6, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3344.47, 5730.45, 18.08), rotationZ = 5.1, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3312.41, 5898.94, 74.12), rotationZ = 12.8, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3226.34, 5977.84, 99.65), rotationZ = 94.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3079.86, 6037.27, 129.38), rotationZ = 8.6, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3014.29, 6217.34, 103.49), rotationZ = 86.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2849.41, 6312.80, 73.25), rotationZ = 61.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2733.88, 6369.71, 112.54), rotationZ = 63.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2637.62, 6291.37, 125.54), rotationZ = 146.2, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2720.79, 6154.62, 240.55), rotationZ = -94.7, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2822.53, 6065.99, 296.70), rotationZ = -145.7, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2858.68, 5930.85, 359.06), rotationZ = -153.5, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2920.94, 5836.07, 343.55), rotationZ = -167.8, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2990.63, 5739.82, 295.78), rotationZ = 162.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2972.51, 5644.70, 244.07), rotationZ = 173.7, scale = {x = 15.0, y = 15.0, z = 15.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2935.90, 5403.65, 145.43), rotationZ = -172.3, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2867.38, 5285.01, 93.27), rotationZ = 135.5, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2704.88, 5140.18, 43.69), rotationZ = -149.5, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(2830.74, 4985.55, 33.54), rotationZ = -46.4, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3058.63, 5064.40, 25.30), rotationZ = -1.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(3244.03, 5139.37, 19.52), rotationZ = -64.0, scale = {x = 7.0, y = 7.0, z = 7.0}, type = 4, color = {r = 255, g = 255, b = 51, a = 100}}
		},

		StartPositions = {
			{coords = vector3(3291.79, 5145.53, 18.33), heading = 84.0},
			{coords = vector3(3292.03, 5148.33, 18.46), heading = 84.0},
			{coords = vector3(3292.21, 5150.05, 18.36), heading = 84.0},
			{coords = vector3(3300.72, 5145.66, 18.31), heading = 84.0},
			{coords = vector3(3300.98, 5150.48, 18.31), heading = 84.0},
			{coords = vector3(3301.20, 5154.04, 18.37), heading = 84.0},
			{coords = vector3(3297.12, 5159.38, 18.35), heading = 108.0},
			{coords = vector3(3301.6, 5138.1, 18.4), heading = 108.0},
			{coords = vector3(3289.2, 5139.1, 18.5), heading = 108.0},
			{coords = vector3(3275.8, 5142.2, 19.3), heading = 108.0},
			{coords = vector3(3309.8, 5152.9, 18.3), heading = 108.0},
			{coords = vector3(3297.2, 5157.2, 18.5), heading = 108.0},
			{coords = vector3(3290.7, 5155.9, 18.4), heading = 108.0},
		}
	},

	{
		coords = vector3(-2333.22, 3422.50, 32.0),
		rewards = { min = 1000, max = 25000, black = false },
		vehicle = 'crusader',
		blip = { sprite = 315, color = 7 },
		forceFirstPerson = true,
		timerTilStart = 1000 * 60 * 1,
		timerTilDnf = 90,
		players = { min = 3, max = 10 },
	
		CheckPoints = {
			{coords = vector3(-2027.18, 3325.78, 33.01), rotationZ = -38.0, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1859.01, 3326.61, 32.93), rotationZ = -122.9, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1699.73, 3231.39, 32.92), rotationZ = -175.5, scale = {x = 15.0, y = 15.0, z = 15.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1754.77, 3151.80, 32.91), rotationZ = 84.6, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1796.30, 3145.41, 32.86), rotationZ = 146.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1840.81, 3067.05, 32.81), rotationZ = -177.9, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1815.38, 3051.11, 32.81), rotationZ = -124.4, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1730.55, 3002.30, 32.86), rotationZ = -157.9, scale = {x = 15.0, y = 15.0, z = 15.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1726.56, 2935.67, 32.81), rotationZ = -121.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1705.14, 2854.29, 32.89), rotationZ = 143.4, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1761.64, 2824.26, 32.81), rotationZ = 90.0, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1897.15, 2838.40, 32.81), rotationZ = 59.6, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2124.56, 2959.54, 32.81), rotationZ = 57.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2430.91, 3136.85, 32.82), rotationZ = 60.4, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2679.71, 3291.43, 32.81), rotationZ = -7.7, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2543.41, 3307.65, 32.81), rotationZ = -64.1, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2427.65, 3353.05, 32.83), rotationZ = -121.6, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2374.40, 3308.09, 32.83), rotationZ = -116.0, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2282.53, 3302.79, 32.83), rotationZ = -57.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2237.78, 3310.56, 32.82), rotationZ = -120.6, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2202.88, 3269.35, 32.81), rotationZ = -165.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2111.65, 3181.27, 32.81), rotationZ = -117.1, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1910.29, 3060.89, 32.81), rotationZ = 170.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1924.05, 3027.03, 32.81), rotationZ = 149.1, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1960.70, 3002.75, 32.81), rotationZ = 71.3, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2134.32, 3120.63, 32.81), rotationZ = -22.1, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2092.54, 3233.59, 32.81), rotationZ = -30.2, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2063.12, 3282.37, 32.81), rotationZ = -91.3, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1937.56, 3214.92, 32.81), rotationZ = -175.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-1984.02, 3123.52, 32.81), rotationZ = 90.8, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2151.50, 3227.74, 32.81), rotationZ = -10.4, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 6, color = {r = 255, g = 255, b = 51, a = 100}},
			{coords = vector3(-2133.51, 3265.25, 32.81), rotationZ = -41.4, scale = {x = 10.0, y = 10.0, z = 10.0}, type = 4, color = {r = 155, g = 80, b = 228, a = 100}}
		},

		StartPositions = {
			{coords = vector3(-2084.33, 3335.57, 32.94), heading = 235.0},
			{coords = vector3(-2085.91, 3342.96, 32.93), heading = 235.0},
			{coords = vector3(-2093.91, 3341.01, 32.94), heading = 235.0},
			{coords = vector3(-2093.69, 3347.22, 32.94), heading = 235.0},
			{coords = vector3(-2099.90, 3344.65, 32.95), heading = 235.0},
			{coords = vector3(-2100.04, 3351.05, 32.93), heading = 235.0},
			{coords = vector3(-2107.06, 3348.76, 32.95), heading = 235.0},
			{coords = vector3(-2105.54, 3353.73, 32.95), heading = 235.0},
			{coords = vector3(-2111.42, 3350.99, 32.94), heading = 235.0},
			{coords = vector3(-2117.18, 3354.67, 32.95), heading = 235.0}

		}
	}
}

Config.RadioStations = {
	{radio = 'RADIO_01_CLASS_ROCK', label = 'Los Santos Rock Radio'},
	{radio = 'RADIO_02_POP', label = 'Non-Stop-Pop FM'},
	{radio = 'RADIO_03_HIPHOP_NEW', label = 'Radio Los Santos'},
	{radio = 'RADIO_04_PUNK', label = 'Channel X'},
	{radio = 'RADIO_07_DANCE_01', label = 'Soulwax FM'}
}