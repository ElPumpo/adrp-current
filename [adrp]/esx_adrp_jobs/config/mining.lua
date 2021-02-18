Config.Mining = {}

Config.Mining.Zones = {
	Mine = {coords = vector3(2947.3, 2798.1, 40.9), label = 'Mine Quarry', sprite = 618, color = 5, circle = 20.0},
	MineProcessing = {coords = vector3(307.4, 2877.5, 43.5), label = 'Mine Processing', sprite = 467, color = 13},
	JewelryStore = {coords = vector3(-620.6, -228.5, 38.1), label = 'Jewelry Store', sprite = 617, color = 15},
	CommodityTrader = {coords = vector3(-1160.4, 2669.5, 18.1), label = 'Commodity Trader', sprite = 351, color = 20}
}

Config.Mining.MineItems = {
	'iron_ore', 'gold_ore', 'diamond_uncut'
}

Config.Mining.Prices = {
	iron = 15,
	gold = 40,
	diamond = 500
}

Config.Mining.Licenses = {
	iron_ore = 'iron_processing',
	gold_ore = 'gold_processing',
	diamond_uncut = 'diamond_processing'
}