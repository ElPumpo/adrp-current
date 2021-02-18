ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Allowed to reset during server restart
-- You can use this number to calculate a vehicle spawn location index if you have multiple
-- eg: 3 spawnlocations = index % 3 + 1
local _UnimpoundedVehicleCount = 1

RegisterServerEvent('HRP:Impound:ImpoundVehicle')
RegisterServerEvent('HRP:Impound:GetImpoundedVehicles')
RegisterServerEvent('HRP:Impound:GetVehicles')
RegisterServerEvent('HRP:Impound:UnimpoundVehicle')
RegisterServerEvent('HRP:Impound:UnlockVehicle')

AddEventHandler('HRP:Impound:ImpoundVehicle', function (form)
	_source = source
	MySQL.Async.execute('INSERT INTO `impounded_vehicles` VALUES (@plate, @officer, @mechanic, @releasedate, @fee, @reason, @notes, CONCAT(@vehicle), @identifier, @hold_o, @hold_m)', {
		['@plate'] 			= form.plate,
		['@officer']     	= form.officer,
		['@mechanic']       = form.mechanic,
		['@releasedate']	= form.releasedate,
		['@fee']			= form.fee,
		['@reason']			= form.reason,
		['@notes']			= form.notes,
		['@vehicle']		= form.vehicle,
		['@identifier']		= form.identifier,
		['@hold_o']			= form.hold_o,
		['@hold_m']			= form.hold_m
	}, function(rowsChanged)
		if (rowsChanged == 0) then
			TriggerClientEvent('esx:showNotification', _source, 'Could not impound')
		else
			TriggerClientEvent('esx:showNotification', _source, 'Vehicle Impounded')
		end
	end)
end)

AddEventHandler('HRP:Impound:GetImpoundedVehicles', function (identifier)
	_source = source
	MySQL.Async.fetchAll('SELECT * FROM `impounded_vehicles` WHERE `identifier` = @identifier ORDER BY `releasedate`', {
		['@identifier'] = identifier,
	}, function (impoundedVehicles)
		TriggerClientEvent('HRP:Impound:SetImpoundedVehicles', _source, impoundedVehicles)
	end)
end)

AddEventHandler('HRP:Impound:UnimpoundVehicle', function (plate)
	_source = source
	xPlayer = ESX.GetPlayerFromId(_source)

	_UnimpoundedVehicleCount = _UnimpoundedVehicleCount + 1

	local veh = MySQL.Sync.fetchAll('SELECT * FROM `impounded_vehicles` WHERE `plate` = @plate', {
		['@plate'] = plate,
	})

	if(veh == nil) then
		TriggerClientEvent("HRP:Impound:CannotUnimpound")
		return
	end

	if (xPlayer.getMoney() < veh[1].fee) then
		TriggerClientEvent("HRP:Impound:CannotUnimpound")
	else
		xPlayer.removeMoney(ESX.Math.Round(veh[1].fee))

		MySQL.Async.execute('DELETE FROM `impounded_vehicles` WHERE `plate` = @plate', {
			['@plate'] = plate,
		}, function (rows)
			TriggerClientEvent('HRP:Impound:VehicleUnimpounded', _source, veh[1], _UnimpoundedVehicleCount)
		end)
	end
end)

AddEventHandler('HRP:Impound:GetVehicles', function ()
	_source = source

	local vehicles = MySQL.Async.fetchAll('SELECT * FROM `impounded_vehicles`', nil, function (vehicles)
		TriggerClientEvent('HRP:Impound:SetImpoundedVehicles', _source, vehicles)
	end)
end)

AddEventHandler('HRP:Impound:UnlockVehicle', function (plate)
	MySQL.Async.execute('UPDATE `impounded_vehicles` SET `hold_m` = false, `hold_o` = false WHERE `plate` = @plate', {
		['@plate'] = plate
	}, function (bs)
		-- Something
	end)
end)

RegisterServerEvent('HRP:ESX:GetVehicleAndOwner')
AddEventHandler('HRP:ESX:GetVehicleAndOwner', function(plate)
	local playerId = source

	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(owner)
		if owner[1] then
			MySQL.Async.fetchAll('SELECT fullname FROM users WHERE identifier = @identifier', {
				['@identifier'] = owner[1].owner
			}, function(player)
				if player[1] then
					owner[1].fullname = player[1].fullname
					owner[1].plate = plate
					TriggerClientEvent('HRP:ESX:SetVehicleAndOwner', playerId, owner[1])
				else
					TriggerClientEvent('HRP:ESX:SetVehicleAndOwner', playerId, nil)
				end
			end)
		else
			TriggerClientEvent('HRP:ESX:SetVehicleAndOwner', playerId, nil)
		end
	end)
end)