resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'mapmanager_shared.lua',
	'mapmanager_client.lua'
}

server_scripts {
	'mapmanager_shared.lua',
	'mapmanager_server.lua'
}

server_exports {
	'getCurrentGameType',
	'getCurrentMap',
	'changeGameType',
	'changeMap',
	'doesMapSupportGameType',
	'getMaps',
	'roundEnded'
}