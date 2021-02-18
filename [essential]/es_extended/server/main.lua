AddEventHandler('es:playerLoaded', function(source, _player)
	local _source = source
	local tasks   = {}

	local userData = {
		accounts     = {},
		inventory    = {},
		job          = {},
		loadout      = {},
		playerName   = GetPlayerName(_source),
		lastPosition = {},
		gang = {}
	}

	userData.job.name = 'unemployed'
	userData.job.label = 'Unemployed'
	userData.job.grade = 0
	userData.job.grade_name = 'unemployed'
	userData.job.grade_label = 'Unemployed'
	userData.job.grade_salary = 0
	userData.job.skin_male = {}
	userData.job.skin_female = {}

	userData.gang.name  = 'nogang'
	userData.gang.grade = 0
	userData.gang.label = 'none'

	userData.gang.grade_name  = 'recruit'
	userData.gang.grade_label = 'No Gang'

	TriggerEvent('es:getPlayerFromId', _source, function(player)

		-- Update user name in DB
		table.insert(tasks, function(cb)
			MySQL.Async.execute('UPDATE users SET name = @name WHERE identifier = @identifier', {
				['@identifier'] = player.getIdentifier(),
				['@name'] = userData.playerName
			}, function(rowsChanged)
				cb()
			end)
		end)

		-- Get accounts
		table.insert(tasks, function(cb)
			MySQL.Async.fetchAll('SELECT * FROM user_accounts WHERE identifier = @identifier', {
				['@identifier'] = player.getIdentifier()
			}, function(accounts)
				for i=1, #Config.Accounts, 1 do
					for j=1, #accounts, 1 do
						if accounts[j].name == Config.Accounts[i] then
							table.insert(userData.accounts, {
								name  = accounts[j].name,
								money = accounts[j].money,
								label = Config.AccountLabels[accounts[j].name]
							})
						end

						break
					end
				end

				cb()
			end)
		end)

		-- Get inventory
		table.insert(tasks, function(cb)
			for itemName,item in pairs(ESX.Items) do
				table.insert(userData.inventory, {
					name = itemName,
					count = 0,
					label = item.label,
					weight = item.weight,
					usable = ESX.UsableItemsCallbacks[itemName] ~= nil,
					rare = item.rare,
					canRemove = item.canRemove
				})
			end

			table.sort(userData.inventory, function(a,b)
				return a.label < b.label
			end)

			cb()
		end)

		-- Run Tasks
		Async.parallel(tasks, function(results)
			local xPlayer = CreateExtendedPlayer(player, userData.accounts, userData.inventory, userData.job, userData.gang, userData.loadout, userData.playerName, userData.lastPosition)

			xPlayer.getMissingAccounts(function(missingAccounts)
				if #missingAccounts > 0 then
					for i=1, #missingAccounts, 1 do
						table.insert(xPlayer.accounts, {
							name  = missingAccounts[i],
							money = 0,
							label = Config.AccountLabels[missingAccounts[i]]
						})
					end

					xPlayer.createAccounts(missingAccounts)
				end
			end)

			ESX.Players[_source] = xPlayer
			TriggerEvent('esx:playerLoaded', _source, xPlayer)

			TriggerClientEvent('esx:playerLoaded', _source, {
				identifier   = xPlayer.identifier,
				accounts     = xPlayer.getAccounts(),
				inventory    = xPlayer.getInventory(),
				job          = xPlayer.getJob(),
				gang         = xPlayer.getGang(),
				loadout      = xPlayer.getLoadout(),
				lastPosition = xPlayer.getLastPosition(),
				money        = xPlayer.getMoney()
			})

			TriggerClientEvent('esx:createMissingPickups', _source, ESX.Pickups)
		end)

	end)

end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source

	if playerId < 10000 then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			TriggerEvent('esx:playerDropped', playerId, reason)

			ESX.SavePlayer(xPlayer, function()
				ESX.Players[playerId] = nil
				ESX.LastPlayerData[playerId] = nil
			end)
		end
	end
end)

RegisterServerEvent('esx:updateLoadout')
AddEventHandler('esx:updateLoadout', function(loadout)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.loadout = loadout
end)

RegisterServerEvent('esx:updateLastPosition')
AddEventHandler('esx:updateLastPosition', function(position)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setLastPosition(position)
end)

RegisterServerEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == 'item_standard' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)
				
				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label, sourceXPlayer.name))

				local message = ('**Source:** %s | %s\n**Target:** %s | %s\n**Item:** %s\n**Count:** %s'):format(playerId, sourceXPlayer.identifier, targetXPlayer.source, targetXPlayer.identifier, ESX.Items[itemName].label, itemCount)
		 		TriggerEvent('adrp_anticheat:sendLog', message, 'Item Give Notifications')
			else
				sourceXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.name))
			end
		else
			sourceXPlayer.showNotification(_U('imp_invalid_quantity'))
		end
	elseif type == 'item_money' then
		if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then

			sourceXPlayer.removeMoney(itemCount)
			targetXPlayer.addMoney   (itemCount)

			sourceXPlayer.showNotification(_U('gave_money', ESX.Math.GroupDigits(itemCount), targetXPlayer.name))
			targetXPlayer.showNotification(_U('received_money', ESX.Math.GroupDigits(itemCount), sourceXPlayer.name))

			local message = ('**Source:** %s | %s\n**Target:** %s | %s\n**Amount:** $%s'):format(playerId, sourceXPlayer.identifier, targetXPlayer.source, targetXPlayer.identifier, ESX.Math.GroupDigits(itemCount))
			TriggerEvent('adrp_anticheat:sendLog', message, 'Cash Give Notification')

		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then

			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney   (itemName, itemCount)

			sourceXPlayer.showNotification(_U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.AccountLabels[itemName], targetXPlayer.name))
			targetXPlayer.showNotification(_U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.AccountLabels[itemName], sourceXPlayer.name))

			local message = ('**Source:** %s | %s\n**Target:** %s | %s\n**Account:** %s\n**Amount:** $%s'):format(playerId, sourceXPlayer.identifier, targetXPlayer.source, targetXPlayer.identifier, Config.AccountLabels[itemName], ESX.Math.GroupDigits(itemCount))
			TriggerEvent('adrp_anticheat:sendLog', message, 'Account Give Notification')
		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	elseif type == 'item_weapon' then
		local weaponLabel = ESX.GetWeaponLabel(itemName)

		if not targetXPlayer.hasWeapon(itemName) then
			sourceXPlayer.removeWeapon(itemName)
			targetXPlayer.addWeapon(itemName, itemCount)

			if itemCount > 0 then
				sourceXPlayer.showNotification(_U('gave_weapon_withammo', weaponLabel, itemCount, targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_weapon_withammo', weaponLabel, itemCount, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('gave_weapon', weaponLabel, targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_weapon', weaponLabel, sourceXPlayer.name))
				local message = ('**Source:** %s | %s\n**Target:** %s | %s\n**Weapon:** %s\n**Ammo:** %s'):format(playerId, sourceXPlayer.identifier, targetXPlayer.source, targetXPlayer.identifier, weaponLabel, itemCount)
				TriggerEvent('adrp_anticheat:sendLog', message, 'Weapon Give Notification')
			end
		else
			sourceXPlayer.showNotification(_U('gave_weapon_hasalready', targetXPlayer.name, weaponLabel))
			targetXPlayer.showNotification(_U('received_weapon_hasalready', sourceXPlayer.name, weaponLabel))
		end
	elseif type == 'item_ammo' then
		if sourceXPlayer.hasWeapon(itemName) then
			if targetXPlayer.hasWeapon(itemName) then
				local weaponNum, weapon = sourceXPlayer.getWeapon(itemName)

				if weapon.ammo >= itemCount then
					sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
					targetXPlayer.addWeaponAmmo(itemName, itemCount)

					sourceXPlayer.showNotification(_U('gave_weapon_ammo', itemCount, weapon.label, targetXPlayer.name))
					targetXPlayer.showNotification(_U('received_weapon_ammo', itemCount, weapon.label, sourceXPlayer.name))
				end
			else
				sourceXPlayer.showNotification(_U('gave_weapon_noweapon', targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_weapon_noweapon', sourceXPlayer.name, weapon.label))
			end
		end
	end
end)

RegisterServerEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then

		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_quantity'))
		else

			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification(_U('imp_invalid_quantity'))
			else
				xPlayer.removeInventoryItem(itemName, itemCount)

				local pickupLabel = ('~y~%s~s~ [~b~%s~s~]'):format(xItem.label, itemCount)
				ESX.CreatePickup('item_standard', itemName, itemCount, pickupLabel, playerId)
				xPlayer.showNotification(_U('threw_standard', itemCount, xItem.label))

				local message = ('**Source:** %s | %s\n**Item:** %s\n**Count:** %s'):format(playerId, xPlayer.identifier, xItem.label, itemCount)
				TriggerEvent('adrp_anticheat:sendLog', message, 'Item Dropped Notification')
			end

		end

	elseif type == 'item_money' then

		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else

			local playerCash = xPlayer.getMoney()

			if (itemCount > playerCash or playerCash < 1) then
				xPlayer.showNotification(_U('imp_invalid_amount'))
			else
				xPlayer.removeMoney(itemCount)

				local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(_U('cash'), _U('locale_currency', ESX.Math.GroupDigits(itemCount)))
				ESX.CreatePickup('item_money', 'money', itemCount, pickupLabel, playerId)
				xPlayer.showNotification(_U('threw_money', ESX.Math.GroupDigits(itemCount)))

				local message = ('**Source:** %s | %s\n**Dropped amount:** $%s'):format(playerId, xPlayer.identifier, ESX.Math.GroupDigits(itemCount))
				TriggerEvent('adrp_anticheat:sendLog', message, 'Cash Dropped Notification')
			end

		end

	elseif type == 'item_account' then

		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local account = xPlayer.getAccount(itemName)

			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification(_U('imp_invalid_amount'))
			else
				xPlayer.removeAccountMoney(itemName, itemCount)

				local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(account.label, _U('locale_currency', ESX.Math.GroupDigits(itemCount)))
				ESX.CreatePickup('item_account', itemName, itemCount, pickupLabel, playerId)
				xPlayer.showNotification(_U('threw_account', ESX.Math.GroupDigits(itemCount), string.lower(account.label)))

				local message = ('**Source:** %s | %s\n**Account:** %s\n**Amount:** $%s'):format(playerId, sourceXPlayer.identifier, account.label, ESX.Math.GroupDigits(itemCount))
				TriggerEvent('adrp_anticheat:sendLog', message, 'Account Dropped Notification')
			end

		end

	elseif type == 'item_weapon' then
		if xPlayer.hasWeapon(itemName) then
			local weaponNum, weapon = xPlayer.getWeapon(itemName)
			local weaponPickup = 'PICKUP_' .. string.upper(itemName)
			xPlayer.removeWeapon(itemName)

			if weapon.ammo > 0 then
				TriggerClientEvent('esx:pickupWeapon', playerId, weaponPickup, itemName, weapon.ammo)
				xPlayer.showNotification(_U('threw_weapon_ammo', weapon.label, weapon.ammo))
			else
				-- workaround for CreateAmbientPickup() giving 30 rounds of ammo when you drop the weapon with 0 ammo
				TriggerClientEvent('esx:pickupWeapon', playerId, weaponPickup, itemName, 1)
				xPlayer.showNotification(_U('threw_weapon', weapon.label))
			end

			local message = ('**Source:** %s | %s\n**Weapon:** %s\n**Ammo:** %s'):format(playerId, xPlayer.identifier, weaponLabel, itemCount)
			TriggerEvent('adrp_anticheat:sendLog', message, 'Weapon Dropped Notification')
		end
	end

end)

RegisterServerEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(itemName).count

	if count > 0 then
		ESX.UseItem(source, itemName)
	else
		xPlayer.showNotification(_U('act_imp'))
	end
end)

RegisterServerEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(id)
	local _source = source
	local pickup  = ESX.Pickups[id]
	local xPlayer = ESX.GetPlayerFromId(_source)

	if pickup.type == 'item_standard' then

		if xPlayer.canCarryItem(pickup.name, pickup.count) then
			xPlayer.addInventoryItem(pickup.name, pickup.count)
			TriggerClientEvent('esx:removePickup', -1, id)
		end
		
	elseif pickup.type == 'item_money' then
		TriggerClientEvent('esx:removePickup', -1, id)
		xPlayer.addMoney(pickup.count)

		local message = ('**Source:** %s | %s\n**Amount:** $%s'):format(_source, xPlayer.identifier, ESX.Math.GroupDigits(pickup.count))
		TriggerEvent('adrp_anticheat:sendLog', message, 'Cash Pickup Notification')
	elseif pickup.type == 'item_account' then
		TriggerClientEvent('esx:removePickup', -1, id)
		xPlayer.addAccountMoney(pickup.name, pickup.count)

		local message = ('**Source:** %s | %s\n**Account:** %s\n**Amount:** $%s'):format(_source, xPlayer.identifier, Config.AccountLabels[pickup.name], ESX.Math.GroupDigits(pickup.count))
		TriggerEvent('adrp_anticheat:sendLog', message, 'Account Pickup Notification')
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		gang         = xPlayer.getGang(),
		loadout      = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		gang         = xPlayer.getGang(),
		loadout      = xPlayer.getLoadout(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

ESX.StartDBSync()
ESX.StartPayCheck()