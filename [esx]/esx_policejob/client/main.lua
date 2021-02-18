local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastStation               = nil
local LastPart                  = nil
local LastPartNum               = nil
local LastEntity                = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isHandcuffed              = false
local DragStatus              = {}
DragStatus.IsDragged          = false
local IsInService = false
local myName, jobBlips = nil, {}
local isRespondingBackup = false
local availableUnits = {}
local drawAboveNearestPlayer = false

isInShopMenu = false
local hasShot               = false
local GunpowderSaveTime       = 15 * 60 * 1000

ESX                             = nil

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('esx_policejob:openJobMenu', function()
	if IsInService and not isInShopMenu then
		OpenPoliceActionsMenu()
	end
end)

function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modTurbo        = true,
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function inServiceCop()
	return IsInService
end

function getJob()
	if PlayerData.job then
		return PlayerData.job.name
	end
end

function OpenCloakroomMenu()
	local elements = {
		{label = 'Go off duty', value = 'off_duty'},
		{label = 'Go on duty and select uniform', value = 'on_duty_eup'},
		{label = 'Go on duty as a police dog', value = 'on_duty_dog'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'on_duty_eup' then
			ESX.UI.Menu.CloseAll()
			TriggerEvent('eup-ui:showMenu')
			TriggerEvent('customNotification', 'You have clocked in, welcome!')
			TriggerServerEvent('es_extended:setService', true)
			TriggerServerEvent('player:serviceOn', PlayerData.job.name, myName, PlayerData.job.grade_label)
			IsInService = true
		elseif data.current.value == 'off_duty' then
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				local isMale = skin.sex == 0

				TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
						TriggerEvent('esx:restoreLoadout')

						TriggerServerEvent('es_extended:setService', false)
						TriggerServerEvent('player:serviceOff', PlayerData.job.name)
						TriggerEvent('customNotification', 'You have clocked out')
						IsInService = false
					end)
				end)
			end)
		elseif data.current.value == 'on_duty_dog' then
			local modelHash = GetHashKey('a_c_rottweiler')

			ESX.Streaming.RequestModel(modelHash, function()
				SetPlayerModel(PlayerId(), modelHash)
				SetPedDefaultComponentVariation(PlayerPedId())
				SetModelAsNoLongerNeeded(modelHash)

				TriggerEvent('customNotification', 'You have clocked in as a dog, welcome! Remember that dog roleplay training is required before use.')
				TriggerServerEvent('es_extended:setService', true)
				TriggerServerEvent('player:serviceOn', PlayerData.job.name, myName, PlayerData.job.grade_label)
				IsInService = true
			end)
		end

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end, function(data, menu)
		menu.close()
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenEvidenceMenu(station)
	local elements = {
		{label = 'Submit Evidence',  value = 'submit_evidence'},
	}

	if PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = 'View Evidence', value = 'view_evidence'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'evidence', {
		title    = 'Evidence Locker',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'submit_evidence' then
			OpenSubmitEvidenceMenu()
		elseif data.current.value == 'view_evidence' then
			OpenViewEvidenceMenu()
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_evidence'
		CurrentActionMsg  = 'press ~INPUT_CONTEXT~ to access the ~y~Evidence Locker~s~.'
		CurrentActionData = {station = station}
	end)
end

function OpenViewEvidenceMenu()
	ESX.TriggerServerCallback('esx_policejob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = "Evidence Locker",
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenSubmitEvidenceMenu()
	ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name,
					count = item.count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value
			local itemCount = data.current.count

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil or count > itemCount then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					TriggerServerEvent('esx_policejob:putStockItems', itemName, count)
					SetTimeout(1000, function()
						OpenSubmitEvidenceMenu()
					end)
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenBuyWeaponsMenu()
	local elements = {}
	local playerPed = PlayerPedId()
	PlayerData = ESX.GetPlayerData()
	local authorizedWeapons = {}

	if PlayerData.job.name == 'police' then
		authorizedWeapons = Config.PoliceAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'sheriff' then
		authorizedWeapons = Config.SheriffAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'state' then
		authorizedWeapons = Config.StateAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'securoserv' then
		authorizedWeapons = Config.SecuroServAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'usmarshal' then
		authorizedWeapons = Config.UsmarshalAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'dod' then
		authorizedWeapons = Config.dodAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'fib' then
		authorizedWeapons = Config.FibAuthorizedWeapons[PlayerData.job.grade_name]
	elseif PlayerData.job.name == 'doj' then
		authorizedWeapons = Config.DojAuthorizedWeapons[PlayerData.job.grade_name]
	end

	for k,v in ipairs(authorizedWeapons) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local components, label = {}
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if v.components then
			for i=1, #v.components do
				if v.components[i] then

					local component = weapon.components[i]
					local hasComponent = HasPedGotWeaponComponent(playerPed, GetHashKey(v.weapon), component.hash)

					if hasComponent then
						label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_owned'))
					else
						if v.components[i] > 0 then
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_item', ESX.Math.GroupDigits(v.components[i])))
						else
							label = ('%s: <span style="color:green;">%s</span>'):format(component.label, _U('armory_free'))
						end
					end

					table.insert(components, {
						label = label,
						componentLabel = component.label,
						hash = component.hash,
						name = component.name,
						price = v.components[i],
						hasComponent = hasComponent,
						componentNum = i
					})
				end
			end
		end

		if hasWeapon and v.components then
			label = ('%s: <span style="color:green;">></span>'):format(weapon.label)
		elseif hasWeapon and not v.components then
			label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_owned'))
		else
			if v.price > 0 then
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_item', ESX.Math.GroupDigits(v.price)))
			else
				label = ('%s: <span style="color:green;">%s</span>'):format(weapon.label, _U('armory_free'))
			end
		end

		table.insert(elements, {
			label = label,
			weaponLabel = weapon.label,
			name = weapon.name,
			components = components,
			price = v.price,
			hasWeapon = hasWeapon
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons', {
		title    = _U('armory_weapontitle'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.hasWeapon then
			if #data.current.components > 0 then
				OpenWeaponComponentShop(data.current.components, data.current.name, menu)
			end
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.weaponLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()

					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, data.current.name, 1)
		end

	end, function(data, menu)
		menu.close()
	end)

end

function OpenWeaponComponentShop(components, weaponName, parentShop)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_buy_weapons_components', {
		title    = _U('armory_componenttitle'),
		align    = 'top-left',
		elements = components
	}, function(data, menu)

		if data.current.hasComponent then
			ESX.ShowNotification(_U('armory_hascomponent'))
		else
			ESX.TriggerServerCallback('esx_policejob:buyWeapon', function(bought)
				if bought then
					if data.current.price > 0 then
						ESX.ShowNotification(_U('armory_bought', data.current.componentLabel, ESX.Math.GroupDigits(data.current.price)))
					end

					menu.close()
					parentShop.close()

					OpenBuyWeaponsMenu()
				else
					ESX.ShowNotification(_U('armory_money'))
				end
			end, weaponName, 2, data.current.componentNum)
		end

	end, function(data, menu)
		menu.close()
	end)
end

function IsInVehicle()
	local ply = PlayerPedId()
	if IsPedSittingInAnyVehicle(ply) then
		return true
	else
		return false
	end
end

function openBackupMenu()
	local job = getJob()
	local elements = {}

	local serverId = GetPlayerServerId(PlayerId())

	for playerId,playerInfo in pairs(availableUnits) do
		if playerInfo.job == job and playerId ~= serverId then

			table.insert(elements, {
				label = ('%s: %s'):format(playerInfo.name, playerInfo.grade),
				playerId = playerId
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_backup', {
		title    = 'Call backup',
		align    = 'center',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_policejob:callBackup', data.current.playerId)
		TriggerEvent('customNotification', "You have called for a 10-32!")
		Citizen.Wait(1000)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx_policejob:callBackup')
AddEventHandler('esx_policejob:callBackup', function(playerId, playerName)
	if isRespondingBackup then
		return
	end

	PlaySound(-1, 'Menu_Accept', 'Phone_SoundSet_Default', false, 0, true)

	isRespondingBackup = true
	local player = GetPlayerFromServerId(playerId)
	local playerPed = GetPlayerPed(player)
	local playerCoords = GetEntityCoords(playerPed)

	TriggerEvent("pNotify:SendNotification", {
		text = ('10-32: Officer <span style="color:#4790ef;">%s</span> is requesting backup!<br><br>Press <span style="color:#fcd336;">LEFT SHIFT+Y</span> within 15 seconds for GPS route'):format(playerName),
		type = "warning",
		timeout = 15000,
		layout = "centerRight",
		queue = "right"
	})

	local timeout = 1000 * 15

	Citizen.CreateThread(function()
		while timeout > 0 do
			Citizen.Wait(1000)
			timeout = timeout - 1000
		end
	end)

	Citizen.CreateThread(function()
		while timeout > 0 do
			Citizen.Wait(0)

			if IsControlPressed(1, 21) and IsControlPressed(1, 246) then
				SetNewWaypoint(playerCoords.x, playerCoords.y)
				TriggerEvent('customNotification', "You have responded to the 10-32. GPS route has been marked on your map.")
				PlaySound(-1, 'WAYPOINT_SET', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false, 0, true)
				isRespondingBackup = false
				break
			end
		end
	end)
end)

function OpenPoliceActionsMenu()
	local ped, elements = PlayerPedId()
	ESX.UI.Menu.CloseAll()

	if PlayerData.job.name == 'securoserv' then
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = 'Call backup', value = 'backup'},
		}
	else
		elements = {
			{label = _U('citizen_interaction'), value = 'citizen_interaction'},
			{label = _U('vehicle_interaction'), value = 'vehicle_interaction'},
			{label = _U('object_spawner'), value = 'object_spawner'},
			{label = 'Repair Vehicle', value = 'repair_vehicle'},
			{label = 'Call backup', value = 'backup'},
			{label = 'Police Identification', value = 'police_id'}
		}
	end

	if (IsInVehicle()) then
		local vehicle = GetVehiclePedIsIn(ped, false )
		if (GetPedInVehicleSeat(vehicle, -1) == ped and IsPedInAnyPoliceVehicle(ped)) then
			if GetVehicleBodyHealth(vehicle) == 1000  then
				table.insert(elements, {label = "Vehicle Extras", value = 'vehicle_extra'})
			end
			table.insert(elements, {label = "Wash Vehicle", value = 'vehicle_wash'})
		end
	end

	table.insert(elements, {label = "Drop GPS & Radio", value = 'drop_GPS'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_actions', {
		title    = 'Police Mobile Actions',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'repair_vehicle' then
			TriggerEvent('esx_policejob:repairVehicle')
		elseif data.current.value == 'backup' then
			openBackupMenu()
		elseif data.current.value == 'drop_GPS' then
			ESX.UI.Menu.CloseAll()
			TriggerServerEvent('es_extended:setService', false)
			TriggerEvent('customNotification', "You have destroyed your gps and dropped your radio")
			TriggerEvent("mecommand", "has dropped their radio and gps")
		elseif data.current.value == 'citizen_interaction' then
			openCitizenInteractionMenu()
		elseif data.current.value == 'vehicle_wash' then
			SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(),  false),  0.01)
		elseif data.current.value == 'vehicle_extra' then

			local extras = {}
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			for i = 1, 12 do
				if DoesExtraExist(vehicle, i) then
					table.insert(extras, {
						label = "Extra "..tostring(i),
						extra = i
					})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_extra', {
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = extras
			}, function(data2, menu2)
				SetVehicleExtra(vehicle, data2.current.extra, IsVehicleExtraTurnedOn(vehicle, data2.current.extra) and true or false)
			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'vehicle_interaction' then

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_interaction', {
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('vehicle_info'), value = 'vehicle_infos'},
					{label = _U('pick_lock'),    value = 'hijack_vehicle'}
			}}, function(data2, menu2)

				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local vehicle   = GetClosestVehicle(coords, 3.0, 0, 71)

				if DoesEntityExist(vehicle) then

					local vehicleData = ESX.Game.GetVehicleProperties(vehicle)

					if data2.current.value == 'vehicle_infos' then
						OpenVehicleInfosMenu(vehicleData)
					elseif data2.current.value == 'hijack_vehicle' then
						local playerPed = PlayerPedId()
						local coords    = GetEntityCoords(playerPed)

						if IsAnyVehicleNearPoint(coords, 3.0) then
							local vehicle = GetClosestVehicle(coords, 3.0, 0, 71)

							if DoesEntityExist(vehicle) then
								TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)

								Wait(20000)

								ClearPedTasksImmediately(playerPed)

								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)

								TriggerEvent('esx:showNotification', _U('vehicle_unlocked'))
							end
						end
					end

				else
					ESX.ShowNotification(_U('no_vehicles_nearby'))
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		elseif data.current.value == 'object_spawner' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('traffic_interaction'),
				align    = 'top-left',
				elements = {
					{label = _U('cone'),        value = 'prop_roadcone02a'},
					{label = _U('barrier'),     value = 'prop_barrier_work05'},
					{label = _U('spikestrips'), value = 'p_ld_stinger_s'},
					{label = _U('box'),         value = 'prop_boxpile_07d'},
					{label = _U('cash'),        value = 'hei_prop_cash_crate_half_full'}
			}}, function(data2, menu2)
				local model     = data2.current.value
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				local forward   = GetEntityForwardVector(playerPed)
				local x, y, z   = table.unpack(coords + forward * 1.0)

				if model == 'prop_roadcone02a' then
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
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif data.current.value == 'police_id' then
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_id', {
				title    = 'Police Identification',
				align    = 'top-left',
				elements = {
					{label = 'Set Police ID (Badge)', value = 'set_pol_id'},
					{label = 'Show Police ID', value = 'show_pol_id'},
					{label = 'See Police ID', value = 'see_pol_id'}
			}}, function(data2, menu2)
				if data2.current.value == 'set_pol_id' then
					TriggerEvent('esx_badge:setBadge')
				elseif data2.current.value == 'show_pol_id' then
					TriggerEvent('esx_badge:showBadge', target)
				elseif data2.current.value == 'see_pol_id' then
					TriggerEvent('esx_badge:openBadge')
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenSecuroActionsMenu()
	local ped = PlayerPedId()

	ESX.UI.Menu.CloseAll()

	local elements = {
		{label = _U('citizen_interaction'), value = 'citizen_interaction'},
		{label = 'Call backup', value = 'backup'}
	}

	if IsInVehicle() then
		local vehicle = GetVehiclePedIsIn(ped, false)
		if GetPedInVehicleSeat(vehicle, -1) == ped and IsPedInAnyPoliceVehicle(ped) then
			if GetVehicleBodyHealth(vehicle) == 1000  then
				table.insert(elements, {label = "Vehicle Extras", value = 'vehicle_extra'})
			end

			table.insert(elements, {label = "Wash Vehicle", value = 'vehicle_wash'})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'securo_actions', {
		title    = 'Securo Serv Actions',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'backup' then
			openBackupMenu()
		elseif data.current.value == 'citizen_interaction' then
			openCitizenInteractionSecuroMenu()
		elseif data.current.value == 'vehicle_wash' then
			SetVehicleDirtLevel(GetVehiclePedIsIn(PlayerPedId(),  false),  0.01)
		elseif data.current.value == 'vehicle_extra' then
			local extras = {}
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			for i = 1, 12 do
				if DoesExtraExist(vehicle, i) then
					table.insert(extras, {
						label = "Extra "..tostring(i),
						extra = i
					})
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_extra', {
				title    = _U('vehicle_interaction'),
				align    = 'top-left',
				elements = extras
			}, function(data2, menu2)
				SetVehicleExtra(vehicle, data2.current.extra, IsVehicleExtraTurnedOn(vehicle, data2.current.extra) and true or false)
			end, function(data2, menu2)
				menu2.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openCitizenInteractionMenu()
	startDrawMarkerAboveNearbyPlayer()
	local elements

	if PlayerData.job.name == 'securoserv' then
		elements = {
			{label = _U('handcuff'), value = 'handcuff'},
			{label = _U('drag'), value = 'drag'},
			{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
			{label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
		}
	else
		elements = {
			{label = _U('search'), value = 'body_search'},
			{label = _U('handcuff'), value = 'handcuff'},
			{label = _U('drag'), value = 'drag'},
			{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
			{label = _U('out_the_vehicle'), value = 'out_the_vehicle'},
			{label = _U('fine'), value = 'fine'},
			{label = _U('jail_player'), value = 'jail_player'},
			{label = 'Manage Player Licenses', value = 'license_manage'},
			{label = "Fingerprint player", value = 'finger_print'},
			{label = "Perform GSR Test", value = 'gsr_test'},
			{label = "View Unpaid Fines", value = 'unpaid_fines'},
			{label = _U('breathalyze'), value = 'body_breath'}
		}
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = _U('citizen_interaction'),
		align    = 'top-left',
		elements = elements
	}, function(data2, menu2)
		local player, distance = ESX.Game.GetClosestPlayer()

		if distance ~= -1 and distance <= 3.0 then
			local action = data2.current.value

			if action == 'body_breath' then
				OpenBreath(player)
			elseif action == 'unpaid_fines' then
				OpenUnpaidBillsMenu(player)
			elseif action == 'gsr_test' then
				performGSRtest(player)
			elseif action == 'license_manage' then
				ManageLicenses(player)
			elseif action == 'jail_player' then
				JailPlayer(GetPlayerServerId(player))
			elseif action == 'body_search' then
				OpenBodySearchMenu(player)
			elseif action == 'handcuff' then
				local playerPed = PlayerPedId()
				local forwardVector, playerCoords, playerHeading = GetEntityForwardVector(playerPed), GetEntityCoords(playerPed), GetEntityHeading(playerPed)
				local forwardCoords = playerCoords + forwardVector * 1
				local finalCoords = {x = ESX.Math.Round(forwardCoords.x, 1), y = ESX.Math.Round(forwardCoords.y, 1), z = ESX.Math.Round(forwardCoords.z, 1), h = playerHeading}

				ESX.TriggerServerCallback('esx_policejob:performHandcuff', function(cuff)
					if cuff then
						ESX.Streaming.RequestAnimDict('mp_arrest_paired')
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuff', 0.7)
						TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8.0, 3750, 2, 0.0, false, false, false)
					else
						ESX.Streaming.RequestAnimDict('mp_arresting')
						TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8.0, -1, 2, 0.0, false, false, false)
						Citizen.Wait(5500)
						ClearPedTasks(playerPed)
					end
				end, GetPlayerServerId(player), finalCoords)
			elseif action == 'drag' then
				TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
			elseif action == 'put_in_vehicle' then
				TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
			elseif action == 'out_the_vehicle' then
				TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
			elseif action == 'fine' then
				OpenFineMenu(player)
			elseif action == 'finger_print' then
				fingerPrintNearbyPlayer(player)
			end
		else
			ESX.ShowNotification(_U('no_players_nearby'))
		end
	end, function(data2, menu2)
		drawAboveNearestPlayer = false
		menu2.close()
	end)
end

function openCitizenInteractionSecuroMenu()
	startDrawMarkerAboveNearbyPlayer()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
		title    = _U('citizen_interaction'),
		align    = 'top-left',
		elements = {
			{label = _U('handcuff'), value = 'handcuff'},
			{label = _U('drag'), value = 'drag'},
			{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
			{label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
	}}, function(data2, menu2)
		local player, distance = ESX.Game.GetClosestPlayer()

		if distance ~= -1 and distance <= 3.0 then
			local action = data2.current.value

			if action == 'handcuff' then
				local playerPed = PlayerPedId()
				local forwardVector, playerCoords, playerHeading = GetEntityForwardVector(playerPed), GetEntityCoords(playerPed), GetEntityHeading(playerPed)
				local forwardCoords = playerCoords + forwardVector * 1
				local finalCoords = {x = ESX.Math.Round(forwardCoords.x, 1), y = ESX.Math.Round(forwardCoords.y, 1), z = ESX.Math.Round(forwardCoords.z, 1), h = playerHeading}

				ESX.TriggerServerCallback('esx_policejob:performHandcuff', function(cuff)
					if cuff then
						ESX.Streaming.RequestAnimDict('mp_arrest_paired')
						TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 2.0, 'cuff', 0.7)
						TaskPlayAnim(playerPed, 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8.0, 3750, 2, 0.0, false, false, false)
					else
						ESX.Streaming.RequestAnimDict('mp_arresting')
						TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8.0, -1, 2, 0.0, false, false, false)
						Citizen.Wait(5500)
						ClearPedTasks(playerPed)
					end
				end, GetPlayerServerId(player), finalCoords)
			elseif action == 'drag' then
				TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(player))
			elseif action == 'put_in_vehicle' then
				TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(player))
			elseif action == 'out_the_vehicle' then
				TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(player))
			end
		else
			ESX.ShowNotification(_U('no_players_nearby'))
		end
	end, function(data2, menu2)
		drawAboveNearestPlayer = false
		menu2.close()
	end)
end

function startDrawMarkerAboveNearbyPlayer()
	local markerDraw

	if drawAboveNearestPlayer then return end
	drawAboveNearestPlayer = true

	Citizen.CreateThread(function()
		while drawAboveNearestPlayer do
			Citizen.Wait(100)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

			if closestPlayer ~= -1 and closestDistance < 3.0 then
				markerDraw = GetOffsetFromEntityInWorldCoords(GetPlayerPed(closestPlayer), 0.0, 0.0, 1.1)
			else
				markerDraw = nil
			end

			if not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'citizen_interaction') then
				drawAboveNearestPlayer = false
			end
		end
	end)

	Citizen.CreateThread(function()
		while drawAboveNearestPlayer do
			Citizen.Wait(0)

			if markerDraw then
				DrawMarker(20, markerDraw, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 40, 150, 30, 100, false, false, 2, true, nil, nil, false)
			else
				Citizen.Wait(500)
			end
		end
	end)
end

function fingerPrintNearbyPlayer(player)
	local player, distance = ESX.Game.GetClosestPlayer()
	local coords = GetEntityCoords(PlayerPedId())
	local isNear = false

	for k,v in pairs(Config.PoliceStations) do
		for i=1, #v.FingerPrinting, 1 do
			local distance = #(coords - v.FingerPrinting[i])

			if distance < 5.0 then
				isNear = true
				break
			end
		end

		if isNear then
			break
		end
	end

	if distance ~= -1 and distance <= 3.0 and isNear then
		TriggerEvent('customNotification', 'Scanning fingerprints of suspect...')
		RequestAnimDict("amb@prop_human_bbq@male@base")
		while not HasAnimDictLoaded("amb@prop_human_bbq@male@base") do
			Citizen.Wait(0)
		end
		TaskPlayAnim(player, "amb@prop_human_bbq@male@base", "base",  8.0, -8, -1, 49, 0, 0, 0, 0)
		Citizen.Wait(5000)

		ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
			local idlabel, dob

			if data.name then
				idLabel = 'ID: ' .. data.name
				dob = 'Date of Birth: ' .. data.name
			else
				idLabel = 'ID: Unknown'
				dob = 'ID: Unknown'
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = "Fingerprint results",
				align    = 'top-left',
				elements = {
					{label = _U('name') .. data.firstname .. " " .. data.lastname},
					{label = "Date of Birth: " .. data.dob}
			}}, nil, function(data, menu)
				menu.close()
			end)
		end, GetPlayerServerId(player))
	else
		TriggerEvent('customNotification', 'You must be at the fingerprinting station')
	end
end

function startCustomFine(player)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fine_menu',{
		title = "Fine price?",
	}, function (data2, menu)
		local fineAmount = tonumber(data2.value)

		if fineAmount == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fine_menu_reason', {
				title = "Illegal Offence?",
			}, function (data, menu)
				local offence = data.value
				TriggerServerEvent('esx_billing:sendPlayerBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. offence, fineAmount)
				TriggerEvent('customNotificaiton', 'You have fined them for ' .. offence .. ' in the amount of $'.. ESX.Math.GroupDigits(fineAmount))
				ESX.UI.Menu.CloseAll()
			end, function(data, menu)
				menu.close()
			end)
		end
	end)
end

function JailPlayer(playerId)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jail_menu', {
		title = 'Jail time in minutes',
	}, function (data, menu)
		local jailTime = tonumber(data.value)
		if jailTime == nil then
			ESX.ShowNotification(_U('invalid_amount'))
		else
			TriggerServerEvent('esx_jail:sendPlayerToJail', playerId, jailTime * 60)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenBreath(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements  = {}

		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac') .. data.drunk .. '%'})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements,
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function CheckLicenses(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}

		if data.licenses then
			table.insert(elements, {label = '--- Licenses ---'})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements,
			}, nil, function(data, menu)
				menu.close()
			end)
		end
	end, GetPlayerServerId(player))
end

function ManageLicenses(player)
	local elements, targetName = {}

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label and data.licenses[i].type then
					table.insert(elements, {
						label = data.licenses[i].label,
						type = data.licenses[i].type
					})
				end
			end
		end

		targetName = data.firstname .. ' ' .. data.lastname

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license', {
			title    = _U('license_revoke'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification(_U('licence_you_revoked', data.current.label, targetName))
			TriggerServerEvent('esx_policejob:message', GetPlayerServerId(player), _U('license_revoked', data.current.label))

			TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.type)

			ESX.SetTimeout(300, function()
				ManageLicenses(player)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.drunk then
			table.insert(elements, {label = _U('bac') .. data.drunk .. '%'})
		end

		if data.licenses then
			table.insert(elements, {label = '--- Licenses ---'})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction', {
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements,
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}
		local blackMoney = 0

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' then
				blackMoney = data.accounts[i].money
				break
			end
		end

		table.insert(elements, {
			label          = _U('confiscate_dirty') .. blackMoney,
			value          = 'black_money',
			itemType       = 'item_account',
			amount         = blackMoney
		})

		table.insert(elements, {label = '--- Weapons ---'})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label          = _U('confiscate') .. ESX.GetWeaponLabel(data.weapons[i].name),
				value          = data.weapons[i].name,
				itemType       = 'item_weapon',
				amount         = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = _U('inventory_label')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label          = _U('confiscate_inv') .. data.inventory[i].count .. ' ' .. data.inventory[i].label,
					value          = data.inventory[i].name,
					itemType       = 'item_standard',
					amount         = data.inventory[i].count,
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = _U('search'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			local itemType = data.current.itemType
			local itemName = data.current.value
			local amount   = data.current.amount

			if data.current.value then
				TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function OpenFineMenu(player)
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine', {
		title    = _U('fine'),
		align    = 'top-left',
		elements = {
			{label = "Chapter 1",   value = 0},
			{label = "Chapter 2",   value = 1},
			{label = "Chapter 3",   value = 2},
			{label = "Chapter 4",   value = 3},
			{label = "Chapter 5",   value = 4},
			{label = "Chapter 6",   value = 5},
			{label = "Custom Fine", value = 6}
	}}, function(data, menu)
		if data.current.value == 6 then
			startCustomFine(player)
		else
			OpenFineCategoryMenu(player, data.current.value)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenFineCategoryMenu(player, category)
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' <span style="color: red;">$' .. ESX.Math.GroupDigits(fines[i].amount) .. '</span>',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category', {
			title    = _U('fine'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local label  = data.current.fineLabel
			local amount = data.current.amount
			menu.close()
			TriggerServerEvent('esx_billing:sendPlayerBill', GetPlayerServerId(player), 'society_police', _U('fine_total') .. label, amount)

			ESX.SetTimeout(300, function()
				OpenFineCategoryMenu(player, category)
			end)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

function OpenVehicleInfosMenu(vehicleData)
	ESX.TriggerServerCallback('esx_policejob:getVehicleInfos', function(infos)
		local elements = {
			{label = _U('plate') .. infos.plate}
		}

		if infos.owner == nil then
			table.insert(elements, {label = _U('owner_unknown')})
		else
			table.insert(elements, {label = _U('owner') .. infos.owner})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos', {
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements,
		}, nil, function(data, menu)
			menu.close()
		end)
	end, ESX.Math.Trim(vehicleData.plate))
end

AddEventHandler('esx_policejob:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'EvidenceLocker' then
		CurrentAction     = 'menu_evidence'
		CurrentActionMsg  = 'press ~INPUT_CONTEXT~ to access the ~y~Evidence Locker~s~.'
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {}
	elseif part == 'Vehicles' then
		CurrentAction     = 'Vehicles'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Boats' then
		CurrentAction     = 'Boats'
		CurrentActionMsg  = _U('boat_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'Helicopters' then
		CurrentAction     = 'Helicopters'
		CurrentActionMsg  = _U('helicopter_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_policejob:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

AddEventHandler('esx_policejob:hasEnteredEntityZone', function(entity)
	local playerPed = PlayerPedId()

	if PlayerData.job ~= nil then
		if PlayerData.job.name == 'police' or PlayerData.job.name == 'state' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'usmarshal' or PlayerData.job.name == 'dod' or PlayerData.job.name == 'fib' and not IsPedInAnyVehicle(playerPed, false) then
			CurrentAction     = 'remove_entity'
			CurrentActionMsg  = _U('remove_object')
			CurrentActionData = {entity = entity}
		end
	end

	if GetEntityModel(entity) == GetHashKey('p_ld_stinger_s') then
		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed)

			for i=0, 7, 1 do
				SetVehicleTyreBurst(vehicle, i, true, 1000)
			end
		end
	end
end)

AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() and isHandcuffed then
		TriggerEvent('esx_policejob:unrestrain')
	end
end)

RegisterNetEvent('esx_policejob:performHandcuff')
AddEventHandler('esx_policejob:performHandcuff', function(arrestingOfficer, finalCoords)
	local playerPed = PlayerPedId()
	arrestingOfficer = GetPlayerFromServerId(arrestingOfficer)
	ESX.Game.Teleport(playerPed, finalCoords)
	SetEntityHeading(playerPed, finalCoords.h)

	if isHandcuffed then -- uncuff
		ESX.Streaming.RequestAnimDict('mp_arresting')
		TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8.0, -1, 0, 0.0, false, false, false)

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)
	else -- cuff
		SetEnableHandcuffs(playerPed, true)
		DisablePlayerFiring(playerPed, true)
		SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
		SetPedCanPlayGestureAnims(playerPed, false)
		ESX.Streaming.RequestAnimDict('mp_arrest_paired')
		TaskPlayAnim(playerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8.0, 3750, 2, 0.0, false, false, false)

		Citizen.Wait(3760)
		ESX.Streaming.RequestAnimDict('mp_arresting')
		TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0.0, false, false, false)

		FreezeEntityPosition(playerPed, true)
		DisplayRadar(false)
	end

	isHandcuffed = not isHandcuffed
end)

RegisterNetEvent('esx_policejob:drag')
AddEventHandler('esx_policejob:drag', function(copID)
	if not isHandcuffed then
		return
	end

	DragStatus.IsDragged = not DragStatus.IsDragged
	DragStatus.CopId     = tonumber(copID)
end)

Citizen.CreateThread(function()
	local playerPed
	local targetPed

	while true do
		Citizen.Wait(1)

		if isHandcuffed then
			playerPed = PlayerPedId()

			if DragStatus.IsDragged then
				targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))

				-- undrag if target is in an vehicle
				if not IsPedSittingInAnyVehicle(targetPed) then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
				else
					DragStatus.IsDragged = false
					DetachEntity(playerPed, true, false)
				end

			else
				DetachEntity(playerPed, true, false)
			end
		else
			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('esx_policejob:putInVehicle')
AddEventHandler('esx_policejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not isHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat

			for i=maxSeats-1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				DragStatus.IsDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_policejob:OutVehicle')
AddEventHandler('esx_policejob:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed then
			DisableControlAction(0, 1, true) -- Disable pan
			DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			DisableControlAction(0, 32, true) -- W
			DisableControlAction(0, 34, true) -- A
			DisableControlAction(0, 31, true) -- S
			DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 170,  true) -- Disable scoreboard
			DisableControlAction(0, 167,  true) -- Disable phone
			DisableControlAction(0, 311, true) -- Inventory
			DisableControlAction(0, 19, true) -- Job

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	for i=1, #Config.Blips do
		local blip = AddBlipForCoord(Config.Blips[i])

		SetBlipSprite(blip, 60)
		SetBlipScale(blip, 1.2)
		SetBlipColour(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Police Station")
		EndTextCommandSetBlipName(blip)
	end
end)

function CheckPolice(allowEms)
	if PlayerData.job then
		local job = PlayerData.job.name
		if job == 'police' or job == 'state' or job == 'sheriff' or job == 'usmarshal' or job == 'securoserv' or job == 'dod' or job == 'fib' or job == 'doj' then
			return true
		end

		if allowEms and job == 'ambulance' then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CheckPolice() then
			local playerCoords = GetEntityCoords(PlayerPedId())

			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.PoliceStations) do
				for i=1, #v.Cloakrooms, 1 do
					local distance = #(playerCoords - v.Cloakrooms[i])

					if distance < Config.DrawDistance then
						letSleep = false
						DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

						if distance < Config.MarkerSize.x then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
						end
					end
				end

				if IsInService then
					for i=1, #v.FingerPrinting, 1 do
						local distance = #(playerCoords - v.FingerPrinting[i])

						if distance < Config.DrawDistance then
							letSleep = false
							DrawMarker(Config.MarkerType, v.FingerPrinting[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
						end
					end

					for i=1, #v.EvidenceLocker, 1 do
						local distance = #(playerCoords - v.EvidenceLocker[i])

						if distance < Config.DrawDistance then
							letSleep = false
							DrawMarker(Config.MarkerType, v.EvidenceLocker[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'EvidenceLocker', i
							end
						end
					end

					for i=1, #v.Armories, 1 do
						local distance = #(playerCoords - v.Armories[i])

						if distance < Config.DrawDistance then
							letSleep = false
							DrawMarker(21, v.Armories[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
							end
						end
					end

					for i=1, #v.Vehicles, 1 do
						local distance = #(playerCoords - v.Vehicles[i].Spawner)

						if distance < Config.DrawDistance then
							letSleep = false
							DrawMarker(36, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
							end
						end
					end

					for i=1, #v.Boats, 1 do
						local distance = #(playerCoords - v.Boats[i].Spawner)

						if distance < Config.DrawDistance then
							letSleep = false
							DrawMarker(35, v.Boats[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Boats', i
							end
						end
					end

					for i=1, #v.Helicopters, 1 do
						local distance = #(playerCoords - v.Helicopters[i].Spawner)

						if distance < Config.DrawDistance then
							letSleep = false
							DrawMarker(34, v.Helicopters[i].Spawner, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)

							if distance < Config.MarkerSize.x then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Helicopters', i
							end
						end
					end

					if Config.EnablePlayerManagement and PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'depchief' then
						for i=1, #v.BossActions, 1 do
							local distance = #(playerCoords - v.BossActions[i])

							if distance < Config.DrawDistance then
								letSleep = false
								DrawMarker(Config.MarkerType, v.BossActions[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)

								if distance < Config.MarkerSize.x then
									isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
								end
							end
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum) ) then
				if
					(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_policejob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_policejob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
			
			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Enter / Exit entity zone events
Citizen.CreateThread(function()
	local trackedEntities = {
		'prop_roadcone02a',
		'prop_barrier_work06a',
		'p_ld_stinger_s',
		'prop_boxpile_07d',
		'hei_prop_cash_crate_half_full'
	}

	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #trackedEntities, 1 do
			local object = GetClosestObjectOfType(coords, 3.0, GetHashKey(trackedEntities[i]), false, false, false)

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
				TriggerEvent('esx_policejob:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity ~= nil then
				TriggerEvent('esx_policejob:hasExitedEntityZone', LastEntity)
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

			if IsControlJustReleased(0, 38) and PlayerData.job then
				if CheckPolice() then
					if CurrentAction == 'menu_cloakroom' then
						OpenCloakroomMenu()
					elseif CurrentAction == 'menu_evidence' then
						OpenEvidenceMenu()
					elseif CurrentAction == 'menu_armory' then
						OpenBuyWeaponsMenu()
					elseif CurrentAction == 'menu_boss_actions' then
						ESX.UI.Menu.CloseAll()

						TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu)
							menu.close()

							CurrentAction     = 'menu_boss_actions'
							CurrentActionMsg  = _U('open_bossmenu')
							CurrentActionData = {}
						end, {wash = false})
					elseif CurrentAction == 'remove_entity' then
						DeleteEntity(CurrentActionData.entity)
					elseif CurrentAction == 'Vehicles' then
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					elseif CurrentAction == 'Boats' then
						OpenVehicleSpawnerMenu('boats', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					elseif CurrentAction == 'Helicopters' then
						OpenVehicleSpawnerMenu('helicopter', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					end

					CurrentAction = nil
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	local mediHeli = GetHashKey("as350")

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local inVehicle = IsPedInAnyVehicle(playerPed, true)

		if inVehicle and not CheckPolice(true) then
			local vehicle = GetVehiclePedIsUsing(playerPed)
			local vehicleClass = GetVehicleClass(vehicle)

			if vehicleClass == 18 or IsVehicleModel(vehicle, mediHeli) then
				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					drawTxt("~r~It's against the server rules for civilians to drive these vehicles!",0,1,0.5,0.8,0.6,255,255,255,255)
					SetVehicleUndriveable(vehicle, true)
				end
			else
				Citizen.Wait(2000)
			end
		else
			Citizen.Wait(2000)
		end
	end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x , y)
end

function OpenUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {
				label = bills[i].label .. ' - <span style="color: red;">$' .. ESX.Math.GroupDigits(bills[i].amount) .. '</span>',
				value = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing', {
			title    = "Unpaid Bills",
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

function performGSRtest(player)
	TaskStartScenarioInPlace(PlayerPedId(), "CODE_HUMAN_MEDIC_KNEEL", 0, true)
	Citizen.Wait(10000)
	ClearPedTasksImmediately(PlayerPedId())

	ESX.TriggerServerCallback('esx_guntest:hasPlayerRecentlyFiredAGun', function(hasGunpowder)
		if hasGunpowder then
			TriggerEvent("customNotification", "Subject tested <font color='red'>POSITIVE</font> for GSR")
		else
			TriggerEvent("customNotification", "Subject tested <font color='green'>Negative</font> for GSR")
		end
	end, GetPlayerServerId(player))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		if IsPedShooting(PlayerPedId()) then
			hasShot = true
			TriggerServerEvent('esx_guntest:storePlayerGunpowderStatus')
		end

		if hasShot then
			Citizen.Wait(GunpowderSaveTime)
			hasShot = false
			TriggerServerEvent('esx_guntest:removePlayerGunpowderStatus')
		end
	end
end)

RegisterNetEvent('esx_policejob:repairVehicle')
AddEventHandler('esx_policejob:repairVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle

		if IsPedInAnyVehicle(playerPed, false) then
			TriggerEvent('customNotification', "You must be out of your vehicle to begin repairs")
		else
			vehicle = GetClosestVehicle(coords, 5.0, 0, 71)
		end

		if DoesEntityExist(vehicle) then
			if GetVehicleClass(vehicle) == 18 then
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
					drawProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, "Repairing vehicle")
				end

				SetVehicleFixed(vehicle)
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
				TriggerEvent('customNotification', 'You can only repair emergency vehicles')
			end
		end
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

RegisterNetEvent("robberies:warnCopsNotification")
AddEventHandler("robberies:warnCopsNotification", function()
	TriggerEvent("pNotify:SendNotification", {
		text = "10-1 : We have lost contact with an officer!",
		type = "warning",
		timeout = 10000,
		layout = "centerRight",
		queue = "right"
	})
end)

RegisterNetEvent('esx_policejob:updateAvailableUnits')
AddEventHandler('esx_policejob:updateAvailableUnits', function(_availableUnits)
	availableUnits = _availableUnits
	local job = getJob()

	for _,blip in pairs(jobBlips) do
		RemoveBlip(blip)
	end

	jobBlips = {}

	if job and IsInService then
		if job == 'police' or job == 'state' or job == 'sheriff' or job == 'securoserv' or job == 'usmarshal' or job == 'dod' or job == 'fib' or job == 'doj' then
			updateBlips(availableUnits, job)
		end
	end
end)

function updateBlips(availableUnits, job)
	local myServerId = GetPlayerServerId(PlayerId())

	for playerId,playerInfo in pairs(availableUnits) do
		if playerId ~= myServerId then
			local player = GetPlayerFromServerId(playerId)
			local playerPed = GetPlayerPed(player)
			local blip = AddBlipForEntity(playerPed)
			SetBlipColour(blip, playerInfo.blipColor)
			SetBlipCategory(blip, 7) -- show distance

			-- set proper character name
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(('[%s] %s'):format(playerInfo.jobLabel, playerInfo.name))
			EndTextCommandSetBlipName(blip)

			jobBlips[playerId] = blip
		end
	end
end