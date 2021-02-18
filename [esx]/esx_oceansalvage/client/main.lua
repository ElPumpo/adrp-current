ESX = nil
local lastZone, CurrentAction, CurrentActionMsg, blipCloakRoom, blipVehicle, blipVehicleDeleter, NPCTargetPool, NPCTargetPoolBlip, lastPool
local OnJob, isBusy, hasAlreadyEnteredMarker, onDuty = false, false, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	CreateBlip()
end)

function SelectPool()
	local index = GetRandomIntInRange(1, #Config.Pool)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Pool[index].x and v.Pos.y == Config.Pool[index].y and v.Pos.z == Config.Pool[index].z then
			return k
		end
	end
end

function StartNPCJob()
	if lastPool then
		NPCTargetPool = lastPool
		lastPool = nil
	else
		NPCTargetPool = SelectPool()
	end

	local zone = Config.Zones[NPCTargetPool]

	NPCTargetPoolBlip = AddBlipForCoord(zone.Pos.x, zone.Pos.y, zone.Pos.z)
	SetBlipRoute(NPCTargetPoolBlip, true)
	ESX.ShowNotification(_U('gps_info'))
end

function StopNPCJob(cancel)
	if NPCTargetPoolBlip then
		RemoveBlip(NPCTargetPoolBlip)
		NPCTargetPoolBlip = nil
	end

	OnJob = false

	if cancel then
		ESX.ShowNotification(_U('cancel_mission'))
	else
		TriggerServerEvent('esx_oceansalvage:giveItem')
		StartNPCJob()
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NPCTargetPool then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local zone = Config.Zones[NPCTargetPool]

			if GetDistanceBetweenCoords(playerCoords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < 3 then
				ESX.ShowHelpNotification(_U('prompt_blowtorch'))

				if IsControlJustReleased(0, 38) and not isBusy then
					isBusy = true
					TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
					Citizen.Wait(17000)
					StopNPCJob()
					Citizen.Wait(3000)
					ClearPedTasksImmediately(playerPed)
					isBusy = false
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function CloakRoomMenu()
	local elements = {}

	if onDuty then
		table.insert(elements, {label = _U('end_service'), value = 'citizen_wear'})
	else
		table.insert(elements, {label = _U('take_service'), value = 'job_wear'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('locker_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'citizen_wear' then
			onDuty = false
			CreateBlip()
			menu.close()
			ESX.ShowNotification(_U('end_service_notif'))

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)

			StopNPCJob(true)
		elseif data.current.value == 'job_wear' then
			onDuty = true
			CreateBlip()
			menu.close()
			ESX.ShowNotification(_U('take_service_notif'))
			setUniform(data.current.value)
		end

		CurrentAction = 'cloakroom_menu'
		CurrentActionMsg = Config.Zones.Cloakroom.hint
	end, function(data, menu)
		menu.close()

		CurrentAction = 'cloakroom_menu'
		CurrentActionMsg = Config.Zones.Cloakroom.hint
	end)
end

function VehicleMenu()
	local elements = {
		{label = Config.Vehicles.JobBoat.Label, hash = Config.Vehicles.JobBoat.Hash}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
		title    = _U('vehicle_spawner_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local plateNum = math.random(1000, 9999)
		local platePrefix = Config.PlatePrefix

		ESX.Game.SpawnVehicle(data.current.hash, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
			SetVehicleNumberPlateText(vehicle, platePrefix .. plateNum)
		end)
	end, function(data, menu)
		menu.close()

		CurrentAction = 'vehiclespawn_menu'
		CurrentActionMsg = Config.Zones.VehicleSpawner.hint
	end)
end

AddEventHandler('esx_oceansalvage:hasEnteredMarker', function(zone)
	if zone == 'Cloakroom' then
		CurrentAction = 'cloakroom_menu'
		CurrentActionMsg = Config.Zones.Cloakroom.hint
	elseif zone == 'VehicleSpawner' then
		CurrentAction = 'vehiclespawn_menu'
		CurrentActionMsg = Config.Zones.VehicleSpawner.hint
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if GetPedInVehicleSeat(vehicle, -1) == playerPed then
				CurrentAction = 'delete_vehicle'
				CurrentActionMsg = Config.Zones.VehicleDeleter.hint
			end
		end
	elseif zone == 'Sell' then
		CurrentAction = 'Sell'
		CurrentActionMsg = Config.Zones.Sell.hint
	end
end)

AddEventHandler('esx_oceansalvage:hasExitedMarker', function(zone)
	if zone == 'Sell' then
		TriggerServerEvent('esx_oceansalvage:stopSell')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

function CreateBlip()
	if not blipCloakRoom then
		blipCloakRoom = AddBlipForCoord(Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z)

		SetBlipSprite(blipCloakRoom, Config.Zones.Cloakroom.BlipSprite)
		SetBlipColour(blipCloakRoom, Config.Zones.Cloakroom.BlipColor)
		SetBlipAsShortRange(blipCloakRoom, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.Zones.Cloakroom.BlipName)
		EndTextCommandSetBlipName(blipCloakRoom)
	end

	if onDuty then
		blipVehicle = AddBlipForCoord(Config.Zones.VehicleSpawner.Pos.x, Config.Zones.VehicleSpawner.Pos.y, Config.Zones.VehicleSpawner.Pos.z)

		SetBlipSprite(blipVehicle, Config.Zones.VehicleSpawner.BlipSprite)
		SetBlipColour(blipVehicle, Config.Zones.VehicleSpawner.BlipColor)
		SetBlipAsShortRange(blipVehicle, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.Zones.VehicleSpawner.BlipName)
		EndTextCommandSetBlipName(blipVehicle)

		BlipSell = AddBlipForCoord(Config.Zones.Sell.Pos.x, Config.Zones.Sell.Pos.y, Config.Zones.Sell.Pos.z)

		SetBlipSprite(BlipSell, Config.Zones.Sell.BlipSprite)
		SetBlipColour(BlipSell, Config.Zones.Sell.BlipColor)
		SetBlipAsShortRange(BlipSell, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.Zones.Sell.BlipName)
		EndTextCommandSetBlipName(BlipSell)

		blipVehicleDeleter = AddBlipForCoord(Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z)

		SetBlipSprite(blipVehicleDeleter, Config.Zones.VehicleDeleter.BlipSprite)
		SetBlipColour(blipVehicleDeleter, Config.Zones.VehicleDeleter.BlipColor)
		SetBlipAsShortRange(blipVehicleDeleter, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(Config.Zones.VehicleDeleter.BlipName)
		EndTextCommandSetBlipName(blipVehicleDeleter)
	else
		if blipVehicle then
			RemoveBlip(blipVehicle)
			blipVehicle = nil
		end

		if BlipSell then
			RemoveBlip(BlipSell)
			BlipSell = nil
		end

		if blipVehicleDeleter then
			RemoveBlip(blipVehicleDeleter)
			blipVehicleDeleter = nil
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, isInMarker, letSleep, currentZone = GetEntityCoords(PlayerPedId()), false, true, nil

		if onDuty then
			for k,v in pairs(Config.Zones) do
				if v.Draw then
					local distance = GetDistanceBetweenCoords(playerCoords, v.Pos.x, v.Pos.y, v.Pos.z, true)

					if distance < Config.DrawDistance then
						DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)
						letSleep = false

						if distance < v.Size.x then
							isInMarker, currentZone = true, k
						end
					end
				end
			end
		end

		local cloakroom = Config.Zones.Cloakroom
		local distance = GetDistanceBetweenCoords(playerCoords, cloakroom.Pos.x, cloakroom.Pos.y, cloakroom.Pos.z, true)

		if distance < Config.DrawDistance then
			DrawMarker(cloakroom.Type, cloakroom.Pos.x, cloakroom.Pos.y, cloakroom.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, cloakroom.Size.x, cloakroom.Size.y, cloakroom.Size.z, cloakroom.Color.r, cloakroom.Color.g, cloakroom.Color.b, 100, false, true, 2, false, nil, nil, false)
			letSleep = false

			if distance < cloakroom.Size.x then
				isInMarker  = true
				currentZone = 'Cloakroom'
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('esx_oceansalvage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_oceansalvage:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				local playerPed = PlayerPedId()

				if CurrentAction == 'cloakroom_menu' then
					if IsPedInAnyVehicle(playerPed, false) then
						ESX.ShowNotification(_U('in_vehicle'))
					else
						CloakRoomMenu()
					end
				elseif CurrentAction == 'vehiclespawn_menu' then
					if IsPedInAnyVehicle(playerPed, false) then
						ESX.ShowNotification(_U('in_vehicle'))
					else
						VehicleMenu()
					end
				elseif CurrentAction == 'Sell' then
					TriggerServerEvent('esx_oceansalvage:startSell')
				elseif CurrentAction == 'delete_vehicle' then
					local vehicle = GetVehiclePedIsIn(playerPed, false)
					local hash = GetEntityModel(vehicle)
					local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
					local platePrefix = Config.PlatePrefix

					if string.find(plate, platePrefix) then
						local JobBoat = Config.Vehicles.JobBoat

						if hash == GetHashKey(JobBoat.Hash) then
							if GetVehicleEngineHealth(vehicle) <= 500 or GetVehicleBodyHealth(vehicle) <= 500 then
								ESX.ShowNotification(_U('vehicle_broken'))
							else
								ESX.Game.DeleteVehicle(vehicle)
							end
						end
					else
						ESX.ShowNotification(_U('bad_vehicle'))
					end
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 56) and onDuty and not isBusy then
			if OnJob then
				lastPool = NPCTargetPool
				StopNPCJob(true)
			else
				local playerPed = PlayerPedId()

				if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey('dinghy')) then
					StartNPCJob()
					OnJob = true
				else
					ESX.ShowNotification(_U('not_good_veh'))
				end
			end
		end
	end
end)

function setUniform(job)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('locker_nooutfit'))
			end
		else
			if Config.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('locker_nooutfit'))
			end
		end
	end)
end
