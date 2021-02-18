resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Police Job'

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/en.lua',
	'config.lua',
	'config.vehicles.lua',
	'config.weapons.lua',
	'server/main.lua',
	'server/anticheat.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'config.vehicles.lua',
	'config.weapons.lua',
	'client/main.lua',
	'client/vehicles.lua'
}

export 'inServiceCop'
export 'getJob'