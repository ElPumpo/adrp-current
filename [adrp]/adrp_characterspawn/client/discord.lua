local randomNames = {
	'role-players', 'RDMers', 'robbers', 'gamers',
	'windows updates available', 'Americans', 'scripters', 'cops',
	'cool kids', 'athletes', 'liars', 'DJs',
	'haters', 'bugs', 'bags of gold', 'players in jail',
	'fans', 'developers', 'moderators', 'ddos attacks',
	'garbage bags picked up', 'pirated copies of gta', 'number of crashes', 'active kill zones'
}

function getRandomName()
	local random = GetRandomIntInRange(1, ESX.Table.SizeOf(randomNames))

	return randomNames[random]
end

RegisterNetEvent('adrp_characterspawn:networkDiscordInformation')
AddEventHandler('adrp_characterspawn:networkDiscordInformation', function(identifier, group)
	if identifier == 'steam:1100001183542fe' then
		SetDiscordRichPresenceAssetSmall('verified')
		SetDiscordRichPresenceAssetSmallText('Verified Server Owner')
	elseif identifier == 'steam:110000104ed291c' then
		SetDiscordRichPresenceAssetSmall('verified')
		SetDiscordRichPresenceAssetSmallText('Verified Head Developer')
	else
		if group == 'admin' or group == 'superadmin' then
			SetDiscordRichPresenceAssetSmall('verified')
			SetDiscordRichPresenceAssetSmallText('Verified Administrator')
		elseif group == 'mod' then
			SetDiscordRichPresenceAssetSmall('verified')
			SetDiscordRichPresenceAssetSmallText('Verified Moderator')
		else
			SetDiscordRichPresenceAssetSmall('avatar')
			SetDiscordRichPresenceAssetSmallText(('Regular Player | ID: %s'):format(GetPlayerServerId(PlayerId())))
		end
	end
end)

Citizen.CreateThread(function()
	SetDiscordAppId(627419329788641309)
	SetDiscordRichPresenceAsset('adrp')

	while true do
		Citizen.Wait(3000)
		SetRichPresence(('%s/70 %s'):format(#GetActivePlayers(), getRandomName()))
	end
end)
