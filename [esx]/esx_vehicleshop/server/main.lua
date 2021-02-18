ESX = nil
local Categories, Vehicles = {}, {}
local availableUnits = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'cardealer', _U('dealer_customers'), false, false)
TriggerEvent('esx_society:registerSociety', 'cardealer', _U('car_dealer'), 'society_cardealer', 'society_cardealer', 'society_cardealer', {type = 'private'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_vehicleshop:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_vehicleshop:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	if lastJob.name == 'cardealer' and job.name ~= 'cardealer' and availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_vehicleshop:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_vehicleshop:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_vehicleshop:updateAvailableUnits', character.playerId, availableUnits)
end)

RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job, name, grade)
	if job == 'cardealer' then
		if not availableUnits[source] then
			availableUnits[source] = {name = name, grade = grade}
			TriggerClientEvent('esx_vehicleshop:updateAvailableUnits', -1, availableUnits)
			TriggerEvent('esx_vehicleshop:updateAvailableUnits', availableUnits)
			TriggerEvent('esx_addons_gcphone:addSource', 'cardealer', source)
		end
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	if availableUnits[source] then
		availableUnits[source] = nil
		TriggerClientEvent('esx_vehicleshop:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_vehicleshop:updateAvailableUnits', availableUnits)
		TriggerEvent('esx_addons_gcphone:removeSource', 'cardealer', source)
	end
end)

Citizen.CreateThread(function()
	local char = Config.PlateLetters
	char = char + Config.PlateNumbers
	if Config.PlateUseSpace then char = char + 1 end

	if char > 8 then
		print(('esx_vehicleshop: ^1WARNING^7 plate character count reached, %s/8 characters.'):format(char))
	end
end)

function RemoveOwnedVehicle(plate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})
end

MySQL.ready(function()
	Categories     = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categories')
	local vehicles = MySQL.Sync.fetchAll('SELECT * FROM vehicles')

	for i=1, #vehicles, 1 do
		local vehicle = vehicles[i]

		for j=1, #Categories, 1 do
			if Categories[j].name == vehicle.category then
				vehicle.categoryLabel = Categories[j].label
				break
			end
		end

		table.insert(Vehicles, vehicle)
	end

	-- send information after db has loaded, making sure everyone gets vehicle information
	TriggerClientEvent('esx_vehicleshop:sendCategories', -1, Categories)
	TriggerClientEvent('esx_vehicleshop:sendVehicles', -1, Vehicles)
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwned')
AddEventHandler('esx_vehicleshop:setVehicleOwned', function(vehicleProps)
	if availableUnits[source] then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
	
		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, real_owner) VALUES (@owner, @plate, @vehicle, @real_owner)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@real_owner'] = xPlayer.identifier
		}, function(rowsChanged)
			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_belongs', vehicleProps.plate))
		end)
	else
		local identifier = GetPlayerIdentifiers(source)[1]
		print(('esx_vehicleshop: %s is using an lua executor!'):format(identifier))
		local message = (('Source: %s | %s'):format(source, identifier))
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_vehicleshop: lua executor detected (setVehicleOwned)')
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_vehicleshop:setVehicleOwnedPlayerId')
AddEventHandler('esx_vehicleshop:setVehicleOwnedPlayerId', function(playerId, vehicleProps)
	if availableUnits[source] then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, real_owner) VALUES (@owner, @plate, @vehicle, @real_owner)', {
			['@owner']   = xPlayer.identifier,
			['@plate']   = vehicleProps.plate,
			['@vehicle'] = json.encode(vehicleProps),
			['@real_owner'] = xPlayer.identifier
		}, function(rowsChanged)
			TriggerClientEvent('esx:showNotification', playerId, _U('vehicle_belongs', vehicleProps.plate))
		end)
	else
		local identifier = GetPlayerIdentifiers(source)[1]
		print(('esx_vehicleshop: %s is using an lua executor!'):format(identifier))
		local message = (('Source: %s | %s'):format(source, identifier))
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_vehicleshop: lua executor detected (setVehicleOwnedPlayerId)')
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_vehicleshop:sellVehicle')
AddEventHandler('esx_vehicleshop:sellVehicle', function(vehicle)
	if availableUnits[source] then
		MySQL.Async.fetchAll('SELECT id FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
			['@vehicle'] = vehicle
		}, function(result)
			local id = result[1].id
	
			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})
		end)
	else
		print(('esx_vehicleshop: %s attempted to run event :sellVehicle'):format(GetPlayerIdentifier(source, 0)))
	end
end)

RegisterServerEvent('esx_vehicleshop:addToList')
AddEventHandler('esx_vehicleshop:addToList', function(target, model, plate)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)
	local dateNow = os.date('%Y-%m-%d %H:%M')

	if xPlayer.job.name == 'cardealer' then
		MySQL.Async.execute('INSERT INTO vehicle_sold (client, model, plate, soldby, date) VALUES (@client, @model, @plate, @soldby, @date)', {
			['@client'] = xTarget.getName(),
			['@model'] = model,
			['@plate'] = plate,
			['@soldby'] = xPlayer.getName(),
			['@date'] = dateNow
		})
	else
		print(('esx_vehicleshop: %s attempted to add a sold vehicle to list!'):format(xPlayer.identifier))
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:getSoldVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM vehicle_sold', {}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:getStockItem')
AddEventHandler('esx_vehicleshop:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_society'))
		end
	end)
end)

RegisterServerEvent('esx_vehicleshop:putStockItems')
AddEventHandler('esx_vehicleshop:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCategories', function(source, cb)
	cb(Categories)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getVehicles', function(source, cb)
	cb(Vehicles)
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicle', function(source, cb, vehicleModel)
	local xPlayer     = ESX.GetPlayerFromId(source)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	if xPlayer.getMoney() >= vehicleData.price then
		xPlayer.removeMoney(vehicleData.price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vehicleshop:buyVehicleSociety', function(source, cb, society, vehicleModel)
	local vehicleData = nil

	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == vehicleModel then
			vehicleData = Vehicles[i]
			break
		end
	end

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
		if account.money >= vehicleData.price then
			account.removeMoney(vehicleData.price)

			MySQL.Async.execute('INSERT INTO cardealer_vehicles (vehicle, price) VALUES (@vehicle, @price)',
			{
				['@vehicle'] = vehicleData.model,
				['@price']   = vehicleData.price
			}, function(rowsChanged)
				cb(true)
			end)

		else
			cb(false)
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getCommercialVehicles', function(source, cb)
	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles ORDER BY vehicle ASC', {}, function(result)
		local vehicles = {}

		for i=1, #result, 1 do
			table.insert(vehicles, {
				name  = result[i].vehicle,
				price = result[i].price
			})
		end

		cb(vehicles)
	end)
end)

RegisterServerEvent('esx_vehicleshop:returnProvider')
AddEventHandler('esx_vehicleshop:returnProvider', function(vehicleModel)
	local _source = source

	MySQL.Async.fetchAll('SELECT * FROM cardealer_vehicles WHERE vehicle = @vehicle LIMIT 1', {
		['@vehicle'] = vehicleModel
	}, function(result)

		if result[1] then
			local id    = result[1].id
			local price = ESX.Round(result[1].price * 0.75)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_cardealer', function(account)
				account.addMoney(price)
			end)

			MySQL.Async.execute('DELETE FROM cardealer_vehicles WHERE id = @id', {
				['@id'] = id
			})

			TriggerClientEvent('esx:showNotification', _source, _U('vehicle_sold_for', vehicleModel, ESX.Math.GroupDigits(price)))
		else
			
			print(('esx_vehicleshop: %s attempted selling an invalid vehicle!'):format(GetPlayerIdentifiers(_source)[1]))
		end

	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:resellVehicle', function(source, cb, plate, model)
	local resellPrice
	local xPlayer = ESX.GetPlayerFromId(source)

	-- calculate the resell price
	for i=1, #Vehicles, 1 do
		if Vehicles[i].model == model then
			resellPrice = ESX.Math.Round(Vehicles[i].price / 100 * Config.ResellPercentage)
			break
		end
	end

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then -- does the owner match?
			local vehicle = json.decode(result[1].vehicle)

			if vehicle.model == GetHashKey(model) then
				if vehicle.plate == plate then
					xPlayer.addMoney(resellPrice)
					RemoveOwnedVehicle(plate)
					cb(true)
				else
					print(('esx_vehicleshop: %s attempted to sell an vehicle with plate mismatch!'):format(xPlayer.identifier))
					cb(false)
				end
			else
				print(('esx_vehicleshop: %s attempted to sell an vehicle with model mismatch!'):format(xPlayer.identifier))
				cb(false)
			end
		end
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_cardealer', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({ items = items })
end)

ESX.RegisterServerCallback('esx_vehicleshop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)

ESX.RegisterServerCallback('esx_vehicleshop:retrieveJobVehicles', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE real_owner = @owner AND type = @type AND job = @job', {
		['@owner'] = xPlayer.identifier,
		['@type'] = type,
		['@job'] = xPlayer.job.name
	}, function(result)
		cb(result)
	end)
end)

RegisterServerEvent('esx_vehicleshop:setJobVehicleState')
AddEventHandler('esx_vehicleshop:setJobVehicleState', function(plate, state, label)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET state = @state WHERE plate = @plate AND job = @job', {
		['@state'] = state,
		['@plate'] = plate, 
		['@job'] = xPlayer.job.name
	}, function(rowsChanged)
		if rowsChanged > 0 then
			TriggerEvent('esx_adrp_vehicle:addKey', xPlayer.source, plate, label)
		else
			print(('esx_vehicleshop: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)