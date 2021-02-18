ESX = nil

local discordWebHook = 'https://discordapp.com/api/webhooks/646022136896552990/M1DJ_Yag6omiuJH9DQCHVfuSX7U062iEO8NlkhWgN1LuuiqKLaC4h2lPu5BgKni974SE'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.execute('UPDATE owned_vehicles SET state = true WHERE state = false', {}, function(rowsChanged)
		print(('esx_eden_garage: stored %s vehicles in garage!'):format(rowsChanged))
	end)
end)

RegisterNetEvent('esx_eden_garage:sendNulledVehicle')
AddEventHandler('esx_eden_garage:sendNulledVehicle', function(vehicleModel)
	sendToDiscord('Missing vehicle label', vehicleModel, 16711680)
end)

function sendToDiscord(title, message, color)
	if message == nil or message == '' then return end

	local embeds = {{
		title = message,
		type = 'rich',
		color = color,
		footer = {text = 'esx_eden_garage'}
	}}

	PerformHttpRequest(discordWebHook, function(err, text, headers)
	end, 'POST', json.encode({username = title, embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('esx_eden_garage:getVehicles', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT vehicle, state, job, type FROM owned_vehicles WHERE owner = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_eden_garage:storeVehicle',function(playerId, cb, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate AND owner = @owner', {
			['@plate'] = vehicleProps.plate,
			['@owner'] = xPlayer.identifier
		}, function(result)
			if result[1] then
				local remoteVehicle = json.decode(result[1].vehicle)

				if vehicleProps.model == remoteVehicle.model then
					MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
						['@vehicle'] = json.encode(vehicleProps),
						['@plate'] = vehicleProps.plate
					}, function(rowsChanged)
						cb(rowsChanged > 0)
					end)
				else
					print(('esx_eden_garage: ignored storeVehicle() due to mismatching model'):format(xPlayer.identifier))
					cb(false)
				end
			else
				cb(false)
			end
		end)

	else
		cb(false)
	end
end)

RegisterNetEvent('esx_eden_garage:modifyState')
AddEventHandler('esx_eden_garage:modifyState', function(vehicleProps, state, vehLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.execute('UPDATE owned_vehicles SET state = @state WHERE plate = @plate AND owner = @owner', {
		['@state'] = state,
		['@plate'] = vehicleProps.plate,
		['@owner'] = xPlayer.identifier
	}, function(rowsChanged)
		if state then
			TriggerEvent('esx_adrp_vehicle:dropTargetKey', _source, vehicleProps.plate)
			TriggerEvent('esx_adrp_vehicle:clearTrunkInventory', vehicleProps.plate)
		else
			if vehLabel then
				TriggerEvent('esx_adrp_vehicle:addKey', _source, vehicleProps.plate, vehLabel)
			end
		end

	end)
end)

ESX.RegisterServerCallback('esx_eden_garage:getOutVehicles', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT vehicle, job, type FROM owned_vehicles WHERE owner = @identifier AND state = false AND owned_vehicles.plate NOT IN (SELECT plate from impounded_vehicles)', {
		['@identifier'] = xPlayer.getIdentifier()
	}, function(result)
		cb(result)
	end)
end)

ESX.RegisterServerCallback('esx_eden_garage:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.Price then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_eden_garage:pay')
AddEventHandler('esx_eden_garage:pay', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('esx:showNotification', source, 'You have paid $' .. Config.Price)
end)

ESX.RegisterServerCallback('esx_eden_garage:payVehicleDamage', function(playerId, cb, price)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		xPlayer.showNotification(('You have paid ~o~$%s~s~ to fix your damaged vehicle.'):format(ESX.Math.GroupDigits(price)))
		cb(true)
	else
		xPlayer.showNotification('~r~You can not afford to fix your damaged vehicle. Try a mechanic')
		cb(false)
	end
end)

RegisterServerEvent('eden_garage:payhealth')
AddEventHandler('eden_garage:payhealth', function(price)
	local date = os.date('%Y-%m-%d %H:%M')
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('eden_garage: %s cheater attempted to run old event :payhealth!'):format(identifier))

	local message = (('eden_garage cheater attempted to run old event :payhealth!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
	TriggerEvent('adrp_anticheat:cheaterDetected', message)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)