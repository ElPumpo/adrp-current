resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ADRP Character Spawn System'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua',
	'client/discord.lua'
}

ui_page 'html/characterspawn/char.html'

loadscreen_manual_shutdown 'yes'

loadscreen 'html/loadingscreen/index.html'

files {
	'html/characterspawn/char.html',
	'html/characterspawn/style.css',
	'html/characterspawn/grid.css',
	'html/characterspawn/main.js',

	'html/loadingscreen/index.html',
	'html/loadingscreen/style.css',
	'html/loadingscreen/adrplogo.png'
}