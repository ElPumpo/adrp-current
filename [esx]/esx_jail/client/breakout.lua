local CurrentAction, CurrentActionMsg

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())

		local distance = GetDistanceBetweenCoords(coords, Config.Locations.PrisonBreak, true)

		if distance < 100 then
			DrawMarker(1, Config.Locations.PrisonBreak, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 100, 200, 50, 100, false, true, 2, false, false, false, false)

			if distance < 1.5 then
				CurrentAction = 'prison_break'
				CurrentActionMsg = _U('jailbreak_prompt')
			else
				CurrentAction = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'prison_break' then
					StartPrisonBreak()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function StartPrisonBreak()
	ESX.TriggerServerCallback('esx_jail:attemptJailBreak', function(success, errorMessage)
		if success then
			StartPrisonBreakTimers()
		else
			ESX.ShowNotification(errorMessage)
		end
	end)
end

function StartPrisonBreakTimers()
	local timeCurrent = 0
	local timeBegin = ESX.Math.Round(Config.PrisonBreakTime / 1000)

	Citizen.CreateThread(function()
		while timeCurrent < timeBegin and not isDead do
			Citizen.Wait(1000)
			timeCurrent = timeCurrent + 1

			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = GetDistanceBetweenCoords(playerCoords, Config.Locations.PrisonBreak, true)

			if distance > 14 then
				timeCurrent = timeBegin
				TriggerServerEvent('esx_jail:cancelPrisonBreak')
			end
		end
	end)

	Citizen.CreateThread(function()
		while timeCurrent < timeBegin and not isDead do
			Citizen.Wait(0)
			drawProgressBar(timeCurrent / timeBegin, nil, nil, 200, 100, 200, 'JAIL BREAK')
			DrawMarker(1, Config.Locations.PrisonBreak, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 27.0, 27.0, 1.0, 220, 50, 50, 200, false, false, 2, false, nil, nil, false)
		end
	end)
end

RegisterNetEvent('esx_jail:prisonBreakStarted')
AddEventHandler('esx_jail:prisonBreakStarted', function()
	PrepareAlarm('PRISON_ALARMS')

	Citizen.Wait(700)
	StartAlarm('PRISON_ALARMS', 0)

	ESX.ShowAdvancedNotification(_U('noti_title_started'), '', _U('noti_msg_started'), 'CHAR_CALL911', 1)
end)

RegisterNetEvent('esx_jail:cancelPrisonBreak')
AddEventHandler('esx_jail:cancelPrisonBreak', function(msg)
	StopAlarm('PRISON_ALARMS', true)

	if msg then
		ESX.ShowAdvancedNotification(_U('noti_title_canceled'), '', _U('noti_msg_canceled'), 'CHAR_CALL911', 1)
	end
end)

function drawProgressBar(completion, xOffset, yOffset, r, g, b, text)
	if xOffset == nil then
		xOffset = 0.4
	end

	if yOffset == nil then
		yOffset = -0.5
	end

	local percentage = ESX.Math.Round(100 * completion)
	local width = (0.14/100.0) * percentage

	local progressBar = {
		x = 0.016 + xOffset,
		y = 0.8 + yOffset,
		width = 10,
		height = 0.05
	}

	DrawRect(progressBar.x + 0.07, progressBar.y, 0.143, progressBar.height + .004, 0, 0, 0, 60)
	DrawRect(progressBar.x + (width/2), progressBar.y, width, progressBar.height, r, g, b, 200)
	drawTxt(progressBar.x + (width/2) + 0.06, progressBar.y - 0.01, width, progressBar.height, 0.10, percentage..' % - ' .. text)
end

function drawTxt(x, y, width, height, scale, text)
	SetTextFont(1)
	SetTextScale(0.5, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end