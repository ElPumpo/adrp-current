Config = {}

Config.JailBlip     = vector3(1854.0, 2622.0, 45.0)
Config.JailLocation = vector3(1714.6, 2543.3, 45.0)

Config.Locale       = 'en'

Config.PrisonBreakTime         = 60000 * 10
Config.PrisonBreakCooldown     = 60000 * 15
Config.PrisonBreakRequiredCops = 6

Config.Locations = {
	PrisonBreak = vector3(1831.3, 2603.2, 44.6)
}

Config.Uniforms = {

	prison_wear = {
		male = {
			tshirt_1 = 15,  tshirt_2 = 0,
			torso_1  = 146, torso_2  = 0,
			decals_1 = 0,   decals_2 = 0,
			arms     = 0,   pants_1  = 3,
			pants_2  = 7,   shoes_1  = 12,
			shoes_2  = 12,  chain_1  = 0,
			chain_2  = 0
		},

		female = {
			tshirt_1 = 14,   tshirt_2 = 0,
			torso_1  = 79,  torso_2  = 2,
			decals_1 = 0,   decals_2 = 0,
			arms     = 0,   pants_1  = 66,
			pants_2  = 6,  shoes_1  = 60,
			shoes_2  = 9,   chain_1  = 0,
			chain_2  = 2
		}
	}

}