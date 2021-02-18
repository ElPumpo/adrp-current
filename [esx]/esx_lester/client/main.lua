local hasAlreadyEnteredMarker, isInJoblistingMarker, menuIsShowed, lastZone = false, false, false, nil

ESX = nil

local blips = {
	{name='Lester', id=84, x = 1272.3, y = -1714.8, z = 54.2, color = 49, heading=190.7, scale=0.7}
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowLesterMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'joblisting', {
		title    = _U('Lester_Jobs'),
		align    = 'top-left',
		elements = {
			{label = 'Coke Collection $45,000', value = 'coke_collection'},
			{label = 'Meth Collection $30,000', value = 'meth_collection'},
			{label = 'Meth Processing $15,000', value = 'meth_process'},
			--{label = 'Money Laundering $300,000', value = 'money_laundering'},
			{label = 'Guns and Gear $10,000', value = 'black_weapons'}
	}}, function(data, menu)
		if data.current.value == 'coke_collection' then
			TriggerServerEvent('Lester:drugInformation', 'cokeCollect', 300000)
		elseif data.current.value == 'meth_collection' then
			TriggerServerEvent('Lester:drugInformation', 'methCollect', 30000)
		elseif data.current.value == 'meth_process' then
			TriggerServerEvent('Lester:drugInformation', 'methProcess', 15000)
		elseif data.current.value == 'money_laundering' then
			TriggerServerEvent('Lester:drugInformation', 'moneyLaundering', 300000)
		elseif data.current.value == 'black_weapons' then
			TriggerServerEvent('Lester:drugInformation', 'blackweapons', 10000)
		end

		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('DBG_LesterJobs:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, currentZone = GetEntityCoords(PlayerPedId())
		isInJoblistingMarker = false

		for k,v in ipairs(Config.Zones) do
			local distance = #(playerCoords - v)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)

				if distance < 1.5 then
					isInJoblistingMarker = true
					ESX.ShowHelpNotification(_U('access_job_list'))
				end
			end
		end

		if isInJoblistingMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end

		if not isInJoblistingMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('DBG_LesterJobs:hasExitedMarker')
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	RequestModel(GetHashKey('cs_lestercrest'))
	while not HasModelLoaded(GetHashKey('CS_LesterCrest')) do
		Citizen.Wait(100)
	end

	for _,item in ipairs(blips) do
		local lester = CreatePed(4, 0xB594F5C3, item.x, item.y, item.z, item.heading, false, false)
		SetEntityHeading(lester, item.heading)
		SetEntityInvincible(lester, true)
		SetBlockingOfNonTemporaryEvents(lester, true)
		SetPedCanRagdoll(lester, false)
		Citizen.Wait(2000)
		FreezeEntityPosition(lester, true)
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInJoblistingMarker then
			if IsControlJustReleased(0, 38) and not menuIsShowed then
				ShowLesterMenu()
			end
		else
			Citizen.Wait(500)
		end
	end
end)
