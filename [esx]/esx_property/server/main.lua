ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

function SetPropertyOwned(name, price, rented, owner)
	MySQL.Async.execute('INSERT INTO owned_properties (name, price, rented, owner) VALUES (@name, @price, @rented, @owner)', {
		['@name']   = name,
		['@price']  = price,
		['@rented'] = (rented and 1 or 0),
		['@owner']  = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, true, rented)

			if rented then
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('rented_for', ESX.Math.GroupDigits(price)))
			else
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('purchased_for', ESX.Math.GroupDigits(price)))
			end
		end
	end)
end

function RemoveOwnedProperty(name, owner)
	MySQL.Async.fetchAll('SELECT id, rented, price FROM owned_properties WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(result)
		if result[1] then
			MySQL.Async.execute('DELETE FROM owned_properties WHERE id = @id', {
				['@id'] = result[1].id
			}, function(rowsChanged)
				local xPlayer = ESX.GetPlayerFromIdentifier(owner)

				if xPlayer then
					TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, false)

					if result[1].rented == 1 then
						TriggerClientEvent('esx:showNotification', xPlayer.source, 'You moved out and do no longer rent the property.')
					else
						local sellPrice = ESX.Math.Round(result[1].price / 2)
						TriggerClientEvent('esx:showNotification', xPlayer.source, _U('made_property', ESX.Math.GroupDigits(sellPrice)))
						xPlayer.addAccountMoney('bank', sellPrice)
					end
				end
			end)
		end
	end)
end

MySQL.ready(function()
	Citizen.Wait(1000)

	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local roomMenu  = nil

			if properties[i].entering then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].exit then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			if properties[i].room_menu then
				roomMenu = json.decode(properties[i].room_menu)
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				price     = properties[i].price
			})
		end

		TriggerClientEvent('esx_property:sendProperties', -1, Config.Properties)
	end)

end)

ESX.RegisterServerCallback('esx_property:getProperties', function(source, cb)
	cb(Config.Properties)
end)

AddEventHandler('esx_ownedproperty:getOwnedProperties', function(cb)
	MySQL.Async.fetchAll('SELECT * FROM owned_properties', {}, function(result)
		local properties = {}

		for i=1, #result, 1 do
			table.insert(properties, {
				id     = result[i].id,
				name   = result[i].name,
				label  = GetProperty(result[i].name).label,
				price  = result[i].price,
				rented = (result[i].rented == 1 and true or false),
				owner  = result[i].owner
			})
		end

		cb(properties)
	end)
end)

AddEventHandler('esx_property:setPropertyOwned', function(name, price, rented, owner)
	SetPropertyOwned(name, price, rented, owner)
end)

AddEventHandler('esx_property:removeOwnedProperty', function(name, owner)
	RemoveOwnedProperty(name, owner)
end)

RegisterServerEvent('esx_property:rentProperty')
AddEventHandler('esx_property:rentProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)
	local rent     = ESX.Math.Round(property.price / 200)

	SetPropertyOwned(propertyName, rent, true, xPlayer.identifier)
end)

RegisterServerEvent('esx_property:buyProperty')
AddEventHandler('esx_property:buyProperty', function(propertyName)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local property = GetProperty(propertyName)

	if property.price <= xPlayer.getMoney() then
		xPlayer.removeMoney(property.price)
		SetPropertyOwned(propertyName, property.price, false, xPlayer.identifier)
	else
		TriggerClientEvent('esx:showNotification', source, _U('not_enough'))
	end
end)

RegisterServerEvent('esx_property:removeOwnedProperty')
AddEventHandler('esx_property:removeOwnedProperty', function(propertyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	RemoveOwnedProperty(propertyName, xPlayer.identifier)
end)

AddEventHandler('esx_property:removeOwnedPropertyIdentifier', function(propertyName, identifier)
	RemoveOwnedProperty(propertyName, identifier)
end)

RegisterServerEvent('esx_property:saveLastProperty')
AddEventHandler('esx_property:saveLastProperty', function(property)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = @last_property WHERE identifier = @identifier', {
		['@last_property'] = property,
		['@identifier']    = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:deleteLastProperty')
AddEventHandler('esx_property:deleteLastProperty', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET last_property = NULL WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_property:getItem')
AddEventHandler('esx_property:getItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then
		local sourceItem = xPlayer.getInventoryItem(item)

		TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)

			-- is there enough in the property?
			if count > 0 and inventoryItem.count >= count then
				-- can the player carry the said amount of x item?
				if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
					TriggerClientEvent('esx:showNotification', _source, _U('player_cannot_hold'))
				else
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
					TriggerClientEvent('esx:showNotification', _source, _U('have_withdrawn', count, inventoryItem.label))
				end
			else
				TriggerClientEvent('esx:showNotification', _source, _U('not_enough_in_property'))
			end
		end)
	elseif type == 'item_account' then
		TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
			local roomAccountMoney = account.money

			if roomAccountMoney >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
				TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
			end
		end)
	elseif type == 'item_weapon' then
		TriggerEvent('esx_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
			local storeWeapons = store.get('weapons') or {}

			for k,v in ipairs(storeWeapons) do
				if v.name == item then -- found weapon
					if xPlayer.hasWeapon(v.name) then
						xPlayer.showNotification('You already have a similar weapon on you.')
					else
						xPlayer.addWeapon(v.name, v.ammo)

						if v.components then
							for _,component in ipairs(v.components) do
								xPlayer.addWeaponComponent(v.name, component)
							end
						end
	
						table.remove(storeWeapons, k)
					end

					break
				end
			end

			store.set('weapons', storeWeapons)
		end)
	end
end)

RegisterServerEvent('esx_property:putItem')
AddEventHandler('esx_property:putItem', function(owner, type, item, count)
	local _source      = source
	local xPlayer      = ESX.GetPlayerFromId(_source)
	local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayerOwner.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
				TriggerClientEvent('esx:showNotification', _source, _U('have_deposited', count, inventory.getItem(item).label))
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
		end
	elseif type == 'item_account' then
		local playerAccountMoney = xPlayer.getAccount(item).money

		if playerAccountMoney >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getAccount', 'property_' .. item, xPlayerOwner.identifier, function(account)
				account.addMoney(count)
			end)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('amount_invalid'))
		end
	elseif type == 'item_weapon' then
		local weaponNum, weapon = xPlayer.getWeapon(item)

		if weapon then
			TriggerEvent('esx_datastore:getDataStore', 'property', xPlayerOwner.identifier, function(store)
				local storeWeapons = store.get('weapons') or {}

				table.insert(storeWeapons, {
					name = item,
					ammo = weapon.ammo,
					components = weapon.components
				})

				store.set('weapons', storeWeapons)
				xPlayer.removeWeapon(item)
			end)
		end
	end
end)

ESX.RegisterServerCallback('esx_property:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT name, rented FROM owned_properties WHERE owner = @owner', {
	['@owner'] = xPlayer.identifier
	}, function(ownedProperties)
		local properties = {}

		for i=1, #ownedProperties, 1 do
			table.insert(properties, {
				name = ownedProperties[i].name,
				rented = ownedProperties[i].rented
			})
		end

		cb(properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPropertyInventory', function(source, cb, owner)
	local xPlayer    = ESX.GetPlayerFromIdentifier(owner)
	local blackMoney = 0
	local items      = {}
	local weapons    = {}

	TriggerEvent('esx_addonaccount:getAccount', 'property_black_money', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getInventory', 'property', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		weapons = store.get('weapons') or {}
	end)

	cb({
		blackMoney = blackMoney,
		items = items,
		weapons = weapons
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
		loadout    = xPlayer.getLoadout()
	})
end)

ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('esx_property:removeOutfit')
AddEventHandler('esx_property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)

function PayRent()
	print('esx_property: PayRent()')
	local playerMessages = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE rented = 1', {}, function(results)
		for k,ownedProperty in ipairs(results) do
			local xPlayer, isPlayerOnline = ESX.GetPlayerFromIdentifier(ownedProperty.owner), false

			if xPlayer then
				local bankBalance = xPlayer.getAccount('bank').money
				isPlayerOnline = true

				if bankBalance < ownedProperty.price then
					EvictProperty(ownedProperty.name, ownedProperty.owner)
					local propertyLabel = GetProperty(ownedProperty.name).label
					local message = ('You have been evicted from <span style="font-weight: bold;">%s</span> for not paying your rent at <span style="color: #00ea1b;">$%s</span>!<br><br>'):format(propertyLabel, ESX.Math.GroupDigits(ownedProperty.price))

					if not playerMessages[xPlayer.source] then
						playerMessages[xPlayer.source] = {}
					end

					table.insert(playerMessages[xPlayer.source], message)
				else
					xPlayer.removeAccountMoney('bank', ownedProperty.price)
					local propertyLabel = GetProperty(ownedProperty.name).label
					local message = ('You have paid rent for <span style="font-weight: bold;">%s</span> at <span style="color: #00ea1b;">$%s</span>!<br><br>'):format(propertyLabel, ESX.Math.GroupDigits(ownedProperty.price))

					if not playerMessages[xPlayer.source] then
						playerMessages[xPlayer.source] = {}
					end

					table.insert(playerMessages[xPlayer.source], message)
				end
			end

			if not isPlayerOnline then
				MySQL.Async.fetchAll('SELECT characterID, properties, bank FROM characters WHERE identifier = @identifier', {
					['@identifier'] = ownedProperty.owner
				}, function(chars)
					local found = false

					for _,char in ipairs(chars) do -- for each character
						if char and char.properties then
							local rentedProperties = json.decode(char.properties)

							for _,charProperties in ipairs(rentedProperties) do
								if charProperties.id == ownedProperty.id then -- found owned property
									if char.bank < ownedProperty.price then
										EvictProperty(ownedProperty.name, ownedProperty.owner)
									else
										MySQL.Sync.execute('UPDATE characters SET bank = bank - @rentPrice WHERE identifier = @identifier AND characterID = @characterID', {
											['@rentPrice'] = ownedProperty.price,
											['@identifier'] = ownedProperty.owner,
											['@characterID'] = char.characterID
										})
									end
	
									found = true
									break
								end
							end
	
							if found then break end
						end
					end
				end)
			end
		end

		for playerId,messages in pairs(playerMessages) do
			local finalMessage = ''

			for index,message in ipairs(messages) do
				finalMessage = finalMessage .. message
			end

			finalMessage = finalMessage .. '<br>Message sent from <span style="color: D4383B;">Maze Bank</span>'

			TriggerClientEvent('customNotification', playerId, finalMessage, #messages * 10000)
		end
	end)
end

function EvictProperty(name, owner)
	MySQL.Async.execute('DELETE FROM owned_properties WHERE name = @name AND owner = @owner', {
		['@name']  = name,
		['@owner'] = owner
	}, function(rowsChanged)
		local xPlayer = ESX.GetPlayerFromIdentifier(owner)

		if xPlayer then
			TriggerClientEvent('esx_property:setPropertyOwned', xPlayer.source, name, false)
		end
	end)
end

local paid2day = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)

		local time = os.date('*t')
		local hourPay = 12 -- the time of day to pay (local time), in this case 12:00

		if time.hour == hourPay and not paid2day then
			paid2day = true
			PayRent()
		elseif paid2day and time.hour ~= hourPay then
			paid2day = false
		end
	end
end)