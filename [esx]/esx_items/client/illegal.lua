local isZipped, isDisabled, scissorsModel = false, false, 'prop_cs_scissors'
local validZones = {AIRP = 'high', ALAMO = 'Alamo Sea', BANHAMC = 'Banham Canyon Dr', BANNING = 'Banning', BAYTRE = 'Baytree Canyon',  BEACH = 'Vespucci Beach', BHAMCA = 'Banham Canyon', BRADP = 'Braddock Pass', BRADT = 'Braddock Tunnel', BURTON = 'Burton', CALAFB = 'Calafia Bridge', CANNY = 'Raton Canyon', CCREAK = 'Cassidy Creek', CMSW = 'Chiliad Mountain State Wilderness', ELGORL = 'El Gordo Lighthouse', ELYSIAN = 'Elysian Island', GALFISH = 'Galilee', GALLI = 'Galileo Park', GRAPES = 'Grapeseed', GREATC = 'Great Chaparral', HARMO = 'Harmony', HAWICK = 'Hawick', LACT = 'Land Act Reservoir', LAGO = 'Lago Zancudo', LDAM = 'Land Act Dam', MTCHIL = 'Mount Chiliad', MTGORDO = 'Mount Gordo', MTJOSE = 'Mount Josiah', OCEANA = 'Pacific Ocean', PALCOV = 'Paleto Cove', PALETO = 'Paleto Bay', PALFOR = 'Paleto Forest', PALHIGH = 'Palomino Highlands', PALMPOW = 'Palmer-Taylor Power Station', PBLUFF = 'Pacific Bluffs', PROCOB = 'Procopio Beach', SANCHIA = 'San Chianski Mountain Range', SANDY = 'low', TATAMO = 'Tataviam Mountains', TONGVAH = 'Tongva Hills', TONGVAV = 'Tongva Valley', VCANA = 'Vespucci Canals', WINDF = 'Ron Alternates Wind Farm', ZANCUDO = 'Zancudo River'}

RegisterNetEvent('esx_items:onUseCampfire')
AddEventHandler('esx_items:onUseCampfire', function()
	if isValidZone() then
		isDisabled = true
		TriggerServerEvent('esx_items:onUseCampfire')
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict('anim@heists@money_grab@duffel', function()
			TaskPlayAnim(playerPed, 'anim@heists@money_grab@duffel', 'loop', 3.0, 3.0, -1, 0, 0.0, false, false, false)
		end)

		local model   = 'prop_beach_fire'
		local coords  = GetEntityCoords(playerPed)
		local forward = GetEntityForwardVector(playerPed)
		local x, y, z = table.unpack(coords + forward * 1.5)

		ESX.Game.SpawnObject(model, {x = x, y = y, z = z-1.6}, function(obj)
			SetEntityHeading(obj, GetEntityHeading(playerPed))
			local objCoords = GetEntityCoords(obj)
			isDisabled = false

			TriggerServerEvent('esx_items:relayCampfireLocation', {
				x = ESX.Math.Round(objCoords.x, 1),
				y = ESX.Math.Round(objCoords.y, 1),
				z = ESX.Math.Round(objCoords.z, 1)
			})

		end)
	else
		TriggerEvent('customNotification', 'You are not allowed to start a fire here!')
	end
end)

RegisterNetEvent('esx_items:onUseScissors')
AddEventHandler('esx_items:onUseScissors', function()
	local player, distance = ESX.Game.GetClosestPlayer()

	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('esx_items:onUseScissors', GetPlayerServerId(player))
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestModel(scissorsModel)
		ESX.Streaming.RequestAnimDict('mp_missheist_ornatebank')

		FreezeEntityPosition(player, true)
		FreezeEntityPosition(playerPed, true)
		ClearPedTasksImmediately(playerPed)

		local offsetCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, -5.0)

		ESX.Game.SpawnObject(scissorsModel, offsetCoords, function(object)
			AttachEntityToEntity(object, playerPed, GetPedBoneIndex(playerPed, 28422), 0.08, 0.03, 0.0, 240.0, 0.0, 0.0, true, true, false, true, 0, true)

			for i=1, 3 do
				TaskPlayAnim(playerPed, 'mp_missheist_ornatebank', 'stand_cash_in_bag_loop', 3.0, 3.0, -1, 0, 0.0, false, false, false)
				Citizen.Wait(1500)
			end

			ESX.Game.DeleteObject(scissorsspawned)

			FreezeEntityPosition(player, false)
			FreezeEntityPosition(playerPed, false)
		end)
	else
		TriggerEvent('customNotification', 'There is no one nearby you!')
	end
end)

RegisterNetEvent('esx_items:onUseZipties')
AddEventHandler('esx_items:onUseZipties', function()
	local player, distance = ESX.Game.GetClosestPlayer()

	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('esx_items:onUseZipties', GetPlayerServerId(player))
	else
		TriggerEvent('customNotification', 'There is no one nearby you!')
	end
end)

RegisterNetEvent('esx_items:onUseZiptiePlayer')
AddEventHandler('esx_items:onUseZiptiePlayer', function()
	local playerPed = PlayerPedId()
	isZipped = true

	ESX.Streaming.RequestAnimDict('mp_arresting')
	TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
	SetEnableHandcuffs(playerPed, true)
	DisablePlayerFiring(playerPed, true)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	SetPedCanPlayGestureAnims(playerPed, false)
	DisplayRadar(false)
end)

RegisterNetEvent('esx_items:onUseScissorsPlayer')
AddEventHandler('esx_items:onUseScissorsPlayer', function()
	local playerPed = PlayerPedId()
	isZipped = false

	ClearPedTasksImmediately(playerPed)
	SetEnableHandcuffs(playerPed, false)
	DisablePlayerFiring(playerPed, false)
	SetPedCanPlayGestureAnims(playerPed, true)
	DisplayRadar(true)
	TriggerEvent('customNotification', 'You have been freed!')
end)

RegisterNetEvent('esx_items:onUseSack')
AddEventHandler('esx_items:onUseSack', function(item)
	local player, distance = ESX.Game.GetClosestPlayer()

	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('esx_items:onUseSack', GetPlayerServerId(player))
	else
		TriggerEvent('customNotification', 'There is no one nearby you!')
	end
end)

RegisterNetEvent('esx_items:onUseSackPlayer')
AddEventHandler('esx_items:onUseSackPlayer', function()
	TriggerEvent('ui:toggle', false, true)

	local clothesSkin = {
		mask_1 = 49,
		mask_2 = 18,
		glasses_1 = 24,
		glasses_2 = 2
	}

	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)

	local startTime = GetGameTimer()
	local endTime = 300000
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('POPUP_WARNING')

	while startTime + endTime >= GetGameTimer() do
		Citizen.Wait(0)

		local value = math.floor(((startTime + endTime) - GetGameTimer())*0.001)
		local minutes = math.floor(value/60)
		local time = '~r~'..minutes..' minutes and '..math.floor(value - (minutes*60))..' seconds'

		BeginScaleformMovieMethod(scaleform, 'SHOW_POPUP_WARNING')
		ScaleformMovieMethodAddParamFloat(500.0) -- black background
		PushScaleformMovieMethodParameterString('~r~WTF!!')
		PushScaleformMovieMethodParameterString('Someone has thrown a bag over your head!\n')
		PushScaleformMovieMethodParameterString('You must wait: '..time)
		ScaleformMovieMethodAddParamBool(true)
		EndScaleformMovieMethod()

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		SetScriptGfxDrawBehindPausemenu(true)
	end

	TriggerEvent('ui:toggle', true)
	SetScaleformMovieAsNoLongerNeeded(scaleform)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
end)

function isValidZone()
	local zone = GetNameOfZone(GetEntityCoords(PlayerPedId()))
	if validZones[tostring(zone)] then
		return true
	end

	return false
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isDisabled then
			DisableAllControlActions(0)
		elseif isZipped then
			local playerPed = PlayerPedId()
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

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

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

			if not (IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) == 1) then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)