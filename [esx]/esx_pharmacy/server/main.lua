ESX = nil
local ItemLabels, onlineMedics = {}, 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i = 1, #result, 1 do
			ItemLabels[result[i].name] = result[i].label
		end
	end)
end)

AddEventHandler('esx_ambulancejob:updateAvailableUnits', function(availableUnits)
	onlineMedics = ESX.Table.SizeOf(availableUnits)
end)

RegisterServerEvent('esx_pharmacy:buyItem')
AddEventHandler('esx_pharmacy:buyItem', function(itemName, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(itemName, 1)

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(account)
			account.addMoney(price)
		end)

		TriggerClientEvent('esx:showNotification', _source, _U('bought') .. ItemLabels[itemName])
	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
	end
end)

RegisterServerEvent('esx_pharmacy:removeItem')
AddEventHandler('esx_pharmacy:removeItem', function(itemName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(itemName, 1)
end)

ESX.RegisterUsableItem('firstaidkit', function(source)
	if onlineMedics == 0 then
		TriggerClientEvent('esx_pharmacy:useKit', source, 'firstaidkit', 4)
	else
		TriggerClientEvent('esx:showNotification', source, _U('has_ambulance'))
	end
end)

ESX.RegisterUsableItem('defibrillateur', function(source)
	if onlineMedics == 0 then
		TriggerClientEvent('esx_pharmacy:onUseDefibrillateur', source)
	else
		TriggerClientEvent('esx:showNotification', source, _U('has_ambulance'))
	end
end)