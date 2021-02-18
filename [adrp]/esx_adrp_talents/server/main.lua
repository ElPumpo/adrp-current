ESX = nil

local playerTalents = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx_adrp_talents:loadPlayer', function(playerId)
	local identifier = GetPlayerIdentifier(playerId, 1)

	MySQL.Async.FetchAll('FETCH * FROM user_talents WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			playerTalents[playerId] = result[1]
			TriggerClientEvent('esx_adrp_talents:loadPlayer', playerId, result[1])
		else
			-- Create missing talent entry... or should we really?!
			MySQL.Async.execute('INSERT INTO user_talents (identifier, available_talents, available_experience, talents) VALUES (@identifier, @available_talents, @available_experience, @talents)', {
				['@identifier'] = identifier,
				['@available_talents'] = 0,
				['@available_experience'] = 0,
				['@talents'] = {}
			}, function(rowsChanged)
				if rowsChanged < 1 then
					print('esx_adrp_talents: failed to create missing entry!')
				end

				TriggerEvent('esx_adrp_talents:loadPlayer', playerId)
			end)
		end
	end)
end)

AddEventHandler('esx_adrp_talents:addExperience', function(playerId, experience)
	local identifier = GetPlayerIdentifier(playerId, 1)

	MySQL.Async.FetchAll('FETCH available_experience, available_talents FROM user_talents WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local sumXP = result[1].available_experience + experience
		local talents = result[1].available_talents

		if sumXP >= Config.MaxXP then
			sumXP = sumXP - Config.MaxXP
			talents = result[1].available_talents + 1
		end

		MySQL.Async.execute('UPDATE user_talents SET available_experience = @available_experience, available_talents = @available_talents WHERE identifier = @identifier', {
			['@identifier'] = identifier,
			['@available_experience'] = sumXP,
			['@available_talents'] = talents
		}, function(rowsChanged)
			playerTalents[playerId].available_experience = sumXP
			playerTalents[playerId].available_talents = talents

			TriggerClientEvent('esx_adrp_talents:addExperience', playerId, sumXP, talents)
		end)
	end)
end)