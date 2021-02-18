ESX = nil
local workTruck, lastMission, garbageBag, collectionAction, trashCollection, trashCollectionCoords, missionReturnTruck, missionDelivery, isInService, truckDeposit, hasAlreadyEnteredMarker, lastZone, CurrentAction, destination
local nameZone, nameZoneNum, nameZoneRegion, missionRegion, vehicleMaxHealth, moneyTookOff, deliveryTotalPay, bagsOfTrash = 'Delivery', 0, 0, 0, 1000, 0, 0, math.random(2, 10)
local deliveryNumber, missionNum, blips, vehiclePlate, vehicleRealPlate, CurrentActionMsg, CurrentActionData, totalBagPay, currentBag = 0, 0, {}, '', '', '', {}, 0, bagsOfTrash

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function MenuCloakRoom()
	ESX.UI.Menu.CloseAll()
	local elements

	if isInService then
		elements = {{label = 'Cloak Off', service = false}}
	else
		elements = {{label = 'Cloak On', service = true}}
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.service then
			TriggerEvent('customNotification', 'You have clocked on')
			isInService = true
		else
			TriggerEvent('customNotification', 'You have clocked off')
			isInService = false
		end
	end, function(data, menu)
		menu.close()
	end)
end

function MenuVehicleSpawner(location, part)
	local elements = {}

	for i=1, #Config.Trucks do
		table.insert(elements, {
			label = GetLabelText(GetDisplayNameFromVehicleModel(Config.Trucks[i])),
			model = Config.Trucks[i]
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = _U('vehiclespawner'),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		menu.close()
		local spawnPoint = Config.JobLocations[location].vehicles[part].spawnPoint

		if ESX.Game.IsSpawnPointClear(spawnPoint.coords, 10.0) then
			ESX.Game.SpawnVehicle(data.current.model, spawnPoint.coords, spawnPoint.heading, function(vehicle)
				local plateNum = math.random(100, 999)
				vehiclePlate = 'TRASH'..plateNum
				SetVehicleNumberPlateText(vehicle, vehiclePlate)
				MissionDeliverySelect()

				if data.current.model == 'phantom3' then
					ESX.Game.SpawnVehicle('trailers2', spawnPoint.coords, spawnPoint.heading, function(trailer)
						AttachVehicleToTrailer(vehicle, trailer, 1.1)
					end)
				end
			end)
		else
			ESX.ShowNotification('The current spawnpoint is blocked!')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function IsATruck()
	local playerPed = PlayerPedId()

	for i=1, #Config.Trucks do
		if IsVehicleModel(GetVehiclePedIsUsing(playerPed), Config.Trucks[i]) then
			return true
		end
	end

	return false
end

AddEventHandler('esx_garbagejob:hasEnteredMarker', function(zone, location, part)
	local playerPed = PlayerPedId()

	if zone == 'cloakroom' then
		CurrentAction, CurrentActionMsg = 'cloakroom', _U('cloakroom_prompt')
	elseif zone == 'vehicles' then
		if missionReturnTruck or missionDelivery then
			CurrentAction, CurrentActionMsg = 'hint', _U('already_have_truck')
		else
			MenuVehicleSpawner(location, part)
		end
	elseif zone == nameZone then
		if not collectionAction then
			if isInService and missionDelivery and missionNum == nameZoneNum and missionRegion == nameZoneRegion then
				if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
					UpdateCurrentVehiclePlate()

					if vehiclePlate == vehicleRealPlate then
						if blips.delivery then
							RemoveBlip(blips.delivery)
							blips.delivery = nil
						end

						CurrentAction, CurrentActionMsg = 'delivery', _U('delivery')
					else
						CurrentAction, CurrentActionMsg = 'hint', _U('not_your_truck')
					end
				else
					CurrentAction, CurrentActionMsg = 'hint', _U('not_your_truck2')
				end
			end
		end
	elseif zone == 'CancelMission' then
		if isInService and missionDelivery then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				UpdateCurrentVehiclePlate()

				if vehiclePlate == vehicleRealPlate then
					CurrentAction, CurrentActionMsg = 'return_truck_cancel_mission', _U('cancel_mission')
				else
					CurrentAction, CurrentActionMsg = 'hint', _U('not_your_truck')
				end
			else
				CurrentAction = 'return_truck_lost_cancel_mission'
			end
		end
	elseif zone == 'ReturnTruck' then
		if isInService and missionReturnTruck then
			if IsPedSittingInAnyVehicle(playerPed) and IsATruck() then
				UpdateCurrentVehiclePlate()

				if vehiclePlate == vehicleRealPlate then
					CurrentAction, CurrentActionMsg = 'truck_return', _U('end_mission')
				else
					CurrentAction, CurrentActionMsg = 'return_truck_cancel_mission', _U('not_your_truck')
				end
			else
				CurrentAction, CurrentActionMsg = 'truck_lost', _U('end_mission_lost_truck')
			end
		end
	end
end)

AddEventHandler('esx_garbagejob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction, CurrentActionMsg = nil, nil
end)

function SetNextDestination()
	deliveryNumber = deliveryNumber + 1
	deliveryTotalPay = deliveryTotalPay + destination.pay + totalBagPay
	totalBagPay = 0

	if deliveryNumber >= Config.MaxDelivery then
		MissionDeliveryStopReturnToDepot()
	else
		local nextDelivery = math.random(0, 100)

		if nextDelivery <= 10 then
			MissionDeliveryStopReturnToDepot()
		elseif nextDelivery <= 80 then
			MissionDeliverySelect()
		elseif nextDelivery <= 100 then
			if missionRegion == 1 then
				missionRegion = 2
			elseif missionRegion == 2 then
				missionRegion = 1
			end

			MissionDeliverySelect()
		end
	end
end

function ReturnTruck()
	if blips.delivery then
		RemoveBlip(blips.delivery)
		blips.delivery = nil
	elseif blips.cancelMission then
		RemoveBlip(blips.cancelMission)
		blips.cancelMission = nil
	end

	missionReturnTruck = false
	deliveryNumber = 0
	missionRegion = 0

	GiveThePay()
end

function JobTruckLost()
	if blips.delivery then
		RemoveBlip(blips.delivery)
		blips.delivery = nil
	elseif blips.cancelMission then
		RemoveBlip(blips.cancelMission)
		blips.cancelMission = nil
	end

	missionReturnTruck = false
	deliveryNumber = 0
	missionRegion = 0

	PayForMissingTruck()
end

function ReturnTruckCancelMission()
	if blips.delivery then
		RemoveBlip(blips.delivery)
		blips.delivery = nil
	elseif blips.cancelMission then
		RemoveBlip(blips.cancelMission)
		blips.cancelMission = nil
	end

	missionDelivery = false
	deliveryNumber = 0
	missionRegion = 0

	GiveThePay()
end

function ReturnTruckLostCancelMission()
	if blips.delivery then
		RemoveBlip(blips.delivery)
		blips.delivery = nil
	elseif blips.cancelMission then
		RemoveBlip(blips.cancelMission)
		blips.cancelMission = nil
	end

	missionDelivery = false
	deliveryNumber = 0
	missionRegion = 0

	PayForMissingTruck()
end

function GiveThePay()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)
	local vehicleHealth = GetVehicleEngineHealth(vehicle)
	local vehicleDamgePay = ESX.Math.Round(vehicleMaxHealth - vehicleHealth)

	if vehicleDamgePay <= 0 then
		moneyTookOff = 0
	else
		moneyTookOff = vehicleDamgePay
	end

	ESX.Game.DeleteVehicle(vehicle)
	local amount = deliveryTotalPay - moneyTookOff

	if vehicleHealth >= 1 then
		if deliveryTotalPay == 0 then
			ESX.ShowNotification(_U('not_delivery'))
			ESX.ShowNotification(_U('pay_repair'))
			ESX.ShowNotification(_U('repair_minus', ESX.Math.GroupDigits(moneyTookOff)))
			TriggerServerEvent('esx_garbagejob:giveCash', amount)
			deliveryTotalPay = 0
		else
			if moneyTookOff <= 0 then
				ESX.ShowNotification(_U('shipments_plus', ESX.Math.GroupDigits(deliveryTotalPay)))
				TriggerServerEvent('esx_garbagejob:giveCash', amount)
				deliveryTotalPay = 0
			else
				ESX.ShowNotification(_U('shipments_plus', ESX.Math.GroupDigits(deliveryTotalPay)))
				ESX.ShowNotification(_U('repair_minus', ESX.Math.GroupDigits(moneyTookOff)))
				TriggerServerEvent('esx_garbagejob:giveCash', amount)
				deliveryTotalPay = 0
			end
		end
	else
		if deliveryTotalPay ~= 0 and amount <= 0 then
			ESX.ShowNotification(_U('truck_state'))
			deliveryTotalPay = 0
		else
			if moneyTookOff <= 0 then
				ESX.ShowNotification(_U('shipments_plus', ESX.Math.GroupDigits(deliveryTotalPay)))
				TriggerServerEvent('esx_garbagejob:giveCash', amount)
				deliveryTotalPay = 0
			else
				ESX.ShowNotification(_U('shipments_plus', ESX.Math.GroupDigits(deliveryTotalPay)))
				ESX.ShowNotification(_U('repair_minus', ESX.Math.GroupDigits(moneyTookOff)))
				TriggerServerEvent('esx_garbagejob:giveCash', amount)
				deliveryTotalPay = 0
			end
		end
	end
end

function PayForMissingTruck()
	moneyTookOff = Config.MissingTruckPrice
	local amount = deliveryTotalPay - moneyTookOff

	if deliveryTotalPay == 0 then
		ESX.ShowNotification(_U('no_delivery_no_truck'))
		ESX.ShowNotification(_U('truck_price', ESX.Math.GroupDigits(moneyTookOff)))
		TriggerServerEvent('esx_garbagejob:giveCash', amount)
		deliveryTotalPay = 0
	else
		if amount >= 1 then
			ESX.ShowNotification(_U('shipments_plus', ESX.Math.GroupDigits(deliveryTotalPay)))
			ESX.ShowNotification(_U('truck_price', ESX.Math.GroupDigits(moneyTookOff)))
			TriggerServerEvent('esx_garbagejob:giveCash', amount)
			deliveryTotalPay = 0
		else
			ESX.ShowNotification(_U('truck_state'))
			deliveryTotalPay = 0
		end
	end
end

function SelectNewTrashBin()
	local newBin, newBinDistance = ESX.Game.GetClosestObject(Config.DumpstersAvailable)
	trashCollectionCoords = GetEntityCoords(newBin)
end

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction or collectionAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if collectionAction == 'collection' then
					ESX.Streaming.RequestAnimDict('anim@heists@narcotics@trash')
					local playerPed = PlayerPedId()
					local playerCoords = GetEntityCoords(playerPed)
					local distance = #(playerCoords - trashCollectionCoords)

					if distance < 3.5 then
						if currentBag > 0 then
							TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
							Citizen.Wait(4000)
							ClearPedTasks(playerPed)
							local randomBag, boneIndex = math.random(0,2), GetPedBoneIndex(playerPed, 57005)

							if randomBag == 0 then
								ESX.Game.SpawnObject('prop_cs_street_binbag_01', playerCoords, function(object)
									AttachEntityToEntity(object, playerPed, boneIndex, 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
									garbageBag = object
								end)
							elseif randomBag == 1 then
								ESX.Game.SpawnObject('bkr_prop_fakeid_binbag_01', playerCoords, function(object)
									AttachEntityToEntity(object, playerPed, boneIndex, 0.65, 0, -.1, 0, 270.0, 60.0, true, true, false, true, 1, true)
									garbageBag = object
								end)
							elseif randomBag == 2 then
								ESX.Game.SpawnObject('hei_prop_heist_binbag', playerCoords, function(object)
									AttachEntityToEntity(object, playerPed, boneIndex, 0.12, 0.0, 0.00, 25.0, 270.0, 180.0, true, true, false, true, 1, true)
									garbageBag = object
								end)
							end

							DisablePlayerFiring(playerPed, true)
							TaskPlayAnim(playerPed, 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0, -1, 49, 0.0, false, false, false)
							currentBag  = currentBag - 1
							trashCollection = false
							truckDeposit = true
							collectionAction = 'deposit'
						else
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_BUM_WASH', 0, true)
							Citizen.Wait(4000)
							ClearPedTasks(playerPed)
							bagsOfTrash = math.random(2, 10)
							currentBag = bagsOfTrash
							collectionAction = nil
							trashCollection = false
							truckDeposit = false

							ESX.ShowNotification('Collection finished, return to your truck!')

							while not IsPedInVehicle(playerPed, workTruck, false) do
								Citizen.Wait(500)
							end

							SetVehicleDoorShut(workTruck, 5, false)
							Citizen.Wait(2000)
							SetNextDestination()
						end
					end
				elseif collectionAction == 'deposit'  then
					local playerPed = PlayerPedId()
					local taillight_r, taillight_l = GetWorldPositionOfEntityBone(workTruck, GetEntityBoneIndexByName(workTruck, 'taillight_r')), GetWorldPositionOfEntityBone(workTruck, GetEntityBoneIndexByName(workTruck, 'taillight_l'))
					local newCoordX, newCoordY = (taillight_r.x - taillight_l.x) / 2, (taillight_r.y - taillight_l.y) / 2

					local tallLightCoords = vector3(taillight_r.x - newCoordX, taillight_r.y - newCoordY, taillight_r.z)
					local distance = #(GetEntityCoords(playerPed) - tallLightCoords)

					if distance < 2.0 then
						ClearPedTasksImmediately(playerPed)
						Citizen.Wait(5)
						TaskPlayAnim(playerPed, 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0, -1, 2, 0.0, false, false, false)
						Citizen.Wait(800)
						ESX.Game.DeleteObject(garbageBag)
						DisablePlayerFiring(playerPed, false)
						totalBagPay = totalBagPay + Config.BagPay
						Citizen.Wait(100)
						ClearPedTasksImmediately(playerPed)
						collectionAction = 'collection'
						truckDeposit = false
						trashCollection = true
					end
				end

				if CurrentAction == 'delivery' then
					workTruck = GetVehiclePedIsIn(PlayerPedId(), false)
					SetVehicleDoorOpen(workTruck, 5, false, false)

					if blips.delivery then
						RemoveBlip(blips.delivery)
						blips.delivery = nil
					end

					missionDelivery = false
					SelectNewTrashBin()
					trashCollection = true
					collectionAction = 'collection'
				elseif CurrentAction == 'truck_return' then
					ReturnTruck()
				elseif CurrentAction == 'truck_lost' then
					JobTruckLost()
				elseif CurrentAction == 'return_truck_cancel_mission' then
					ReturnTruckCancelMission()
				elseif CurrentAction == 'return_truck_lost_cancel_mission' then
					ReturnTruckLostCancelMission()
				elseif CurrentAction == 'cloakroom' then
					MenuCloakRoom()
				end

				CurrentAction = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep = true

		if truckDeposit then
			local taillight_r, taillight_l = GetWorldPositionOfEntityBone(workTruck, GetEntityBoneIndexByName(workTruck, 'taillight_r')), GetWorldPositionOfEntityBone(workTruck, GetEntityBoneIndexByName(workTruck, 'taillight_l'))
			local newCoordX, newCoordY = (taillight_r.x - taillight_l.x) / 2, (taillight_r.y - taillight_l.y) / 2
			local playerCoords = GetEntityCoords(PlayerPedId())
			local tailLightCoords = vector3(taillight_r.x - newCoordX, taillight_r.y - newCoordY, taillight_r.z)
			local distance = #(playerCoords - tailLightCoords)

			if distance < 20 then
				letSleep = false
				DrawMarker(27, tailLightCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.25, 1.25, 1.0, 0, 128, 0, 200, false, false, 2, false, nil, nil, false)

				if distance < 2 then
					ESX.Game.Utils.DrawText3D(vector3(tailLightCoords.x, tailLightCoords.y, tailLightCoords.z + .5), '[~g~E~s~] Throw bag in Truck', 1.0)
				end
			end
		end

		if trashCollection then
			letSleep = false
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - trashCollectionCoords)
			DrawMarker(1, trashCollectionCoords.x, trashCollectionCoords.y, trashCollectionCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 200, false, false, 2, false, nil, nil, false)

			if distance < 5 then
				if currentBag == 0 then
					ESX.Game.Utils.DrawText3D(trashCollectionCoords + vector3(0.0, 0.0, 1.0), '[~g~E~s~] Clean up debris', 1.0)
				else
					local formatted = ('[~g~E~s~] Collect bag from trash bin [%s/%s]'):format(currentBag, bagsOfTrash)
					ESX.Game.Utils.DrawText3D(trashCollectionCoords + vector3(0.0, 0.0, 1.0), formatted, 1.0)
				end
			end
		end

		if missionDelivery then
			letSleep = false
			DrawMarker(1, destination.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 3.0, 204, 204, 0, 100, false, false, 2, false, nil, nil, false)
			DrawMarker(1, Config.Deliveries.CancelMission.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 3.0, 204, 204, 0, 100, false, false, 2, false, nil, nil, false)
		elseif missionReturnTruck then
			letSleep = false
			DrawMarker(1, destination.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 3.0, 204, 204, 0, 100, false, false, 2, false, nil, nil, false)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Draw marker & Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, isInMarker, letSleep, currentZone, currentLocation, currentPart = GetEntityCoords(PlayerPedId()), false, true

		for k,v in ipairs(Config.JobLocations) do
			if isInService then
				-- Vehicle
				for l,w in ipairs(v.vehicles) do
					local distance = #(playerCoords - w.coords)

					if distance < Config.DrawDistance then
						letSleep = false
						DrawMarker(w.type, w.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, w.scale, w.color.r, w.color.g, w.color.b, w.color.a, false, false, 2, false, nil, nil, false)

						if distance < w.scale.x then
							isInMarker, currentZone, currentLocation, currentPart = true, 'vehicles', k, l
						end
					end
				end

				for k,v in pairs(Config.Deliveries) do
					local distance = #(playerCoords - v.coords)

					if distance < 5 then
						isInMarker, currentZone = true, k
					end
				end
			end

			-- Cloakroom
			local distance = #(playerCoords - v.cloakroom)

			if distance < Config.DrawDistance then
				letSleep = false
				DrawMarker(1, v.cloakroom, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 204, 204, 0, 100, false, false, 2, false, nil, nil, false)

				if distance < 3 then
					isInMarker, currentZone, currentLocation = true, 'cloakroom', k
				end
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('esx_garbagejob:hasEnteredMarker', currentZone, currentLocation, currentPart)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_garbagejob:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Create Blip
Citizen.CreateThread(function()
	for k,v in ipairs(Config.JobLocations) do
		local blip = AddBlipForCoord(v.cloakroom)

		SetBlipSprite(blip, 318)
		SetBlipColour(blip, 5)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('blip_job'))
		EndTextCommandSetBlipName(blip)
	end
end)

function MissionDeliverySelect()
	if missionRegion == 0 then
		missionRegion = math.random(1, 2)
	end

	if missionRegion == 1 then -- Los santos
		missionNum = math.random(1, 10)
		while lastMission == missionNum do
			Citizen.Wait(50)
			missionNum = math.random(1, 10)
		end

		if missionNum == 1 then destination = Config.Deliveries.Delivery1LS nameZone = 'Delivery1LS' nameZoneNum = 1 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 2 then destination = Config.Deliveries.Delivery2LS nameZone = 'Delivery2LS' nameZoneNum = 2 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 3 then destination = Config.Deliveries.Delivery3LS nameZone = 'Delivery3LS' nameZoneNum = 3 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 4 then destination = Config.Deliveries.Delivery4LS nameZone = 'Delivery4LS' nameZoneNum = 4 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 5 then destination = Config.Deliveries.Delivery5LS nameZone = 'Delivery5LS' nameZoneNum = 5 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 6 then destination = Config.Deliveries.Delivery6LS nameZone = 'Delivery6LS' nameZoneNum = 6 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 7 then destination = Config.Deliveries.Delivery7LS nameZone = 'Delivery7LS' nameZoneNum = 7 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 8 then destination = Config.Deliveries.Delivery8LS nameZone = 'Delivery8LS' nameZoneNum = 8 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 9 then destination = Config.Deliveries.Delivery9LS nameZone = 'Delivery9LS' nameZoneNum = 9 nameZoneRegion = 1 lastMission = missionNum
		elseif missionNum == 10 then destination = Config.Deliveries.Delivery10LS nameZone = 'Delivery10LS' nameZoneNum = 10 nameZoneRegion = 1 lastMission = missionNum
		end

	elseif missionRegion == 2 then -- Blaine County
		missionNum = math.random(1, 10)

		if missionNum == 1 then destination = Config.Deliveries.Delivery1BC nameZone = 'Delivery1BC' nameZoneNum = 1 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 2 then destination = Config.Deliveries.Delivery2BC nameZone = 'Delivery2BC' nameZoneNum = 2 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 3 then destination = Config.Deliveries.Delivery3BC nameZone = 'Delivery3BC' nameZoneNum = 3 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 4 then destination = Config.Deliveries.Delivery4BC nameZone = 'Delivery4BC' nameZoneNum = 4 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 5 then destination = Config.Deliveries.Delivery5BC nameZone = 'Delivery5BC' nameZoneNum = 5 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 6 then destination = Config.Deliveries.Delivery6BC nameZone = 'Delivery6BC' nameZoneNum = 6 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 7 then destination = Config.Deliveries.Delivery7BC nameZone = 'Delivery7BC' nameZoneNum = 7 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 8 then destination = Config.Deliveries.Delivery8BC nameZone = 'Delivery8BC' nameZoneNum = 8 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 9 then destination = Config.Deliveries.Delivery9BC nameZone = 'Delivery9BC' nameZoneNum = 9 nameZoneRegion = 2 lastMission = missionNum
		elseif missionNum == 10 then destination = Config.Deliveries.Delivery10BC nameZone = 'Delivery10BC' nameZoneNum = 10 nameZoneRegion = 2 lastMission = missionNum
		end
	end

	MissionDeliveryLetsGo()
end

function MissionDeliveryLetsGo()
	if blips.delivery then
		RemoveBlip(blips.delivery)
		blips.delivery = nil
	elseif blips.cancelMission then
		RemoveBlip(blips.cancelMission)
		blips.cancelMission = nil
	end

	blips.delivery = AddBlipForCoord(destination.coords)
	SetBlipRoute(blips.delivery, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_delivery'))
	EndTextCommandSetBlipName(blips.delivery)

	blips.cancelMission = AddBlipForCoord(Config.Deliveries.CancelMission.coords)
	SetBlipSprite(blips.cancelMission, 414)
	SetBlipAsShortRange(blips.cancelMission, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_cancel'))
	EndTextCommandSetBlipName(blips.cancelMission)

	if missionRegion == 1 then
		ESX.ShowNotification(_U('meet_ls'))
	elseif missionRegion == 2 then
		ESX.ShowNotification(_U('meet_bc'))
	elseif missionRegion == 0 then
		ESX.ShowNotification(_U('meet_del'))
	end

	missionDelivery = true
end

function MissionDeliveryStopReturnToDepot()
	destination = Config.Deliveries.ReturnTruck

	blips.delivery = AddBlipForCoord(destination.coords)
	SetBlipRoute(blips.delivery, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_depot'))
	EndTextCommandSetBlipName(blips.delivery)

	if blips.cancelMission then
		RemoveBlip(blips.cancelMission)
		blips.cancelMission = nil
	end

	ESX.ShowNotification(_U('return_depot'))

	missionRegion = 0
	missionDelivery = false
	missionNum = 0
	missionReturnTruck = true
end

function UpdateCurrentVehiclePlate()
	vehicleRealPlate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if DoesEntityExist(garbageBag) then
			ESX.Game.DeleteObject(garbageBag)
			DisablePlayerFiring(PlayerPedId(), false)
		end

		if DoesEntityExist(workTruck) then
			ESX.Game.DeleteVehicle(workTruck)
		end
	end
end)