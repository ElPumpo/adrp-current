ESX = nil
local cooldowns = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(type)
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_dmvschool: %s ran booby trapped :addLicense!'):format(identifier))
	local message = (('**Source:** %s | %s\n**Type:** %s'):format(source, identifier, type))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_dmvschool: %s ran booby trapped :addLicense')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_dmvschool:pay')
AddEventHandler('esx_dmvschool:pay', function(price)
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_dmvschool: %s ran booby trapped :pay!'):format(identifier))
	local message = (('**Source:** %s | %s\n**Price:** %s'):format(source, identifier, price))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_dmvschool: %s ran booby trapped :pay')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_dmvschool:rewardLicense')
AddEventHandler('esx_dmvschool:rewardLicense', function(type)
	local _source = source

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('esx_dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

ESX.RegisterServerCallback('esx_dmvschool:payPrice', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.Prices[type]

	if price and xPlayer and xPlayer.getMoney() >= price then
		local ok = false

		-- is player on cooldown?
		if cooldowns[xPlayer.identifier] then
			local timeNow = os.clock()

			-- has cooldown expired?
			if timeNow - cooldowns[xPlayer.identifier] > Config.TestTimeout then
				ok = true
			else
				xPlayer.showNotification('You\'re on a test cooldown. Please return later.')
			end
		else
			ok = true
		end

		-- everything went well
		if ok then
			cooldowns[xPlayer.identifier] = os.clock()
			xPlayer.removeMoney(price)
			xPlayer.showNotification(_U('you_paid', ESX.Math.GroupDigits(price)))
			cb(true)
		end
	else
		xPlayer.showNotification('You cannot afford the test!')
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_dmvschool:buyTaxiLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = Config.Prices.taxi_license

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		TriggerEvent('esx_license:addLicense', source, 'taxi', function()
			TriggerEvent('esx_license:getLicenses', source, function(licenses)
				TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
				cb(true)
			end)
		end)
	else
		cb(false)
	end
end)