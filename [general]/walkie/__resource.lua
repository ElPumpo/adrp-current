resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


ui_page 'html/walkie.html'

client_scripts {
	'client.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

files {
	'html/walkie.html',
	'html/style.css',
	'html/grid.css',
	'html/main.js',
	'html/mic_click_on.wav',
	'html/mic_click_off.wav',
}