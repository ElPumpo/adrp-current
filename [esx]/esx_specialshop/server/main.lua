ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj 
end)

ESX.RegisterServerCallback('revenge-specialshop:buyItem', function(source, callback, itemName, amount, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getMoney() >= price then
			xPlayer.addInventoryItem(itemName, amount)
			xPlayer.removeMoney(price)

			callback(true)
		else
			callback(false)
		end
	end
end)

ESX.RegisterServerCallback('revenge-specialshop:buyBulletproofVest', function(source, callback, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			callback(true)
		else
			callback(false)
		end
	end
end)
