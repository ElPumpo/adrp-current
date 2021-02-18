resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Scoreboard'

version '1.0.0'

server_script 'server/main.lua'

client_scripts {
	'client/main.lua',
	'client/id.lua',
	'client/api.lua'
}

ui_page 'html/scoreboard.html'

files {
	'html/scoreboard.html',
	'html/style.css',
	'html/listener.js'
}