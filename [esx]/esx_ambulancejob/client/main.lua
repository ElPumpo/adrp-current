Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local firstSpawn, playerLoaded = true, false

isDead, myName, availableAmbulance = false, '', {}
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	playerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
	myName = ESX.PlayerData.name
end)

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(name)
	myName = name
end)

RegisterNetEvent('esx_ambulancejob:updateAvailableUnits')
AddEventHandler('esx_ambulancejob:updateAvailableUnits', function(_availableAmbulance)
	availableAmbulance = _availableAmbulance

	UpdateOnlineAmbulance()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	playerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	if job ~= 'ambulance' and onDuty then
		onDuty = false
		UpdateOnlineAmbulance()
	end

	ESX.PlayerData.job = job
end)

AddEventHandler('playerSpawned', function()
	isDead = false

	if firstSpawn then
		exports.spawnmanager:setAutoSpawn(false) -- disable respawn
		firstSpawn = false
	else
		TriggerServerEvent('esx_ambulancejob:onPlayerSpawn')
	end
end)

RegisterNetEvent('esx_ambulancejob:combatKillPlayer')
AddEventHandler('esx_ambulancejob:combatKillPlayer', function()
	if Config.AntiCombatLog then
		while not playerLoaded do
			Citizen.Wait(1000)
		end

		ESX.ShowNotification(_U('combatlog_message'))
		RemoveItemsAfterRPDeath()
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Hospitals) do
		local blip = AddBlipForCoord(v.Blip.coords)

		SetBlipSprite(blip, v.Blip.sprite)
		SetBlipScale(blip, v.Blip.scale)
		SetBlipColour(blip, v.Blip.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		if v.Blip.sprite == 436 then
			AddTextComponentSubstringPlayerName('Fire Station')
		else
			AddTextComponentSubstringPlayerName(_U('blip_hospital'))
		end
		EndTextCommandSetBlipName(blip)
	end
end)

-- Disable most inputs when dead
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isDead then
			DisableAllControlActions(0)
			EnableControlAction(0, Keys['G'], true)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, Keys['N'], true)
			EnableControlAction(0, Keys['F3'], true)
			EnableControlAction(0, Keys['ENTER'], true)
			EnableControlAction(0, Keys['TOP'], true)
			EnableControlAction(0, Keys['UP'], true)
			EnableControlAction(0, Keys['DOWN'], true)
		else
			Citizen.Wait(500)
		end
	end
end)

function OnPlayerDeath()
	isDead = true
	ESX.UI.Menu.CloseAll()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)

	StartDeathTimer()
	StartDistressSignal()

	StartScreenEffect('DeathFailOut', 0, false)
	TriggerEvent('ui:toggle', false, true)
	DisplayRadar(false)
end

RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()
	local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
	local playerPed = PlayerPedId()

	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

		Citizen.Wait(500)
		while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
			Citizen.Wait(0)
			DisableAllControlActions(0)
		end

		TriggerEvent('esx_ambulancejob:heal', true)
	end)
end)

function StartDistressSignal()
	Citizen.CreateThread(function()
		local timer = Config.BleedoutTimer

		while timer > 0 and isDead do
			Citizen.Wait(2)
			timer = timer - 30

			DrawGenericTextThisFrame()
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(_U('distress_send'))
			EndTextCommandDisplayText(0.5, 0.83)

			if IsControlPressed(0, Keys['G']) then
				SendDistressSignal()

				Citizen.CreateThread(function()
					Citizen.Wait(1000 * 60 * 5)
					if isDead then
						StartDistressSignal()
					end
				end)

				break
			end
		end
	end)
end

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords, formattedCoords = GetEntityCoords(playerPed)

	formattedCoords = { x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1) }
	TriggerServerEvent('esx_addons_gcphone:startCall', 'ambulance', _U('distress_message'), formattedCoords)


	ESX.ShowNotification(_U('distress_sent'))
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format("%02.f", math.floor(seconds / 3600))
		local mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function GetNearestMedicDistance()
	local playerPed = PlayerPedId()
	local playerCoords, distances = GetEntityCoords(playerPed), {}

	for playerId,unit in pairs(availableAmbulance) do
		local player = GetPlayerFromServerId(playerId)

		if player and GetPlayerName(player) then
			local targetPed = GetPlayerPed(player)

			if DoesEntityExist(targetPed) and targetPed ~= playerPed then
				local targetCoords = GetEntityCoords(targetPed)
				local distance = #(playerCoords - targetCoords)

				table.insert(distances, distance)
			end
		end
	end

	table.sort(distances)

	if distances[1] then
		return ESX.Math.Round(distances[1])
	else
		return nil
	end
end

function StartDeathTimer()
	local canPayFine, nearestMedic = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	Citizen.CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(1000)
			nearestMedic = GetNearestMedicDistance()

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(1000)
			nearestMedic = GetNearestMedicDistance()

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Citizen.Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			if nearestMedic then
				DrawGenericTextThisFrame()
				BeginTextCommandDisplayText('STRING')
				AddTextComponentSubstringPlayerName(('Nearest Medic: %s units away'):format(ESX.Math.GroupDigits(nearestMedic)))
				EndTextCommandDisplayText(0.5, 0.77)
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Citizen.Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer)) .. _U('respawn_bleedout_prompt')

			if IsControlPressed(0, Keys['E']) then
				if timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end

				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			if nearestMedic then
				DrawGenericTextThisFrame()
				BeginTextCommandDisplayText('STRING')
				AddTextComponentSubstringPlayerName(('Nearest Medic: %s units'):format(nearestMedic))
				EndTextCommandDisplayText(0.5, 0.86)
			end
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(10)
		end

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		local dist1 = GetDistanceBetweenCoords(coords, Config.RespawnPoints[1].coords, false)
		local dist2 = GetDistanceBetweenCoords(coords, Config.RespawnPoints[2].coords, false)
		local dist3 = GetDistanceBetweenCoords(coords, Config.RespawnPoints[3].coords, false)
		local location

		if dist1 < dist3 and dist1 < dist2 then
			location = Config.RespawnPoints[1]
		elseif dist2 < dist3 and dist2 < dist1 then
			location = Config.RespawnPoints[2]
		elseif dist3 < dist1 and dist3 < dist2 then
			location = Config.RespawnPoints[3]
		end

		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = location.coords.x,
				y = location.coords.y,
				z = location.coords.z
			}

			ESX.SetPlayerData('lastPosition', formattedCoords)
			ESX.SetPlayerData('loadout', {})

			TriggerEvent('adrp_characterspawn:setPosition', formattedCoords)
			TriggerServerEvent('esx:updateLastPosition', formattedCoords)
			RespawnPed(PlayerPedId(), formattedCoords, location.heading)

			StopScreenEffect('DeathFailOut')
			DoScreenFadeIn(800)
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

AddEventHandler('esx:onPlayerDeath', function(data)
	OnPlayerDeath()
end)

AddEventHandler('esx_ambulancejob:revive', function()
	TriggerServerEvent('esx_ambulancejob:revive')
end)

RegisterNetEvent('esx_ambulancejob:revivePlayer')
AddEventHandler('esx_ambulancejob:revivePlayer', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}

		ESX.SetPlayerData('lastPosition', formattedCoords)

		TriggerServerEvent('esx:updateLastPosition', formattedCoords)

		RespawnPed(playerPed, formattedCoords, 0.0)

		StopScreenEffect('DeathFailOut')
		DoScreenFadeIn(800)

		TriggerEvent('ui:toggle', true)
		DisplayRadar(true)
	end)
end)

-- Load unloaded IPLs
if Config.LoadIpl then
	Citizen.CreateThread(function()
		RequestIpl('Coroner_Int_on') -- Morgue
	end)
end
