resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX QTE Events'

dependency 'es_extended'

client_script 'client.lua'

ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/style.css',
	'html/main.js'
}