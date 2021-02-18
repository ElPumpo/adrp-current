ESX = nil
local menuIsOpen, fullName = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
	fullName = ESX.PlayerData.name
end)

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(newName)
	fullName = newName
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	closeGui()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if menuIsOpen then
			if IsControlJustPressed(0, 177) and menuIsOpen then
				closeGui()
			end
		end
	end
end)

RegisterNetEvent('esx_badge:showBadge')
AddEventHandler('esx_badge:showBadge', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local data = {
		fullname = fullName,
		job = ESX.PlayerData.job.label,
		badgeid = GetResourceKvpString('polbadge')
	}
	if closestPlayer == -1 or closestDistance > 3.0 then
		ESX.ShowNotification('There are no players near you.')
	else
		ESX.ShowNotification('Showing ID to: ' .. GetPlayerName(closestPlayer))
		TriggerServerEvent('esx_badge:openBadgeServer', GetPlayerServerId(closestPlayer), data)
	end
end)

RegisterNetEvent('esx_badge:openBadge')
AddEventHandler('esx_badge:openBadge', function(data)
	local data = {
		fullname = fullName,
		job = ESX.PlayerData.job.label,
		badgeid = GetResourceKvpString('polbadge')
	}

	openGuiBadge(data)
end)

RegisterNetEvent('esx_badge:openBadgeTwo')
AddEventHandler('esx_badge:openBadgeTwo', function(data)
	-- santitize ourselves (duh)
	data.fullname = ESX.Math.Sanitize(data.fullname)
	data.job = ESX.Math.Sanitize(data.job)
	data.badgeid = ESX.Math.Sanitize(data.badgeid)

	openGuiBadge(data)
end)

function openGuiBadge(data)
	SendNUIMessage({method = 'openGuiBadge', data = data})
	menuIsOpen = true
end

function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({method = 'closeGui'})
	menuIsOpen = false
end

AddEventHandler('esx_badge:setBadge', function()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'badge_setup', {
		title = 'Input your Police ID'
	}, function(data, menu)
		local length = string.len(data.value)
		local polID = ESX.Math.Sanitize(data.value)

		if not polID or length < 4 or length > 8 then
			ESX.ShowNotification('Invalid ID input. ~n~Usage:~n~0F 000~n~0 - Rank~n~F - Department~n~000 - Custom number')
		else
			SetResourceKvp('polbadge', polID)
			ESX.ShowNotification('Your badge number has been set to: ' .. polID)
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end)