-- jail command
TriggerEvent('es:addGroupCommand', 'jail', 'admin', function(source, args, user)
	if args[1] and GetPlayerName(args[1]) and tonumber(args[2]) then
		TriggerEvent('esx_jail:sendPlayerToJail', tonumber(args[1]), tonumber(args[2] * 60))
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID or jail time!' } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Put a player in jail', params = {{name = 'playerId', help = 'player id'}, {name = 'time', help = 'jail time in minutes'}}})

-- unjail
TriggerEvent('es:addGroupCommand', 'unjail', 'admin', function(source, args, user)
	if args[1] then
		if GetPlayerName(args[1]) then
			unjailPlayer(tonumber(args[1]))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID!' } } )
		end
	else
		TriggerEvent('esx_jail:unjailQuest', source)
		unjailPlayer(source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Unjail people from jail', params = {{name = 'playerId', help = 'player id'}}})

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for playerId,timeRemaining in pairs(playersInJail) do
			playersInJail[playerId] = timeRemaining - 1

			if timeRemaining < 1 then
				unjailPlayer(playerId, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000 * 60 * 5)
		local tasks = {}

		for playerId,timeRemaining in pairs(playersInJail) do
			local task = function(cb)
				MySQL.Async.execute('UPDATE users SET jail_time = @time_remaining WHERE identifier = @identifier', {
					['@identifier'] = GetPlayerIdentifiers(playerId)[1],
					['@time_remaining'] = timeRemaining
				}, function(rowsChanged)
					cb(rowsChanged)
				end)
			end

			table.insert(tasks, task)
		end

		Async.parallelLimit(tasks, 4, function(results) end)
	end
end)

AddEventHandler('esx_jail:charAddPlayer', function(playerId, jailTime)
	TriggerClientEvent('esx_jail:jail', playerId, jailTime)
	playersInJail[playerId] = jailTime
	TriggerClientEvent('esx_jail:updatePlayersInJail', -1, ESX.Table.SizeOf(playersInJail))
end)

-- send to jail and register in database
RegisterNetEvent('esx_jail:sendPlayerToJail')
AddEventHandler('esx_jail:sendPlayerToJail', function(playerId, jailTime)
	local identifier = GetPlayerIdentifiers(playerId)[1]

	MySQL.Async.execute('UPDATE users SET jail_time = @jailTime WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@jailTime'] = jailTime
	})

	TriggerClientEvent('chat:addMessage', -1, { templateId = 'jail', args = { _U('jailed_msg', playerName[playerId], ESX.Math.Round(jailTime / 60)) } })

	TriggerClientEvent('esx_policejob:unrestrain', playerId)
	TriggerClientEvent('esx_jail:jail', playerId, jailTime)
	playersInJail[playerId] = jailTime
	TriggerClientEvent('esx_jail:updatePlayersInJail', -1, ESX.Table.SizeOf(playersInJail))

	local sourceIdentifier, sourceLabel

	if source ~= '' and source > 0 then
		sourceIdentifier, sourceLabel = GetPlayerIdentifiers(source)[1], source
	else
		sourceIdentifier, sourceLabel = 'n/a', 'admin command command/console'
	end

	local message = (('**Source:** %s | %s\n**Target:** %s | %s\n**Jail Time:** %s minutes'):format(sourceLabel, sourceIdentifier, playerId, identifier, jailTime))

	TriggerEvent('adrp_anticheat:sendLog', message, 'Player Sent To Jail')
end)

function unjailPlayer(playerId, quiet)
	local identifier = GetPlayerIdentifiers(playerId)[1]

	MySQL.Async.execute('UPDATE users SET jail_time = @jailTime WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@jailTime'] = 0
	})

	if not quiet then
		TriggerClientEvent('chat:addMessage', -1, { templateId = 'jail', args = { _U('unjailed', playerName[playerId])} })
	end

	TriggerClientEvent('esx_jail:unjail', playerId)
	playersInJail[playerId] = nil
	TriggerClientEvent('esx_jail:updatePlayersInJail', -1, ESX.Table.SizeOf(playersInJail))
end