resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'K Menu'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	'client/keycontrol.lua',
	'client/handsup.lua',
	'client/pointing.lua',
	'client/crouch.lua',
	'client/animations.lua'
}