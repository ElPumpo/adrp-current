resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'common/server.lua', -- common
	'drugs/server.lua',
	'heli/server.lua',
	'luxart/server.lua',
	'trains/server.lua',
	'aircraft/server.lua',
	'aircraft/config.lua',
	'customs/server.lua',
	'indicators/server.lua',
	'fishing/server.lua',
	--'chopshop/server.lua',
	--'DuckHunt/server.lua',
	'radars/server.lua',
}

client_scripts {
	'common/client.lua', -- common
	'trains/client.lua',
	'luxart/client.lua',
	'drugs/client.lua',
	'heli/client.lua',
	'PoliceVehiclesWeaponDeleter/client.lua',
	'streetLabel/client.lua',
	'warehouses/warehouses.lua',
	'announcements/client.lua',
	'chasse/client.lua',
	'aircraft/client.lua',
	'aircraft/config.lua',
	'customs/menu.lua',
	'customs/client.lua',
	'customs/config.lua',
	'indicators/client.lua',
	'fishing/client.lua',
	'teleport/client.lua',
	'blackout/config.lua',
	'blackout/client.lua',
	'radars/client.lua',
}

export 'checkJail'