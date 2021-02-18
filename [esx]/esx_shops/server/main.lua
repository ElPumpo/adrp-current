ESX = nil
local itemLabels, shopItems = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(itemResult)
		for _,item in ipairs(itemResult) do
			itemLabels[item.name] = item.label
		end

		-- Get shop items
		MySQL.Async.fetchAll('SELECT * FROM shops', {}, function(shopResult)
			for _,item in ipairs(shopResult) do
				if itemLabels[item.item] then
					if not shopItems[item.name] then
						shopItems[item.name] = {}
					end

					table.insert(shopItems[item.name], {
						name  = item.item,
						price = item.price,
						label = itemLabels[item.item]
					})
				else
					print(('esx_shops: ignoring invalid item "%s"'):format(item.name))
				end
			end
		end)
	end)
end)

ESX.RegisterServerCallback('esx_shop:requestDBItems', function(source, cb)
	cb(shopItems)
end)

RegisterServerEvent('esx_shop:buyItem')
AddEventHandler('esx_shop:buyItem', function(itemName, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	if price < 0 then
		return
	end

	-- can the player afford this item?
	if xPlayer.getMoney() >= price then

		-- can the player carry the said amount of x item?
		if sourceItem.limit ~= -1 and (sourceItem.count + 1) > sourceItem.limit then
			TriggerClientEvent('esx:showNotificatioon', _source, _U('player_cannot_hold'))
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('esx:showNotification', _source, _U('bought', itemLabels[itemName], ESX.Math.GroupDigits(price)))
		end
	else
		local missingMoney = price - xPlayer.getMoney()
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough', ESX.Math.GroupDigits(missingMoney)))
	end
end)