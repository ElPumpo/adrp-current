ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	TriggerServerEvent('esx:playerconnected')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local isJacking = true
local isStolen = true

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, true) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)

			if IsVehicleStolen(vehicle) and isStolen then
				Citizen.Wait(1000)
				local model, plate = GetEntityModel(vehicle), ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
				local spawnName = GetDisplayNameFromVehicleModel(model)
				TriggerServerEvent('esx_discordbot:onCarJack', spawnName, plate)
				isStolen = false
			end
		else
			isStolen = true
			vehicle = nil
		end

		if IsPedJacking(playerPed) then
			if isJacking then
				local coords = GetEntityCoords(playerPed)
				local vehicle = nil

				if IsPedInAnyVehicle(playerPed, true) then
					vehicle = GetVehiclePedIsIn(playerPed, false)
				else
					vehicle = GetClosestVehicle(coords, 7.0, 0, 70)
				end

				if DoesEntityExist(vehicle) then
					local model, plate = GetEntityModel(vehicle), ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
					local spawnName = GetDisplayNameFromVehicleModel(model)

					if model then
						TriggerServerEvent('esx_discordbot:onCarJack', spawnName, plate)
					end

					Citizen.Wait(1000)
					isJacking = false
					vehicle = nil
				end
			end
		else
			isJacking = true
		end
	end
end)

local isIncarPolice = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if IsPedInAnyPoliceVehicle(playerPed) then
			if(not isIncarPolice and ESX.PlayerData.job.name ~= 'police') then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local model, plate = GetEntityModel(vehicle), ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
				local spawnName = GetDisplayNameFromVehicleModel(model)

				TriggerServerEvent('esx_discordbot:onEnteredPoliceVehicle', spawnName, plate)
				isIncarPolice = true
			else
				Citizen.Wait(1000)
			end
		else
			isIncarPolice = false
		end
	end
end)

local isInCar = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, true) and not IsPedInAnyPoliceVehicle(playerPed) then
			if not isInCar then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local model, plate = GetEntityModel(vehicle), ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
				local spawnName = GetDisplayNameFromVehicleModel(model)

				for i=1, #blacklistedModels, 1 do
					if blacklistedModels[i] == spawnName then
						TriggerServerEvent('esx_discordbot:onEnteredBlacklistedVehicle', spawnName, plate)
						isInCar = true
						break
					end
				end
			end
		else
			isInCar = false
		end
	end
end)
