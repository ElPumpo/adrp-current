local playersInMine, playersProcessing = {}, {}

ESX.RegisterUsableItem('pickaxe', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and not playersInMine[playerId] then
		local playerCoords = xPlayer.getCoords(true)
		local distance = #(playerCoords - Config.Mining.Zones.Mine.coords)

		if distance < 20 then
			playersInMine[playerId] = os.clock()
			TriggerClientEvent('esx_adrp_jobs:mining:startMining', playerId)
		else
			xPlayer.showNotification('You can only use your pickaxe at the ~y~Mine Quarry~s~!')
		end
	elseif xPlayer and playersInMine[playerId] then
		playersInMine[playerId] = nil
		TriggerClientEvent('esx_adrp_jobs:mining:cancel', playerId)
	end
end)

RegisterNetEvent('esx_adrp_jobs:mining:sellItem')
AddEventHandler('esx_adrp_jobs:mining:sellItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		local distance
		if itemName == 'diamond' then
			distance = #(xPlayer.getCoords(true) - Config.Mining.Zones.JewelryStore.coords)
		elseif itemName == 'iron' or itemName == 'gold' then
			distance = #(xPlayer.getCoords(true) - Config.Mining.Zones.CommodityTrader.coords)
		else
			print(('esx_adrp_jobs:mining:sellItem: %s parsed invalid item %s'):format(xPlayer.identifier, itemName))
			return
		end

		if distance < 5 then
			local item = xPlayer.getInventoryItem(itemName)

			if item.count > 0 then
				local earn = item.count * Config.Mining.Prices[itemName]
				xPlayer.removeInventoryItem(itemName, item.count)
				xPlayer.addMoney(earn)

				xPlayer.showNotification(('You sold x~y~%s~s~ ~b~%s~s~ for ~g~$%s~s~'):format(item.count, item.label, ESX.Math.GroupDigits(earn)))
			else
				xPlayer.showNotification('You have none to sell!')
			end
		else
			print(('esx_adrp_jobs:mining:sellItem: distance: %s too far from %s'):format(distance, xPlayer.identifier))
		end
	end
end)

ESX.RegisterServerCallback('esx_adrp_jobs:mining:startProcessing', function(playerId, cb, itemName)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local foundItem = false

		for index,item in ipairs(Config.Mining.MineItems) do
			if itemName == item then
				foundItem = true
				break
			end
		end

		if foundItem then
			local distance = #(xPlayer.getCoords(true) - Config.Mining.Zones.MineProcessing.coords)

			if distance < 5 then
				local item = xPlayer.getInventoryItem(itemName)

				if item.count >= 9 then
					playersProcessing[playerId] = {timeStart = os.clock(), item = itemName}
					cb(true)
				else
					cb(false)
				end
			else
				cb(false)
			end
		else
			print(('esx_adrp_jobs: %s attempted mining:startProcessing with invalid item name %s'):format(xPlayer.identifier, itemName))
			cb(false)
		end
	else
		cb(false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local timeNow = os.clock()

		for playerId,timeStart in pairs(playersInMine) do
			Citizen.Wait(10)
			local xPlayer = ESX.GetPlayerFromId(playerId)

			-- Is player online?
			if xPlayer then
				local distance = #(xPlayer.getCoords(true) - Config.Mining.Zones.Mine.coords)
		
				-- Is player still in the zone?
				if distance < 20 then
					local timeSpent = timeNow - timeStart

					-- Player has spent >= 10 active seconds in mine
					if timeSpent >= 10 then
						math.randomseed(os.clock())
						local randomIndex = math.random(1, #Config.Mining.MineItems)
						local randomItem = Config.Mining.MineItems[randomIndex]
						local playerItem = xPlayer.getInventoryItem(randomItem)

						if playerItem.count + 1 <= playerItem.limit then
							xPlayer.addInventoryItem(randomItem, 1)
						else
							xPlayer.showNotification(('You mined ~y~%s~s~ but the item could not be stored due to item limit reached.'):format(playerItem.label))
						end

						playersInMine[playerId] = timeNow
					end
				else
					-- Player left zone, cancel animation and remove from active table
					playersInMine[playerId] = nil
					TriggerClientEvent('esx_adrp_jobs:mining:cancel', playerId)
				end
			else
				-- Player not online, remove from active table
				playersInMine[playerId] = nil
			end
		end

		for playerId,info in pairs(playersProcessing) do
			Citizen.Wait(10)
			local xPlayer = ESX.GetPlayerFromId(playerId)

			-- Is player online?
			if xPlayer then
				local distance = #(xPlayer.getCoords(true) - Config.Mining.Zones.MineProcessing.coords)
				
				-- Is player still in the zone?
				if distance < 2 then
					local timeSpent = timeNow - info.timeStart
					local item = xPlayer.getInventoryItem(info.item)

					-- No longer has item?
					if item.count < 9 then
						playersProcessing[playerId] = nil
						TriggerClientEvent('esx_adrp_jobs:mining:cancel', playerId)
					else
						-- Player has spent >= 50 active seconds in processing
						if timeSpent >= 50 then
							xPlayer.removeInventoryItem(info.item, 9)
							local msg = ('You have processed x~y~%s~s~ ~b~%s~s~ to ~y~x%s~s~ ~b~%s~s~')

							if info.item == 'iron_ore' then
								xPlayer.addInventoryItem('iron', 4)
								xPlayer.showNotification(msg:format(9, item.label, 4, 'Iron'))
							elseif info.item == 'gold_ore' then
								xPlayer.addInventoryItem('gold', 4)
								xPlayer.showNotification(msg:format(9, item.label, 4, 'Gold'))
							elseif info.item == 'diamond_uncut' then
								xPlayer.addInventoryItem('diamond', 2)
								xPlayer.showNotification(msg:format(9, item.label, 2, 'Diamond'))
							end

							playersProcessing[playerId] = nil
							TriggerClientEvent('esx_adrp_jobs:mining:cancel', playerId, true)
						end
					end
				else
					-- Player left zone, remove from active table
					playersProcessing[playerId] = nil
					TriggerClientEvent('esx_adrp_jobs:mining:cancel', playerId)
				end
			else
				-- Player not online, remove from active table
				playersProcessing[playerId] = nil
			end
		end
	end
end)