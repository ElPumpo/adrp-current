ESX = nil

local obj1, obj2
local isActive, isRedGullActive, isLockpickActive, isRepairKitActive = false, false, false, false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_items:onUseOxygen')
AddEventHandler('esx_items:onUseOxygen', function()
	local playerPed = PlayerPedId()

	if isActive then
		ESX.ShowNotification('You\'re already on a oxygen tank, wait for it to wear off.')
		return
	elseif not IsPedOnFoot(playerPed) then
		ESX.ShowNotification('You\'re not on foot damnit. How are you gonna put your gear on like this?')
		return
	end

	isActive = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_items:onUseOxygen')
	TriggerEvent('esx_status:setValue', 'oxygen', 1000000)

	local coords = GetEntityCoords(playerPed)
	local boneIndex = GetPedBoneIndex(playerPed, 12844)
	local boneIndex2 = GetPedBoneIndex(playerPed, 24818)

	ESX.Game.SpawnObject('p_s_scuba_mask_s', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)
		ESX.Game.SpawnObject('p_s_scuba_tank_s', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object2)
			AttachEntityToEntity(object2, playerPed, boneIndex2, -0.30, -0.22, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
			AttachEntityToEntity(object, playerPed, boneIndex, 0.0, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
			SetPedDiesInWater(playerPed, false)

			ESX.ShowNotification('You\'ve put on your diving helmet and connected it to your scuba tank, it will last for 15 minutes.')
			obj1, obj2 = object, object2
		end)
	end)
end)

RegisterNetEvent('esx_items:onUseRedgull')
AddEventHandler('esx_items:onUseRedgull', function()
	if isRedGullActive then
		ESX.ShowNotification('You are already on redgull, wait for it to wear off.')
		return
	end

	isRedGullActive = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_items:onUseRedgull')

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local boneIndex = GetPedBoneIndex(playerPed, 18905)
	local timer = 0

	ESX.Streaming.RequestAnimDict('mp_player_intdrink')

	ESX.Game.SpawnObject('prop_energy_drink', {x = coords.x, y = coords.y, z = coords.z - 3}, function(object)
		TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
		AttachEntityToEntity(object, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
		Citizen.Wait(3000)
		DeleteObject(object)
		ClearPedSecondaryTask(playerPed)
	end)

	ESX.ShowNotification('You feel hyped and can now run for ~y~5~s~ minutes ~o~without becoming tired~s~!')

	while timer < 300 do
		ResetPlayerStamina(PlayerId())
		Citizen.Wait(2000)
		timer = timer + 2
	end

	ESX.ShowNotification('You feel your heart rate returning to a normal level')
	isRedGullActive = false
end)

AddEventHandler('esx_status:loaded', function(status)
	TriggerEvent('esx_status:registerStatus', 'oxygen', 0, '#5495FF', function(status)
		if status.val == 0 and isActive then
			local playerPed = PlayerPedId()

			SetPedDiesInWater(playerPed, true)
			DeleteObject(obj1)
			DeleteObject(obj2)
			ClearPedSecondaryTask(playerPed)

			obj1, obj2, isActive = nil, nil, false
		end

		return false
	end, function(status)
		status.remove(1111) -- every tick (1 minute), should last 15 minutes
	end)
end)

RegisterNetEvent('esx_items:onUseLockpick')
AddEventHandler('esx_items:onUseLockpick', function()
	if isLockpickActive then
		ESX.ShowNotification('You are already using a lockpick.')
		return
	end

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	-- TOOD use esx functions to get nearby vehicle
	if IsAnyVehicleNearPoint(coords, 5.0) and IsPedOnFoot(playerPed) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		local chance = math.random(100)
		local alarm = math.random(100)

		if DoesEntityExist(vehicle) then -- TODO check is this vehicle even locked?
			isLockpickActive = true
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esx_items:onUseLockpick')
			TriggerEvent('customNotification', 'You have used a lockpick')

			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end

			ESX.Streaming.RequestAnimDict('mini@repair')

			TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_player', 8.0, 0.0, -1, 1, 0.0, false, false, false)
			Citizen.Wait(10000)

			if chance <= 66 then
				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				TriggerEvent('customNotification', 'The vehicle has been lockpicked!')
			else
				TriggerEvent('customNotification', 'The lockpick broke!')
				ClearPedTasksImmediately(playerPed)
			end

			isLockpickActive = false
		end
	else
		TriggerEvent('customNotification', 'Could not find a nearby vehicle.')
	end
end)

RegisterNetEvent('esx_items:onUseRepairKit')
AddEventHandler('esx_items:onUseRepairKit', function()
	if isRepairKitActive then
		ESX.ShowNotification('You are already using a repair kit.')
		return
	end

	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local actionTime, timeWaited, checkTime, lastCheckTime = 30, 0, 10, GetGameTimer()

	-- TOOD use esx functions to get nearby vehicle
	if IsAnyVehicleNearPoint(coords, 3.1) and IsPedOnFoot(playerPed) then
		local vehicle = GetClosestVehicle(coords, 3.1, 0, 71)

		if DoesEntityExist(vehicle) then
			isRepairKitActive = true
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('esx_items:onUseRepairKit')
			TriggerEvent('customNotification', 'You have used a repair kit!')

			local hasHood = DoesVehicleHaveDoor(vehicle, 4)

			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)

			if hasHood then
				SetVehicleDoorOpen(vehicle, 4, false, false)
			end

			while timeWaited < actionTime do
				Citizen.Wait(1)
				if GetGameTimer() > lastCheckTime + checkTime then
					timeWaited = timeWaited + 0.01
					lastCheckTime = GetGameTimer()
				end

				ESX.Game.Utils.ProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, 'Repairing vehicle...')
			end

			SetVehicleEngineHealth(vehicle, 1000)
			SetVehicleBodyHealth(vehicle, 1000.0)
			SetVehicleFixed(vehicle)

			if hasHood then
				SetVehicleDoorShut(vehicle, 4, false)
			end

			ClearPedTasksImmediately(playerPed)
			TriggerEvent('customNotification', 'you repaired the vehicle!')
			isRepairKitActive = false
		else
			TriggerEvent('customNotification', 'There is no vehicle nearby.')
		end
	end
end)

RegisterNetEvent('esx_items:onUseBodyArmor')
AddEventHandler('esx_items:onUseBodyArmor', function()
	local playerPed = PlayerPedId()
	SetPedArmour(playerPed, 1000)
	TriggerEvent('customNotification', 'Your armor has been filled to 100%')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_status:unregisterStatus', 'oxygen')

		if isActive then
			local playerPed = PlayerPedId()

			SetPedDiesInWater(playerPed, true)
			DeleteObject(obj1)
			DeleteObject(obj2)
			ClearPedSecondaryTask(playerPed)
		end
	end
end)