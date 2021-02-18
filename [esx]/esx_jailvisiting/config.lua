Config = {}
Config.DrawDistance = 100.0
Config.MarkerColor  = {r = 120, g = 120, b = 240}

Config.Zones = {
	EnterVisitation = { -- spawn parloir pour prisonnier
		Pos = vector3(1847.0, 2586.0, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},


	LeaveVisitationVisitor = { -- marker quitter le parloir prisonnier
		Pos = vector3(1777.3, 2584.9, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	LeaveVisitation = { -- marker quitter le parloir prisonnier
		Pos = vector3(1774.2, 2573.8, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	EnterVisitationInmate = { -- marker entré dans le parloir
		Pos = vector3(1737.1, 2622.8, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	ExitVisitation = { -- marker quitter le parloir
		Pos = vector3(1706.1, 2581.1, -70.4),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	yardVisitation = { -- marker for entering visitation
		Pos = vector3(1775.4, 2552.0, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	yardVisitation2 = { -- marker for entering visitation
		Pos = vector3(1818.6, 2594.2, 44.7),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	cellblock = { -- marker for entering visitation
		Pos = vector3(1636.2, 2565.2, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	chowhall = { -- marker for entering visitation
		Pos = vector3(1729.3, 2563.6, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	},

	exitchow = { -- marker for entering visitation
		Pos = vector3(1729.4, 2592.0, 44.5),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 255, g = 165, b = 0},
		Type  = 1
	}
}