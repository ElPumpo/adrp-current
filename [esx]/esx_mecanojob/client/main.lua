local PlayerData, CurrentActionData, Blips, availableUnits = {}, {}, {}, {}
local hasAlreadyEnteredMarker, LastZone, CurrentAction, CurrentActionMsg, CurrentlyTowedVehicle, NPCTargetTowable, NPCTargetTowableZone, myName
local OnJob, NPCOnJob, NPCHasSpawnedTowable, NPCLastCancel, NPCHasBeenNextToTowable, IsDead, IsBusy, isInService = false, false, false, GetGameTimer() - 5 * 60000, false, false, false, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
	myName = PlayerData.name
end)

function SelectRandomTowable()
	local index = GetRandomIntInRange(1,  #Config.Towables)

	for k,v in pairs(Config.Zones) do
		if v.Pos.x == Config.Towables[index].x and v.Pos.y == Config.Towables[index].y and v.Pos.z == Config.Towables[index].z then
			return k
		end
	end
end

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(name)
	myName = name
end)

RegisterNetEvent('esx_mecanojob:updateAvailableUnits')
AddEventHandler('esx_mecanojob:updateAvailableUnits', function(units)
	availableUnits = units
	-- todo do they want colleague blips?
end)

function StartNPCJob()
	NPCOnJob = true

	NPCTargetTowableZone = SelectRandomTowable()
	local zone       = Config.Zones[NPCTargetTowableZone]

	Blips['NPCTargetTowableZone'] = AddBlipForCoord(zone.Pos.x,  zone.Pos.y,  zone.Pos.z)
	SetBlipRoute(Blips['NPCTargetTowableZone'], true)

	ESX.ShowNotification(_U('drive_to_indicated'))
end

function StopNPCJob(cancel)
	if Blips['NPCTargetTowableZone'] ~= nil then
		RemoveBlip(Blips['NPCTargetTowableZone'])
		Blips['NPCTargetTowableZone'] = nil
	end

	if Blips['NPCDelivery'] ~= nil then
		RemoveBlip(Blips['NPCDelivery'])
		Blips['NPCDelivery'] = nil
	end


	Config.Zones.VehicleDelivery.Type = -1

	NPCOnJob                = false
	NPCTargetTowable        = nil
	NPCTargetTowableZone    = nil
	NPCHasSpawnedTowable    = false
	NPCHasBeenNextToTowable = false

	if cancel then
		ESX.ShowNotification(_U('mission_canceled'))
	else
		TriggerServerEvent('esx_mecanojob:onNPCJobCompleted')
	end
end

function OpenMecanoClockin()

	local elements = {}

	if not isInService then
		table.insert(elements, {label = "Clock in", value = 'cloakroom'})
	else
		table.insert(elements, {label = "Clock Out", value = 'cloakroom2'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'mecano_actions',
		{
			title    = _U('mechanic'),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			menu.close()
			if data.current.value == 'cloakroom' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
					else
						TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
					end

					TriggerEvent('customNotification', "You have clocked in")
					TriggerServerEvent('es_extended:setService', true)
					TriggerServerEvent('player:serviceOn', 'mecano', myName, PlayerData.job.grade_label)
					isInService = true
				end)
			end

			if data.current.value == 'cloakroom2' then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					TriggerEvent('skinchanger:loadSkin', skin)
					TriggerEvent('customNotification', "You have clocked out")
					TriggerServerEvent('es_extended:setService', false)
					TriggerServerEvent('player:serviceOff', 'mecano')
					isInService = false
				end)
			end

			CurrentAction     = 'mecano_cloakroom'
			CurrentActionData = {}

		end,
		function(data, menu)

			menu.close()

			CurrentAction     = 'mecano_cloakroom'
			CurrentActionMsg  = _U('open_actions')
			CurrentActionData = {}
		end
	)

end

function OpenMecanoActionsMenu()

	local elements = {
		{label = _U('vehicle_list'),   value = 'vehicle_list'},
		{label = _U('deposit_stock'),  value = 'put_stock'},
		{label = _U('withdraw_stock'), value = 'get_stock'}
	}
	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'mecano_actions',
		{
			title    = _U('mechanic'),
			align    = 'top-left',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'vehicle_list' then

				local elements = {
					{label = _U('flat_bed'),  value = 'flatbed'},
					{label = _U('tow_truck'), value = 'towtruck2'},
					{label = "AAA Towtruck", value = 'towtruck'}
				}

				if Config.EnablePlayerManagement and PlayerData.job ~= nil and
					(PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'chef' or PlayerData.job.grade_name == 'experimente') then
					table.insert(elements, {label = 'SlamVan', value = 'slamvan3'})
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'spawn_vehicle',
					{
						title    = _U('service_vehicle'),
						align    = 'top-left',
						elements = elements
					},
					function(data, menu)
						ESX.Game.SpawnVehicle(data.current.value, Config.Zones.VehicleSpawnPoint.Pos, 355.0, function(vehicle)
							local playerPed = PlayerPedId()
							TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
						end)

						menu.close()
					end,
					function(data, menu)
						menu.close()
						OpenMecanoActionsMenu()
					end
				)
			end

			if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			end

			if data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			end

			if data.current.value == 'boss_actions' then
				TriggerEvent('esx_society:openBossMenu', 'mecano', function(data, menu)
					menu.close()
				end)
			end

		end,
		function(data, menu)
			menu.close()
			CurrentAction     = 'mecano_actions_menu'
			CurrentActionMsg  = _U('open_actions')
			CurrentActionData = {}
		end
	)
end

function OpenMecanoHarvestMenu()

	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then
		local elements = {
			{label = _U('gas_can'), value = 'gaz_bottle'},
			{label = _U('repair_tools'), value = 'fix_tool'},
			{label = _U('body_work_tools'), value = 'caro_tool'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'mecano_harvest',
			{
				title    = _U('harvest'),
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)
				if data.current.value == 'gaz_bottle' then
					menu.close()
					TriggerServerEvent('esx_mecanojob:startHarvest')
				end

				if data.current.value == 'fix_tool' then
					menu.close()
					TriggerServerEvent('esx_mecanojob:startHarvest2')
				end

				if data.current.value == 'caro_tool' then
					menu.close()
					TriggerServerEvent('esx_mecanojob:startHarvest3')
				end

			end,
			function(data, menu)
				menu.close()
				CurrentAction     = 'mecano_harvest_menu'
				CurrentActionMsg  = _U('harvest_menu')
				CurrentActionData = {}
			end
		)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMecanoCraftMenu()
	if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name ~= 'recrue' then

		local elements = {
			{label = _U('blowtorch'),  value = 'blow_pipe'},
			{label = _U('repair_kit'), value = 'fix_kit'},
			{label = _U('body_kit'),   value = 'caro_kit'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'mecano_craft',
			{
				title    = _U('craft'),
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)
				if data.current.value == 'blow_pipe' then
					menu.close()
					TriggerServerEvent('esx_mecanojob:startCraft')
				end

				if data.current.value == 'fix_kit' then
					menu.close()
					TriggerServerEvent('esx_mecanojob:startCraft2')
				end

				if data.current.value == 'caro_kit' then
					menu.close()
					TriggerServerEvent('esx_mecanojob:startCraft3')
				end

			end,
			function(data, menu)
				menu.close()
				CurrentAction     = 'mecano_craft_menu'
				CurrentActionMsg  = _U('craft_menu')
				CurrentActionData = {}
			end
		)
	else
		ESX.ShowNotification(_U('not_experienced_enough'))
	end
end

function OpenMobileMecanoActionsMenu()

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'mobile_mecano_actions',
		{
			title    = _U('mechanic'),
			align    = 'top-left',
			elements = {
				{label = _U('billing'),       value = 'billing'},
				{label = _U('hijack'),        value = 'hijack_vehicle'},
				{label = _U('repair'),        value = 'fix_vehicle'},
				{label = _U('clean'),         value = 'clean_vehicle'},
				{label = _U('imp_veh'),       value = 'del_vehicle'},
				{label = _U('flat_bed'),      value = 'dep_vehicle'},
				{label = _U('place_objects'), value = 'object_spawner'}
			}
		},
	function(data, menu)
			if IsBusy then return end

			if data.current.value == 'billing' then
				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'billing',
					{
						title = _U('invoice_amount')
					},
					function(data, menu)
						local amount = tonumber(data.value)
						if amount == nil or amount < 0 then
							ESX.ShowNotification(_U('amount_invalid'))
						else
							
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
							if closestPlayer == -1 or closestDistance > 3.0 then
								ESX.ShowNotification(_U('no_players_nearby'))
							else
								menu.close()
								TriggerServerEvent('esx_billing:sendPlayerBill', GetPlayerServerId(closestPlayer), 'society_mecano', _U('mechanic'), amount)
							end
						end
					end,
				function(data, menu)
					menu.close()
				end
				)
			end

			if data.current.value == 'hijack_vehicle' then

		local playerPed = PlayerPedId()
		local vehicle   = ESX.Game.GetVehicleInDirection()
		local coords    = GetEntityCoords(playerPed)

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

		if DoesEntityExist(vehicle) then
			IsBusy = true
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)

				SetVehicleDoorsLocked(vehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(vehicle, false)
				ClearPedTasksImmediately(playerPed)

				ESX.ShowNotification(_U('vehicle_unlocked'))
				IsBusy = false
			end)
		else
			ESX.ShowNotification(_U('no_vehicle_nearby'))
		end

	elseif data.current.value == 'fix_vehicle' then

		local playerPed = PlayerPedId()
		local vehicle   = ESX.Game.GetVehicleInDirection()
		local coords    = GetEntityCoords(playerPed)

		if not IsPedOnFoot(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

		if DoesEntityExist(vehicle) then
			if not GetIsVehicleEngineRunning(vehicle) then
				local actionTime = 20
				local timeWaited = 0
				local timeIncrement = .01
				local checkTime = 10 -- in milli
				local lastCheckTime = GetGameTimer()
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
				SetVehicleDoorOpen(vehicle, 4, false, false)

				while timeWaited < actionTime do
					Wait(1)
					if GetGameTimer() > lastCheckTime + checkTime then
						timeWaited = timeWaited + timeIncrement
						lastCheckTime = GetGameTimer()
					end
					drawProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, "Repairing vehicle...")
				end

				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				SetVehicleEngineOn(vehicle, true, true)
				ClearPedTasksImmediately(playerPed)
				TriggerEvent('customNotification', 'Vehicle has been repaired')
				SetVehicleDoorShut(vehicle, 4, false)

				SetVehicleEngineHealth(vehicle, 1000)
				SetVehicleBodyHealth(vehicle, 1000.0)
				SetVehicleFixed(vehicle)
			else
				TriggerEvent("customNotification", "Vehicle cannot be running while repairing")
			end
		end

	elseif data.current.value == 'clean_vehicle' then
		local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local actionTime = 20
				local timeWaited = 0
				local timeIncrement = .01
				local checkTime = 10 -- in milli
				local lastCheckTime = GetGameTimer()

				if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

					local vehicle = nil

					if IsPedInAnyVehicle(playerPed, false) then
						vehicle = GetVehiclePedIsIn(playerPed, false)
					else
						vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
					end

					if DoesEntityExist(vehicle) then
						TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MAID_CLEAN", 0, true)
						while timeWaited < actionTime do
							Wait(1)
							if GetGameTimer() > lastCheckTime + checkTime then
								timeWaited = timeWaited + timeIncrement
								lastCheckTime = GetGameTimer()
							end
							drawProgressBar(timeWaited / actionTime, 0, -0.05, 0, 25, 200, "Cleaning Vehicle...")
						end
						Wait(1750)
						Citizen.CreateThread(function()
							Citizen.Wait(10000)
							SetVehicleDirtLevel(vehicle, 0)
							ClearPedTasksImmediately(playerPed)
							ESX.ShowNotification(_U('vehicle_cleaned'))
						end)
					end
				end
			end

			if data.current.value == 'dep_vehicle' then

				local playerped = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(playerped, true)

				local towmodel = GetHashKey('flatbed')
				local isVehicleTow = IsVehicleModel(vehicle, towmodel)

				if isVehicleTow then
					local targetVehicle = ESX.Game.GetVehicleInDirection()

					if CurrentlyTowedVehicle == nil then
						if targetVehicle ~= 0 then
							if not IsPedInAnyVehicle(playerped, true) then
								if vehicle ~= targetVehicle then
									AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
									CurrentlyTowedVehicle = targetVehicle
									ESX.ShowNotification(_U('vehicle_success_attached'))

									if NPCOnJob then

										if NPCTargetTowable == targetVehicle then
											ESX.ShowNotification(_U('please_drop_off'))

											Config.Zones.VehicleDelivery.Type = 1

											if Blips['NPCTargetTowableZone'] ~= nil then
												RemoveBlip(Blips['NPCTargetTowableZone'])
												Blips['NPCTargetTowableZone'] = nil
											end

											Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x,  Config.Zones.VehicleDelivery.Pos.y,  Config.Zones.VehicleDelivery.Pos.z)

											SetBlipRoute(Blips['NPCDelivery'], true)

										end

									end

								else
									ESX.ShowNotification(_U('cant_attach_own_tt'))
								end
							end
						else
							ESX.ShowNotification(_U('no_veh_att'))
						end
					else

						AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						DetachEntity(CurrentlyTowedVehicle, true, true)

						if NPCOnJob then

							if NPCTargetDeleterZone then

								if CurrentlyTowedVehicle == NPCTargetTowable then
									ESX.Game.DeleteVehicle(NPCTargetTowable)
									TriggerServerEvent('esx_mecanojob:onNPCJobMissionCompleted')
									StopNPCJob()
									NPCTargetDeleterZone = false

								else
									ESX.ShowNotification(_U('not_right_veh'))
								end

							else
								ESX.ShowNotification(_U('not_right_place'))
							end

						end

						CurrentlyTowedVehicle = nil

						ESX.ShowNotification(_U('veh_det_succ'))
					end
				else
					ESX.ShowNotification(_U('imp_flatbed'))
				end
			end

			if data.current.value == 'object_spawner' then
		local playerPed = PlayerPedId()

		if IsPedSittingInAnyVehicle(playerPed) then
			ESX.ShowNotification(_U('inside_vehicle'))
			return
		end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'mobile_mecano_actions_spawn',
					{
						title    = _U('objects'),
						align    = 'top-left',
						elements = {
							{label = _U('roadcone'),     value = 'prop_roadcone02a'},
							{label = _U('toolbox'), value = 'prop_toolchest_01'},
						},
					},
					function(data2, menu2)

						local model     = data2.current.value
						local coords    = GetEntityCoords(playerPed)
						local forward   = GetEntityForwardVector(playerPed)
						local x, y, z   = table.unpack(coords + forward * 1.0)

						if model == 'prop_roadcone02a' then
							z = z - 2.0
						elseif model == 'prop_toolchest_01' then
							z = z - 2.0
						end

						ESX.Game.SpawnObject(model, {
							x = x,
							y = y,
							z = z
						}, function(obj)
							SetEntityHeading(obj, GetEntityHeading(playerPed))
							PlaceObjectOnGroundProperly(obj)
						end)

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end

		end,
	function(data, menu)
		menu.close()
	end
	)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_mecanojob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'stocks_menu',
			{
				title    = _U('mechanic_stock'),
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count',
					{
						title = _U('quantity')
					},
					function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							ESX.ShowNotification(_U('invalid_quantity'))
						else
							menu2.close()
							menu.close()
							TriggerServerEvent('esx_mecanojob:getStockItem', itemName, count)

							Citizen.Wait(1000)
							OpenGetStocksMenu()
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end,
			function(data, menu)
				menu.close()
			end
		)

	end)

end

function OpenPutStocksMenu()

ESX.TriggerServerCallback('esx_mecanojob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do

			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end

		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'stocks_menu',
			{
				title    = _U('inventory'),
				align    = 'top-left',
				elements = elements
			},
			function(data, menu)

				local itemName = data.current.value

				ESX.UI.Menu.Open(
					'dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count',
					{
						title = _U('quantity')
					},
					function(data2, menu2)

						local count = tonumber(data2.value)

						if count == nil then
							ESX.ShowNotification(_U('invalid_quantity'))
						else
							menu2.close()
							menu.close()
							TriggerServerEvent('esx_mecanojob:putStockItems', itemName, count)

							Citizen.Wait(1000)
							OpenPutStocksMenu()
						end

					end,
					function(data2, menu2)
						menu2.close()
					end
				)

			end,
			function(data, menu)
				menu.close()
			end
		)

	end)

end


RegisterNetEvent('esx_mecanojob:onHijack')
AddEventHandler('esx_mecanojob:onHijack', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		local crochete = math.random(100)
		local alarm    = math.random(100)

		if DoesEntityExist(vehicle) then
			if alarm <= 33 then
				SetVehicleAlarm(vehicle, true)
				StartVehicleAlarm(vehicle)
			end
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				if crochete <= 66 then
					SetVehicleDoorsLocked(vehicle, 1)
					SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					ClearPedTasksImmediately(playerPed)
					ESX.ShowNotification(_U('veh_unlocked'))
				else
					ESX.ShowNotification(_U('hijack_failed'))
					ClearPedTasksImmediately(playerPed)
				end
			end)
		end

	end
end)

RegisterNetEvent('esx_mecanojob:onCarokit')
AddEventHandler('esx_mecanojob:onCarokit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_HAMMERING", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(10000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('body_repaired'))
			end)
		end
	end
end)



RegisterNetEvent('esx_mecanojob:onFixkit')
AddEventHandler('esx_mecanojob:onFixkit', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

		local vehicle = nil

		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		else
			vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)
			Citizen.CreateThread(function()
				Citizen.Wait(20000)
				SetVehicleFixed(vehicle)
				SetVehicleDeformationFixed(vehicle)
				SetVehicleUndriveable(vehicle, false)
				ClearPedTasksImmediately(playerPed)
				ESX.ShowNotification(_U('veh_repaired'))
			end)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if job ~= 'mecano' and isInService then
		isInService = false
	end

	PlayerData.job = job
end)

AddEventHandler('esx_mecanojob:hasEnteredMarker', function(zone)
	if zone =='Clocking' then
		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			CurrentAction     = 'mecano_cloakroom'
			CurrentActionMsg  = _U('open_actions')
			CurrentActionData = {}
		end
	elseif zone =='VehicleDelivery' and isInService then
		NPCTargetDeleterZone = true
	elseif zone == 'MecanoActions' and isInService then
		if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' then
			CurrentAction     = 'mecano_actions_menu'
			CurrentActionMsg  = _U('open_actions')
			CurrentActionData = {}
		end
	elseif zone == 'Garage' and isInService then
		CurrentAction     = 'mecano_harvest_menu'
		CurrentActionMsg  = _U('harvest_menu')
		CurrentActionData = {}
	elseif zone == 'Craft' and isInService then
		CurrentAction     = 'mecano_craft_menu'
		CurrentActionMsg  = _U('craft_menu')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' and isInService then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed,  false) then

			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('veh_stored')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_mecanojob:hasExitedMarker', function(zone)

	if zone =='VehicleDelivery' then
		NPCTargetDeleterZone = false
	end

	if zone == 'Craft' then
		TriggerServerEvent('esx_mecanojob:stopCraft')
		TriggerServerEvent('esx_mecanojob:stopCraft2')
		TriggerServerEvent('esx_mecanojob:stopCraft3')
	end

	if zone == 'Garage' then
		TriggerServerEvent('esx_mecanojob:stopHarvest')
		TriggerServerEvent('esx_mecanojob:stopHarvest2')
		TriggerServerEvent('esx_mecanojob:stopHarvest3')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('esx_mecanojob:hasEnteredEntityZone', function(entity)

	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil and PlayerData.job.name == 'mecano' and not IsPedInAnyVehicle(playerPed, false) and isInService then
		CurrentAction     = 'remove_entity'
		CurrentActionMsg  = _U('press_remove_obj')
		CurrentActionData = {entity = entity}
	end

end)

AddEventHandler('esx_mecanojob:hasExitedEntityZone', function(entity)

	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end

end)

-- Pop NPC mission vehicle when inside area
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NPCTargetTowableZone and not NPCHasSpawnedTowable then
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCSpawnDistance then
				local model = Config.Vehicles[GetRandomIntInRange(1,  #Config.Vehicles)]

				ESX.Game.SpawnVehicle(model, zone.Pos, 0, function(vehicle)
					NPCTargetTowable = vehicle
				end)

				NPCHasSpawnedTowable = true
			end
		end

		if NPCTargetTowableZone and NPCHasSpawnedTowable and not NPCHasBeenNextToTowable then
			local coords = GetEntityCoords(PlayerPedId())
			local zone   = Config.Zones[NPCTargetTowableZone]

			if(GetDistanceBetweenCoords(coords, zone.Pos.x, zone.Pos.y, zone.Pos.z, true) < Config.NPCNextToDistance) then
				ESX.ShowNotification(_U('please_tow'))
				NPCHasBeenNextToTowable = true
			end
		end

		if not NPCTargetTowableZone then
			Citizen.Wait(500)
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.MecanoActions.Pos.x, Config.Zones.MecanoActions.Pos.y, Config.Zones.MecanoActions.Pos.z)

	SetBlipSprite(blip, 446)
	SetBlipColour(blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('mechanic'))
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true
		local currentZone = nil

		if PlayerData.job and PlayerData.job.name == 'mecano' then
			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)
	
				if distance < Config.DrawDistance and v.Type ~= -1 then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					letSleep = false
				end
	
				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end
	
			if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				hasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_mecanojob:hasEnteredMarker', currentZone)
			end
	
			if not isInMarker and hasAlreadyEnteredMarker then
				hasAlreadyEnteredMarker = false
				TriggerEvent('esx_mecanojob:hasExitedMarker', LastZone)
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_toolchest_01'
	}

	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			Citizen.Wait(100)

			local object = GetClosestObjectOfType(coords.x,  coords.y,  coords.z,  3.0,  GetHashKey(trackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = #(coords - objCoords)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestEntity   = object
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 3.0 then
			if LastEntity ~= closestEntity then
				TriggerEvent('esx_mecanojob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_mecanojob:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'mecano' then
				if CurrentAction == 'mecano_cloakroom' then
					OpenMecanoClockin()
				elseif CurrentAction == 'mecano_actions_menu' then
					OpenMecanoActionsMenu()
				elseif CurrentAction == 'mecano_harvest_menu' then
					OpenMecanoHarvestMenu()
				elseif CurrentAction == 'mecano_craft_menu' then
					OpenMecanoCraftMenu()
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, 178) then
			if not IsDead and PlayerData.job ~= nil and PlayerData.job.name == 'mecano' and isInService then
				if NPCOnJob then
					if GetGameTimer() - NPCLastCancel > 5 * 60000 then
						StopNPCJob(true)
						NPCLastCancel = GetGameTimer()
					else
						ESX.ShowNotification(_U('wait_five'))
					end
				else
					local playerPed = PlayerPedId()

					if IsPedInAnyVehicle(playerPed, false) and IsVehicleModel(GetVehiclePedIsIn(playerPed, false), GetHashKey("flatbed")) then
						StartNPCJob()
					else
						ESX.ShowNotification(_U('must_in_flatbed'))
					end
				end
			end
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

AddEventHandler('esx_mechanicjob:openJobMenu', function()
	if isInService then
		OpenMobileMecanoActionsMenu()
	end
end)

function drawProgressBar(completion, xoffset, yoffset, r, g, b, text)
	local pedCoords = GetEntityCoords(PlayerPedId())
	if xoffset == nil then
		xoffset = 0
	end

	if yoffset == nil then
		yoffset = 0
	end

	local percentage = 100 * completion
	local width = (0.14/100.0)*percentage
	local progressBar = {
		x = 0.480 + xoffset,
		y = 0.60 + yoffset,
		width = 0.3,
		height = 0.009,
	}
	--x, y, width, height, r, g, b, a
	DrawRect(progressBar.x + 0.07, progressBar.y, 0.143, progressBar.height + .004, 0, 0, 0, 60)
	DrawRect(progressBar.x + (width/2), progressBar.y, width, progressBar.height, r, g, b, 200)
	drawTxt2(progressBar.x + (width/2) + 0.065, progressBar.y - 0.01, width, progressBar.height,0.10, ESX.Math.Round(percentage, 1).."%", 255,255,255, 255)
	drawTxt2(progressBar.x + (width/2) + 0.044, progressBar.y + 0.01, width, progressBar.height,0.10, text, 255,255,255, 255)
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(0)
	SetTextScale(0.23, 0.23)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end