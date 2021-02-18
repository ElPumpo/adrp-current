Config = {}

Config.DrawDistance       = 100.0 -- Change the distance before you can see the marker. Less is better performance.
Config.EnableBlips        = true -- Set to false to disable blips.
Config.MarkerType         = 27    -- Change to -1 to disable marker.
Config.MarkerColor        = { r = 255, g = 0, b = 0 } -- Change the marker color.

Config.Locale             = 'en' -- Change the language. Currently available (en or fr).
Config.CooldownMinutes    = 15 -- Minutes between chopping.

Config.CallCops           = true -- Set to true if you want cops to be alerted when chopping is in progress
Config.CallCopsPercent    = 1 -- (min1) if 1 then cops will be called every time=100%, 2=50%, 3=33%, 4=25%, 5=20%.
Config.CopsRequired       = 1

Config.NPCEnable          = true -- Set to false to disable NPC Ped at shop location.
Config.NPCHash			      = 68070371 --Hash of the npc ped. Change only if you know what you are doing.
Config.NPCShop	          = { x = -55.42, y = 6392.8, z = 30.5, h = 46.0 } -- Location of the shop For the npc.

Config.GiveBlack          = true -- Wanna use Blackmoney?


Config.Timer = 10000
Config.DrawDistance       = 100.0 -- Change the distance before you can see the marker. Less is better performance.



Config.CarModels = {
	'blista',
	'tampa3'
}

Config.MechanicPeds = {
	MechanicPed1 = {name = 'Door1', coords = vector3(236.02, -2951.3, 5.88), Model= 's_m_y_xmech_01'},
	MechanicPed2 = {name = 'Door2', coords = vector3(236.02, -2957.3, 5.88), Model= 's_m_y_xmech_02'},
	MechanicPed3 = {name = 'Door3', coords = vector3(236.02, -2954.3, 5.88), Model= 's_m_y_winclean_01'},
	MechanicPed4 = {name = 'Door4', coords = vector3(236.02, -2959.3, 5.88), Model= 's_m_y_xmech_02_mp'}
}

Config.CarSpawns = {
	vector3(187.78, -3031.61, 5.84),

}

Config.Zones = {
	Chopshop = {coords = vector3(246.48, -2948.09, 4.85), name = 'Chop Shop', color = 49, sprite = 225, radius = 100.0, Pos = { x = 246.48, y = -2948.09, z = 5.00}, Size  = { x = 10.0, y = 10.0, z = 0.5 }, }
   --Shop = {coords = vector3(-55.42, 6392.8, 30.5), name = _U('map_blip_shop'), color = 50, sprite = 120, radius = 25.0, Pos = { x = -55.42, y = 6392.8, z = 30.5}, Size  = { x = 3.0, y = 3.0, z = 1.0 }, },
}


Config.ChopLocation = {
	vector3(968.5, -1832.1, 31.3),
}
