resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Advanced Fuel'

server_scripts {
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/notifs.lua',
	'client/map.lua',
	'client/main.lua',
	'client/GUI.lua'
}

export 'getFuel'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js'
}