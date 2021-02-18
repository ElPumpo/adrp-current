ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord(url, message, title, color)
	local embeds = {{
		description = message,
		type = 'rich',
		color = color or Config.WebHookColors.grey
	}}

	PerformHttpRequest(url, function(err, text, headers) end, 'POST', json.encode({username = title, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('adrp_anticheat:cheaterDetected', function(message, title, color)
	sendToDiscord(Config.AntiCheatWebHook, message, title, color)
end)

AddEventHandler('adrp_anticheat:sendLog', function(message, title, color)
	sendToDiscord(Config.LogWebHook, message, title, color)
end)

AddEventHandler('adrp:onPlayerKicked', function(targetIdentifierList, targetPlayerName, kickReason, sourceIdentifier, sourcePlayerName)
	local message = ('**Player Name:** %s\n**Kick Reason:** %s\n**Player Identifier List:**\n%s\n\n**Staff Name:** %s\n**Staff Identifier:** %s'):format(targetPlayerName, kickReason, targetIdentifierList, sourcePlayerName, sourceIdentifier)
	sendToDiscord(Config.KickLogWebHook, message, 'Player Kicked', Config.WebHookColors.orange)
end)

AddEventHandler('adrp:onPlayerBanned', function(targetIdentifierList, targetPlayerName, banReason, sourceIdentifier, sourcePlayerName, bannedUntil)
	local message = ('**Player Name:** %s\n**Ban Reason:** %s\n**Banned Until:** %s\n**Player Identifier List:**\n%s\n**Staff Name:** %s\n**Staff Identifier:** %s'):format(targetPlayerName, banReason, bannedUntil, targetIdentifierList, sourcePlayerName, sourceIdentifier)
	sendToDiscord(Config.BanLogWebHook, message, 'Player Banned', Config.WebHookColors.orange)
end)

function sanitize(str)
	local replacements = {
		['<'] = '',
		['>'] = ''
	}

	return str:gsub('[<>]', replacements)
end

AddEventHandler('playerConnecting', function(playerName, setCallback, deferrals)
	deferrals.defer()
	local playerId = source
	Citizen.Wait(300)

	local sanitizedName, invalidChars = sanitize(playerName)

	if playerName == sanitizedName then
		deferrals.done()
	else
		local ids = ''

		for index,id in pairs(GetPlayerIdentifiers(playerId)) do
			ids = ('%s %s'):format(ids, id)
		end

		local message = ('**Identifiers:**\n%s\n**Player Name:** %s'):format(ids, playerName)
		sendToDiscord(Config.LogWebHook, message, 'Rejected Scripter Connection')

		print('adrp_anticheat: rejected playerConnecting due to player name blacklist')
		deferrals.done('Your name contains blacklisted characters: < or >')
	end
end)