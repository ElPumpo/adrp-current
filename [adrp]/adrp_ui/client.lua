ESX = nil
local isTalking, inVehicle, visable, isPaused = false, false, true, false
local voipDistance = 10.0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	UpdateHud(ESX.PlayerData)
end)

function UpdateHud(playerData)
	SendNUIMessage({action = 'setValue', key = 'money', value = '$'..ESX.Math.GroupDigits(playerData.money)})

	for _,account in pairs(playerData.accounts) do
		if account.name == 'bank' then
			SendNUIMessage({action = 'setValue', key = 'bankmoney', value = '$'..ESX.Math.GroupDigits(account.money)})
		elseif account.name == 'black_money' then
			SendNUIMessage({action = 'setValue', key = 'dirtymoney', value = '$'..ESX.Math.GroupDigits(account.money)})
		end
	end

	-- Job
	local job = playerData.job

	if job.label:lower() == job.grade_label:lower() then
		SendNUIMessage({action = 'setValue', key = 'job', value = job.label, icon = job.name})
	else
		SendNUIMessage({action = 'setValue', key = 'job', value = job.label..' - '..job.grade_label, icon = job.name})
	end

	-- Gang
	local gang = playerData.gang
	local showGang = gang.name ~= 'nogang'

	SendNUIMessage({action = 'setValue', key = 'gang', value = gang.label..' - '..gang.grade_label, icon = gang.name})
	SendNUIMessage({action = 'toggleGang', state = showGang})

	-- Money
	SendNUIMessage({action = 'setValue', key = 'money', value = '$' .. ESX.Math.GroupDigits(playerData.money)})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local playerPed = PlayerPedId()

		if isTalking then
			if not NetworkIsPlayerTalking(PlayerId()) then
				isTalking = false
				SendNUIMessage({action = 'setTalking', value = false})
			end
		else
			if NetworkIsPlayerTalking(PlayerId()) then
				isTalking = true
				SendNUIMessage({action = 'setTalking', value = true})
			end
		end

		if inVehicle then
			if IsPedInAnyVehicle(playerPed) and GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed), -1) == playerPed then
				local essence = exports.esx_advancedfuel:getFuel()
				local percent = (essence / 0.142) * 100
				SendNUIMessage({action = 'updateCarStatus', status = {{name = 'gas', percent = percent}}})
			else
				inVehicle = false
				SendNUIMessage({action = 'toggleCar', show = false})
			end
		else
			if IsPedInAnyVehicle(playerPed) and GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed), -1) == playerPed then
				inVehicle = true
				SendNUIMessage({action = 'toggleCar', show = true})
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not isPaused then
			isPaused = true
			TriggerEvent('adrp_ui:toggleUI', false, true)
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false
			TriggerEvent('adrp_ui:toggleUI', visable)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustPressed(0, 243) then
			local voip

			if voipDistance <= 2.0 then
				voipDistance = 10.0
				voip = 'normal'
			elseif voipDistance == 10.0 then
				voipDistance = 26.0
				voip = 'shout'
			elseif voipDistance >= 26.0 then
				voipDistance = 2.0
				voip = 'whisper'
			end

			NetworkSetTalkerProximity(voipDistance)
			SendNUIMessage({action = 'setProximity', value = voip})
		end

		if IsControlPressed(0, 243) then
			local markerCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
			DrawMarker(1, markerCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, voipDistance * 2, voipDistance * 2, 0.8, 0, 75, 255, 165, false, false, 2, false, nil, nil, false)
		end
	end
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(state, override)
	SendNUIMessage({action = 'toggleUI', show = state})

	if not override then
		visable = state
	end
end)

RegisterNetEvent('adrp_ui:toggleUI')
AddEventHandler('adrp_ui:toggleUI', function(state, override)
	SendNUIMessage({action = 'toggleUI', show = state})

	if not override then
		visable = state
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'bank' then
		SendNUIMessage({action = 'setValue', key = 'bankmoney', value = '$'..ESX.Math.GroupDigits(account.money)})
	elseif account.name == 'black_money' then
		SendNUIMessage({action = 'setValue', key = 'dirtymoney', value = '$'..ESX.Math.GroupDigits(account.money)})
	end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	SendNUIMessage({action = 'setValue', key = 'money', value = '$'..ESX.Math.GroupDigits(money)})
end)

AddEventHandler('esx_society:toggleSocietyHud', function(state)
	SendNUIMessage({action = 'toggleSociety', state = state})
end)

AddEventHandler('esx_society:setSocietyMoney', function(money)
	SendNUIMessage({action = 'setValue', key = 'society', value = '$'..ESX.Math.GroupDigits(money)})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	if job.label:lower() == job.grade_label:lower() then
		SendNUIMessage({action = 'setValue', key = 'job', value = job.label, icon = job.name})
	else
		SendNUIMessage({action = 'setValue', key = 'job', value = job.label..' - '..job.grade_label, icon = job.name})
	end
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	ESX.PlayerData.gang = gang
	local showGang = gang.name ~= 'nogang'

	SendNUIMessage({action = 'setValue', key = 'gang', value = gang.label..' - '..gang.grade_label, icon = gang.name})
	SendNUIMessage({action = 'toggleGang', state = showGang})
end)

RegisterNetEvent('adrp_ui:updateStatus')
AddEventHandler('adrp_ui:updateStatus', function(status)
	SendNUIMessage({action = 'updateStatus', status = status})
end)

AddEventHandler('esx_status:onTick', function(status)
	SendNUIMessage({action = 'updateStatus', status = status})
end)

AddEventHandler('esx_jail:updateRemainingTime', function(formattedTime)
	SendNUIMessage({action = 'setValue', key = 'jail', value = formattedTime})
end)

RegisterNetEvent('adrp_ui:updateWeight')
AddEventHandler('adrp_ui:updateWeight', function(weightProcent)
	SendNUIMessage({action = 'updateWeight', weight = weightProcent})
end)