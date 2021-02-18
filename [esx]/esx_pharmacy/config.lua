Config              = {}

Config.DrawDistance = 100.0
Config.MarkerSize   = { x = 1.0, y = 1.0, z = 1.0 }
Config.MarkerColor  = { r = 102, g = 102, b = 204 }
Config.MarkerType   = 29

Config.Locale       = 'en'

Config.Shops = {
	vector3(68.7, -1569.7, 29.5),
	vector3(98.4, -225.4, 54.6),
	vector3(591.2, 2744.4, 42.0),
	vector3(326.5, -1074.2, 29.4),
	vector3(213.6, -1835.1, 27.5),
	vector3(-3157.7, 1095.2, 19.8),
	vector3(1843.4, 3678.1, 34.3)
}

Config.Price = {
	firstaidkit = 2750,
	defibrillateur = 7500
}

Config.ValidBeds = {
	GetHashKey('v_med_bed'),
	GetHashKey('v_med_emptybed'),
	GetHashKey('v_med_bed2')
}