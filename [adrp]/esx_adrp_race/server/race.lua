local raceNum, raceBusy, playersInRace, playersFinished, playersFinishedNum, startTime, playersReady, hasWarnedPlayers = nil, false, {}, {}, 0, 0, 0, false
raceStarted = false
--[[
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000 * 1)
			math.randomseed(GetGameTimer())
			--math.random(1, 50) == 25

			if true and not raceBusy then
				--raceNum = math.random(1, #Config.Races)
				raceNum = 2
				TriggerEvent('esx_adrp_race:notifyRace')
			elseif raceBusy then
				Citizen.Wait(1000 * 60 * 30) -- wait 30 mins
			end
		end
	end)

]]

RegisterNetEvent('es:updatePositions')
AddEventHandler('es:updatePositions', function(x, y, z)
	if playersInRace[source] then
		playersInRace[source].coords = {ESX.Math.Round(x, 1), ESX.Math.Round(y, 1), ESX.Math.Round(z, 1)}
	end
end)

RegisterCommand('race_start', function(source, args, rawCommand)
	if source == 0 then
		raceNum = 1
		TriggerEvent('esx_adrp_race:notifyRace')
	end
end, true)

AddEventHandler('esx_adrp_race:notifyRace', function()
	raceBusy = true

	TriggerClientEvent('esx_adrp_race:notifyRace', -1, raceNum)

	local currentRace = Config.Races[raceNum]
	local halfTime, minReward = currentRace.timerTilStart / 2, currentRace.rewards.min
	local min, sec = SecondsToClock(halfTime / 1000)

	Citizen.Wait(halfTime)

	TriggerClientEvent('esx:showAdvancedNotification', -1, _U('race_noti_title'), _U('race_noti_subject'), _U('race_noti_msg', raceNum, min, sec, ESX.Math.GroupDigits(minReward)), 'CHAR_CARSITE', 8)

	Citizen.Wait(halfTime)

	raceStarted = true

	if ESX.Table.SizeOf(playersInRace) >= currentRace.players.min then
		for k,v in pairs(playersInRace) do
			local pointNum = GetAvailableSpawn()
			TriggerClientEvent('esx_adrp_race:prepareRace', k, pointNum)
			TriggerClientEvent('esx_adrp_race:addPlayerBlips', k, playersInRace)

			playersInRace[k].cp = 0
		end

		Citizen.Wait(800 * 4) -- see scaleform for countdown
		startTime = os.clock()
	else
		TriggerClientEvent('esx:showNotification', -1, _U('race_canceled_players', raceNum))
		TriggerClientEvent('esx_adrp_race:concludeRace', -1)
	end
end)

RegisterNetEvent('esx_adrp_race:onPlayerReady')
AddEventHandler('esx_adrp_race:onPlayerReady', function()
	local playerIdentifier = GetPlayerIdentifiers(source)[1]

	if not playersInRace[source] then
		print(('esx_adrp_race: %s triggered onPlayerReady but not in race!'):format(playerIdentifier))
		return
	end

	playersReady = playersReady + 1

	if playersReady == ESX.Table.SizeOf(playersInRace) then
		TriggerEvent('esx_adrp_race:startRace')
	end
end)

AddEventHandler('esx_adrp_race:startRace', function()
	Citizen.Wait(2000)

	for i=3, 0, -1 do
		TriggerClientEvent('esx_adrp_race:drawCountdown', -1, i)

		if i > 0 then
			Citizen.Wait(800)
		end
	end

	TriggerClientEvent('esx_adrp_race:startRace', -1)
	StartAsyncCalculatingPositions()
end)

function GetAvailableSpawn()
	for k,v in ipairs(Config.Races[raceNum].StartPositions) do
		if v.taken == nil then
			v.taken = true

			return k
		end
	end
end

function StartAsyncCalculatingPositions()
	Citizen.CreateThread(function()
		while raceNum do
			Citizen.Wait(500)
			local position = 0

			for k,v in ESX.Table.Sort(playersInRace, function(t, a, b)
				a = t[a]
				b = t[b]

				-- any of the two finished?
				if a.finished or b.finished then
					if a.finished and not b.finished then
						return true
					elseif b.finished and not a.finished then
						return false
					end

					-- position of finished?
					if a.finished and b.finished then
						if a.place > b.place then
							return true
						elseif b.place > a.place then
							return false
						end
					end
				end

				-- different checkpoints?
				if a.cp > b.cp then
					return true
				elseif b.cp > a.cp then
					return false
				end

				-- compare distance to next checkpoint
				local nextCp = Config.Races[raceNum].CheckPoints[a.cp + 1].coords

				local distanceA = #(vector3(table.unpack(a.coords)) - nextCp)
				local distanceB = #(vector3(table.unpack(b.coords)) - nextCp)

				if distanceA < distanceB then
					return true
				elseif distanceB < distanceA then
					return false
				end
			end) do
				position = position + 1
				TriggerClientEvent('esx_adrp_race:updatePlayerPosition', k, position)
			end
		end
	end)
end

ESX.RegisterServerCallback('esx_adrp_race:playerJoined', function(source, cb)
	if ESX.Table.SizeOf(playersInRace) <= Config.Races[raceNum].players.max then
		if not raceStarted then
			local xPlayer = ESX.GetPlayerFromId(source)

			if xPlayer then
				TriggerClientEvent('esx_adrp_race:playerJoined', -1)
				playersInRace[source] = {name = xPlayer.name}
				cb(true)
			else
				cb(false)
			end
		else
			cb(false)
		end
	else
		cb(false)
	end
end)

RegisterNetEvent('esx_adrp_race:playerLeft')
AddEventHandler('esx_adrp_race:playerLeft', function()
	if playersInRace[source] then
		playersInRace[source] = nil
		TriggerClientEvent('esx_adrp_race:playerLeft', -1)
	end
end)

RegisterNetEvent('esx_adrp_race:onPlayerReachedCheckpoint')
AddEventHandler('esx_adrp_race:onPlayerReachedCheckpoint', function(cp)
	local playerIdentifier = GetPlayerIdentifiers(source)[1]

	if not playersInRace[source] then
		print(('esx_adrp_race: %s triggered onPlayerReachedCheckpoint but not in race!'):format(playerIdentifier))
		return
	end

	playersInRace[source].cp = cp
	TriggerClientEvent('esx_adrp_race:onPlayerReachedCheckpoint', -1, source, cp) -- todo no usage
end)

RegisterNetEvent('esx_adrp_race:onPlayerFinished')
AddEventHandler('esx_adrp_race:onPlayerFinished', function(dnf)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerIdentifier, playerName = xPlayer.identifier, xPlayer.name
	local playerTime = ESX.Math.Round(os.clock() - startTime)

	if not playersInRace[source] then
		print(('esx_adrp_race: %s triggered onPlayerFinished but not in race!'):format(playerIdentifier))
		return
	elseif playersFinished[source] then
		print(('esx_adrp_race: %s triggered onPlayerFinished but has already finished!'):format(playerIdentifier))
		return
	elseif not dnf and playersInRace[source].cp < #Config.Races[raceNum].CheckPoints then
		print(('esx_adrp_race: %s triggered onPlayerFinished but has not reached final check point!'):format(playerIdentifier))
		return
	end

	playersFinishedNum = playersFinishedNum + 1

	playersFinished[source] = {}
	playersFinished[source].place = playersFinishedNum
	playersFinished[source].time = playerTime
	playersFinished[source].name = playerName

	playersInRace[source].finished = true
	playersInRace[source].place = playersFinishedNum

	for k,v in pairs(playersInRace) do
		TriggerClientEvent('esx_adrp_race:onPlayerFinished', k, source, playerName, playersFinishedNum, playerTime)
	end

	if ESX.Table.SizeOf(playersFinished) == ESX.Table.SizeOf(playersInRace) then
		TriggerEvent('esx_adrp_race:concludeRace')
	else
		if not hasWarnedPlayers then
			hasWarnedPlayers = true

			for k,v in pairs(playersInRace) do
				if k ~= source then
					TriggerClientEvent('esx_adrp_race:hurryUp', k) -- todo
				end
			end
		end
	end
end)

AddEventHandler('esx_adrp_race:concludeRace', function()
	TriggerClientEvent('esx_adrp_race:concludeRace', -1)
	local reward = Config.Races[raceNum].rewards

	-- give winner the max reward
	for k,v in pairs(playersFinished) do
		if v.place == 1 then
			local xPlayer = ESX.GetPlayerFromId(k)

			if black then
				xPlayer.addAccountMoney('black_money', reward.max)
			else
				xPlayer.addAccountMoney('bank', reward.max)
			end

			TriggerClientEvent('esx:showNotification', -1, _U('race_winner', v.name, raceNum, ESX.Math.GroupDigits(reward.max)))
			TriggerClientEvent('esx:showHelpNotification', k, _U('race_fairplay'))

			playersFinished[k] = nil
			break
		end
	end

	for k,v in pairs(playersFinished) do
		local xPlayer = ESX.GetPlayerFromId(k)

		local playerReward = ESX.Math.Round(reward.min * v.place / ESX.Table.SizeOf(playersInRace))

		TriggerClientEvent('esx:showNotification', k, _U('race_reward', ESX.Math.GroupDigits(playerReward)))
		TriggerClientEvent('esx:showHelpNotification', k, _U('race_fairplay'))

		if black then
			xPlayer.addAccountMoney('black_money', playerReward)
		else
			xPlayer.addAccountMoney('bank', playerReward)
		end
	end

	TriggerClientEvent('esx_adrp_race:concludeRace', -1)

	-- todo reset all vars
end)