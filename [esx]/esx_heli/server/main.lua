ESX = nil
local availableUnits = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'heli', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'heli', _U('heli_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'heli', 'heli', 'society_heli', 'society_heli', 'society_heli', {type = 'private'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_helijob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_helijob:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	if lastJob.name == 'heli' and job.name ~= 'heli' and availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_helijob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_helijob:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_helijob:updateAvailableUnits', character.playerId, availableUnits)
end)

RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job, name, grade)
	if job == 'heli' then
		if not availableUnits[source] then
			availableUnits[source] = {name = name, grade = grade}
			TriggerClientEvent('esx_helijob:updateAvailableUnits', -1, availableUnits)
			TriggerEvent('esx_helijob:updateAvailableUnits', availableUnits)
			TriggerEvent('esx_addons_gcphone:addSource', 'heli', source)
		end
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	if availableUnits[source] then
		availableUnits[source] = nil
		TriggerClientEvent('esx_helijob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_helijob:updateAvailableUnits', availableUnits)
		TriggerEvent('esx_addons_gcphone:removeSource', 'heli', source)
	end
end)

RegisterServerEvent('esx_helijob:getStockItem')
AddEventHandler('esx_helijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'heli' then
		print(('esx_helijob: %s attempted to esx_helijob:getStockItem!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_heli', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. item.label)

	end)
end)

ESX.RegisterServerCallback('esx_helijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_heli', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_helijob:putStockItems')
AddEventHandler('esx_helijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'heli' then
		print(('esx_helijob: %s attempted to esx_helijob:putStockItems!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_heli', function(inventory)

		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)

	end)
end)

ESX.RegisterServerCallback('esx_helijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items = xPlayer.inventory

	cb({
		items = items
	})
end)
