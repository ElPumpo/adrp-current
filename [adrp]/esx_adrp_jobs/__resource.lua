resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX ADRP Jobs'

version '0.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'config/fishing.lua',
	'config/fueler.lua',
	'config/mining.lua',
	'server/main.lua',
	'server/jobs/fishing.lua',
	--'server/jobs/fueler.lua',
	'server/jobs/mining.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'config/fishing.lua',
	'config/fueler.lua',
	'config/mining.lua',
	'client/main.lua',
	'client/jobs/fishing.lua',
	--'client/jobs/fueler.lua',
	'client/jobs/mining.lua',
	'client/utils/ui.lua'
}

this_is_a_map 'true'

dependency 'es_extended'