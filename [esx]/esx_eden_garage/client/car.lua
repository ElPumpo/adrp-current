local CurrentAction, LastZone, CurrentActionMsg
local HasAlreadyEnteredMarker, times, currentGarage = false, 0, {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local zones, blipInfo = {}, {}

	for k,v in pairs(Config.Garages) do
		local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

		SetBlipSprite (blip, 290)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Car Garage')
		EndTextCommandSetBlipName(blip)

		local blip = AddBlipForCoord(v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z)

		SetBlipSprite (blip, 68)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Car Impound')
		EndTextCommandSetBlipName(blip)
	end
end)

function OpenMenuGarage(PointType)
	ESX.UI.Menu.CloseAll()
	local elements = {}

	if PointType == 'spawn' then
		table.insert(elements, {label = 'Vehicles in Garage', value = 'vehicles_in_garage'})
	end

	if PointType == 'delete' then
		table.insert(elements, {label = 'Store Vehicle in Garage', value = 'store_in_garage'})
	end

	if PointType == 'pound' then
		table.insert(elements, {
			label = ('Pay impound: <span style="color:#00ea1b;">$%s</span>]'):format(ESX.Math.GroupDigits(Config.Price)),
			value = 'impound'
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_menu', {
		title    = 'Garage - Main Menu',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'vehicles_in_garage' then
			OpenSpawnVehicleMenu()
		elseif data.current.value == 'store_in_garage' then
			OpenStoreVehicleMenu()
		elseif data.current.value == 'impound' then
			OpenImpoundMenu()
		end

		SpawnVehicle(data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenSpawnVehicleMenu()
	local elements, vehiclePropsList = {}, {}

	ESX.TriggerServerCallback('esx_eden_garage:getVehicles', function(vehicles)
		for k,v in ipairs(vehicles) do
			local vehicleProps = json.decode(v.vehicle)

			if IsModelInCdimage(vehicleProps.model) then
				vehiclePropsList[vehicleProps.plate] = vehicleProps
				local vehicleName, vehicleLabel = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model)), nil

				if vehicleName == 'NULL' then
					vehicleName = GetDisplayNameFromVehicleModel(vehicleProps.model)
					TriggerServerEvent('esx_eden_garage:sendNulledVehicle', GetDisplayNameFromVehicleModel(vehicleProps.model))
				end

				if v.state then
					vehicleLabel = ('%s: <span style="color:green;">In garage</span>'):format(vehicleName)
				else
					vehicleLabel = ('%s: <span style="color:darkred;">Impounded</span>'):format(vehicleName)
				end
	
				if not v.job and v.type == 'car' then
					table.insert(elements, {
						label = vehicleLabel,
						state = v.state,
						plate = vehicleProps.plate,
						vehicleName = vehicleName
					})
				end
			else
				table.insert(elements, {
					label = '<span style="color:darkred;">Detected Invalid Vehicle</span>',
					model = vehicleProps.model,
					plate = vehicleProps.plate,
					error = true
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_vehicle', {
			title    = 'Garage - Spawn Vehicle',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.error then
				local msg = ('<span style="font-weight: bold;">Invalid vehicle found!</span><br>This vehicle is missing from the server files. Please contact ADRP staff in order to get this sorted.<br><br><span style="font-weight: bold;">Vehicle Model:</span> %s<br><span style="font-weight: bold;">Vehicle Plate:</span> %s'):format(data.current.model, data.current.plate)
				TriggerEvent('customNotification', msg, 20000)
			else
				if data.current.state then
					menu.close()
					local vehicleProps = vehiclePropsList[data.current.plate]
					SpawnVehicle(vehicleProps, data.current.vehicleName)
				else
					ESX.ShowNotification('That vehicle is ~o~impounded~s~ and cannot be taken out here!')
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenRepairMenu(fixPrice, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()

	local elements = {
		{
			label = ('Store vehicle: <span style="color:#00ea1b;">$%s</span>'):format(ESX.Math.GroupDigits(fixPrice)),
			value = 'yes'
		},

		{
			label = 'See the mechanic',
			value = 'no'
		}
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'repair_menu', {
		title    = 'Garage - Pay Vehicle Damage',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_eden_garage:payVehicleDamage', function(paid)
				if paid then
					vehicleProps.bodyHealth = 1000.0
					vehicleProps.engineHealth = 1000
					StoreVehicle(vehicle, vehicleProps)
				end
			end, fixPrice)
		elseif data.current.value == 'no' then
			ESX.ShowNotification('You should call a mechanic!')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function StoreVehicle(vehicle, vehicleProps)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('esx_eden_garage:modifyState', vehicleProps, true, nil)
	ESX.ShowNotification('Your vehicle has successfully been stored in the garage.')
end

function OpenStoreVehicleMenu()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local engineHealth = GetVehicleEngineHealth(vehicle)

		ESX.TriggerServerCallback('esx_eden_garage:storeVehicle', function(isStored)
			if isStored then
				if engineHealth < 1000 then
					local fixPrice = ESX.Math.Round((1000 - engineHealth) * 17)
					OpenRepairMenu(fixPrice, vehicle, vehicleProps)
				else
					StoreVehicle(vehicle, vehicleProps)
				end
			else
				ESX.ShowNotification('You can not store this vehicle, sorry.')
			end
		end, vehicleProps)
	else
		ESX.ShowNotification('You are not sitting in an vehicle!')
	end
end

function SpawnVehicle(vehicleProps, vehicleName)
	ESX.Game.SpawnVehicle(vehicleProps.model, {x = currentGarage.SpawnPoint.Pos.x, y = currentGarage.SpawnPoint.Pos.y, z = currentGarage.SpawnPoint.Pos.z + 1}, currentGarage.SpawnPoint.Heading, function(vehicle)
		ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
	end)

	TriggerServerEvent('esx_eden_garage:modifyState', vehicleProps, false, vehicleName)
end

function SpawnImpoundedVehicle(vehicleProps, vehicleName)
	ESX.Game.SpawnVehicle(vehicleProps.model, {x = currentGarage.SpawnMunicipalPoundPoint.Pos.x, y = currentGarage.SpawnMunicipalPoundPoint.Pos.y, z = currentGarage.SpawnMunicipalPoundPoint.Pos.z + 1}, 180.0, function(vehicle)
		ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
	end)

	TriggerServerEvent('esx_eden_garage:modifyState', vehicleProps, true, vehicleName)

	ESX.SetTimeout(10000, function()
		TriggerServerEvent('esx_eden_garage:modifyState', vehicleProps, false, vehicleName)
	end)
end

AddEventHandler('esx_eden_garage:hasEnteredMarker', function(zone)
	if zone == 'spawn' then
		CurrentAction     = 'spawn'
		CurrentActionMsg  = 'Press ~INPUT_PICKUP~ to open the ~y~Vehicle Garage~s~.'
	elseif zone == 'delete' then
		CurrentAction     = 'delete'
		CurrentActionMsg  = 'Press ~INPUT_PICKUP~ to save your vehicle in the ~o~Garage~s~.'
	elseif zone == 'pound' then
		CurrentAction     = 'pound_action_menu'
		CurrentActionMsg  = 'Press ~INPUT_PICKUP~ to access the ~b~Vehicle Impound~s~.'
	end
end)

AddEventHandler('esx_eden_garage:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

function OpenImpoundMenu()
	ESX.TriggerServerCallback('esx_eden_garage:getOutVehicles', function(vehicles)
		local elements, vehiclePropsList = {}, {}

		for k,v in ipairs(vehicles) do
			local vehicleProps = json.decode(v.vehicle)

			if IsModelInCdimage(vehicleProps.model) then
				vehiclePropsList[vehicleProps.plate] = vehicleProps

				local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(vehicleProps.model))
				
				if vehicleName == 'NULL' then
					vehicleName = GetDisplayNameFromVehicleModel(vehicleProps.model)
					TriggerServerEvent('esx_eden_garage:sendNulledVehicle', GetDisplayNameFromVehicleModel(vehicleProps.model))
				end

				local vehicleLabel = ('%s: <span style="color:darkred;">Not in Garage</span>'):format(vehicleName)
	
				if not v.job and v.type == 'car' then
					table.insert(elements, {
						label = vehicleLabel,
						plate = vehicleProps.plate,
						vehicleName = vehicleName
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impounded_menu', {
			title    = 'Garage - Impounded Vehicles',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_eden_garage:checkMoney', function(canAfford)
				if canAfford then
					if times == 0 then
						TriggerServerEvent('esx_eden_garage:pay')
						local vehicleProps = vehiclePropsList[data.current.plate]
						SpawnImpoundedVehicle(vehicleProps, data.current.vehicleName)
						ESX.UI.Menu.CloseAll()
						times = times + 1
					elseif times > 0 then
						TriggerEvent('customNotification', 'You can\'t get a car out yet, please wait...')
						ESX.SetTimeout(60000, function()
							times = 0
						end)
					end
				else
					ESX.ShowNotification('You cannot afford that!')
				end
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

Citizen.CreateThread(function()
	local currentZone

	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true

		for k,v in pairs(Config.Garages) do
			local spawnDistance = GetDistanceBetweenCoords(coords, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, true)
			local deleteDistance = GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true)

			if spawnDistance < Config.DrawDistance then
				letSleep = false
				DrawMarker(v.SpawnPoint.Marker, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, v.SpawnPoint.Rotate, nil, nil, false)

				if spawnDistance < v.Size.x then
					isInMarker  = true
					currentGarage = v
					currentZone = 'spawn'
				end
			end

			if deleteDistance < Config.DrawDistance then
				letSleep = false
				DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, v.SpawnPoint.Rotate, nil, nil, false)

				if deleteDistance < v.Size.x then
					isInMarker  = true
					currentGarage = v
					currentZone = 'delete'
				end
			end

			local distance = GetDistanceBetweenCoords(coords, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, true)

			if distance < Config.DrawDistance then
				letSleep = false
				DrawMarker(v.MunicipalPoundPoint.Marker, v.MunicipalPoundPoint.Pos.x, v.MunicipalPoundPoint.Pos.y, v.MunicipalPoundPoint.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.MunicipalPoundPoint.Size.x, v.MunicipalPoundPoint.Size.y, v.MunicipalPoundPoint.Size.z, v.MunicipalPoundPoint.Color.r, v.MunicipalPoundPoint.Color.g, v.MunicipalPoundPoint.Color.b, 100, false, true, 2, v.MunicipalPoundPoint.Rotate, nil, nil, false)
	
				if distance < v.MunicipalPoundPoint.Size.x then
					isInMarker  = true
					currentGarage = v
					currentZone = 'pound'
				end
			end
		end

		for k,v in ipairs(Config.GangGarages) do
			local spawnDistance = GetDistanceBetweenCoords(coords, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, true)
			local deleteDistance = GetDistanceBetweenCoords(coords, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, true)

			if spawnDistance < Config.DrawDistance then
				letSleep = false
				DrawMarker(v.SpawnPoint.Marker, v.SpawnPoint.Pos.x, v.SpawnPoint.Pos.y, v.SpawnPoint.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.SpawnPoint.Size.x, v.SpawnPoint.Size.y, v.SpawnPoint.Size.z, v.SpawnPoint.Color.r, v.SpawnPoint.Color.g, v.SpawnPoint.Color.b, 100, false, true, 2, v.SpawnPoint.Rotate, nil, nil, false)

				if spawnDistance < v.Size.x then
					isInMarker  = true
					currentGarage = v
					currentZone = 'spawn'
				end
			end

			if deleteDistance < Config.DrawDistance then
				letSleep = false
				DrawMarker(v.DeletePoint.Marker, v.DeletePoint.Pos.x, v.DeletePoint.Pos.y, v.DeletePoint.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.DeletePoint.Size.x, v.DeletePoint.Size.y, v.DeletePoint.Size.z, v.DeletePoint.Color.r, v.DeletePoint.Color.g, v.DeletePoint.Color.b, 100, false, true, 2, v.DeletePoint.Rotate, nil, nil, false)

				if deleteDistance < v.Size.x then
					isInMarker  = true
					currentGarage = v
					currentZone = 'delete'
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_eden_garage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_eden_garage:hasExitedMarker', LastZone)
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
				if CurrentAction == 'pound_action_menu' then
					OpenMenuGarage('pound')
				elseif CurrentAction == 'spawn' then
					OpenMenuGarage('spawn')
				elseif CurrentAction == 'delete' then
					OpenMenuGarage('delete')
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)