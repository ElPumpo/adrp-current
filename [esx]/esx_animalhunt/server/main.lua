ESX = nil
local playersSelling = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_animalhunt:harvestReward')
AddEventHandler('esx_animalhunt:harvestReward', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('meat', math.random(1, 2))
end)

ESX.RegisterServerCallback('esx_animalhunt:canAfford', function(source, cb, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_animalhunt:sellMeat', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer and not playersSelling[source] then
		playersSelling[source] = true
		local earned = 0

		for item,value in pairs(Config.MeatMarketPrices) do
			local xItem = xPlayer.getInventoryItem(item)
			earned = earned + (xItem.count * value)
			xPlayer.removeInventoryItem(item, xItem.count)
		end

		if earned > 0 then
			xPlayer.addMoney(earned)
		end

		playersSelling[source] = nil
		cb(earned)
	else
		cb(0)
	end
end)

ESX.RegisterServerCallback('esx_animalhunt:buyHuntingLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= Config.HuntingLicense then
		xPlayer.removeMoney(Config.HuntingLicense)

		TriggerEvent('esx_license:addLicense', source, 'hunting', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)