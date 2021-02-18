resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Show Identity'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

client_script 'client.lua'

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/carteV3_h.png',
	'html/carteV3_f.png',
	'html/cursor.png'
}