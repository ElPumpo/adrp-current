local taskID, jobVehicle, trailerVehicle, tankSize, currentBlip = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local letSleep = true

		for k,v in ipairs(Config.Fueler.StartPositions) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.area.coords, true)

			if distance < 100 then
				DrawMarker(v.area.type, v.area.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.area.scale, v.area.color, v.area.bobUpAndDown, false, 2, v.area.rotate, nil, nil, false)
				letSleep = false
			end

			if distance < 1 and not jobVehicle then
				DrawMissionText(_U('fueler_prompt_start'), 0)

				if IsControlJustReleased(0, Keys['E']) then
					ChooseFuelerVehicle(k)
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function ChooseFuelerVehicle(startPosition)
	local elements = {}

	for k,v in ipairs(Config.Fueler.StartPositions[startPosition].vehicles) do
		table.insert(elements, {
			label = ('%s'):format(v.label),
			vehicle = v.vehicle,
			number = k
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fueler_choose', {
		title    = _U('fueler_choose_title'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
		SpawnFuelerVehicle(startPosition, data.current.number)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function SpawnFuelerVehicle(startPosition, vehicleNumber)
	local vehicleObject = Config.Fueler.StartPositions[startPosition].vehicles[vehicleNumber]
	local found, spawnPoint = GetAvailableVehicleSpawnPoint(startPosition, 1)

	if found then
		ESX.Game.SpawnVehicle(vehicleObject.vehicle, spawnPoint.coords, spawnPoint.heading, function(vehicle)
			jobVehicle = vehicle

			TriggerServerEvent('esx_adrp_jobs:fueler:startJob')
			StartTrackingFuelerSpawn(spawnPoint.coords, startPosition)
		end)
	else
		ESX.ShowHelpNotification(_U('fueler_help_spawn_truck'))
	end
end

function StartTrackingFuelerSpawn(coords, startPosition)
	local playerPed = PlayerPedId()

	SetJobTask(coords, _U('fueler_blip_destination'), _U('fueler_task_get_in'))

	while not IsPedInVehicle(playerPed, jobVehicle, false) do
		Citizen.Wait(500)
	end

	SpawnFuelerTrailer(startPosition)
end

function SpawnFuelerTrailer(startPosition)
	local found, spawnPoint = GetAvailableVehicleSpawnPoint(startPosition, 2)

	Citizen.CreateThread(function()
		while not found do
			Citizen.Wait(0)
			ESX.ShowHelpNotification(_U('fueler_help_spawn_trailer'))
		end
	end)

	while not found do
		Citizen.Wait(1000)
		found, spawnPoint = GetAvailableVehicleSpawnPoint(startPosition, 2)
	end

	ESX.Game.SpawnVehicle('tanker2', spawnPoint.coords, spawnPoint.heading, function(vehicle)
		trailerVehicle = vehicle
		SetJobTask(spawnPoint.coords, _U('fueler_blip_destination'), _U('fueler_task_attach_trailer'))

		StartTrackingTrailer(startPosition)
	end)
end

function StartTrackingTrailer(startPosition)
	while true do
		Citizen.Wait(2000)
		local hasTrailer,_ = GetVehicleTrailerVehicle(jobVehicle, trailerVehicle)

		if hasTrailer then
			break
		end
	end

	tankSize = 2000

	-- todo maybe move? doesnt have to be in its own loop, instead loop with damage check etc?
	Citizen.CreateThread(function()
		while trailerVehicle do
			Citizen.Wait(0)

			DrawTimerBar(_U('fueler_timer_title'), ESX.Math.GroupDigits(tankSize), 1)
		end
	end)

	Citizen.CreateThread(function()
		while jobVehicle do
			Citizen.Wait(2000)
			local canContinue = true

			if trailerVehicle then
				local hasTrailer,_ = GetVehicleTrailerVehicle(jobVehicle, trailerVehicle)

				if not hasTrailer then
					canContinue = false
					ESX.ShowHelpNotification(_U('fueler_help_missing_trailer'))
				end
			end

			if not DoesEntityExist(jobVehicle) then
				canContinue = false
				ESX.ShowHelpNotification(_U('fueler_help_missing_truck'))
			else
				local health = GetVehicleEngineHealth(jobVehicle)

				if health < 100 then
					canContinue = false
					ESX.ShowHelpNotification(_U('fueler_help_truck_damaged'))
				end
			end

			if not canContinue then
				-- todo press f10 to cancel mission?
			end
		end
	end)

	local gasStations = Config.Fueler.GasStations

	DriveToNextGasStation(gasStations, startPosition)
end

function DriveToNextGasStation(gasStations, startPosition)
	local stationNum = math.random(1, #gasStations)
	local station = gasStations[stationNum]

	local fillStation = false

	SetJobTask(station, _U('fueler_blip_destination'), _U('fueler_task_drive_tostation'))
	local playerPed = PlayerPedId()

	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(playerCoords, station, true)
		local letSleep = true

		if distance < 100 then
			DrawMarker(2, station, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 250, 100, 100, 100, false, false, 2, true, nil, nil, false)
			letSleep = false
		end

		if distance < 5 then
			local vehicleDistance = GetDistanceBetweenCoords(playerCoords, GetEntityCoords(jobVehicle), true)
	
			if vehicleDistance < 5 then
				if IsPedOnFoot(playerPed) then
					ESX.ShowHelpNotification(_U('fueler_prompt_fill_station'))

					if IsControlJustReleased(0, Keys['E']) then
						fillStation = true
						break
					end
				else
					ESX.ShowHelpNotification(_U('fueler_help_invehicle'))
				end
			else
				ESX.ShowHelpNotification(_U('fueler_help_missing_vehicle'))
			end
		end

		if letSleep then
			Citizen.Wait(1000)
		end
	end

	if fillStation then
		local timer = 2

		while timer > 0 do
			Citizen.Wait(100)
			timer = timer - 0.01

			tankSize = tankSize - 10
		end

		SetJobTask(GetEntityCoords(jobVehicle), _U('fueler_blip_destination'), _U('fueler_task_getback'))

		while not IsPedInVehicle(PlayerPedId(), jobVehicle, false) do
			Citizen.Wait(2000)
		end
	end

	table.remove(gasStations, stationNum)

	if tankSize < 1 then
		ReturnTrailerAtDepot(startPosition)
	else
		DriveToNextGasStation(gasStations, startPosition)
	end
end

function ReturnTrailerAtDepot(startPosition)
	local trailerNum = math.random(1, #Config.Fueler.StartPositions[startPosition].returntrailer)
	local returnLocation = Config.Fueler.StartPositions[startPosition].returntrailer[trailerNum]
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	SetJobTask(returnLocation, _U('fueler_blip_destination'), _U('fueler_task_return_depot'))

	while true do
		Citizen.Wait(0)
		playerCoords = GetEntityCoords(playerPed)
		local distance, letSleep = GetDistanceBetweenCoords(playerCoords, returnLocation, true), true

		if distance < 100 then
			DrawMarker(1, returnLocation, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 5.0, 250, 10, 10, 100, false, false, 2, false, nil, nil, false)
			letSleep = false
		end

		if distance < 5 then
			ESX.ShowHelpNotification(_U('fueler_prompt_return_trailer'))

			if IsControlJustReleased(0, Keys['E']) then
				DetachVehicleFromTrailer(jobVehicle)
				Citizen.Wait(100)

				ESX.Game.DeleteVehicle(trailerVehicle)
				ESX.ShowNotification(_U('fueler_message_detached'))
				trailerVehicle = nil

				break
			end
		end

		if letSleep then
			Citizen.Wait(1000)
		end
	end

	AskPlayerToContinue(startPosition)
end

function AskPlayerToContinue(startPosition)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fueler_continue', {
		title    = _U('fueler_continue_title'),
		align    = 'center',
		elements = {
			{label = _U('fueler_continue_no'), action = 'no'},
			{label = _U('fueler_continue_yes'), action = 'yes'}
		}
	}, function(data, menu)
		menu.close()

		TriggerServerEvent('esx_adrp_jobs:fueler:queryPay')

		if data.current.action == 'no' then
			ReturnTruckAtDepot(startPosition)
		elseif data.current.action == 'yes' then
			SpawnFuelerTrailer(startPosition)
			TriggerServerEvent('esx_adrp_jobs:fueler:startJob')
		end
	end, function(data, menu)

	end)
end

function ReturnTruckAtDepot(startPosition)
	local truckNum = math.random(1, #Config.Fueler.StartPositions[startPosition].returntrucks)
	local returnLocation = Config.Fueler.StartPositions[startPosition].returntrucks[truckNum]
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)

	SetJobTask(returnLocation, _U('fueler_blip_destination'), _U('fueler_task_return_depot'))

	while true do
		Citizen.Wait(0)
		playerCoords = GetEntityCoords(playerPed)
		local distance, letSleep = GetDistanceBetweenCoords(playerCoords, returnLocation, true), true

		if distance < 100 then
			DrawMarker(1, returnLocation, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 5.0, 250, 10, 10, 100, false, false, 2, false, nil, nil, false)
			letSleep = false
		end

		if distance < 5 then
			local vehicleDistance = GetDistanceBetweenCoords(playerCoords, GetEntityCoords(jobVehicle), true)

			if not ESX.Game.IsVehicleEmpty(jobVehicle) then
				ESX.ShowHelpNotification(_U('fueler_help_not_empty'))
			elseif vehicleDistance < 5 then
				ESX.ShowHelpNotification(_U('fueler_prompt_return_truck'))

				if IsControlJustReleased(0, Keys['E']) then
					ESX.Game.DeleteVehicle(jobVehicle)

					TriggerServerEvent('esx_adrp_jobs:fueler:stopJob')
					break
				end
			else
				ESX.ShowHelpNotification(_U('fueler_help_missing_truck_depot'))
			end
		end

		if letSleep then
			Citizen.Wait(1000)
		end
	end

	if currentBlip and DoesBlipExist(currentBlip) then
		RemoveBlip(currentBlip)
	end

	taskID, jobVehicle, trailerVehicle, tankSize, currentBlip = 0

	TriggerServerEvent('esx_adrp_jobs:fueler:stopJob')
end

function SetJobTask(coords, blipText, missionText)
	taskID = taskID + 1

	if currentBlip and DoesBlipExist(currentBlip) then
		RemoveBlip(currentBlip)
	end

	currentBlip = AddBlipForCoord(coords)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(blipText)
	EndTextCommandSetBlipName(currentBlip)

	SetBlipRoute(currentBlip, true)

	Citizen.CreateThread(function()
		local currentID = taskID

		while taskID == currentID and jobVehicle do
			Citizen.Wait(0)

			DrawMissionText(missionText, 0)
		end
	end)
end

function GetAvailableVehicleSpawnPoint(startPosition, type)
	local found, spawnPoint, spawnPoints = false

	if type == 1 then -- vehicle
		spawnPoints = Config.Fueler.StartPositions[startPosition].spawnpoints
	elseif type == 2 then -- trailor
		spawnPoints = Config.Fueler.StartPositions[startPosition].trailers
	end

	for i=1, #spawnPoints do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i].coords, 3.0) then
			found, spawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, spawnPoint
	else
		return false
	end
end

Citizen.CreateThread(function()
	for k,v in ipairs(Config.Fueler.StartPositions) do
		local blip = AddBlipForCoord(v.blip.coords)

		SetBlipSprite (blip, v.blip.sprite)
		SetBlipColour (blip, v.blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('fueler_blip_home'))
		EndTextCommandSetBlipName(blip)
	end
end)