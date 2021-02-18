ESX = nil
local playersZipped = {}
local campfireLocations = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('oxycan', function(playerId)
	TriggerClientEvent('esx_items:onUseOxygen', playerId)
end)

RegisterNetEvent('esx_items:onUseOxygen')
AddEventHandler('esx_items:onUseOxygen', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('oxycan', 1)
end)

ESX.RegisterUsableItem('redgull', function(playerId)
	TriggerClientEvent('esx_items:onUseRedgull', playerId)
end)

RegisterNetEvent('esx_items:onUseRedgull')
AddEventHandler('esx_items:onUseRedgull', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('redgull', 1)
end)

ESX.RegisterUsableItem('lockpick', function(playerId)
	TriggerClientEvent('esx_items:onUseLockpick', playerId)
end)

RegisterNetEvent('esx_items:onUseLockpick')
AddEventHandler('esx_items:onUseLockpick', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('lockpick', 1)
end)

ESX.RegisterUsableItem('binoculars', function(playerId)
	TriggerClientEvent('esx_items:toggleBinoculars', playerId)
end)

ESX.RegisterUsableItem('zipties', function(playerId)
	TriggerClientEvent('esx_items:onUseZipties', playerId)
end)

RegisterNetEvent('esx_items:onUseZipties')
AddEventHandler('esx_items:onUseZipties', function(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if playersZipped[targetId] then
		TriggerClientEvent('customNotification', source, 'That player is already zipped up!')
	elseif xPlayer and xPlayer.getInventoryItem('zipties').count > 0 then
		xPlayer.removeInventoryItem('zipties', 1)
		TriggerClientEvent('esx_items:onUseZiptiePlayer', targetId)
		playersZipped[targetId] = true
		TriggerClientEvent('customNotification', source, 'You have consumed a ziptie!')
	else
		print(('esx_items: ignoring onUseZipties from %s due to not having zipties'):format(GetPlayerIdentifier(source, 0)))
	end
end)

ESX.RegisterUsableItem('sack', function(playerId)
	TriggerClientEvent('esx_items:onUseSack', playerId)
end)

RegisterNetEvent('esx_items:onUseSack')
AddEventHandler('esx_items:onUseSack', function(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer and xPlayer.getInventoryItem('sack').count > 0 then
		xPlayer.removeInventoryItem('sack', 1)
		TriggerClientEvent('esx_items:onUseSackPlayer', targetId)
		TriggerClientEvent('customNotification', source, 'You have put a sack over the players head!')

		local identifier = GetPlayerIdentifier(source, 0)
		local message = (('**Source:** %s | %s\n**Target:** %s'):format(source, identifier, targetId))
		TriggerEvent('adrp_anticheat:sendLog', message, 'Player Used Sack')
	else
		print(('esx_items: ignoring onUseSack from %s due to not having sack'):format(GetPlayerIdentifier(source, 0)))
	end
end)

ESX.RegisterUsableItem('pocketknife', function(playerId)
	TriggerClientEvent('esx_items:onUseScissors', playerId)
end)

RegisterNetEvent('esx_items:onUseScissors')
AddEventHandler('esx_items:onUseScissors', function(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not playersZipped[targetId] then
		TriggerClientEvent('customNotification', source, 'That player doesn\'t need your help.')
	elseif xPlayer and xPlayer.getInventoryItem('pocketknife').count > 0 then
		xPlayer.removeInventoryItem('pocketknife', 1)

		Citizen.Wait(5000)
		TriggerClientEvent('esx_items:onUseScissorsPlayer', targetId)
		playersZipped[targetId] = nil
		TriggerClientEvent('customNotification', xPlayer.source, 'You have consumed a pocket knife and freed the player.')
	else
		print(('esx_items: ignoring onUseScissors from %s due to not having scissors'):format(GetPlayerIdentifier(source, 0)))
	end
end)

ESX.RegisterUsableItem('campfire', function(playerId)
	TriggerClientEvent('esx_items:onUseCampfire', playerId)
end)

RegisterNetEvent('esx_items:onUseCampfire')
AddEventHandler('esx_items:onUseCampfire', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('campfire', 1)
end)

RegisterNetEvent('esx_items:relayCampfireLocation')
AddEventHandler('esx_items:relayCampfireLocation', function(campfireCoords)
	table.insert(campfireLocations, campfireCoords)
	TriggerClientEvent('esx_items:relayCampfireLocation', -1, campfireLocations)
end)

ESX.RegisterUsableItem('repairkit', function(playerId)
	TriggerClientEvent('esx_items:onUseRepairKit', playerId)
end)

RegisterNetEvent('esx_items:onUseRepairKit')
AddEventHandler('esx_items:onUseRepairKit', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('repairkit', 1)
end)

ESX.RegisterUsableItem('bodyArmour', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	xPlayer.removeInventoryItem('bodyArmour', 1)
	TriggerClientEvent('esx_items:onUseBodyArmor', playerId)
end)