ESX = nil
local shopItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM weashops', {}, function(result)
		for i=1, #result, 1 do
			if not shopItems[result[i].name] then
				shopItems[result[i].name] = {}
			end

			table.insert(shopItems[result[i].name], {
				item  = result[i].item,
				price = result[i].price,
				label = ESX.GetWeaponLabel(result[i].item)
			})
		end

		TriggerClientEvent('esx_weaponshop:sendShop', -1, shopItems)
	end)
end)

function loadLicenses(playerId)
	TriggerEvent('esx_license:getLicenses', playerId, function(licenses)
		TriggerClientEvent('esx_weashop:loadLicenses', playerId, licenses)
	end)
end

ESX.RegisterServerCallback('esx_weaponshop:getShop', function(playerId, cb)
	cb(shopItems)
end)

ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(playerId, cb, wType, wNum)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local licensePrice = Config.LicensePrice * wNum

	if xPlayer.getMoney() >= licensePrice then
		xPlayer.removeMoney(licensePrice)

		TriggerEvent('esx_license:addLicense', playerId, wType, function()
			loadLicenses(playerId) -- reload licenses
			cb(true)
		end)
	else
		xPlayer.showNotification(_U('not_enough'))
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(playerId, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local price = getWeaponPrice(weaponName, zone)

	if price == 0 then
		print(('esx_weaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	else
		if xPlayer.hasWeapon(weaponName) then
			xPlayer.showNotification(_U('already_owned'))
			cb(false)
		else
			if zone == 'BlackWeashop' then
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price)
					xPlayer.addWeapon(weaponName, 42)
					cb(true)
				else
					xPlayer.showNotification(_U('not_enough_black'))
					cb(false)
				end
			else
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price)
					xPlayer.addWeapon(weaponName, 42)
					cb(true)
				else
					xPlayer.showNotification(_U('not_enough'))
					cb(false)
				end
			end
		end
	end
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeaponAttachment', function(playerId, cb, weaponName, componentIndex)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local weaponComponent, weaponComponentPrice = getComponentInfo(weaponName, componentIndex)

	if weaponComponent then
		if xPlayer.getMoney() >= weaponComponentPrice then
			if xPlayer.hasWeapon(weaponName) then
				if not xPlayer.hasWeaponComponent(weaponName, weaponComponent) then
					xPlayer.removeMoney(weaponComponentPrice)
					xPlayer.addWeaponComponent(weaponName, weaponComponent)
					cb(true)
				else
					xPlayer.showNotification('You already have that attachment!')
					cb(false)
				end
			else
				xPlayer.showNotification('You dont have that weapon!')
				cb(false)
			end
		else
			xPlayer.showNotification('You cannot afford that attachment!')
			cb(false)
		end
	else
		cb(false)
	end
end)

function getWeaponPrice(weaponName, zone)
	if not weaponName or not zone then return 0 end

	if zone == 'GunShop' then
		local level1Prices = Config.Zones[zone].Items1
		local level2Prices = Config.Zones[zone].Items2
		local level3Prices = Config.Zones[zone].Items3
		local sqlPrices = shopItems[zone]

		for k,v in ipairs(level1Prices) do
			if v.name == weaponName then
				return v.price
			end
		end

		for k,v in ipairs(level2Prices) do
			if v.name == weaponName then
				return v.price
			end
		end

		for k,v in ipairs(level3Prices) do
			if v.name == weaponName then
				return v.price
			end
		end

		for k,v in ipairs(sqlPrices) do
			if v.item == weaponName then
				return v.price
			end
		end
	elseif zone == 'BlackWeashop' then
		local configItems = Config.Zones[zone].Items
		local sqlPrices = shopItems[zone]

		for k,v in ipairs(configItems) do
			if v.name == weaponName then
				return v.price
			end
		end

		for k,v in ipairs(sqlPrices) do
			if v.item == weaponName then
				return v.price
			end
		end
	end

	return 0
end

function getComponentInfo(weaponName, componentIndex)
	if not weaponName or not componentIndex then return end

	for k,v in ipairs(Config.Attachments) do
		if v.weapon == weaponName then
			local weaponNum, weapon = ESX.GetWeapon(weaponName)
			local component = weapon.components[componentIndex]
			local componentPrice = v.components[componentIndex]

			if component and componentPrice then
				return component.name, componentPrice
			else
				return
			end

			break
		end
	end
end

ESX.RegisterUsableItem('clip', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	TriggerClientEvent('esx_weashop:clipcli', playerId)
	xPlayer.removeInventoryItem('clip', 1)
end)
