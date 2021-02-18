ESX.RegisterUsableItem('fishing_rod', function(source)
	TriggerClientEvent('esx_fishing:startFishing', source)
end)

ESX.RegisterUsableItem('fish', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('fish', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 140000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx_fishing:onEatFish', source)
	TriggerClientEvent('esx:showNotification', source, 'You have ate 1x ~b~fish~s~')
end)

RegisterServerEvent('esx_fishing:caughtFish')
AddEventHandler('esx_fishing:caughtFish', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('fish', 1)
end)

--[[
RegisterServerEvent('fishing:startSell')
AddEventHandler('fishing:startSell', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local fishQuantity = xPlayer.getInventoryItem('fish').count
	local earned = math.random(25, 50)

	if fishQuantity > 0 then
		xPlayer.removeInventoryItem('fish', 1)
		xPlayer.addMoney(earned)
		TriggerClientEvent('esx:showNotification', _source, 'You sold a ~b~fish~s~ for ~g~$'..earned)
	else
		TriggerClientEvent('esx:showNotification', _source, 'You dont have any fish to sell.')
	end
end)
]]