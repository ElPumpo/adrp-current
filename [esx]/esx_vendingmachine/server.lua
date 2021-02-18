ESX = nil
local vendingItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM vending_items', {}, function(result)
		vendingItems = result

		Citizen.Wait(500)
		TriggerClientEvent('esx_vendingmachine:relayItems', -1, vendingItems)
	end)
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_vendingmachine:relayItems', character.playerId, vendingItems)
end)

ESX.RegisterServerCallback('esx_vendingmachine:buyItem', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromItem(item)

	if price > 0 then
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, 1)

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
				account.addMoney(price)
			end)
			cb(true)
		end
	else
		print(('esx_vendingmachine: "%s" attempted to buy invalid item "%s"'):format(xPlayer.identifier, item))
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_vendingmachine:modifyItemPrice', function(source, cb, item, newPrice)
	newPrice = ESX.Math.Round(newPrice)
	local price, k = getPriceFromItem(item)

	if price > 0 then
		MySQL.Async.execute('UPDATE vending_items SET price = @price WHERE item = @item', {
			['@price'] = newPrice,
			['@item'] = item
		}, function(rowsChanged)
			vendingItems[k].price = newPrice
			TriggerClientEvent('esx_vendingmachine:relayItems', -1, vendingItems)
			cb(true)
		end)
	else
		print(('esx_vendingmachine: "%s" attempted to buy update item price "%s"'):format(GetPlayerIdentifier(source, 0), item))
		cb(false)
	end
end)

function getPriceFromItem(item)
	for k,v in ipairs(vendingItems) do
		if v.item == item then
			return v.price, k
		end
	end

	return 0
end