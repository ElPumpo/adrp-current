ESX = nil
local availableVehiclesForSale, isVehicleBusy = {}, {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT plate, owner, network_id, label, vehicle_props, price FROM esx_adrp_dealership', {}, function(result)
		for k,v in ipairs(result) do
			availableVehiclesForSale[v.plate] = {
				owner = v.owner,
				networkID = v.network_id,
				label = v.label,
				vehicleProps = v.vehicle_props,
				price = v.price
			}
		end
	end)

	Citizen.Wait(2000)
	-- reload midgame
	TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', -1, availableVehiclesForSale)

	for k,playerId in ipairs(ESX.GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer and xPlayer.get('networkID') then
			TriggerClientEvent('esx_adrp_dealership:relayMyNetworkID', playerId, xPlayer.get('networkID'))
		end
	end
end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', character.playerId, availableVehiclesForSale)
	TriggerClientEvent('esx_adrp_dealership:relayMyNetworkID', character.playerId, character.networkID)
end)

ESX.RegisterServerCallback('esx_adrp_dealership:buyVehicle', function(playerId, cb, plate, price)
	if not isVehicleBusy[plate] then
		isVehicleBusy[plate] = true
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer and availableVehiclesForSale[plate] then
			local bankBalance, buyingVehicle = xPlayer.getAccount('bank').money, availableVehiclesForSale[plate]

			-- is the price parsed from client the same we have saved?
			-- this is to make sure that the owner cant change the price
			-- whilst someone is in the process of buying their vehicle
			if price == buyingVehicle.price then
				if bankBalance >= buyingVehicle.price then
					local xOwner, payDatabase = ESX.GetPlayerFromIdentifier(buyingVehicle.owner), false

					-- is owner online?
					if xOwner then
						local networkID = xOwner.get('networkID')

						-- is owner playing on the same character?
						if networkID == buyingVehicle.networkID then
							MySQL.Async.execute('DELETE FROM esx_adrp_dealership WHERE plate = @plate', {
								['@plate'] = plate
							}, function(rowsChanged)
								if rowsChanged > 0 then
									MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, real_owner, state) VALUES (@owner, @plate, @vehicle, @real_owner, @state)', {
										['@owner'] = xPlayer.identifier,
										['@plate'] = plate,
										['@vehicle'] = buyingVehicle.vehicleProps,
										['@real_owner'] = xPlayer.identifier,
										['@state'] = true
									}, function(rowsChanged)
										if rowsChanged > 0 then
											xPlayer.removeAccountMoney('bank', buyingVehicle.price)
											xOwner.addAccountMoney('bank', buyingVehicle.price)
				
											xPlayer.showNotification(('You\'ve bought a ~y~%s~s~ for ~g~$%s~s~, it has been delivered to your garage'):format(buyingVehicle.label, ESX.Math.GroupDigits(buyingVehicle.price)))
											xOwner.showNotification(('Someone have bought one of your vehicles from the used dealership and wired ~g~$%s~s~'):format(ESX.Math.GroupDigits(buyingVehicle.price)))
				
											availableVehiclesForSale[plate] = nil
											isVehicleBusy[plate] = nil
											TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', -1, availableVehiclesForSale)
											cb(true)
										else
											isVehicleBusy[plate] = nil
											cb(false)
										end
									end)
								else
									isVehicleBusy[plate] = nil
									cb(false)
								end
							end)
						else
							-- the owner is online, but is not playing on the same character as the one he put out the vehicle on, so we will have to pay via db, too
							payDatabase = true
						end
					else
						payDatabase = true
					end

					if payDatabase then
						MySQL.Async.fetchAll('SELECT bank FROM characters WHERE networkID = @networkID', {
							['@networkID'] = buyingVehicle.networkID
						}, function(result)
							if result[1] then
								MySQL.Async.execute('UPDATE characters SET bank = @bank WHERE networkID = @networkID', {
									['@bank'] = result[1].bank + buyingVehicle.price,
									['@networkID'] = buyingVehicle.networkID
								}, function(rowsChanged)
									if rowsChanged > 0 then
										MySQL.Async.execute('DELETE FROM esx_adrp_dealership WHERE plate = @plate', {
											['@plate'] = plate
										}, function(rowsChanged)
											if rowsChanged > 0 then
												MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, real_owner, state) VALUES (@owner, @plate, @vehicle, @real_owner, @state)', {
													['@owner'] = xPlayer.identifier,
													['@plate'] = plate,
													['@vehicle'] = buyingVehicle.vehicleProps,
													['@real_owner'] = xPlayer.identifier,
													['@state'] = true
												}, function(rowsChanged)
													if rowsChanged > 0 then
														xPlayer.removeAccountMoney('bank', buyingVehicle.price)
														xPlayer.showNotification(('You\'ve bought a ~y~%s~s~ for ~g~$%s~s~, it has been delivered to your garage'):format(buyingVehicle.label, ESX.Math.GroupDigits(buyingVehicle.price)))
		
														availableVehiclesForSale[plate] = nil
														isVehicleBusy[plate] = nil
														TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', -1, availableVehiclesForSale)
														cb(true)
													else
														isVehicleBusy[plate] = nil
														cb(false)
													end
												end)
											else
												isVehicleBusy[plate] = nil
												cb(false)
											end
										end)
									else
										isVehicleBusy[plate] = nil
										cb(false)
									end
								end)
							else
								print('esx_adrp_dealership: could not handle exception db-missing-networkid')
								xPlayer.showNotification('This vehicle cannot be bought since the owner of this vehicle has deleted his character. This vehicle will automatically unlist itself.')
								isVehicleBusy[plate] = nil
								cb(false)
							end
						end)
					end
				else
					xPlayer.showNotification('You cannot afford the vehicle!')
					isVehicleBusy[plate] = nil
					cb(false)
				end
			else
				xPlayer.showNotification('The vehicle price was just changed! Please reload your menu to reveal the new price.')
				isVehicleBusy[plate] = nil
				cb(false)
			end
		else
			xPlayer.showNotification('That vehicle is no longer for sale, please reload your menu.')
			isVehicleBusy[plate] = nil
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_adrp_dealership:changePrice', function(playerId, cb, plate, price)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and availableVehiclesForSale[plate] and tonumber(price) then
		price = ESX.Math.Round(price)
		local buyingVehicle = availableVehiclesForSale[plate]

		if buyingVehicle.networkID == xPlayer.get('networkID') then
			if price > 0 and price <= Config.MaxVehiclePrice then
				if price ~= buyingVehicle.price then
					MySQL.Async.execute('UPDATE esx_adrp_dealership SET price = @price WHERE plate = @plate', {
						['@plate'] = plate,
						['@price'] = price
					}, function(rowsChanged)
						if rowsChanged > 0 then
							availableVehiclesForSale[plate].price = price
							TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', -1, availableVehiclesForSale)
						end

						xPlayer.showNotification('The vehicle price has been changed.')
						cb(true)
					end)
				else
					xPlayer.showNotification('That\'s the current vehicle price!')
					cb(false)
				end
			else
				xPlayer.showNotification('That price is not allowed!')
				cb(false)
			end
		else
			xPlayer.showNotification('You do not own this vehicle!')
			cb(false)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_adrp_dealership:unlistVehicle', function(playerId, cb, plate)
	if not isVehicleBusy[plate] then
		isVehicleBusy[plate] = true
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer and availableVehiclesForSale[plate] then
			local buyingVehicle, networkID = availableVehiclesForSale[plate], xPlayer.get('networkID')

			if buyingVehicle.networkID == networkID then
				MySQL.Async.execute('DELETE FROM esx_adrp_dealership WHERE network_id = @network_id AND plate = @plate', {
					['@network_id'] = networkID,
					['@plate'] = plate
				}, function(rowsChanged)
					if rowsChanged > 0 then
						MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, real_owner, state) VALUES (@owner, @plate, @vehicle, @real_owner, @state)', {
							['@owner'] = xPlayer.identifier,
							['@plate'] = plate,
							['@vehicle'] = buyingVehicle.vehicleProps,
							['@real_owner'] = xPlayer.identifier,
							['@state'] = true
						}, function(rowsChanged)
							if rowsChanged > 0 then
								availableVehiclesForSale[plate] = nil
								isVehicleBusy[plate] = nil
								TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', -1, availableVehiclesForSale)
								cb(true)
							else
								isVehicleBusy[plate] = nil
								cb(false)
							end
						end)
					else
						isVehicleBusy[plate] = nil
						cb(false)
					end
				end)
			else
				xPlayer.showNotification('You do not own this vehicle!')
				isVehicleBusy[plate] = nil
				cb(false)
			end
		else
			isVehicleBusy[plate] = nil
			cb(false)
		end
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_adrp_dealership:addVehicle', function(playerId, cb, plate, label, price)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if not isVehicleBusy[plate] and tonumber(price) and not availableVehiclesForSale[plate] and xPlayer then
		local networkID = xPlayer.get('networkID')
		isVehicleBusy[plate] = true
		price = ESX.Math.Round(price)

		if price > 0 and price <= Config.MaxVehiclePrice then
			MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
				['@identifier'] = xPlayer.identifier,
				['@plate'] = plate
			}, function(result)
				if result[1] then
					MySQL.Async.execute('INSERT INTO esx_adrp_dealership (plate, owner, network_id, label, vehicle_props, price) VALUES (@plate, @owner, @network_id, @label, @vehicle_props, @price)', {
						['@plate'] = plate,
						['@owner'] = xPlayer.identifier,
						['@network_id'] = networkID,
						['@label'] = label,
						['@vehicle_props'] = result[1].vehicle,
						['@price'] = price
					}, function(rowsChanged)
						MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
							['@plate'] = plate
						}, function(rowsChanged)
							availableVehiclesForSale[plate] = {
								owner = xPlayer.identifier,
								networkID = networkID,
								label = label,
								vehicleProps = result[1].vehicle,
								price = price
							}

							TriggerClientEvent('esx_adrp_dealership:setVehiclesForSale', -1, availableVehiclesForSale)
							xPlayer.showNotification('The vehicle has been put out for sale!')
							isVehicleBusy[plate] = nil
							cb(true)
						end)
					end)
				else
					xPlayer.showNotification('You do not own that vehicle!')
					isVehicleBusy[plate] = nil
					cb(false)
				end
			end)
		else
			xPlayer.showNotification('That price is not allowed')
			isVehicleBusy[plate] = nil
			cb(false)
		end
	else
		cb(false)
	end
end)