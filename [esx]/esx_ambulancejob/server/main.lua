ESX = nil
local playersHealing, deadPlayers, availableUnits = {}, {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = true

	TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
end)

RegisterServerEvent('esx_ambulancejob:onPlayerSpawn')
AddEventHandler('esx_ambulancejob:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end

	if availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_ambulancejob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_ambulancejob:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	if lastJob.name == 'ambulance' and job.name ~= 'ambulance' and availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_ambulancejob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_ambulancejob:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_ambulancejob:updateAvailableUnits', character.playerId, availableUnits)
end)

RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job, name, grade)
	if job == 'ambulance' then
		if not availableUnits[source] then
			availableUnits[source] = {name = name, grade = grade}
			TriggerClientEvent('esx_ambulancejob:updateAvailableUnits', -1, availableUnits)
			TriggerClientEvent('esx_ambulancejob:setDeadPlayers', source, deadPlayers)
			TriggerEvent('esx_ambulancejob:updateAvailableUnits', availableUnits)
			TriggerEvent('esx_addons_gcphone:addSource', 'ambulance', source)
		end
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	if availableUnits[source] then
		availableUnits[source] = nil
		TriggerClientEvent('esx_ambulancejob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_ambulancejob:updateAvailableUnits', availableUnits)
		TriggerEvent('esx_addons_gcphone:removeSource', 'ambulance', source)
	end
end)

RegisterServerEvent('esx_ambulancejob:revivePlayer')
AddEventHandler('esx_ambulancejob:revivePlayer', function(playerId, award)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer and xPlayer.job.name == 'ambulance' and availableUnits[source] then
		if award then
			local xTarget = ESX.GetPlayerFromId(playerId)

			if xTarget then
				xPlayer.addMoney(Config.ReviveReward)
				xPlayer.showNotification(_U('revive_complete_award', xTarget.name, Config.ReviveReward))
			else
				xPlayer.showNotification('That player is not online anymore.')
			end
		end
	else
		print(('esx_ambulancejob: %s used :revivePlayer!'):format(xPlayer.identifier))

		if award then
			print('esx_ambulancejob: player attempted to parse award boolean!')
		end
	end

	TriggerClientEvent('esx_ambulancejob:revivePlayer', playerId)
end)

-- old event that is booby trapped
RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	local message = (('**Source:** %s | %s'):format(source, identifier))
	print(message)
	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_ambulancejob: source ran booby trapped event esx_ambulancejob:revive')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterServerEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(playerId, notify)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', playerId)

		if notify then
			local xTarget = ESX.GetPlayerFromId(playerId)
			xPlayer.showNotification(_U('heal_complete', xTarget.name))
		end
	else
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :heal!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_ambulancejob:drag')
AddEventHandler('esx_ambulancejob:drag', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:drag', playerId, source)
	else
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :drag!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_ambulancejob:runRagdoll')
AddEventHandler('esx_ambulancejob:runRagdoll', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('adrp_fix:ragdoll', playerId)
	else
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :runRagdoll!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', playerId)
	else
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :putInVehicle!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_ambulancejob:putOutVehicle')
AddEventHandler('esx_ambulancejob:putOutVehicle', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putOutVehicle', playerId)
	else
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :putOutVehicle!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

TriggerEvent('esx_phone:registerNumber', 'ambulance', _U('alert_ambulance'), true, true)

TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	if Config.RemoveItemsAfterRPDeath then
		for i=1, #xPlayer.inventory, 1 do
			if xPlayer.inventory[i].count > 0 then
				xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
			end
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			xPlayer.removeWeapon(xPlayer.loadout[i].name)
		end
	else -- save weapons & restore em' since spawnmanager removes them
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterServerEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to exploit the shop (invalid vehicle model)!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
		cb(false)
	end

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, real_owner, vehicle, plate, type, job, `state`) VALUES (@owner, @real_owner, @vehicle, @plate, @type, @job, @state)', {
			['@owner'] = xPlayer.identifier,
			['@real_owner'] = xPlayer.identifier,
			['@vehicle'] = json.encode(vehicleProps),
			['@plate'] = vehicleProps.plate,
			['@type'] = type,
			['@job'] = xPlayer.job.name,
			['@state'] = true
		}, function (rowsChanged)
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE real_owner = @real_owner AND plate = @plate AND job = @job', {
			['@real_owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `state` = true WHERE real_owner = @real_owner AND plate = @plate AND job = @job', {
			['@real_owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_ambulancejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				TriggerEvent('esx_adrp_vehicle:dropTargetKey', xPlayer.source, foundPlate)
				TriggerEvent('esx_adrp_vehicle:clearTrunkInventory', foundPlate)
				cb(true, foundNum)
			end
		end)
	end

end)

function getPriceFromHash(hashKey, jobGrade, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = Config.AuthorizedVehicles[jobGrade]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

RegisterServerEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_bandage'))
	elseif item == 'medikit' then
		TriggerClientEvent('esx:showNotification', _source, _U('used_medikit'))
	end
end)

RegisterServerEvent('esx_ambulancejob:giveItem')
AddEventHandler('esx_ambulancejob:giveItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer or xPlayer.job.name ~= 'ambulance' then
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :giveItem (not medic)!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
		return
	elseif (itemName ~= 'medikit' and itemName ~= 'bandage') then
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :giveItem with invalid arguments!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
		return
	end

	local xItem = xPlayer.getInventoryItem(itemName)
	local count = 1

	if xItem.limit ~= -1 then
		count = xItem.limit - xItem.count
	end

	if xItem.count < xItem.limit then
		xPlayer.addInventoryItem(itemName, count)
	else
		TriggerClientEvent('esx:showNotification', source, _U('max_item'))
	end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'mod', function(source, args, user)
	if args[1] ~= nil then
		if tonumber(args[1]) then
			if GetPlayerName(tonumber(args[1])) ~= nil then
				TriggerClientEvent('esx_ambulancejob:revivePlayer', tonumber(args[1]))
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
			end
		elseif args[1] == 'all' then
			TriggerClientEvent('esx_ambulancejob:revivePlayer', -1)
		end
	else
		TriggerClientEvent('esx_ambulancejob:revivePlayer', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = 'Admin revive a dead player', params = {{ name = 'playerId', help = "Either 'playerId' or 'all' to revive everyone"}} })

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

RegisterServerEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local identifier = GetPlayerIdentifiers(source)[1]

	if type(isDead) ~= 'boolean' then
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_ambulancejob: player attempted to run event :setDeathStatus with argument type other than boolean!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
		return
	end

	MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@isDead'] = isDead
	})
end)
