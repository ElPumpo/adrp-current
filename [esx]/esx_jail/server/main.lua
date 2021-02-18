ESX = nil
playersInJail, jailBreak, jailBreakCooldown, breakoutPlayer, playerName, availablePolice = {}, false, false, nil, {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	playerName[character.playerId] = character.fullname
	TriggerClientEvent('esx_jail:updatePlayersInJail', character.playerId, ESX.Table.SizeOf(playersInJail))
	TriggerClientEvent('esx_jail:updateCooldownStatus', character.playerId, jailBreakCooldown)
end)

AddEventHandler('playerDropped', function(reason)
	playerName[source] = nil
	playersInJail[source] = nil
	availablePolice[source] = nil

	TriggerClientEvent('esx_jail:updatePlayersInJail', -1, ESX.Table.SizeOf(playersInJail))
end)

MySQL.ready(function()
	local xPlayers, xPlayer = ESX.GetPlayers()

	for i=1, #xPlayers do
		Citizen.Wait(1000)
		xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		playerName[xPlayer.source] = xPlayer.name

		MySQL.Async.fetchAll('SELECT jail_time FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local jailTime = result[1].jail_time

			if jailTime > 0 then
				TriggerEvent('esx_jail:charAddPlayer', xPlayer.source, jailTime)
			end
		end)
	end
end)