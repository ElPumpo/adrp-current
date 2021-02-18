ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_addons_gcphone:call')
AddEventHandler('esx_addons_gcphone:call', function(data)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local number = data.number

	coords = {
		x = coords.x,
		y = coords.y,
		z = coords.z
	}

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'call_dialog', {
		title = 'Call message'
	}, function(data, menu)
		menu.close()
		TriggerServerEvent('esx_addons_gcphone:startCall', number, data.value, coords)
	end, function(data, menu)
		menu.close()
	end)
end)
