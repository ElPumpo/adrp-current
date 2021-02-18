resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Jail'

version '1.1.0'

server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'server/jail.lua',
	'server/breakout.lua',
	'server/anticheat.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'client/jail.lua',
	'client/breakout.lua'
}

dependencies {
	'es_extended',
	'fivem-blipapi'
}