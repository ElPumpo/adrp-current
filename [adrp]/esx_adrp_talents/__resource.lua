resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX ADRP Talent System'

version '0.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

files {
	'main.html',
	'app.js',
	'style.css'
}

ui_page 'html/main.html'

dependency 'es_extended'