Config = {}

Config.WeaponAmmo = 42 -- Ammo given by default to crafted weapons

Config.Recipes = {
	['campfire'] = {
		{item = 'wood', quantity = 4}
	},

	['gunpowder'] = {
		{item = 'charcoal', quantity = 1},
		{item = 'sulpher', quantity = 1}
	},

	['bandage'] = {
		{item = 'clothe', quantity = 2}
	},

	['WEAPON_PISTOL'] = {
		{item = 'iron', quantity = 10},
		{item = 'gunpowder', quantity = 10}
	}
}

-- Enable a shop to access the crafting menu
Config.Shop = {
	useShop = true,
	shopCoordinates = {x = 962.5, y = -1585.5, z = 29.6},
	shopName = 'Crafting Station',
	shopBlipID = 446,
	zoneSize = {x = 2.5, y = 2.5, z = 1.5},
	zoneColor = {r = 255, g = 0, b = 0, a = 100}
}

-- Enable crafting menu through a keyboard shortcut
Config.Keyboard = {
	useKeyboard = false,
	keyCode = 303
}
