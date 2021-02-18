Config = {}
Config.Locale = 'en'

Config.DoorList = {

	--
	-- Mission Row First Floor
	--

	-- Entrance Doors
	{
		textCoords = vector3(434.7, -982.0, 31.5),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ph_door01',
				objYaw = -90.0,
				objCoords = vector3(434.7, -980.6, 30.8)
			},

			{
				objName = 'v_ilev_ph_door002',
				objYaw = -90.0,
				objCoords = vector3(434.7, -983.2, 30.8)
			}
		}
	},

	-- To locker room & roof
	{
		objName = 'v_ilev_ph_gendoor004',
		objYaw = 90.0,
		objCoords  = vector3(449.6, -986.4, 30.6),
		textCoords = vector3(450.1, -986.3, 31.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Rooftop
	{
		objName = 'v_ilev_gtdoor02',
		objYaw = 90.0,
		objCoords  = vector3(464.3, -984.6, 43.8),
		textCoords = vector3(464.3, -984.0, 44.8),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Hallway to roof
	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 90.0,
		objCoords  = vector3(461.2, -985.3, 30.8),
		textCoords = vector3(461.5, -986.0, 31.5),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Armory
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 90.0,
		objCoords  = vector3(452.6, -982.7, 30.6),
		textCoords = vector3(453.0, -982.6, 31.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Captain Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -180.0,
		objCoords  = vector3(447.2, -980.6, 30.6),
		textCoords = vector3(447.2, -980.0, 31.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- To downstairs (double doors)
	{
		textCoords = vector3(444.6, -989.4, 31.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 180.0,
				objCoords = vector3(443.9, -989.0, 30.6)
			},

			{
				objName = 'v_ilev_ph_gendoor005',
				objYaw = 0.0,
				objCoords = vector3(445.3, -988.7, 30.6)
			}
		}
	},

	-- Alt entrance
	{
		textCoords = vector3(445.9, -999.0, 30.8),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_gtdoor',
				objYaw = 0.0,
				objCoords = vector3(444.6, -999.0, 30.7)
			},

			{
				objName = 'v_ilev_gtdoor',
				objYaw = 180.0,
				objCoords = vector3(447.2, -999.0, 30.7)
			}
		}
	},

	--
	-- Mission Row Cells
	--

	-- Main Cells
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 0.0,
		objCoords  = vector3(463.8, -992.6, 24.9),
		textCoords = vector3(463.3, -992.6, 25.1),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell 1
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = -90.0,
		objCoords  = vector3(462.3, -993.6, 24.9),
		textCoords = vector3(461.8, -993.3, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell 2
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.3, -998.1, 24.9),
		textCoords = vector3(461.8, -998.8, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell 3
	{
		objName = 'v_ilev_ph_cellgate',
		objYaw = 90.0,
		objCoords  = vector3(462.7, -1001.9, 24.9),
		textCoords = vector3(461.8, -1002.4, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell Alt 1
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(467.1, -996.4, 25.0),
		textCoords = vector3(468.1, -996.4, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell Alt 2
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(471.4, -996.4, 25.0),
		textCoords = vector3(472.4, -996.4, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell Alt 3
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(475.7, -996.4, 25.0),
		textCoords = vector3(476.7, -996.4, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Cell Alt 4
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(480.0, -996.4, 25.0),
		textCoords = vector3(481.0, -996.4, 25.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- To Back
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 0.0,
		objCoords  = vector3(463.4, -1003.5, 25.0),
		textCoords = vector3(464.0, -1003.5, 25.5),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	--
	-- Mission Row Back
	--

	-- Back (double doors)
	{
		textCoords = vector3(468.6, -1014.4, 27.1),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 0.0,
				objCoords = vector3(467.3, -1014.4, 26.5)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 180.0,
				objCoords = vector3(469.9, -1014.4, 26.5)
			}
		}
	},

	-- Back Gate
	{
		objName = 'hei_prop_station_gate',
		objYaw = 90.0,
		objCoords  = vector3(488.8, -1017.2, 27.1),
		textCoords = vector3(488.8, -1020.2, 30.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 14,
		size = 2
	},

	-- Garage Entrance Top
	{
		objName = 507213820,
		objYaw = 2.0,
		objCoords  = vector3(464.2, -1011.3, 33.0),
		textCoords = vector3(463.0, -1011.3, 33.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Heli Access Door
	{
		objName = 'v_ilev_ph_gendoor006',
		objYaw = 90.4,
		objCoords  = vector3(463.7, -983.4, 36.0),
		textCoords = vector3(463.9, -984.3, 35.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Chief's Office
	{
		objName = 'v_ilev_ph_gendoor002',
		objYaw = -0.3,
		objCoords  = vector3(463.4, -1001.0, 36.1),
		textCoords = vector3(462.4, -1001.0, 35.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Asst. Chief's Office
	{
		objName = 'v_ilev_ph_gendoor003',
		objYaw = 179.9,
		objCoords  = vector3(444.2, -979.6, 26.8),
		textCoords = vector3(445.2, -979.2, 26.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Interview 2
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 178.9,
		objCoords  = vector3(477.0, -1003.6, 25.0),
		textCoords = vector3(476.1, -1003.5, 24.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	-- Front Balcony
	{
		textCoords = vector3(429.1, -995.0, 35.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = -603023671,
				objYaw = 89.4,
				objCoords = vector3(429.2, -994.0, 36.2)
			},

			{
				objName = -603023671,
				objYaw = -90.2,
				objCoords = vector3(429.2, -996.2, 36.2)
			}
		}
	},

	-- Interview 3
	{
		objName = 'v_ilev_gtdoor',
		objYaw = 179.4,
		objCoords  = vector3(468.5, -1003.5, 25.0),
		textCoords = vector3(467.5, -1003.5, 24.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	--
	-- Sandy Shores
	--

	-- Entrance
	{
		objName = 'v_ilev_shrfdoor',
		objYaw = 30.0,
		objCoords  = vector3(1855.1, 3683.5, 34.2),
		textCoords = vector3(1855.1, 3683.5, 35.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = false
	},

	{
		objName = 'v_ilev_rc_door2',
		objYaw = -150.9,
		objCoords  = vector3(1857.3, 3690.5, 34.4),
		textCoords = vector3(1856.4, 3689.8, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = 'v_ilev_cd_entrydoor',
		objYaw = -60.3,
		objCoords  = vector3(1844.3, 3694.2, 34.4),
		textCoords = vector3(1845.0, 3693.3, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		textCoords = vector3(1848.1, 3690.9, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 4,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = -151.9,
				objCoords = vector3(1849.4, 3691.2, 34.4)
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 29.4,
				objCoords = vector3(1847.1, 3689.9, 34.4)
			}
		}
	},

	{
		objName = 'v_ilev_rc_door2',
		objYaw = 120.3,
		objCoords  = vector3(1852.5, 3694.2, 34.4),
		textCoords = vector3(1852.0, 3694.7, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		textCoords = vector3(1847.5, 3683.4, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = -149.8,
				objCoords  = vector3(1848.7, 3683.9, 34.4),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 29.9,
				objCoords  = vector3(1846.4, 3682.6, 34.4)
			}
		}
	},

	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 29.9,
		objCoords  = vector3(1852.9, 3686.4, 30.4),
		textCoords = vector3(1852.1, 3686.0, 30.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = -1927754726,
		objYaw = -60.2,
		objCoords  = vector3(1862.7, 3688.4, 30.4),
		textCoords = vector3(1862.3, 3689.4, 30.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = -1927754726,
		objYaw = -59.8,
		objCoords  = vector3(1859.0, 3694.9, 30.4),
		textCoords = vector3(1858.4, 3695.8, 30.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		textCoords = vector3(1847.5, 3683.3, 30.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 30.3,
				objCoords  = vector3(1846.4, 3682.6, 30.4),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = -150.0,
				objCoords  = vector3(1848.7, 3683.9, 30.4)
			}
		}
	},

	--
	-- Paleto Bay
	--

	-- Entrance (double doors)
	{
		textCoords = vector3(-443.5, 6016.3, 32.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_shrf2door',
				objYaw = -45.0,
				objCoords  = vector3(-443.1, 6015.6, 31.7),
			},

			{
				objName = 'v_ilev_shrf2door',
				objYaw = 135.0,
				objCoords  = vector3(-443.9, 6016.6, 31.7)
			}
		}
	},

	{
		textCoords = vector3(-441.9, 6011.7, 31.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = -134.9,
				objCoords  = vector3(-441.1, 6012.8, 31.9),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = 45.1,
				objCoords  = vector3(-442.9, 6011.0, 31.9)
			}
		}
	},
	
	{
		textCoords = vector3(-448.6, 6007.6, 31.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_rc_door2',
				objYaw = 135.2,
				objCoords  = vector3(-447.7, 6006.7, 31.9),
			},

			{
				objName = 'v_ilev_rc_door2',
				objYaw = -45.6,
				objCoords  = vector3(-449.6, 6008.5, 31.9)
			}
		}
	},

	{
		objName = 'v_ilev_rc_door2',
		objYaw = 135.2,
		objCoords  = vector3(-451.0, 6006.4, 31.9),
		textCoords = vector3(-451.7, 6006.4, 31.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = 'v_ilev_rc_door2',
		objYaw = -45.0,
		objCoords  = vector3(-447.2, 6002.3, 31.9),
		textCoords = vector3(-447.2, 6002.3, 31.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 135.0,
		objCoords  = vector3(-447.8, 6005.2, 31.9),
		textCoords = vector3(-447.8, 6005.2, 31.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = 135.0,
		objCoords  = vector3(-437.0, 6003.7, 31.9),
		textCoords = vector3(-437.0, 6003.7, 31.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -135.0,
		objCoords  = vector3(-439.2, 5998.2, 31.9),
		textCoords = vector3(-439.2, 5998.2, 31.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = 'v_ilev_arm_secdoor',
		objYaw = -45.0,
		objCoords  = vector3(-440.4, 5998.6, 31.9),
		textCoords = vector3(-440.4, 5998.6, 31.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},
	-- Prison Cells
	{
		objName = -1927754726,
		objYaw = 45.0,
		objCoords  = vector3(-438.2, 6006.2, 28.1),
		textCoords = vector3(-438.9, 6005.4, 28.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = -1927754726,
		objYaw = 45.0,
		objCoords  = vector3(-442.1, 6010.1, 28.1),
		textCoords = vector3(-442.9, 6009.4, 28.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	{
		objName = -1927754726,
		objYaw = 45.2,
		objCoords  = vector3(-444.4, 6012.2, 28.1),
		textCoords = vector3(-445.0, 6011.6, 28.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true
	},

	

	--
	-- Bolingbroke Penitentiary
	--

	-- Entrance (Two big gates)
	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1844.9, 2604.8, 44.6),
		textCoords = vector3(1844.9, 2608.5, 48.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 12,
		size = 2
	},

	{
		objName = 'prop_gate_prison_01',
		objCoords  = vector3(1818.5, 2604.8, 44.6),
		textCoords = vector3(1818.5, 2608.4, 48.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 12,
		size = 2
	},

	--
	-- Unicorn related
	--

	-- Tequi-la-la front doors
	{
		objName = 'v_ilev_roc_door4',
		objYaw = -5.0,
		objCoords  = vector3(-565.1, 276.6, 83.2),
		textCoords = vector3(-564.0, 276.6, 83.2),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2
	},

	-- Tequi-la-la door underground
	{
		objName = 'v_ilev_roc_door2',
		objYaw = -100.0,
		objCoords  = vector3(-560.2, 293.0, 82.3),
		textCoords = vector3(-560.2, 292.0, 82.3),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2
	},

	-- Tequi-la-la back door
	{
		objName = 'v_ilev_roc_door4',
		objYaw = 175.0,
		objCoords  = vector3(-561.2, 293.5, 87.7),
		textCoords = vector3(-562.6, 293.5, 87.7),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2
	},

	-- Vanilla unicorn staff only
	{
		objName = 'v_ilev_door_orangesolid',
		objYaw = -60.0,
		objCoords  = vector3(113.9, -1297.4, 29.4),
		textCoords = vector3(113.6, -1296.5,  29.3),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2
	},

	-- Vanilla unicorn back entrance
	{
		objName = 'prop_magenta_door',
		objYaw = -150.0,
		objCoords  = vector3(96.0, -1284.8, 29.4),
		textCoords = vector3(95.3, -1285.5, 29.3),
		authorizedJobs = { 'unicorn' },
		locked = true,
		distance = 2
	},
	-- The Court
	{
		textCoords = vector3(-545.7, -203.4, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = -29187315,
				objYaw = -150.0,
				objCoords  = vector3(-546.5, -203.9, 38.4),
			},

			{
				objName = -29187315,
				objYaw = 30.0,
				objCoords  = vector3(-544.6, -202.8, 38.4)
			}
		}
	},

	{
		textCoords = vector3(-515.9, -210.4, 38.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -29187315,
				objYaw = 120.0,
				objCoords  = vector3(-516.5, -209.6, 38.5),
			},

			{
				objName = -29187315,
				objYaw = -60.0,
				objCoords  = vector3(-515.4, -211.4, 38.5)
			}
		}
	},

	{
		textCoords = vector3(-568.1, -235.4, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 1858896923,
				objYaw = -60.1,
				objCoords  = vector3(-567.5, -236.3, 34.4),
			},

			{
				objName = 1858896923,
				objYaw = 120.2,
				objCoords  = vector3(-568.6, -234.4, 34.4)
			}
		}
	},

	{
		textCoords = vector3(-582.8, -195.1, 38.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -29187315,
				objYaw = -149.9,
				objCoords  = vector3(-583.6, -195.8, 38.5),
			},

			{
				objName = -29187315,
				objYaw = 29.9,
				objCoords  = vector3(-581.7, -194.7, 38.5)
			}
		}
	},

	{
		textCoords = vector3(-567.8, -200.7, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_bk_door',
				objYaw = 30.0,
				objCoords  = vector3(-566.6, -200.2, 38.4),
			},

			{
				objName = 'v_ilev_bk_door',
				objYaw = -150.0,
				objCoords  = vector3(-568.9, -201.5, 38.4)
			}
		}
	},

	{
		textCoords = vector3(-570.2, -204.5, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = -60.2,
				objCoords  = vector3(-569.6, -205.6, 38.4),
			},

			{
				objName = -384927587,
				objYaw = 119.5,
				objCoords  = vector3(-570.9, -203.4, 38.4)
			}
		}
	},

	-- {
	-- 	objName = 'apa_heist_apart2_door',
	-- 	objCoords  = vector3(-560.7, -196.8, 38.4),
	-- 	textCoords = vector3(-561.6, -197.3, 38.2),
	-- 	authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
	-- 	objYaw = 29.8,
	-- 	locked = true,
	-- },

	{
		textCoords = vector3(-556.2, -196.5, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = 119.6,
				objCoords  = vector3(-557.0, -195.4, 38.4),
			},

			{
				objName = -384927587,
				objYaw = -59.6,
				objCoords  = vector3(-555.7, -197.6, 38.4)
			}
		}
	},

	{
		textCoords = vector3(-511.7, -205.3, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'v_ilev_ra_door2',
				objYaw = -149.5,
				objCoords  = vector3(-510.4, -204.8, 38.4),
			},

			{
				objName = 'v_ilev_ra_door2',
				objYaw = 29.6,
				objCoords  = vector3(-512.7, -206.1, 38.4)
			}
		}
	},

	{
		objName = 'v_ilev_ra_door2',
		objCoords  = vector3(-520.5, -181.1, 38.4),
		textCoords = vector3(-521.4, -181.5, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		objYaw = -150.1,
		locked = true,
	},

	{
		objName = 'v_ilev_ra_door2',
		objCoords  = vector3(-528.2, -185.6, 38.4),
		textCoords = vector3(-527.4, -185.1, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		objYaw = 30.0,
		locked = true,
	},

	{
		textCoords = vector3(-534.0, -167.2, 38.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -29187315,
				objYaw = -151.1,
				objCoords  = vector3(-534.9, -167.7, 38.5),
			},

			{
				objName = -29187315,
				objYaw = 29.7,
				objCoords  = vector3(-533.0, -166.6, 38.5)
			}
		}
	},

	{
		textCoords = vector3(-546.1, -190.7, 38.2),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = -59.8,
				objCoords  = vector3(-545.6, -191.8, 38.4),
			},

			{
				objName = -384927587,
				objYaw = 119.5,
				objCoords  = vector3(-546.8, -189.6, 38.4)
			}
		}
	},

	{
		textCoords = vector3(-560.7, -201.2, 42.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'apa_heist_apart2_door',
				objYaw = -150.0,
				objCoords  = vector3(-561.8, -201.9, 42.9),
			},

			{
				objName = 'apa_heist_apart2_door',
				objYaw = 30.0,
				objCoords  = vector3(-559.5, -200.6, 42.9)
			}
		}
	},

	{
		textCoords = vector3(-556.2, -196.5, 42.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = -60.2,
				objCoords  = vector3(-555.7, -197.6, 42.8),
			},

			{
				objName = -384927587,
				objYaw = 120.1,
				objCoords  = vector3(-557.0, -195.4, 42.8)
			}
		}
	},

	{
		textCoords = vector3(-534.0, -185.7, 42.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = 'apa_heist_apart2_door',
				objYaw = -149.8,
				objCoords  = vector3(-535.0, -186.5, 42.8),
			},

			{
				objName = 'apa_heist_apart2_door',
				objYaw = 29.8,
				objCoords  = vector3(-532.7, -185.2, 42.9)
			}
		}
	},

	{
		textCoords = vector3(-546.0, -190.5, 42.7),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = 119.9,
				objCoords  = vector3(-546.6, -189.5, 42.8),
			},

			{
				objName = -384927587,
				objYaw = -60.2,
				objCoords  = vector3(-545.4, -191.7, 42.8)
			}
		}
	},

	{
		textCoords = vector3(-546.4, -191.2, 47.5),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = 119.2,
				objCoords  = vector3(-547.1, -190.2, 47.7),
			},

			{
				objName = -384927587,
				objYaw = -60.3,
				objCoords  = vector3(-545.9, -192.4, 47.7)
			}
		}
	},

	{
		textCoords = vector3(-555.0, -196.2, 47.5),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		locked = true,
		distance = 2.5,
		doors = {
			{
				objName = -384927587,
				objYaw = 121.9,
				objCoords  = vector3(-555.6, -195.1, 47.7),
			},

			{
				objName = -384927587,
				objYaw = -60.4,
				objCoords  = vector3(-554.4, -197.3, 47.7)
			}
		}
	},

	{
		objName = 'v_ilev_ra_door2',
		objCoords  = vector3(-556.5, -190.8, 56.4),
		textCoords = vector3(-556.0, -191.8, 56.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		objYaw = -58.8,
		locked = true,
	},

	{
		objName = 'v_ilev_ra_door2',
		objCoords  = vector3(-556.5, -190.8, 61.1),
		textCoords = vector3(-556.0, -191.7, 60.9),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		objYaw = -60.0,
		locked = true,
	},

	{
		objName = 'v_ilev_ra_door2',
		objCoords  = vector3(-556.5, -190.8, 65.6),
		textCoords = vector3(-556.0, -191.7, 65.5),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		objYaw = -60.0,
		locked = true,
	},
	
	{
		objName = 'v_ilev_ra_door2',
		objCoords  = vector3(-556.5, -190.8, 70.1),
		textCoords = vector3(-556.0, -191.7, 70.0),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod' },
		objYaw = -59.6,
		locked = true,
	},

	-- Sandy EMS Hospital
	{
		textCoords = vector3(1838.5, 3673.9, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'fib', 'doj', 'dod', 'ambulance'},
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'apa_prop_ss1_mpint_door_r',
				objYaw = -150.0,
				objCoords  = vector3(1837.5, 3673.4, 34.8),
			},

			{
				objName = 'apa_prop_ss1_mpint_door_r',
				objYaw = 29.6,
				objCoords  = vector3(1839.4, 3674.4, 34.8)
			}
		}
	},

	{
		objName = 'v_ilev_cor_firedoorwide',
		objCoords  = vector3(1834.0, 3685.7, 34.3),
		textCoords = vector3(1833.5, 3686.6, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod', 'ambulance'},
		objYaw = -60.0,
		locked = true,
	},

	{
		objName = 'v_ilev_cor_firedoorwide',
		objCoords  = vector3(1826.2, 3670.8, 34.3),
		textCoords = vector3(1826.7, 3669.9, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'securoserv', 'fib', 'doj', 'dod', 'ambulance'},
		objYaw = 120.0,
		locked = true,
	},

	{
		textCoords = vector3(1828.5, 3691.1, 34.3),
		authorizedJobs = { 'police', 'state', 'usmarshal', 'sheriff', 'fib', 'doj', 'dod', 'ambulance'},
		locked = false,
		distance = 2.5,
		doors = {
			{
				objName = 'apa_prop_ss1_mpint_door_r',
				objYaw = -150.4,
				objCoords  = vector3(1827.6, 3690.6, 34.8),
			},

			{
				objName = 'apa_prop_ss1_mpint_door_r',
				objYaw = 29.9,
				objCoords  = vector3(1829.5, 3691.7, 34.8)
			}
		}
	},

	-- Cypress Flats Repair Shop
	{
		objName = 'v_ilev_cm_door1',
		objCoords  = vector3(971.0, -1849.4, 31.4),
		textCoords = vector3(969.9, -1849.3, 31.3),
		authorizedJobs = { 'cypress' },
		objYaw = -5.4,
		locked = true,
	},

	{
		objName = 'v_ilev_cm_door1',
		objCoords  = vector3(968.7, -1836.4, 31.4),
		textCoords = vector3(967.7, -1836.0, 31.3),
		authorizedJobs = { 'cypress' },
		objYaw = -5.5,
		locked = true,
	},

	{
		objName = 'v_ilev_vag_door',
		objCoords  = vector3(968.4, -1829.7, 31.4),
		textCoords = vector3(967.4, -1829.6, 31.3),
		authorizedJobs = { 'cypress' },
		objYaw = -5.6,
		locked = true,
	},
}