resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

ui_page 'web/index.html'

files {
	'config.json',
	'web/index.html',
	'web/script.js',
	'web/style.css'
}