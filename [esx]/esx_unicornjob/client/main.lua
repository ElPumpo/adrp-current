local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

local isInService = false
local isInMarker              = false
local isInPublicMarker        = false
local hintIsShowed            = false
local hintToDisplay           = 'no hint to display'

ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
end)

function IsJobTrue()
	if PlayerData ~= nil then
		local IsJobTrue = false
		if PlayerData.job ~= nil and PlayerData.job.name == 'unicorn' then
			IsJobTrue = true
		end

		return IsJobTrue
	end
end

function IsGradeBoss()
	if PlayerData ~= nil then
		local IsGradeBoss = false
		if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'viceboss' then
			IsGradeBoss = true
		end

		return IsGradeBoss
	end
end

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 0,
		modBrakes       = 0,
		modTransmission = 0,
		modSuspension   = 0,
		modTurbo        = false,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function OpenCloakroomMenu()
	local elements = {
		{ label = 'Stop Shift', value = 'stop_shift' },
		{ label = 'Start Shift', value = 'start_shift' }
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = 'Cloakroom',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'stop_shift' then
			isInService = false
			TriggerServerEvent('player:serviceOff', 'unicorn')
			TriggerServerEvent('es_extended:setService', false)
			TriggerEvent('customNotification', 'You\'ve ended your shift')

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'start_shift' then
			isInService = true
			TriggerServerEvent('player:serviceOn', 'unicorn')
			TriggerServerEvent('es_extended:setService', true)
			TriggerEvent('customNotification', 'You\'ve started your shift')

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

function OpenVaultMenu()
	if Config.EnableVaultManagement then

		local elements = {
			{label = _U('get_weapon'), value = 'get_weapon'},
			{label = _U('put_weapon'), value = 'put_weapon'},
			{label = _U('get_object'), value = 'get_stock'},
			{label = _U('put_object'), value = 'put_stock'}
		}

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault', {
			title    = _U('vault'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			if data.current.value == 'get_weapon' then
				OpenGetWeaponMenu()
			elseif data.current.value == 'put_weapon' then
				OpenPutWeaponMenu()
			elseif data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			elseif data.current.value == 'get_stock' then
				OpenGetStocksMenu()
			end
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_vault'
			CurrentActionMsg  = _U('open_vault')
			CurrentActionData = {}
		end)
	end
end

function OpenFridgeMenu()
	local elements = {
		{label = _U('get_object'), value = 'get_stock'},
		{label = _U('put_object'), value = 'put_stock'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fridge', {
		title    = _U('fridge'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'put_stock' then
			OpenPutFridgeStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetFridgeStocksMenu()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_fridge'
		CurrentActionMsg  = _U('open_fridge')
		CurrentActionData = {}
	end)
end

function OpenVehicleSpawnerMenu(zone)
	ESX.UI.Menu.CloseAll()
	local vehicles

	if zone == 'Vehicles' then
		vehicles = Config.Zones.Vehicles
	elseif zone == 'Vehicles2' then
		vehicles = Config.Zones.Vehicles2
	end

	local elements = {}

	for i=1, #Config.AuthorizedVehicles, 1 do
		local vehicle = Config.AuthorizedVehicles[i]

		table.insert(elements, {
			label = vehicle.label,
			value = vehicle.name
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner', {
		title    = _U('vehicle_menu'),
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		menu.close()

		if ESX.Game.IsSpawnPointClear(vehicles.SpawnPoint, 7.0) then
			ESX.Game.SpawnVehicle(data.current.value, vehicles.SpawnPoint, vehicles.Heading)
		else
			ESX.ShowNotification('Spawn point is blocked :/')
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {zone = zone}
	end)
end

function OpenSocietyActionsMenu()
	local elements = {{label = _U('billing'), value = 'billing'}}

	if IsGradeBoss() then
		table.insert(elements, {label = _U('crafting'), value = 'menu_crafting'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unicorn_actions', {
		title    = _U('unicorn'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'billing' then
			OpenBillingMenu()
		elseif data.current.value == 'menu_crafting' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_crafting', {
				title = _U('crafting'),
				align = 'top-left',
				elements = {
					{label = _U('jagerbomb'),     value = 'jagerbomb'},
					{label = _U('golem'),         value = 'golem'},
					{label = _U('whiskycoca'),    value = 'whiskycoca'},
					{label = _U('vodkaenergy'),   value = 'vodkaenergy'},
					{label = _U('vodkafruit'),    value = 'vodkafruit'},
					{label = _U('rhumfruit'),     value = 'rhumfruit'},
					{label = _U('rhumcoca'),      value = 'rhumcoca'},
					{label = _U('mixapero'),      value = 'mixapero'},
					{label = _U('metreshooter'),  value = 'metreshooter'},
			}}, function(data2, menu2)
				TriggerServerEvent('esx_unicornjob:craftingCoktails', data2.current.value)
				animsAction({ lib = 'mini@drinking', anim = 'shots_barman_b' })
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBillingMenu()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = _U('billing_amount')
	}, function(data, menu)
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()

		if player ~= -1 and distance <= 3.0 then
			menu.close()
			if amount == nil or amount < 0 then
				ESX.ShowNotification(_U('amount_invalid'))
			else
				TriggerServerEvent('esx_billing:sendPlayerBill', GetPlayerServerId(player), 'society_unicorn', _U('billing'), amount)
			end
		else
			ESX.ShowNotification(_U('no_players_nearby'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('unicorn_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					OpenGetStocksMenu()

					TriggerServerEvent('esx_unicornjob:getStockItem', itemName, count)
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
	ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
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
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					OpenPutStocksMenu()

					TriggerServerEvent('esx_unicornjob:putStockItems', itemName, count)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGetFridgeStocksMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getFridgeStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('unicorn_fridge_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_unicornjob:getFridgeStockItem', itemName, count)

					Citizen.Wait(500)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutFridgeStocksMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getPlayerInventory', function(inventory)
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
			title    = _U('fridge_inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('invalid_quantity'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_unicornjob:putFridgeStockItems', itemName, count)
					Citizen.Wait(500)
					OpenPutFridgeStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGetWeaponMenu()
	ESX.TriggerServerCallback('esx_unicornjob:getVaultWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault_get_weapon', {
			title    = _U('get_weapon_menu'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('esx_unicornjob:removeVaultWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed,  weaponHash,  false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault_put_weapon', {
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements,
	}, function(data, menu)
		menu.close()

		ESX.TriggerServerCallback('esx_unicornjob:addVaultWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

function OpenShopMenu(zone)
	local elements = {}

	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		table.insert(elements, {
			label     = item.label .. ' - <span style="color:red;">$' .. item.price .. ' </span>',
			realLabel = item.label,
			value     = item.name,
			price     = item.price
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unicorn_shop', {
		title    = _U('shop'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_unicornjob:buyItem', data.current.value, data.current.price, data.current.realLabel)
	end, function(data, menu)
		menu.close()
	end)
end

function animsAction(animObj)
	Citizen.CreateThread(function()
		if not playAnim then
			local playerPed = PlayerPedId();
			if DoesEntityExist(playerPed) then -- Check if ped exist
				dataAnim = animObj

				-- Play Animation
				RequestAnimDict(dataAnim.lib)
				while not HasAnimDictLoaded(dataAnim.lib) do
					Citizen.Wait(0)
				end

				if HasAnimDictLoaded(dataAnim.lib) then
					local flag = 0
					if dataAnim.loop ~= nil and dataAnim.loop then
						flag = 1
					elseif dataAnim.move ~= nil and dataAnim.move then
						flag = 49
					end

					TaskPlayAnim(playerPed, dataAnim.lib, dataAnim.anim, 8.0, -8.0, -1, flag, 0, 0, 0, 0)
					playAnimation = true
				end

				-- Wait end animation
				while true do
					Citizen.Wait(0)
					if not IsEntityPlayingAnim(playerPed, dataAnim.lib, dataAnim.anim, 3) then
						playAnim = false
						break
					end
				end
			end -- end ped exist
		end
	end)
end

AddEventHandler('esx_unicornjob:hasEnteredMarker', function(zone)
	if (zone == 'BossActions' or zone == 'BossActions2') and PlayerData.job.grade_name == 'boss' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	elseif zone == 'Cloakrooms' or zone == 'Cloakrooms2' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif zone == 'Vaults' or zone == 'Vaults2' then
		CurrentAction     = 'menu_vault'
		CurrentActionMsg  = _U('open_vault')
		CurrentActionData = {}
	elseif zone == 'Fridge' or zone == 'Fridge2' or zone == 'Fridge3' or zone == 'Fridge4' then
		CurrentAction     = 'menu_fridge'
		CurrentActionMsg  = _U('open_fridge')
		CurrentActionData = {}
	elseif zone == 'Flacons' or zone == 'NoAlcool' or zone == 'Apero' or zone == 'Ice' then
		CurrentAction     = 'menu_shop'
		CurrentActionMsg  = _U('shop_menu')
		CurrentActionData = {zone = zone}
	elseif zone == 'Vehicles' or zone == 'Vehicles2' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {zone = zone}
	elseif zone == 'VehicleDeleters' then
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed,  false) then
			local vehicle = GetVehiclePedIsIn(playerPed,  false)

			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_vehicle')
			CurrentActionData = {vehicle = vehicle}
		end
	end
end)

AddEventHandler('esx_unicornjob:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.Blips) do
		local blipCoord = AddBlipForCoord(v.coords)

		SetBlipSprite(blipCoord, v.sprite)
		SetBlipScale(blipCoord, 1.2)
		SetBlipColour (blipCoord, v.color)
		SetBlipAsShortRange(blipCoord, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(v.name)
		EndTextCommandSetBlipName(blipCoord)
	end
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsJobTrue() then
			local coords = GetEntityCoords(PlayerPedId())

			for k,v in pairs(Config.Zones) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, false, false, false)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsJobTrue() then
			local coords      = GetEntityCoords(PlayerPedId())
			local isInMarker  = false
			local currentZone = nil

			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_unicornjob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_unicornjob:hasExitedMarker', LastZone)
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

			if IsControlJustReleased(0, 38) and IsJobTrue() then
				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_vault' then
					OpenVaultMenu()
				elseif CurrentAction == 'menu_fridge' then
					OpenFridgeMenu()
				elseif CurrentAction == 'menu_shop' then
					OpenShopMenu(CurrentActionData.zone)
				elseif CurrentAction == 'menu_vehicle_spawner' then
					OpenVehicleSpawnerMenu(CurrentActionData.zone)
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				end

				if CurrentAction == 'menu_boss_actions' and PlayerData.job.grade_name == 'boss' then
					ESX.UI.Menu.CloseAll()

					TriggerEvent('esx_society:openBossMenu', 'unicorn', function(data, menu)
						menu.close()
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end)
				end

				CurrentAction = nil
			end
		end
	end
end)

AddEventHandler('esx_unicornjob:teleportMarkers', function(position)
	SetEntityCoords(PlayerPedId(), position.x, position.y, position.z)
end)

-- Show top left hint
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if hintIsShowed then
			SetTextComponentFormat('STRING')
			AddTextComponentString(hintToDisplay)
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
		else
			Citizen.Wait(500)
		end
	end
end)

-- Activate teleport marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsJobTrue() then
			local coords = GetEntityCoords(PlayerPedId())
			local position, zone
			local letSleep = true

			for k,v in pairs(Config.TeleportZones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
					letSleep = false
				end

				if distance < v.Size.x then
					isInPublicMarker = true
					position = v.Teleport
					zone = v
					break
				else
					isInPublicMarker  = false
				end
			end

			if IsControlJustReleased(0, 38) and isInPublicMarker then
				TriggerEvent('esx_unicornjob:teleportMarkers', position)
			end

			-- hide or show top left zone hints
			if isInPublicMarker then
				hintToDisplay = zone.Hint
				hintIsShowed = true
			else
				if not isInMarker then
					hintToDisplay = 'no hint to display'
					hintIsShowed = false
				end
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_unicornjob:openJobMenu', function()
	if isInService then
		OpenSocietyActionsMenu()
	end
end)