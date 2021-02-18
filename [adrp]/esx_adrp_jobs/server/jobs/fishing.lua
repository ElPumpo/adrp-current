local playersFishing = {}
local playersCooking = {}

ESX.RegisterUsableItem('fishingnet', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer and not playersFishing[playerId] then
		local playerCoords = xPlayer.getCoords(true)

		if isPlayerNearAnyFishingSpot(playerCoords) then
			playersFishing[playerId] = {timeStart = os.clock(), lastCoords = playerCoords}
			TriggerClientEvent('esx_adrp_jobs:fishing:startFishing', playerId)
		else
			xPlayer.showNotification('You can only use your fishing net at ~b~Fishing Spots~s~!')
		end
	elseif xPlayer and playersFishing[playerId] then
		xPlayer.showNotification('You have already thrown your fishing net, wait it for to come back up.')
	end
end)

RegisterNetEvent('esx_adrp_jobs:fishing:cancel')
AddEventHandler('esx_adrp_jobs:fishing:cancel', function()
	playersFishing[source] = nil
end)

function isPlayerNearAnyFishingSpot(playerCoords)
	for k,v in ipairs(Config.Fishing.FishingZones) do
		if #(playerCoords - v) < Config.Fishing.FishingZoneRadius then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local timeNow = os.clock()

		for playerId,details in pairs(playersFishing) do
			Citizen.Wait(100)
			local xPlayer = ESX.GetPlayerFromId(playerId)

			-- Is player online?
			if xPlayer then
				local timeSpent = timeNow - details.timeStart

				-- Player has spent >= 5 active seconds in mine
				if timeSpent >= 10 then
					local playerCoords = xPlayer.getCoords(true)
					local unitsMovedSinceLastTick = #(playerCoords - details.lastCoords)
					details.lastCoords = playerCoords

					-- Is player still in the zone?
					if isPlayerNearAnyFishingSpot(playerCoords) and unitsMovedSinceLastTick < 50 then
						math.randomseed(os.clock())
						local randomIndex = math.random(1, #Config.Fishing.AvailableFish)
						local randomItem = Config.Fishing.AvailableFish[randomIndex]

						if randomItem == 'none' then
							xPlayer.showNotification('You didn\'t catch anything.')
							playersFishing[playerId] = nil
							TriggerClientEvent('esx_adrp_jobs:fishing:cancel', playerId)
						else
							local playerItem = xPlayer.getInventoryItem(randomItem)

							if playerItem.count + 1 <= playerItem.limit then
								xPlayer.addInventoryItem(randomItem, 1)
							else
								xPlayer.showNotification(('You caught a ~y~%s~s~ but the fish could not be stored due to item limit reached.'):format(playerItem.label))
							end
	
							-- dont repeat, so set as nil
							playersFishing[playerId] = nil
							TriggerClientEvent('esx_adrp_jobs:fishing:cancel', playerId)
						end
					else
						-- Player left zone, cancel animation and remove from active table
						xPlayer.showNotification('You are outside of the zone, or moved too much.')
						playersFishing[playerId] = nil
						TriggerClientEvent('esx_adrp_jobs:fishing:cancel', playerId)
					end
				end
			else
				-- Player not online, remove from active table
				playersFishing[playerId] = nil
			end
		end
	end
end)


-- TODO implement burnt fish? can be a part of our talent system
RegisterNetEvent('esx_adrp_jobs:fishing:finishCooking')
AddEventHandler('esx_adrp_jobs:fishing:finishCooking', function(success)
	if playersCooking[source] then
		if success then
			local xPlayer = ESX.GetPlayerFromId(source)
			local item = xPlayer.getInventoryItem(playersCooking[source])

			if item.count > 0 then
				local cookedItem = string.sub(playersCooking[source], 1, #playersCooking[source] - 4)
				xPlayer.addInventoryItem(cookedItem, 1)
				xPlayer.removeInventoryItem(playersCooking[source], 1)
			end
		end

		playersCooking[source] = nil
	end
end)

Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(1000)
	end

	local rawFish = {'salema_raw', 'ornate_raw', 'mackerel_raw', 'tuna_raw', 'mullet_raw', 'catshark_raw'}

	for k,v in pairs(rawFish) do
		ESX.RegisterUsableItem(v, function(playerId)
			cookFish(playerId, v)
		end)
	end
end)

function cookFish(playerId, fish)
	if not playersCooking[playerId] then
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			local item = xPlayer.getInventoryItem(fish)
			if item.count > 0 then
				playersCooking[playerId] = fish
				TriggerClientEvent('esx_adrp_jobs:fishing:startCooking', playerId, fish, item.label)
			end
		end
	end
end