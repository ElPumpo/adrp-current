Config = {}

Config.Locale = 'en'

Config.Blips = {

	Blip = {
		Pos 	= vector3(2009.2, 2688.4, 45.8),
		Sprite	= 458,
		Scale	= 1.0,
		Color	= 50
	}

}

Config.Zones = {

	BlueCloakroom = {
		Pos 	= vector3(2017.7, 2713.4, 49.4),
		Size	= { x = 1.5, y = 1.5, z = 1.0 },
		Color	= { r = 0, g = 155, b = 255 },
		Type	= 27
	},

	RedCloakroom = {
		Pos 	= vector3(2024.8, 2851.5, 49.7),
		Size	= { x = 1.5, y = 1.5, z = 1.0 },
		Color	= { r = 255, g = 0, b = 0 },
		Type	= 27
	},

	Enter = {
		Pos 	= vector3(2009.2, 2688.4, 45.8),
		Size	= { x = 2.0, y = 2.0, z = 2.0 },
		Color	= { r = 178, g = 102, b = 255 },
		Type	= 1
	},

	Game = {
		Pos 	= vector3(2021.5, 2786.2, 50.3),
		Size	= { x = 2.0, y = 2.0, z = 1.8 },
		Color	= { r = 0, g = 200, b = 100 },
		Type	= 5
	},

	Middle = {
		Pos 	= vector3(2014.4, 2785.6, 50.3),
		Size	= { x = 2.0, y = 2.0, z = 1.7 },
		Color	= { r = 0, g = 200, b = 100 },
		Type	= -1
	},

	BlueTeam = {
		Pos 	= vector3(2015.6, 2704.5, 55.9),
		Size	= { x = 3.5, y = 3.5, z = 10.0 },
		Color	= { r = 0, g = 155, b = 255 },
		Type	= 0
	},

	RedTeam = {
		Pos 	= vector3(2030.7, 2858.5, 55.9),
		Size	= { x = 3.5, y = 3.5, z = 10.0 },
		Color	= { r = 255, g = 0, b = 0 },
		Type	= 0
	},

	SpawnBlueTeam = {
		Pos 	= vector3(2015.6, 2704.5, 50.9),
		Size	= { x = 1.5, y = 1.5, z = 1.0 },
		Color	= { r = 0, g = 155, b = 255 },
		Type	= -1
	},

	SpawnRedTeam = {
		Pos 	= vector3(2030.7, 2858.5, 50.9),
		Size	= { x = 1.5, y = 1.5, z = 1.0 },
		Color	= { r = 255, g = 0, b = 0 },
		Type	= -1
	}

}


Config.Uniforms = {

	blue_team = {
		male = {
			['tshirt_1']	= 15, ['tshirt_2']	= 0,
			['torso_1']	 	= 186, ['torso_2']	= 6,
			['decals_1']	= 0,	['decals_2']	= 0,
			['arms']			= 17, ['arms_2']		= 2,
			['pants_1']	 	= 84, ['pants_2']	 	= 6,
			['shoes_1']	 	= 33, ['shoes_2']	 	= 0,
			['helmet_1']	= 59, ['helmet_2']	= 5,
			['mask_1']		= 28, ['mask_2']		= 0,
			['glasses_1']	= -1, ['glasses_2'] = 0,
			['chain_1']	 	= 0,	['chain_2']	 	= 0,
			['ears_1']		= -1, ['ears_2']		= 0
		},
		female = {
			['tshirt_1']	= 2,	['tshirt_2']	= 0,
			['torso_1']	 	= 188, ['torso_2']	= 6,
			['decals_1']	= 0,	['decals_2']	= 0,
			['arms']			= 18, ['arms_2']		= 2,
			['pants_1']	 	= 86, ['pants_2']	 	= 6,
			['shoes_1']	 	= 34, ['shoes_2']	 	= 0,
			['helmet_1']	= 59, ['helmet_2']	= 5,
			['mask_1']		= 28, ['mask_2']		= 0,
			['glasses_1']	= -1, ['glasses_2'] = 0,
			['chain_1']	 	= 0,	['chain_2']	 	= 0,
			['ears_1']		= -1, ['ears_2']		= 0
		}
	},

	red_team = {
		male = {
			['tshirt_1']	= 15, ['tshirt_2']	= 0,
			['torso_1']	 	= 186, ['torso_2']	= 5,
			['decals_1']	= 0,	['decals_2']	= 0,
			['arms']			= 17, ['arms_2']		= 2,
			['pants_1']	 	= 84, ['pants_2']	 	= 5,
			['shoes_1']	 	= 33, ['shoes_2']	 	= 0,
			['helmet_1']	= 59, ['helmet_2']	= 4,
			['mask_1']		= 28, ['mask_2']		= 0,
			['glasses_1']	= -1, ['glasses_2'] = 0,
			['chain_1']	 	= 0,	['chain_2']	 	= 0,
			['ears_1']		= -1, ['ears_2']		= 0
		},
		female = {
			['tshirt_1']	= 2,	['tshirt_2']	= 0,
			['torso_1']	 	= 188, ['torso_2']	= 5,
			['decals_1']	= 0,	['decals_2']	= 0,
			['arms']			= 18, ['arms_2']		= 2,
			['pants_1']	 	= 86, ['pants_2']	 	= 5,
			['shoes_1']	 	= 34, ['shoes_2']	 	= 0,
			['helmet_1']	= 59, ['helmet_2']	= 4,
			['mask_1']		= 28, ['mask_2']		= 0,
			['glasses_1']	= -1, ['glasses_2'] = 0,
			['chain_1']	 	= 0,	['chain_2']	 	= 0,
			['ears_1']		= -1, ['ears_2']		= 0
		}
	}

}