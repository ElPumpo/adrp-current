ESX = nil

local playersGunpowderStatuses = {}
local availablePolice = {}
local handcuffedPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'police', _U('alert_police'), true, true)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})

RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job, name, grade)
	if job == 'police' or job == 'state' or job == 'securoserv' or job == 'sheriff' or job == 'usmarshal' or job == 'dod' or job == 'fib' or job == 'doj' then
		if not availablePolice[source] then
			local jobInfo = Config.CopBlip[job]
			availablePolice[source] = {
				job = job,
				jobLabel = jobInfo.label,
				name = name,
				grade = grade,
				blipColor = jobInfo.color
			}

			TriggerClientEvent('esx_policejob:updateAvailableUnits', -1, availablePolice)
			TriggerEvent('esx_policejob:updateAvailableUnits', availablePolice)
			TriggerEvent('esx_addons_gcphone:addSource', 'police', source)
		end
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	if availablePolice[source] then
		availablePolice[source] = nil
		TriggerClientEvent('esx_policejob:updateAvailableUnits', -1, availablePolice)
		TriggerEvent('esx_policejob:updateAvailableUnits', availablePolice)
		TriggerEvent('esx_addons_gcphone:removeSource', 'police', source)
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerId = source

	if playerId > 3000 then
		return
	end

	if availablePolice[playerId] then
		availablePolice[playerId] = nil
		TriggerClientEvent('esx_policejob:updateAvailableUnits', -1, availablePolice)
		TriggerEvent('esx_policejob:updateAvailableUnits', availablePolice)
	end
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_policejob:updateAvailableUnits', character.playerId, availablePolice)
end)

RegisterServerEvent('esx_policejob:callBackup')
AddEventHandler('esx_policejob:callBackup', function(playerId)
	if availablePolice[source] then
		if availablePolice[playerId] then
			TriggerClientEvent('esx_policejob:callBackup', playerId, source, availablePolice[source].name)
		else
			print('esx_policejob: could not handle exception callBackup :/')
		end
	else
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('esx_policejob: %s attempted to trigger callBackup'):format(identifier)
		print(msg)

		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

ESX.RegisterServerCallback('esx_policejob:performHandcuff', function(playerId, cb, targetId, finalCoords)
	if availablePolice[playerId] then
		handcuffedPlayers[targetId] = not handcuffedPlayers[targetId]
		TriggerClientEvent('esx_policejob:performHandcuff', targetId, playerId, finalCoords)

		cb(handcuffedPlayers[targetId])
	else
		local identifier = GetPlayerIdentifier(playerId, 0)
		local msg = ('esx_policejob: %s attempted to trigger performHandcuff (cb edition)'):format(identifier)
		print(msg)

		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', playerId)

		cb(false)
	end
end)

RegisterServerEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(target)
	if availablePolice[source] then
		TriggerClientEvent('esx_policejob:drag', target, source)
	else
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('esx_policejob: %s attempted to trigger drag'):format(identifier)
		print(msg)

		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function(target)
	if availablePolice[source] then
		TriggerClientEvent('esx_policejob:putInVehicle', target)
	else
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('esx_policejob: %s attempted to trigger putInVehicle'):format(identifier)
		print(msg)

		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function(target)
	if availablePolice[source] then
		TriggerClientEvent('esx_policejob:OutVehicle', target)
	else
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('esx_policejob: %s attempted to trigger OutVehicle'):format(identifier)
		print(msg)

		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('esx_policejob:confiscatePlayerItem')
AddEventHandler('esx_policejob:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if not availablePolice[_source] or not sourceXPlayer then
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('esx_policejob: %s attempted to trigger confiscatePlayerItem'):format(identifier)
		print(msg)

		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', source)
		return
	end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		-- does the target player have enough in their inventory?
		if targetItem.count > 0 and targetItem.count <= amount then

			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + amount) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
			else
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
				TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated', amount, sourceItem.label, targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated', amount, sourceItem.label, sourceXPlayer.name))
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('quantity_invalid'))
		end

	elseif itemType == 'item_account' then
		targetXPlayer.removeAccountMoney(itemName, amount)
		--sourceXPlayer.addAccountMoney   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_account', amount, itemName, targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_account', amount, itemName, sourceXPlayer.name))

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end
		targetXPlayer.removeWeapon(itemName, amount)
		--sourceXPlayer.addWeapon   (itemName, amount)

		TriggerClientEvent('esx:showNotification', _source, _U('you_confiscated_weapon', ESX.GetWeaponLabel(itemName), targetXPlayer.name, amount))
		TriggerClientEvent('esx:showNotification', target,  _U('got_confiscated_weapon', ESX.GetWeaponLabel(itemName), amount, sourceXPlayer.name))
	end
end)

RegisterServerEvent('esx_policejob:putStockItems')
AddEventHandler('esx_policejob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	local result = MySQL.Sync.fetchAll("SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	})

	local user      = result[1]
	local firstname     = user['firstname']
	local lastname      = user['lastname']
	local sex           = user['sex']
	local dob           = user['dateofbirth']
	local height        = user['height'] .. " cm"

	local data = {
		name        = xPlayer.name,
		job         = xPlayer.job,
		inventory   = xPlayer.inventory,
		accounts    = xPlayer.accounts,
		weapons     = xPlayer.loadout,
		firstname   = firstname,
		lastname    = lastname,
		sex         = sex,
		dob         = dob,
		height      = height
	}

	TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
		if status then
			data.drunk = math.floor(status.percent)
		end
	end)

	TriggerEvent('esx_license:getLicenses', target, function(licenses)
		data.licenses = licenses
		cb(data)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getVehicleInfos', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT owner FROM owned_vehicles WHERE @plate = plate', {
		['@plate'] = plate
	}, function(result)
		local retrivedInfo = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)
				retrivedInfo.owner = result2[1].firstname .. ' ' .. result2[1].lastname
				cb(retrivedInfo)
			end)
		else
			cb(retrivedInfo)
		end
	end)
end)

ESX.RegisterServerCallback('esx_policejob:buyWeapon', function(source, cb, weaponName, type, componentNum)
	local xPlayer = ESX.GetPlayerFromId(source)
	local authorizedWeapons, selectedWeapon

	if xPlayer.job.name == 'police' then
		authorizedWeapons = Config.PoliceAuthorizedWeapons[xPlayer.job.grade_name]
	elseif xPlayer.job.name == 'sheriff' then
		authorizedWeapons = Config.SheriffAuthorizedWeapons[xPlayer.job.grade_name]
	elseif xPlayer.job.name == 'state' then
		authorizedWeapons = Config.StateAuthorizedWeapons[xPlayer.job.grade_name]
	elseif xPlayer.job.name == 'securoserv' then
		authorizedWeapons = Config.SecuroServAuthorizedWeapons[xPlayer.job.grade_name]
	elseif xPlayer.job.name == 'usmarshal' then
		authorizedWeapons = Config.UsmarshalAuthorizedWeapons[xPlayer.job.grade_name]
	elseif xPlayer.job.name == 'dod' then
		authorizedWeapons = Config.dodAuthorizedWeapons[xPlayer.job.grade_name]
	elseif xPlayer.job.name == 'fib' then
		authorizedWeapons = Config.FibAuthorizedWeapons[xPlayer.job.grade_name]
	end

	for k,v in ipairs(authorizedWeapons) do
		if v.weapon == weaponName then
			selectedWeapon = v
			break
		end
	end

	if not selectedWeapon then
		print(('esx_policejob: %s attempted to buy an invalid weapon.'):format(xPlayer.identifier))
		cb(false)
	end

	-- Weapon
	if type == 1 then
		if xPlayer.getMoney() >= selectedWeapon.price then
			xPlayer.removeMoney(selectedWeapon.price)
			xPlayer.addWeapon(weaponName, 100)

			cb(true)
		else
			cb(false)
		end

	-- Weapon Component
	elseif type == 2 then
		local price = selectedWeapon.components[componentNum]
		local weaponNum, weapon = ESX.GetWeapon(weaponName)

		local component = weapon.components[componentNum]

		if component then
			if xPlayer.getMoney() >= price then
				xPlayer.removeMoney(price)
				xPlayer.addWeaponComponent(weaponName, component.name)

				cb(true)
			else
				cb(false)
			end
		else
			print(('esx_policejob: %s attempted to buy an invalid weapon component.'):format(xPlayer.identifier))
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_policejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job, type)

	-- vehicle model not found
	if price == 0 then
		print(('esx_policejob: %s attempted to exploit the shop! (invalid vehicle model)'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, real_owner, vehicle, plate, type, job, state) VALUES (@owner, @real_owner, @vehicle, @plate, @type, @job, @state)', {
			['@owner'] = xPlayer.identifier,
			['@real_owner'] = xPlayer.identifier,
			['@vehicle'] = json.encode(vehicleProps),
			['@plate'] = vehicleProps.plate,
			['@type'] = type,
			['@job'] = xPlayer.job.name,
			['@state'] = true
		}, function (rowsChanged)
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_policejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE real_owner = @real_owner AND plate = @plate AND job = @job', {
			['@real_owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET state = true WHERE real_owner = @real_owner AND plate = @plate AND job = @job', {
			['@real_owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				print(('esx_policejob: %s has exploited the garage!'):format(xPlayer.identifier))
				cb(false)
			else
				TriggerEvent('esx_adrp_vehicle:dropTargetKey', xPlayer.source, foundPlate)
				TriggerEvent('esx_adrp_vehicle:clearTrunkInventory', foundPlate)
				cb(true, foundNum)
			end
		end)
	end
end)

function getPriceFromHash(hashKey, job, type)
	if type == 'helicopter' then
		local vehicles = Config.AuthorizedHelicopters[job.name]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'boats' then
		local vehicles = Config.AuthorizedBoats[job.name]

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	elseif type == 'car' then
		local vehicles = {}

		if job.name == 'police' then
			vehicles = Config.PoliceAuthorizedVehicles[job.grade_name]
		elseif job.name == 'sheriff' then
			vehicles = Config.SheriffAuthorizedVehicles[job.grade_name]
		elseif job.name == 'state' then
			vehicles = Config.StateAuthorizedVehicles[job.grade_name]
		elseif job.name == 'securoserv' then
			vehicles = Config.SecuroServAuthorizedVehicles[job.grade_name]
		elseif job.name == 'usmarshal' then
			vehicles = Config.UsmarshalAuthorizedVehicles[job.grade_name]
		elseif job.name == 'dod' then
			vehicles = Config.dodAuthorizedVehicles[job.grade_name]
		elseif job.name == 'fib' then
			vehicles = Config.FibAuthorizedVehicles[job.grade_name]
		elseif job.name == 'doj' then
			vehicles = Config.DojAuthorizedVehicles[job.grade_name]
		end

		for k,v in ipairs(vehicles) do
			if GetHashKey(v.model) == hashKey then
				return v.price
			end
		end
	end

	return 0
end

ESX.RegisterServerCallback('esx_policejob:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('esx_policejob:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent('esx_guntest:storePlayerGunpowderStatus')
AddEventHandler('esx_guntest:storePlayerGunpowderStatus', function()
	local _source = source
	table.insert(playersGunpowderStatuses, _source)
end)

RegisterServerEvent('esx_guntest:removePlayerGunpowderStatus')
AddEventHandler('esx_guntest:removePlayerGunpowderStatus', function()
	for i=#playersGunpowderStatuses, 1, -1 do
		if playersGunpowderStatuses[i] == source then
			table.remove(playersGunpowderStatuses, i)
			break
		end
	end
end)

ESX.RegisterServerCallback('esx_guntest:hasPlayerRecentlyFiredAGun', function(source, cb, target)
	local playerHasGunpowder = false

	for i=#playersGunpowderStatuses, 1, -1 do
		if playersGunpowderStatuses[i] == target then
			playerHasGunpowder = true
			break
		end
	end

	cb(playerHasGunpowder)
end)

RegisterServerEvent('esx_policejob:message')
AddEventHandler('esx_policejob:message', function(target, msg)
	TriggerClientEvent('esx:showNotification', target, msg)
end)