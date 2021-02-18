local campfireLocations = {}

-- Create Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Fishing.FishingZones) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite (blip, 68)
		SetBlipColour (blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Fishing Spot')
		EndTextCommandSetBlipName(blip)

		local blip = AddBlipForRadius(v, Config.Fishing.FishingZoneRadius)
		SetBlipColour(blip, 3)
		SetBlipAlpha(blip, 128)
	end
end)

RegisterNetEvent('esx_items:relayCampfireLocation')
AddEventHandler('esx_items:relayCampfireLocation', function(_campfireLocations)
	campfireLocations = _campfireLocations
end)

RegisterNetEvent('esx_adrp_jobs:fishing:startFishing')
AddEventHandler('esx_adrp_jobs:fishing:startFishing', function()
	local playerPed = PlayerPedId()

	if IsPedInAnyBoat(playerPed) then
		if GetEntitySpeed(GetVehiclePedIsIn(playerPed, false)) * 3.6 > 10 then
			ESX.ShowNotification('You are moving too fast')
			TriggerServerEvent('esx_adrp_jobs:fishing:cancel')
		else
			ESX.ShowNotification('You have dropped the fishing net')
		end
	else
		ESX.ShowNotification('You must sit in a boat in order to drop the fishing net!')
		TriggerServerEvent('esx_adrp_jobs:fishing:cancel')
	end
end)

RegisterNetEvent('esx_adrp_jobs:fishing:startCooking')
AddEventHandler('esx_adrp_jobs:fishing:startCooking', function(fish, fishLabel)
	local playerPed = PlayerPedId()
	local playerCoords, isNearAnyCampfire = GetEntityCoords(playerPed), false

	for k,v in ipairs(campfireLocations) do
		local distance = #(playerCoords - vector3(v.x, v.y, v.z))

		if distance < 2 then
			isNearAnyCampfire = true
			break
		end
	end

	if isNearAnyCampfire then
		ESX.Streaming.RequestAnimDict('anim@heists@money_grab@duffel', function()
			TaskPlayAnim(playerPed, 'anim@heists@money_grab@duffel', 'loop', 3.0, 3.0, -1, 0, 0.0, false, false, false)
		end)

		local actionTime, timeWaited, checkTime, lastCheckTime = 3, 0, 10, GetGameTimer()

		while timeWaited < actionTime do
			Citizen.Wait(1)
			if GetGameTimer() > lastCheckTime + checkTime then
				timeWaited = timeWaited + 0.01
				lastCheckTime = GetGameTimer()
			end

			ESX.Game.Utils.ProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, ('Cooking %s ...'):format(fishLabel))
		end

		TriggerServerEvent('esx_adrp_jobs:fishing:finishCooking', true)
	else
		ESX.ShowNotification('You can only cook fish with ~o~camp fires~s~.')
		TriggerServerEvent('esx_adrp_jobs:fishing:finishCooking', false)
	end
end)