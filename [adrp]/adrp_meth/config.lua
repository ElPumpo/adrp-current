Config = {}

-- Police count and name
Config.MinPoliceCount  = 1

-- Minutes
Config.CookTimerA = 0.5 -- prepare ingredients
Config.CookTimerB = 0.5 -- cook meth
Config.CookTimerC = 0.5 -- cool meth
Config.CookTimerD = 0.5 -- package meth

-- The door
Config.HintLocation = vector3(-68.2, -1208.8, 28.1)

-- Possible spawns
Config.TruckLocations = {
	[1] = vector3(1060.2, -2409.2, 29.9),
	[2] = vector3(-1102.3, -2039.8, 13.2),
	[3] = vector3(123.3, -2580.8, 6.0),
}

-- Possible dropoffs
Config.DropoffLocations = {
	[1] = vector3(1372.6, 3617.6, 34.8),
	[2] = vector3(2343.5, 2612.6, 46.6),
	[3] = vector3(-1889.9, 2045.3, 140.8)
}

-- Models
Config.TruckModels = {
	[1] = 'boxville',
	[2] = 'boxville2',
	[3] = 'boxville3',
	[4] = 'boxville4'
}

-- Draw text at this distance
Config.DrawTextDistance = 5.0

-- How long the note hangs around for (when knocking on door)
Config.NotificationTime = 10

-- How long police have to track a notification (seconds)
Config.TrackableNotifyTimer = 15

-- Spawn truck at x meters
Config.TruckSpawnDistance = 50.0

-- Veh speed
Config.MinSpeedtoCook = 10.0

-- Vehicle can stop for x amount of seconds before police get notified
Config.MaxVehicleStopTime = 30
