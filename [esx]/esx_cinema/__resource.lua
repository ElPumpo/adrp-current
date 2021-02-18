resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Cinema'

version '1.2.0'

server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'locales/en.lua',
	'client/main.lua',
	'client/record.lua',
	'client/bar.lua'
}