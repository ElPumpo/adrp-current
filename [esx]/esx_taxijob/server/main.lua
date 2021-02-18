ESX = nil
local availableUnits = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_taxijob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_taxijob:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	if lastJob.name == 'taxi' and job.name ~= 'taxi' and availableUnits[playerId] then
		availableUnits[playerId] = nil
		TriggerClientEvent('esx_taxijob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_taxijob:updateAvailableUnits', availableUnits)
	end
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_taxijob:updateAvailableUnits', character.playerId, availableUnits)
end)

RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job, name, grade)
	if job == 'taxi' then
		if not availableUnits[source] then
			availableUnits[source] = {name = name, grade = grade}
			TriggerClientEvent('esx_taxijob:updateAvailableUnits', -1, availableUnits)
			TriggerEvent('esx_taxijob:updateAvailableUnits', availableUnits)
			TriggerEvent('esx_addons_gcphone:addSource', 'taxi', source)
		end
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	if availableUnits[source] then
		availableUnits[source] = nil
		TriggerClientEvent('esx_taxijob:updateAvailableUnits', -1, availableUnits)
		TriggerEvent('esx_taxijob:updateAvailableUnits', availableUnits)
		TriggerEvent('esx_addons_gcphone:removeSource', 'taxi', source)
	end
end)

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer or xPlayer.job.name ~= 'taxi' then
		local date = os.date('%Y-%m-%d %H:%M')
		local identifier = GetPlayerIdentifiers(source)[1]
		local message = (('esx_taxijob: player attempted to run event :success and is not a taxi employee!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
		print(message)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', message)
		TriggerEvent('adrp_anticheat:banCheater', source)
		return
	end

	math.randomseed(os.time())

	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
	local society

	TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
		society = account
	end)

	if society then
		local playerMoney  = ESX.Math.Round(total / 100 * 70)
		local societyMoney = ESX.Math.Round(total / 100 * 30)

		xPlayer.addMoney(playerMoney)
		society.addMoney(societyMoney)

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned', societyMoney, playerMoney))
	else
		xPlayer.addMoney(total)
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_earned', total))
	end

end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger getStockItem!'):format(xPlayer.identifier))
		return
	end
	
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('esx_taxijob: %s attempted to trigger putStockItems!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)
