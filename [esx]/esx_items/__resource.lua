resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Items'

dependency 'es_extended'

server_script 'server/main.lua'

client_scripts {
	'client/main.lua',
	'client/binoculars.lua',
	'client/illegal.lua'
}