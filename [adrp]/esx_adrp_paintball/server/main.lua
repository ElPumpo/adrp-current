local playersActive, bluePoints, redPoints, areaOpen = {}, 0, 0, true
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_adrp_paintball:canEnterArea', function(source, cb)
	if #playersActive == 0 and not areaOpen then
		areaOpen = true
	end

	cb(areaOpen)
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source

	for k,v in ipairs(playersActive) do
		if v.playerId == playerId then
			table.remove(playersActive, k)
		end
	end
end)

RegisterServerEvent('esx_adrp_paintball:hasUniform')
AddEventHandler('esx_adrp_paintball:hasUniform', function(team)
	local playerId = source

	table.insert(playersActive, {
		playerId = playerId,
		team = team
	})
end)

RegisterServerEvent('esx_adrp_paintball:hasNoUniform')
AddEventHandler('esx_adrp_paintball:hasNoUniform', function()
	local playerId = source

	for k,v in ipairs(playersActive) do
		if v.playerId == playerId then
			table.remove(playersActive, k)
		end
	end
end)

RegisterServerEvent('esx_adrp_paintball:startGameServer')
AddEventHandler('esx_adrp_paintball:startGameServer', function()
	local playerId = source

	if areaOpen then
		local blueTeam, redTeam = 0, 0

		for k,v in ipairs(playersActive) do
			if v.team == 2 then
				blueTeam = blueTeam + 1
			elseif v.team == 3 then
				redTeam = redTeam + 1
			end
		end

		if blueTeam > 1 and redTeam > 1 then
			if blueTeam - redTeam < 2 and blueTeam - redTeam > -2 then
				TriggerClientEvent('esx_adrp_paintball:startGameClient', -1)
				areaOpen = false
			else
				TriggerClientEvent('esx:showNotification', playerId, _U('game_unbalanced'))
			end
		else
			TriggerClientEvent('esx:showNotification', playerId, _U('game_insufficient_players1'))
			TriggerClientEvent('esx:showNotification', playerId, _U('game_insufficient_players2'))
		end
	else
		TriggerClientEvent('esx:showNotification', playerId, _U('game_busy'))
	end
end)

RegisterServerEvent('esx_adrp_paintball:scorePoint')
AddEventHandler('esx_adrp_paintball:scorePoint', function(team)
	local playerId = source

	if team == 2 then
		if redPoints < 20 then
			redPoints = redPoints + 1
			TriggerClientEvent('esx_adrp_paintball:showNotify', -1, _U('match_score_red', redPoints, bluePoints))
		else
			TriggerClientEvent('esx_adrp_paintball:showNotify', -1, _U('match_win_red'))

			for k,v in ipairs(playersActive) do
				TriggerClientEvent('esx_adrp_paintball:resetGame', v.playerId)
			end

			bluePoints, redPoints, areaOpen, playersActive = 0, 0, true, {}
		end
	end

	if team == 3 then
		if bluePoints < 20 then
			bluePoints = bluePoints + 1
			TriggerClientEvent('esx_adrp_paintball:showNotify', -1, _U('match_score_blue', bluePoints, redPoints))
		else
			TriggerClientEvent('esx_adrp_paintball:showNotify', -1, _U('match_win_blue'))

			for k,v in ipairs(playersActive) do
				TriggerClientEvent('esx_adrp_paintball:resetGame', v.playerId)
			end

			bluePoints, redPoints, areaOpen, playersActive = 0, 0, true, {}
		end
	end
end)

RegisterServerEvent('esx_adrp_paintball:resetEntireGame')
AddEventHandler('esx_adrp_paintball:resetEntireGame', function()
	for k,v in ipairs(playersActive) do
		TriggerClientEvent('esx_adrp_paintball:resetGame', v.playerId)
	end

	TriggerClientEvent('esx_adrp_paintball:showNotify', -1, _U('match_reset'))
	areaOpen, playersActive = true, {}
end)
