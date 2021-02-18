ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('beer', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	xPlayer.removeInventoryItem('beer', 1)

	TriggerClientEvent('esx_status:add', playerId, 'drunk', 200000)
	TriggerClientEvent('esx_status:add', playerId, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', playerId, 'prop_amb_beer_bottle')
	TriggerClientEvent('esx:showNotification', playerId, 'You drank a full size beer can.')
end)

ESX.RegisterUsableItem('rhum', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	xPlayer.removeInventoryItem('rhum', 1)

	TriggerClientEvent('esx_status:add', playerId, 'drunk', 300000)
	TriggerClientEvent('esx_status:add', playerId, 'thirst', 200000)
	TriggerClientEvent('esx_basicneeds:onDrink', playerId, 'prop_cs_whiskey_bottle')
	TriggerClientEvent('esx:showNotification', playerId, 'You drank an entire bottle of rhum, you weirdo!')
end)

ESX.RegisterUsableItem('whisky', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	xPlayer.removeInventoryItem('whisky', 1)

	TriggerClientEvent('esx_status:add', playerId, 'drunk', 250000)
	TriggerClientEvent('esx_status:add', playerId, 'thirst', 150000)
	TriggerClientEvent('esx_basicneeds:onDrink', playerId, 'prop_cs_whiskey_bottle')
	TriggerClientEvent('esx:showNotification', playerId, 'You drank a complete bottle of whisky, ugh!')
end)

ESX.RegisterUsableItem('jagerbomb', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	xPlayer.removeInventoryItem('jagerbomb', 1)

	TriggerClientEvent('esx_status:add', playerId, 'drunk', 400000)
	TriggerClientEvent('esx_status:add', playerId, 'thirst', 10000)
	TriggerClientEvent('esx_basicneeds:onDrink', playerId, 'prop_cs_whiskey_bottle')
	TriggerClientEvent('esx:showNotification', playerId, 'You shotted a jager bomb mini bottle')
end)