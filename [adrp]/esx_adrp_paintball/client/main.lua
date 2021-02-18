ESX = nil
local currentAction, currentActionMsg, hasUniform, lastZone, hasAlreadyEnteredMarker
local weaponHash, currentActionData, team, gameNotStarted, isInArea = GetHashKey('WEAPON_PISTOL50'), {}, 0, true, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local blipMarker = Config.Blips.Blip
	local blip = AddBlipForCoord(blipMarker.Pos)

	SetBlipSprite(blip, blipMarker.Sprite)
	SetBlipScale(blip, blipMarker.Scale)
	SetBlipColour(blip, blipMarker.Color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_name'))
	EndTextCommandSetBlipName(blip)
end)

function DrawSub(text, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(time, true)
end

function OpenGameMenu()
	local elements = {{label = _U('game_exit'), value = 'exit_game'}}

	if hasUniform then
		if gameNotStarted then
			table.insert(elements, {label = _U('game_startgame'), value = 'start_game'})
		end

		table.insert(elements, {label = _U('game_restartgame'), value = 'reset_game'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu_game', {
		title    = _U('game_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local action = data.current.value
		menu.close()

		if action == 'start_game' then
			TriggerServerEvent('esx_adrp_paintball:startGameServer')
		elseif action == 'reset_game' then
			TriggerServerEvent('esx_adrp_paintball:resetEntireGame')
		elseif action == 'exit_game' then
			TriggerServerEvent('esx_adrp_paintball:hasNoUniform')
			LeaveTheArea()
		end
	end, function(data, menu)
		menu.close()

		currentAction		= 'menu_game'
		currentActionMsg	= _U('game_prompt')
		currentActionData	= {}
	end)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)

		if skin.sex == 0 then
			if Config.Uniforms[job].male then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
			else
				ESX.ShowNotification(_U('outfit_missing'))
			end
		else
			if Config.Uniforms[job].female then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
			else
				ESX.ShowNotification(_U('outfit_missing'))
			end
		end
	end)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function OpenTeamMenu(zone)
	local playerPed = PlayerPedId()
	local elements = {{label = _U('outfit_civil'), value = 'citizen_wear'}}
	local title = 'unknown team'

	if zone == 'BlueCloakroom' then
		table.insert(elements, {label = _U('outfit_blue'), value = 'blue_team'})
		title = _U('outfit_blue_title')
	elseif zone == 'RedCloakroom' then
		table.insert(elements, {label = _U('outfit_red'), value = 'red_team'})
		title = _U('outfit_red_title')
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = title,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)
		local action = data.current.value
		menu.close()

		if action == 'citizen_wear' then
			LeaveTheArea()
			TriggerServerEvent('esx_adrp_paintball:hasNoUniform')
		elseif action == 'blue_team' then
			setUniform(action, playerPed)
			GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
			SetCurrentPedWeapon(playerPed, weaponHash, true)
			SetPedCanSwitchWeapon(playerPed, false)
			ESX.ShowNotification(_U('outfit_gotweapon'))
			team = 2
			hasUniform = true
			TriggerServerEvent('esx_adrp_paintball:hasUniform', team)
			AutoRevive()
		elseif action == 'red_team' then
			setUniform(action, playerPed)
			GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
			SetCurrentPedWeapon(playerPed, weaponHash, true)
			SetPedCanSwitchWeapon(playerPed, false)
			ESX.ShowNotification(_U('outfit_gotweapon'))
			team = 3
			hasUniform = true
			TriggerServerEvent('esx_adrp_paintball:hasUniform', team)
			AutoRevive()
		end
	end, function(data, menu)
		menu.close()

		if zone == 'BlueCloakroom' then
			currentAction = 'menu_blue_cloakroom'
			currentActionMsg = _U('outfit_blue_prompt')
		elseif zone == 'RedCloakroom' then
			currentAction = 'menu_red_cloakroom'
			currentActionMsg = _U('outfit_red_prompt')
		end

		currentActionData = {zone = zone}
	end)
end

function GoToArea()
	DoScreenFadeOut(1000)
	Citizen.Wait(2000)

	ESX.Game.Teleport(PlayerPedId(), Config.Zones.Game.Pos)

	Citizen.Wait(1000)
	DoScreenFadeIn(1000)

	isInArea, gameNotStarted = true, true

	areaLoop()
	baseLoop()
	waitUntilGameStart()

	ESX.Scaleform.ShowFreemodeMessage(_U('match_greet'), '', 2)
end

function LeaveTheArea()
	DoScreenFadeOut(1000)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if team == 2 or team == 3 then
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
			team = 1
		end)
	end

	gameNotStarted, hasUniform, isInArea = false, false, false

	Citizen.Wait(2000)

	ESX.Game.Teleport(playerPed, Config.Zones.Enter.Pos)

	RemoveWeaponFromPed(playerPed, weaponHash)
	SetPedCanSwitchWeapon(playerPed, true)
	SetEntityHealth(playerPed, maxHealth)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
end

function AutoRevive()
	Citizen.CreateThread(function()
		while hasUniform do
			Citizen.Wait(0)
			local playerPed = PlayerPedId()
			local health = GetEntityHealth(playerPed)

			if team == 3 then
				DisableControlAction(0, 0, true)
				SetFollowPedCamViewMode(4)

				if health == 0 then
					TriggerEvent('esx_ambulancejob:revivePlayer')
					Citizen.Wait(1500)
					local playerPed = PlayerPedId()

					ESX.Game.Teleport(playerPed, Config.Zones.SpawnRedTeam.Pos)

					GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
					SetCurrentPedWeapon(playerPed, weaponHash, true)
					SetPedCanSwitchWeapon(playerPed, false)
					scorePoint(team)
				end
			elseif team == 2 then
				DisableControlAction(0, 0, true)
				SetFollowPedCamViewMode(4)

				if health == 0 then
					TriggerEvent('esx_ambulancejob:revivePlayer')
					Citizen.Wait(1500)
					local playerPed = PlayerPedId()

					ESX.Game.Teleport(playerPed, Config.Zones.SpawnBlueTeam.Pos)

					GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
					SetCurrentPedWeapon(playerPed, weaponHash, true)
					SetPedCanSwitchWeapon(playerPed, false)
					scorePoint(team)
				end
			end
		end
	end)
end

function scorePoint(team)
	Citizen.Wait(1000)
	TriggerServerEvent('esx_adrp_paintball:scorePoint', team)
end

RegisterNetEvent('esx_adrp_paintball:startGameClient')
AddEventHandler('esx_adrp_paintball:startGameClient', function()
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local distance = #(playerCoords - Config.Zones.Middle.Pos)

	if distance < 100 then
		for i=10, 1, -1 do
			if i == 3 then
				TriggerEvent('InteractSound_CL:PlayOnOne', 'countdown', 1.0)
			end
		
			ESX.ShowNotification(_U('match_countdown', i))
			Citizen.Wait(1000)
		end
		
		gameNotStarted = false
		ESX.ShowNotification(_U('match_imminent'))
		
		if not hasUniform then
			LeaveTheArea()
			Citizen.Wait(500)
			ESX.ShowNotification(_U('match_noteam'))
		end
	end
end)

function areaLoop()
	Citizen.CreateThread(function()
		while isInArea do
			Citizen.Wait(1000)

			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local distance = #(playerCoords - Config.Zones.Middle.Pos)

			if distance > 100 then
				LeaveTheArea()
			 	TriggerServerEvent('esx_adrp_paintball:hasNoUniform')
			 	ESX.ShowNotification(_U('match_abandoned'))
			end
		end
	end)
end

function baseLoop()
	Citizen.CreateThread(function()
		while isInArea do
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)

			if team == 2 then
				local redDistance = #(playerCoords - Config.Zones.SpawnRedTeam.Pos)
				if redDistance < 28 then
					ESX.Game.Teleport(playerPed, Config.Zones.SpawnBlueTeam.Pos)
				 	GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
				 	SetCurrentPedWeapon(playerPed, weaponHash, true)
					ESX.ShowNotification(_U('match_spawncamping'))
				end
			elseif team == 3 then
				local blueDistance = #(playerCoords - Config.Zones.SpawnBlueTeam.Pos)

				if blueDistance < 28 then
					ESX.Game.Teleport(playerPed, Config.Zones.SpawnRedTeam.Pos)

				 	GiveWeaponToPed(playerPed, weaponHash, 250, false, false)
				 	SetCurrentPedWeapon(playerPed, weaponHash, true)
					ESX.ShowNotification(_U('match_spawncamping'))
				end
			end
			Citizen.Wait(1000)
		end
	end)
end

function waitUntilGameStart()
	Citizen.CreateThread(function()
		while gameNotStarted do
			local playerPed = PlayerPedId()
			DisablePlayerFiring(playerPed, true)
			
			Citizen.Wait(1)
		end
	end)
end

RegisterNetEvent('esx_adrp_paintball:resetGame')
AddEventHandler('esx_adrp_paintball:resetGame', function(notify)
	LeaveTheArea()
end)

RegisterNetEvent('esx_adrp_paintball:showNotify')
AddEventHandler('esx_adrp_paintball:showNotify', function(notify)
	local playerPed = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local distance = #(playerCoords - Config.Zones.Middle.Pos)

	if distance < 100 then
		PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', 1)
		ESX.ShowNotification(notify)
	end
end)

AddEventHandler('esx_adrp_paintball:hasEnteredMarker', function(zone)
	if zone == 'Game' then
		currentAction		= 'menu_game'
		currentActionMsg	= _U('game_prompt')
		currentActionData	= {}
	elseif zone == 'Enter' then
		currentAction		= 'menu_enter'
		currentActionMsg	= _U('match_prompt')
		currentActionData	= {}
	elseif zone == 'BlueCloakroom' and isInArea then
		currentAction		= 'menu_blue_cloakroom'
		currentActionMsg	= _U('outfit_blue_prompt')
		currentActionData	= {zone = zone}
	elseif zone == 'RedCloakroom' and isInArea then
		currentAction		= 'menu_red_cloakroom'
		currentActionMsg	= _U('outfit_red_prompt')
		currentActionData	= {zone = zone}
	end
end)

AddEventHandler('esx_adrp_paintball:hasExitedMarker', function(zone)
	currentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Draw marker, enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, letSleep, isInMarker, currentZone = GetEntityCoords(PlayerPedId()), true, false, nil

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)

			if distance < 100.0 then
				letSleep = false

				if v.Type ~= -1 then
					DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, false, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('esx_adrp_paintball:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_adrp_paintball:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentAction then
			ESX.ShowHelpNotification(currentActionMsg)

			if IsControlJustReleased(0, 38) and IsInputDisabled(0) then
				if currentAction == 'menu_game' then
					OpenGameMenu()
				elseif currentAction == 'menu_enter' and IsPedOnFoot(PlayerPedId()) then
					ESX.TriggerServerCallback('esx_adrp_paintball:canEnterArea', function(canEnter)
						if canEnter then
							GoToArea()
						else
							ESX.ShowNotification(_U('match_ongoing'))
						end
					end)
				elseif currentAction == 'menu_blue_cloakroom' then
					OpenTeamMenu(currentActionData.zone)
				elseif currentAction == 'menu_red_cloakroom' then
					OpenTeamMenu(currentActionData.zone)
				end

				currentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)
