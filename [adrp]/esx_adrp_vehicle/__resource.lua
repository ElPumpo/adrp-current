resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX ADRP Vehicle Managment'

version '1.0.0'

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	'server/lock.lua',
	'server/trunk.lua',
	'common/utils.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	'client/lock.lua',
	'client/trunk.lua',
	'common/utils.lua'
}

dependency 'es_extended'