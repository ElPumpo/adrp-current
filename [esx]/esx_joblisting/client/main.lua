local menuIsShowed = false
local hasAlreadyEnteredMarker = false
local isInMarker = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowJobListingMenu()
	local hasTaxi
	ESX.TriggerServerCallback('esx_license:checkLicense', function(callback)
		hasTaxi = callback
	end, GetPlayerServerId(PlayerId()), 'taxi')

	while hasTaxi == nil do
		Citizen.Wait(300)
	end

	ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(jobs)
		local elements = {}

		for i=1, #jobs, 1 do
			if jobs[i].job == 'taxi' and hasTaxi then
				table.insert(elements, {
					label = jobs[i].label,
					job   = jobs[i].job
				})
			elseif jobs[i].job ~= 'taxi' then
				table.insert(elements, {
					label = jobs[i].label,
					job   = jobs[i].job
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'joblisting', {
			title    = _U('job_center'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('esx_joblisting:setJob', data.current.job)
			ESX.ShowNotification(_U('new_job'))
			menu.close()
		end, function(data, menu)
			menu.close()
		end)

	end)
end

AddEventHandler('esx_joblisting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

-- Activate menu when player is inside marker, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords, letSleep = GetEntityCoords(PlayerPedId()), true
		isInMarker = false

		for i=1, #Config.Zones, 1 do
			local distance = GetDistanceBetweenCoords(coords, Config.Zones[i], true)

			if distance < Config.DrawDistance then
				letSleep = false
				DrawMarker(Config.MarkerType, Config.Zones[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
			end

			if distance < (Config.ZoneSize.x / 2) then
				isInMarker = true
				ESX.ShowHelpNotification(_U('access_job_center'))
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_joblisting:hasExitedMarker')
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for i=1, #Config.Zones, 1 do
		local blip = AddBlipForCoord(Config.Zones[i])

		SetBlipSprite (blip, 408)
		SetBlipColour (blip, 10)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('job_center'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInMarker then
			if IsControlJustReleased(0, 38) and not menuIsShowed then
				ESX.UI.Menu.CloseAll()
				ShowJobListingMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)