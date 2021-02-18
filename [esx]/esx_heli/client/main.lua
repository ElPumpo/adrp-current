local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isInService, myName, availableUnits = false, nil, {}

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

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(name)
	myName = name
end)

RegisterNetEvent('esx_helijob:updateAvailableUnits')
AddEventHandler('esx_helijob:updateAvailableUnits', function(units)
	availableUnits = units
end)

function OpenheliActionsMenu()

	if isInService then
		local elements = {
			{label = _U('spawn_veh'), value = 'spawn_vehicle'},
			{label = _U('deposit_stock'), value = 'put_stock'},
			{label = _U('take_stock'), value = 'get_stock'},
			{label = 'Clock out', value = 'clock_out'}
		}

		if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.grade_name == 'boss' then
			table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'heli_actions', {
			title    = 'Pax Air Menu',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			if data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			elseif data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			elseif data.current.value == 'clock_out' then
				isInService = false
				TriggerServerEvent('es_extended:setService', false)
				TriggerServerEvent('player:serviceOff', 'heli')
				TriggerEvent('customNotification', 'You have clocked out')
				ESX.UI.Menu.CloseAll()
			elseif data.current.value == 'spawn_vehicle' then
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
					title    = 'Vehicle spawn list',
					align    = 'top-left',
					elements = {
						{label = 'Granger SUV',  model = 'granger'},
						{label = 'Bus',  model = 'bus2'},
						{label = 'Mercedez Sedan',  model = 'w221s500'},
						{label = 'Limo',  model = 'limoxts'},
						{label = 'Caddy',  model = 'caddy'},
						{label = 'Pax hawk', model = 'mhx2'},
						{label = 'Havok',  model = 'Havok'},
						{label = 'Frogger',  model = 'frogger'},
						{label = 'Super Volito Carbon',  model = 'supervolito2'},
						{label = 'Cargobob',  model = 'cargobob2'},
						{label = 'Buzzard',  model = 'Buzzard2'},
						{label = 'Ka32',  model = 'anpc_kamov'},
						{label = 'News Heli',  model = 'newsmav'},
						{label = 'Dodo',  model = 'dodo'},
						{label = 'Swift',  model = 'swift'},
						{label = 'Volatus',  model = 'volatus'},
						{label = 'Seasparrow',  model = 'Seasparrow'},
						{label = 'Cuban 800',  model = 'cuban800'},
						{label = 'Alpha Z-1',  model = 'alphaz1'},
						{label = 'Rogue',  model = 'rogue'},
						{label = 'Howard',  model = 'howard'},
						{label = 'Vestra',  model = 'vestra'},
						{label = 'Velum',  model = 'velum2'},
						{label = 'Falcon 7-X',  model = 'falcon7x'},
						{label = 'Mallard Stunt',  model = 'stunt'},
						{label = 'Nimbus',  model = 'nimbus'},
						{label = 'Mammatus',  model = 'mammatus'},
						{label = 'Besra',  model = 'besra'},
						{label = 'Miljet',  model = 'miljet'},
						{label = 'Ultra Light',  model = 'microlight'},
						{label = 'Crop Duster',  model = 'duster'},
						{label = 'Honda Jet',  model = 'Ha420'},
						{label = 'Ghawar Jet',  model = 'ghawar'}
				}}, function(data, menu)
					menu.close()

					if ESX.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 10.0) then
						ESX.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Pos, 270.0, function(vehicle)
							local playerPed = PlayerPedId()
	
							if data.current.model == 'polmav' then
								SetVehicleModKit(vehicle, 0)
								SetVehicleLivery(vehicle, 1)
							end
						end)
					else
						ESX.ShowNotification('There is an vehicle blocking the spawnpoint.')
					end
				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'boss_actions' then
				TriggerEvent('esx_society:openBossMenu', 'heli', function(data, menu)
					menu.close()
				end, {wash = true})
			end
		end, function(data, menu)
			menu.close()
		end)
	else
		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'heli_actions', {
			title    = 'Pax Air',
			align    = 'top-left',
			elements = {
				{label = 'Clock in', value = 'clock-in'}
		}}, function(data, menu)
			if data.current.value == 'clock-in' then
				isInService = true
				TriggerServerEvent('es_extended:setService', true)
				TriggerServerEvent('player:serviceOn', 'heli', myName, PlayerData.job.grade_label)
				TriggerEvent('customNotification', 'You have clocked in')
				OpenheliActionsMenu()
			end
		end, function(data, menu)
			menu.close()
		end)
	end
end

function OpenMobileheliActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_heli_actions', {
		title    = 'heli',
		align    = 'top-left',
		elements = {
			{label = _U('billing'), value = 'billing'}
	}}, function(data, menu)
		if data.current.value == 'billing' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)
				local amount = tonumber(data.value)

				if amount == nil or amount < 0 then
					ESX.ShowNotification(_U('amount_invalid'))
				else
					menu.close()
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					if closestPlayer == -1 or closestDistance > 3.0 then
						ESX.ShowNotification(_U('no_players_near'))
					else
						TriggerServerEvent('esx_billing:sendPlayerBill', GetPlayerServerId(closestPlayer), 'society_heli', 'heli', amount)
					end
				end

			end, function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_helijob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Pax Air Menu - Withdraw',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					OpenGetStocksMenu()

					TriggerServerEvent('esx_helijob:getStockItem', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	ESX.TriggerServerCallback('esx_helijob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Pax Air Menu - Deposit',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					OpenPutStocksMenu()

					TriggerServerEvent('esx_helijob:putStockItems', itemName, count)
				end

			end,function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('esx_helijob:hasEnteredMarker', function(zone)
	if zone == 'HeliActions' then
		CurrentAction     = 'heli_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = {vehicle = GetVehiclePedIsIn(playerPed, false)}
		end
	end
end)

AddEventHandler('esx_helijob:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.VehicleDeleter.Pos.x, Config.Zones.VehicleDeleter.Pos.y, Config.Zones.VehicleDeleter.Pos.z)

	SetBlipSprite (blip, 43)
	SetBlipColour (blip, 3)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Pax Air, Helicopter services and rentals')
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if PlayerData.job and PlayerData.job.name == 'heli' then
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker, letSleep = false, true
			local currentZone

			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, v.Rotate, false, false, false)
				end

				if distance < v.Size.x then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_helijob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_helijob:hasExitedMarker', LastZone)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'heli' then
				if CurrentAction == 'heli_actions_menu' then
					OpenheliActionsMenu()
				end

				if CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_heli:openJobMenu', function()
	if isInService then
		OpenMobileheliActionsMenu()
	end
end)