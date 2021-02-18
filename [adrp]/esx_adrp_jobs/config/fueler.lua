Config.Fueler = {}

Config.Fueler.StartPositions = {
	{
		area = {
			coords = vector3(-126.7, -2530.6, 6.1),
			type = 0,
			scale = vector3(0.5, 0.5, 0.5),
			color = vector4(200, 150, 153, 100),
			bobUpAndDown = false,
			rotate = true
		},

		blip = {coords = vector3(-110.4, -2533.4, 6.0), sprite = 85, color = 3},

		vehicles = {
			{vehicle = 'packer', label = 'Packer Truck'},
			{vehicle = 'hauler', label = 'Jobuilt Hauler'}
		},

		spawnpoints = {
			{coords = vector3(-109.3, -2518.7, 6.0), heading = 227.8},
			{coords = vector3(-111.3, -2521.8, 6.0), heading = 227.8},
			{coords = vector3(-113.1, -2524.5, 6.0), heading = 227.8},
			{coords = vector3(-115.1, -2527.1, 6.0), heading = 227.8}
		},

		returntrucks = {
			vector3(-112.2, -2547.2, 6.0)
		},

		trailers = {
			{coords = vector3(-120.6, -2415.5, 6.0), heading = 179.4},
			{coords = vector3(-129.0, -2415.6, 6.0), heading = 179.4},
			{coords = vector3(-137.0, -2415.9, 6.0), heading = 179.4},
			{coords = vector3(188.7, -2438.2, 6.0), heading = 179.4},
			{coords = vector3(-30.8, -2545.9, 6.0), heading = 53.8}
		},

		returntrailer = {
			vector3(-224.7, -2444.4, 5.5),
			vector3(-220.4, -2486.7, 5.5)
		}

	}

}

Config.Fueler.GasStations = {
	vector3(-32.9, -2496.3, 6.1),
	vector3(-28.6, -2509.2, 6.0),
	vector3(-15.7, -2509.2, 6.1)
}
