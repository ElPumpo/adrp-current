essence = 0.142
local stade, lastModel, vehiclesUsed = 0, 0, {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	TriggerServerEvent('esx_advancedfuel:getStationPrices')
end)

function getFuel()
	return essence
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local _,weaponHash = GetCurrentPedWeapon(playerPed)
		CheckVeh(playerPed)

		if weaponHash == GetHashKey('WEAPON_PETROLCAN') then
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local veh = GetClosestVehicle(x, y, z, 4.001, 0, 70)

			if veh and GetVehicleNumberPlateText(veh) then
				local currentAmmo = GetAmmoInPedWeapon(playerPed, GetHashKey('WEAPON_PETROLCAN'))
				if currentAmmo > 0 then
					ESX.ShowHelpNotification(settings[lang].refeel)

					if IsControlJustPressed(0, 38) then
						ESX.Streaming.RequestAnimDict('weapon@w_sp_jerrycan')
						TaskPlayAnim(playerPed, 'weapon@w_sp_jerrycan', 'fire', 8.0, -8, -1, 49, 0.0, false, false, false)
						local done = false
						local amountToEssence = 0.142-essence
	
						while not done do
							Citizen.Wait(0)
							local currentAmmo = GetAmmoInPedWeapon(playerPed, GetHashKey('WEAPON_PETROLCAN'))
							local _essence = essence
	
							if currentAmmo == 0 then
								ESX.ShowNotification('Your gas can is empty!')
								break
							end
	
							if amountToEssence-0.0005 > 0 then
								amountToEssence = amountToEssence-0.0005
								essence = _essence + 0.0005
								_essence = essence
	
								if _essence > 0.142 then
									essence = 0.142
									TriggerEvent('esx_advancedfuel:setFuel', 100, GetVehicleNumberPlateText(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
									done = true
									ESX.ShowNotification('The vehicle has been fueled up!')
								end
	
								SetVehicleUndriveable(veh, true)
								SetVehicleEngineOn(veh, false, false, false)
								local essenceToPercent = (essence/0.142)*65
								SetVehicleFuelLevel(veh, ESX.Math.Round(essenceToPercent, 1))
								local currentAmmo = GetAmmoInPedWeapon(playerPed, GetHashKey('WEAPON_PETROLCAN'))
								SetPedAmmo(playerPed, GetHashKey('WEAPON_PETROLCAN'), currentAmmo - 20)
								Citizen.Wait(100)
							else
								essence = essence + amountToEssence
								local essenceToPercent = (essence/0.142)*65
								SetVehicleFuelLevel(veh, ESX.Math.Round(essenceToPercent, 1))
								TriggerEvent('esx_advancedfuel:setFuel', 100, GetVehicleNumberPlateText(veh), GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
								done = true
	
								ESX.ShowNotification('The vehicle has been fueled up!')
							end
						end
	
						TaskPlayAnim(playerPed, 'weapon@w_sp_jerrycan', 'fire_outro', 8.0, -8, -1, 49, 0.0, false, false, false)
						Citizen.Wait(500)
						ClearPedTasks(playerPed)
						SetVehicleEngineOn(veh, true, false, false)
						SetVehicleUndriveable(veh, false)
					end
				else
					Citizen.Wait(500)
				end
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	local menu = false
	local int = 0

	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local isInVehicle, isVehicleDriver, vehicleDisplayName, vehicle = IsPedInAnyVehicle(playerPed, false), false, nil, nil

		if isInVehicle then
			vehicle = GetVehiclePedIsIn(playerPed, false)
			isVehicleDriver = GetPedInVehicleSeat(vehicle, -1) == playerPed
			vehicleDisplayName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
		end

		local isInHeli, isInEletric, isInBlacklisted = IsPedInAnyHeli(playerPed), isElectricModel(vehicleDisplayName), isBlackListedModel(vehicleDisplayName)
		local isNearFuelStation, stationNumber = isNearStation(playerCoords)
		local isNearFuelPStation, stationPlaneNumber = isNearPlaneStation(playerCoords)
		local isNearFuelHStation, stationHeliNumber = isNearHeliStation(playerCoords)
		local isNearFuelBStation, stationBoatNumber = isNearBoatStation(playerCoords)

		if not isNearFuelStation and
			not isNearFuelPStation and
			not isNearFuelHStation and
			not isNearFuelBStation
		then
			Citizen.Wait(500)
		end

		------------------------------- VEHICLE FUEL PART -------------------------------

		if isNearFuelStation and isInVehicle and isVehicleDriver and not isInHeli and not isInBlacklisted and not isInEletric then
			ESX.ShowHelpNotification(settings[lang].openMenu)

			if IsControlJustPressed(0, 38) then
				menu = not menu
				int = 0
			end

			if menu then
				TriggerEvent('GUI:Title', settings[lang].buyFuel)

				local maxEscense = 60-(essence/0.142)*60

				TriggerEvent('GUI:Int', settings[lang].liters..' : ', int, 0, maxEscense, function(cb)
					int = cb
				end)

				TriggerEvent('GUI:Option', settings[lang].confirm, function(cb)
					if cb then
						menu = not menu

						if int > 0 then
							TriggerServerEvent('esx_advancedfuel:buyFuel', int, stationNumber, false)
						end
					end
				end)

				TriggerEvent('GUI:Update')
			end
		elseif isNearFuelStation and isInVehicle and isVehicleDriver and not isInHeli and isInEletric and not isInBlacklisted then
			ESX.ShowHelpNotification(settings[lang].electricError)
		end

		------------------------------- ELECTRIC VEHICLE PART -------------------------------

		if isNearElectricStation() and isInVehicle and isVehicleDriver and not isInHeli and isInEletric and not isInBlacklisted then
			ESX.ShowHelpNotification(settings[lang].openMenu)

			if IsControlJustPressed(0, 38) then
				menu = not menu
				int = 0
			end

			if menu then
				TriggerEvent('GUI:Title', settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60

				TriggerEvent('GUI:Int', settings[lang].percent..' : ', int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent('GUI:Option', settings[lang].confirm, function(cb)
					if cb then
						menu = not menu

						if int > 0 then
							TriggerServerEvent('esx_advancedfuel:buyFuel', int, electricityPrice, true)
						end
					end
				end)

				TriggerEvent('GUI:Update')
			end
		end

		------------------------------- BOAT PART -------------------------------

		if isNearFuelBStation and isInVehicle and isVehicleDriver and not isInHeli and not isInBlacklisted then
			ESX.ShowHelpNotification(settings[lang].openMenu)

			if IsControlJustPressed(0, 38) then
				menu = not menu
				int = 0
			end

			if menu then
				TriggerEvent('GUI:Title', settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60
				TriggerEvent('GUI:Int', settings[lang].percent..' : ', int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent('GUI:Option', settings[lang].confirm, function(cb)
					if cb then
						menu = not menu

						if int > 0 then
							TriggerServerEvent('esx_advancedfuel:buyFuel', int, stationBoatNumber, false)
						end
					end
				end)

				TriggerEvent('GUI:Update')
			end
		end

		------------------------------- PLANE PART -------------------------------

		if isNearFuelPStation and isInVehicle and isVehicleDriver and not isInBlacklisted and isPlaneModel(vehicleDisplayName) then
			ESX.ShowHelpNotification(settings[lang].openMenu)

			if IsControlJustPressed(0, 38) then
				menu = not menu
				int = 0
			end

			if menu then
				TriggerEvent('GUI:Title', settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60

				TriggerEvent('GUI:Int', settings[lang].percent..' : ', int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent('GUI:Option', settings[lang].confirm, function(cb)
					if cb then
						menu = not menu

						if int > 0 then
							TriggerServerEvent('esx_advancedfuel:buyFuel', int, stationPlaneNumber, false)
						end
					end
				end)

				TriggerEvent('GUI:Update')
			end
		end

		------------------------------- HELI PART -------------------------------

		if isNearFuelHStation and isInVehicle and isVehicleDriver and not isInBlacklisted and isHeliModel(vehicleDisplayName) then
			ESX.ShowHelpNotification(settings[lang].openMenu)

			if IsControlJustPressed(0, 38) then
				menu = not menu
				int = 0
			end

			if menu then
				TriggerEvent('GUI:Title', settings[lang].buyFuel)

				local maxEssence = 60-(essence/0.142)*60

				TriggerEvent('GUI:Int', settings[lang].percent..' : ', int, 0, maxEssence, function(cb)
					int = cb
				end)

				TriggerEvent('GUI:Option', settings[lang].confirm, function(cb)
					if cb then
						menu = not menu

						if int > 0 then
							TriggerServerEvent('esx_advancedfuel:buyFuel', int, stationHeliNumber, false)
						end
					end
				end)

				TriggerEvent('GUI:Update')
			end
		end

		if (isNearFuelStation or isNearFuelPStation or isNearFuelHStation or isNearFuelBStation) and not isInVehicle then
			ESX.ShowHelpNotification(settings[lang].getJerryCan)

			if IsControlJustPressed(0, 38) then
				TriggerServerEvent('esx_advancedfuel:buyFuelCan')
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed and not isBlackListedModel() then
			local speed = math.ceil(GetEntitySpeed(vehicle) * 3.6)

			if speed > 0 and speed < 20 then
				stade = 0.00003
			elseif speed >= 20 and speed <50 then
				stade = 0.00004
			elseif speed >= 50 and speed < 70 then
				stade = 0.00005
			elseif speed >= 70 and speed <90 then
				stade = 0.00006
			elseif speed >=90 and speed <130 then
				stade = 0.00007
			elseif speed >= 130 then
				stade = 0.00008
			elseif speed == 0 and IsVehicleEngineOn(vehicle) then
				stade = 0.00001
			end

			if essence - stade > 0 then
				essence = essence - stade
				local essenceToPercent = (essence/0.142)*65
				SetVehicleFuelLevel(vehicle, ESX.Math.Round(essenceToPercent, 1))
			else
				essence = 0
				SetVehicleFuelLevel(vehicle, 0.0)
				SetVehicleUndriveable(vehicle, true)
			end
		end
	end
end)

-- 0.0001 pour 0 à 20, 0.142 = 100%
-- Donc 0.0001 km en moins toutes les 10 secondes

local lastPlate = 0
local refresh = true

function CheckVeh(playerPed)
	if IsPedInAnyVehicle(playerPed, false) and not isBlackListedModel() then
		if refresh then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			lastModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			lastPlate = GetVehicleNumberPlateText(vehicle)
			TriggerServerEvent('esx_advancedfuel:getFuel', lastPlate, lastModel)
		end

		refresh = false
	else
		if not refresh then
			TriggerServerEvent('esx_advancedfuel:syncFuelWithPlayers', essence, lastPlate, lastModel)
			refresh = true
		end
	end

	if essence == 0 and IsPedInAnyVehicle(playerPed, false) then
		SetVehicleEngineOn(GetVehiclePedIsUsing(playerPed), false, false, false)
	end
end

function isNearStation(playerCoords)
	for _,items in pairs(station) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, playerCoords, true) < 2) then
			return true, items.s
		end
	end

	return false
end

function isNearPlaneStation(playerCoords)
	for _,items in pairs(avion_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, playerCoords, true) < 10) then
			return true, items.s
		end
	end

	return false
end

function isNearHeliStation(playerCoords)
	for _,items in pairs(heli_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, playerCoords, true) < 10) then
			return true, items.s
		end
	end

	return false
end

function isNearBoatStation(playerCoords)
	for _,items in pairs(boat_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, playerCoords, true) < 10) then
			return true, items.s
		end
	end

	return false
end

function isNearElectricStation(playerCoords)
	for _,items in pairs(electric_stations) do
		if(GetDistanceBetweenCoords(items.x, items.y, items.z, playerCoords, true) < 2) then
			return true
		end
	end

	return false
end

--100% = 100L = 100$
-- 1% = 1L = 1

function isBlackListedModel(model)
	model = model or GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))

	for k,v in pairs(blacklistedModels) do
		if v == model then
			return true
		end
	end

	return false
end

function isElectricModel(model)
	model = model or GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId())))

	for k,v in pairs(electric_model) do
		if v == model then
			return true
		end
	end

	return false
end

function isHeliModel(model)
	for k,v in pairs(heli_model) do
		if v == model then
			return true
		end
	end

	return false
end

function isPlaneModel(model)
	for k,v in pairs(plane_model) do
		if v == model then
			return true
		end
	end

	return false
end

RegisterNetEvent('esx_advancedfuel:buyFuel')
AddEventHandler('esx_advancedfuel:buyFuel', function(amount)
	showDoneNotif(settings[lang].YouHaveBought..amount..settings[lang].fuel)
	local amountToEssence = (amount/60)*0.142
	local done = false
	local vehicle = GetVehiclePedIsUsing(PlayerPedId())

	while not done do
		Citizen.Wait(0)
		local _essence = essence

		if amountToEssence-0.0005 > 0 then
			amountToEssence = amountToEssence-0.0005
			essence = _essence + 0.0005
			_essence = essence

			if _essence > 0.142 then
				essence = 0.142
				done = true
			end

			SetVehicleUndriveable(vehicle, true)
			SetVehicleEngineOn(vehicle, false, false, false)
			local essenceToPercent = (essence/0.142)*65
			SetVehicleFuelLevel(vehicle, ESX.Math.Round(essenceToPercent, 1))
			Citizen.Wait(100)
		else
			essence = essence + amountToEssence
			local essenceToPercent = (essence/0.142)*65
			SetVehicleFuelLevel(vehicle, ESX.Math.Round(essenceToPercent, 1))
			done = true
		end
	end

	local displayName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
	TriggerServerEvent('esx_advancedfuel:syncFuelWithPlayers', essence, GetVehicleNumberPlateText(vehicle), displayName)
	SetVehicleUndriveable(vehicle, false)
	SetVehicleEngineOn(vehicle, true, false, false)
end)

RegisterNetEvent('esx_advancedfuel:sendFuel')
AddEventHandler('esx_advancedfuel:sendFuel', function(bool, ess)
	if bool == 1 then
		essence = ess
	else
		essence = (math.random(30,100)/100)*0.142
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		TriggerServerEvent('esx_advancedfuel:syncFuelWithPlayers', essence, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
	end
end)

AddEventHandler('playerSpawned', function()
	TriggerServerEvent('esx_advancedfuel:getStationPrices')
end)

RegisterNetEvent('esx_advancedfuel:setFuel')
AddEventHandler('esx_advancedfuel:setFuel', function(percent, plate, model)
	local toEssence = (percent/100)*0.142
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed, false)

	if GetVehicleNumberPlateText(vehicle) == plate and model == GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) then
		essence = toEssence
		local essenceToPercent = (essence/0.142)*65
		SetVehicleFuelLevel(vehicle, ESX.Math.Round(essenceToPercent, 1))
	end

	TriggerServerEvent('esx_advancedfuel:setFuel', percent, plate, model)
end)

RegisterNetEvent('esx_advancedfuel:syncFuelWithPlayers')
AddEventHandler('esx_advancedfuel:syncFuelWithPlayers', function(fuel, vplate, vmodel)
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		currentPedVModel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
		currentPedVPlate = GetVehicleNumberPlateText(vehicle)

		if currentPedVModel == vmodel and currentPedVPlate == vmodel then
			essence = fuel
		end
	end
end)

function searchByModelAndPlate(plate, model)
	for k,v in pairs(vehiclesUsed) do
		if v.plate == plate and v.model == model then
			return true, k
		end
	end

	return false, nil
end