ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- IGNORE THE WEBHOOK INSIDE THE CONFIG FILE
local discordWebHook = 'https://discordapp.com/api/webhooks/586576050759139339/WeESvb0fKmKbgpj4olPYBuOysEzLv6qS16WGbdhtkLfIbQM_AjrQXeXXk4C6gPQTpQfr'

function sendToDiscord(title, message, color)
	if message == nil or message == '' then return end

	local embeds = {{
		title = message,
		type = 'rich',
		color = color,
		--footer = {text = 'ADRP BOT'}
	}}

	PerformHttpRequest(discordWebHook, function(err, text, headers)
	end, 'POST', json.encode({username = title, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

-- Send the first notification
sendToDiscord('Server Started', 'The server has been started', Config.green)

-- Event when a player is writing
RegisterNetEvent('_chat:networkMessage')
AddEventHandler('_chat:networkMessage', function(message)
	local identifier = GetPlayerIdentifier(source, 0)
	local msg = ('%s (%s): %s'):format(GetPlayerName(source), identifier, message)
	sendToDiscord('Chat Message', msg, Config.blue)
end)

AddEventHandler('explosionEvent', function(playerId, event)
	local identifier = GetPlayerIdentifier(playerId, 0)
	local msg = ('Started by: %s\nCoords: vector3(%.1f, %.1f, %.1f)'):format(identifier, event.posX, event.posY, event.posZ)
	--sendToDiscord('Explosion Event', msg, Config.orange)
	-- too spammy
end)

-- Event when a player is connecting
RegisterServerEvent('esx:playerconnected')
AddEventHandler('esx:playerconnected', function()
	local playerId = source
	local identifier = GetPlayerIdentifier(playerId, 0)
	sendToDiscord('Player Connected', ('**Player Name:** %s\n**Player ID:** %s\n**SteamHEX:** %s'):format(GetPlayerName(playerId), playerId, identifier), Config.green)
end)

AddEventHandler('playerDropped', function(reason)
	if source < 5000 then -- workaround "reconnecting" id above 60000
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('**Player Name:** %s\n**Reason:** %s\n**Player ID:** %s\n**SteamHEX:** %s'):format(GetPlayerName(source), reason, source, identifier)
		sendToDiscord('Player Disconnected', msg, Config.grey)
	end
end)

RegisterServerEvent('esx_discordbot:onEnteredBlacklistedVehicle')
AddEventHandler('esx_discordbot:onEnteredBlacklistedVehicle', function(spawnName, plate)
	local identifier = GetPlayerIdentifier(source, 0)
	sendToDiscord('Player Entered Blacklisted Vehicle', ('**Vehicle Spawn Name:** %s\n**Vehicle Plate:** %s\n**Player Name:** %s\n**Player ID:** %s\n**SteamHEX:** %s'):format(spawnName, plate, GetPlayerName(source), source, identifier), Config.red)
end)

RegisterServerEvent('esx_discordbot:onEnteredPoliceVehicle')
AddEventHandler('esx_discordbot:onEnteredPoliceVehicle', function(spawnName, plate)
	local identifier = GetPlayerIdentifier(source, 0)
	sendToDiscord('Citizen Entered Police Vehicle (against server rules)', ('**Vehicle Spawn Name:** %s\n**Vehicle Plate:** %s\n**Player Name:** %s\n**Player ID:** %s\n**SteamHEX:** %s'):format(spawnName, plate, GetPlayerName(source), source, identifier), Config.red)
end)

RegisterServerEvent('esx_discordbot:onCarJack')
AddEventHandler('esx_discordbot:onCarJack', function(spawnName, plate)
	local identifier = GetPlayerIdentifier(source, 0)
	sendToDiscord('Player has Jacked Vehicle', ('**Vehicle Spawn Name:** %s\n**Vehicle Plate:** %s\n**Player Name:** %s\n**Player ID:** %s\n**SteamHEX:** %s'):format(spawnName, plate, GetPlayerName(source), source, identifier), Config.purple)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

	if data.killedByPlayer then
		local xKiller = ESX.GetPlayerFromId(data.killerServerId)

		local message = ('**%s** was killed by **%s**\n**Victim SteamHEX:** %s\n**Killer StreamHEX:** %s\n**Distance:** %s units\n**Death cause:** %s'):format(xPlayer.name, xKiller.name, xPlayer.identifier, xKiller.identifier, data.distance, data.deathCause)
		sendToDiscord('Player Died', message, Config.red)
	else
		local message = ('**%s** was killed\n**Victim SteamHEX:** %s\n**Death cause:** %s\n**Killed by self:** %s'):format(xPlayer.name, xPlayer.identifier, data.deathCause, tostring(data.killedBySelf))
		sendToDiscord('Player Died', message, Config.red)
	end
end)
