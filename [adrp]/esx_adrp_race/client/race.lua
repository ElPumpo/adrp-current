local currentRace, raceNumber, signedUpForRace, raceTimer, currentCheckPoint, currentBlip, raceVehicle, scaleform, currentPosition, playersInRace
local countPlayersJoined, racerBlips, isParticipatingInRace, isSpectatingRace = 0, {}, false, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if currentRace then
			local playerPed = PlayerPedId()
			local distance = GetDistanceBetweenCoords(GetEntityCoords(playerPed), currentRace.coords, false)

			if distance < 100 then

				if not signedUpForRace then
					ESX.Game.Utils.DrawText3D(currentRace.coords, _U('race_prompt', raceNumber, ESX.Math.GroupDigits(currentRace.rewards.max), ESX.Math.GroupDigits(currentRace.rewards.min)), 1.0)

					if IsControlJustReleased(0, Keys['E']) then
						if not IsPedOnFoot(playerPed) then
							ESX.ShowNotification(_U('race_onfoot'))
						elseif distance > 4 then
							ESX.ShowNotification(_U('race_toofar'))
						else
							ESX.TriggerServerCallback('esx_adrp_race:playerJoined', function(joined)
								if joined then
									signedUpForRace = true
								else
									ESX.ShowNotification(_U('race_player_max'))
								end
							end)
						end
					end
				end

				if signedUpForRace then
					local min, sec = SecondsToClock(raceTimer)

					ESX.Game.Utils.DrawText3D(currentRace.coords, _U('race_prompt_joined', raceNumber, min, sec, countPlayersJoined), 1.0)
				end
			elseif signedUpForRace and distance > 100 then
				ESX.ShowNotification(_U('race_abandoned'))
				DisponeRace(true)
			else
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(500)
		end

		if raceVehicle and DoesEntityExist(raceVehicle) then
			SetVehicleEngineHealth(raceVehicle, 1000)
			SetVehicleBodyHealth(raceVehicle, 1000.0)
			SetVehicleFixed(raceVehicle)
			for i=0, 5 do
				Citizen.Wait(0)
				SetVehicleTyreFixed(raceVehicle, i)
			end
		end
	end
end)

RegisterNetEvent('esx_adrp_race:notifyRace')
AddEventHandler('esx_adrp_race:notifyRace', function(raceNum)
	currentRace, raceNumber, countPlayersJoined, currentCheckPoint, currentPosition = Config.Races[raceNum], raceNum, 0, 1, 'Unknown'

	local minReward = currentRace.rewards.min
	local min, sec = SecondsToClock(currentRace.timerTilStart / 1000)

	ESX.ShowAdvancedNotification(_U('race_noti_title'), _U('race_noti_subject'), _U('race_noti_msg', raceNum, min, sec, ESX.Math.GroupDigits(minReward)), 'CHAR_CARSITE', 8)
	StartRaceTimer(currentRace.timerTilStart / 1000)
end)

RegisterNetEvent('esx_adrp_race:addPlayerBlips')
AddEventHandler('esx_adrp_race:addPlayerBlips', function(_playersInRace)
	-- don't create a blip for yourself
	local myID = GetPlayerServerId(PlayerId())
	playersInRace = _playersInRace
	playersInRace[myID] = nil

	for k,v in pairs(playersInRace) do
		local clientID = GetPlayerFromServerId(k)
		local ped = GetPlayerPed(clientID)
		local blip = AddBlipForEntity(ped)

		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true)
		SetBlipScale(blip, 0.85)
		SetBlipAsShortRange(blip, true)
		SetBlipCategory(blip, 7)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.name)
		EndTextCommandSetBlipName(blip)

		table.insert(racerBlips, blip)
	end
end)

RegisterNetEvent('esx_adrp_race:prepareRace')
AddEventHandler('esx_adrp_race:prepareRace', function(pointNum)
	signedUpForRace, isParticipatingInRace = false, true

	ESX.Game.SpawnVehicle(currentRace.vehicle, currentRace.StartPositions[pointNum].coords, currentRace.StartPositions[pointNum].heading, function(vehicle)
		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
		FreezeEntityPosition(vehicle, true)
		raceVehicle = vehicle
	end)

	scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('COUNTDOWN')

	local selectedRadio = Config.RadioStations[math.random(1, #Config.RadioStations)].radio
	SetVehicleRadioEnabled(raceVehicle, true)
	SetVehRadioStation(raceVehicle, selectedRadio)

	TriggerServerEvent('esx_adrp_race:onPlayerReady')
end)

RegisterNetEvent('esx_adrp_race:drawCountdown')
AddEventHandler('esx_adrp_race:drawCountdown', function(number)
	if isParticipatingInRace and not isSpectatingRace then -- todo test
		DrawCountDownScaleform(scaleform, number, 0.6, 240, 240, 20)
	end
end)

RegisterNetEvent('esx_adrp_race:startRace')
AddEventHandler('esx_adrp_race:startRace', function()
	FreezeEntityPosition(raceVehicle, false)

	Citizen.CreateThread(function()
		StartBarTimers()
	end)

	DrawNextCheckPoint()

	TriggerServerEvent('esx_adrp_race:onPlayerFinished')
end)

function StartBarTimers()
	local startTime, currentTime, currentMin, currentSec = GetGameTimer()

	while currentRace and not isSpectatingRace do
		Citizen.Wait(0)
		currentTime = (GetGameTimer() - startTime) / 1000

		currentMin, currentSec = SecondsToClock(currentTime)

		DrawTimerBar(_U('ui_elapsed'), ('%s:%s'):format(currentMin, currentSec), 1)
		DrawTimerBar(_U('ui_position'), ('%s / %s'):format(currentPosition, countPlayersJoined), 2)
	end
end

RegisterCommand('test', function()
	--DrawNextCheckPoint()
end, false)

function DrawNextCheckPoint()
	--currentRace = Config.Races[2]
	cp = currentRace.CheckPoints[currentCheckPoint]

	SetCheckPointBlip(cp)

	while currentCheckPoint < #currentRace.CheckPoints + 1 do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local distance = #(playerCoords - cp.coords)

		DrawMarker(cp.type, cp.coords, 0.0, 0.0, 0.0, 0.0, 0.0, cp.rotationZ, cp.scale.x, cp.scale.y, cp.scale.z, cp.color.r, cp.color.g, cp.color.b, cp.color.a, false, false, 2, false, nil, nil, false)

		if distance < cp.scale.x / 2 then
			PlaySoundFrontend(-1, 'CHECKPOINT_NORMAL', 'HUD_MINI_GAME_SOUNDSET', false)
			currentCheckPoint = currentCheckPoint + 1

			cp = currentRace.CheckPoints[currentCheckPoint]
			SetCheckPointBlip(cp)

			TriggerServerEvent('esx_adrp_race:onPlayerReachedCheckpoint', currentCheckPoint)
		end
	end
end

-- todo no usage
RegisterNetEvent('esx_adrp_race:onPlayerReachedCheckpoint')
AddEventHandler('esx_adrp_race:onPlayerReachedCheckpoint', function(playerId, cp)
	playersInRace[playerId].cp = cp
end)

-- todo no usage
RegisterNetEvent('esx_adrp_race:startSpectate')
AddEventHandler('esx_adrp_race:startSpectate', function()
	local playerPed = PlayerPedId()
	isSpectatingRace = true
	SetEntityCollision(playerPed, false, false)
	SetEntityVisible(playerPed, false, false)


	ESX.Game.Teleport(playerPed, currentRace.coords, function()
		DoScreenFadeIn(3000)
	end)



	-- todo setup scaleform
end)

RegisterNetEvent('esx_adrp_race:updatePlayerPosition')
AddEventHandler('esx_adrp_race:updatePlayerPosition', function(position)
	currentPosition = position
end)

function SetCheckPointBlip(checkpoint)
	if DoesBlipExist(currentBlip) then
		RemoveBlip(currentBlip)
	end

	if not checkpoint then
		return
	end

	local blip = AddBlipForCoord(checkpoint.coords)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(_U('blip_destination'))
	EndTextCommandSetBlipName(blip)

	SetBlipRoute(blip, true)

	currentBlip = blip
end

RegisterNetEvent('esx_adrp_race:playerJoined')
AddEventHandler('esx_adrp_race:playerJoined', function()
	countPlayersJoined = countPlayersJoined + 1
end)

RegisterNetEvent('esx_adrp_race:playerLeft')
AddEventHandler('esx_adrp_race:playerLeft', function()
	countPlayersJoined = countPlayersJoined - 1
end)

RegisterNetEvent('esx_adrp_race:onPlayerFinished')
AddEventHandler('esx_adrp_race:onPlayerFinished', function(playerId, playerName, playerPosition, playerTime)
	local min, sec = SecondsToClock(playerTime)
	ESX.ShowNotification(_U('race_player_finished', playerName, playerPosition, min, sec))

	-- todo what now
	if playerId == GetPlayerServerId(PlayerId()) then
		DoScreenFadeOut(800)

		Citizen.Wait(3000)
		ESX.Game.DeleteVehicle(raceVehicle)
		TriggerEvent('esx_adrp_race:startSpectate')
	end
end)

RegisterNetEvent('esx_adrp_race:concludeRace')
AddEventHandler('esx_adrp_race:concludeRace', function()
	if DoesEntityExist(raceVehicle) then
		ESX.Game.DeleteVehicle(raceVehicle)
	end

	for i=1, #racerBlips, 1 do
		if DoesBlipExist(racerBlips[i]) then
			RemoveBlip(racerBlips[i])
		end
	end

	DisponeRace(false)
end)

RegisterNetEvent('esx_adrp_race:hurryUp')
AddEventHandler('esx_adrp_race:hurryUp', function()
	if isParticipatingInRace then
		for i=currentRace.timerTilDnf, 0, -1 do
			if not isSpectatingRace then -- has finished?
				DrawCountDownScaleform(scaleform, i, 1, 255, 255 / i, 255)
			end
		end

		TriggerServerEvent('esx_adrp_race:onPlayerFinished', true) -- todo test dnf and value it
	end
end)

function DisponeRace(notify)
	SetScaleformMovieAsNoLongerNeeded(scaleform)

	currentRace, raceNumber, signedUpForRace, countPlayersJoined, raceTimer, currentCheckPoint, currentBlip, raceVehicle, racerBlips, scaleform, currentPosition, isParticipatingInRace = nil, nil, false, 0, 0, nil, nil, nil, {}, nil, nil, false

	-- only notify when leaving race whilst it's still setting up.
	if notify then
		TriggerServerEvent('esx_adrp_race:playerLeft')
	end
end

function StartRaceTimer(timer)
	raceTimer = timer

	Citizen.CreateThread(function()
		while raceTimer > 0 do
			Citizen.Wait(1000)

			if raceTimer > 0 then
				raceTimer = raceTimer - 1
			end
		end
	end)
end