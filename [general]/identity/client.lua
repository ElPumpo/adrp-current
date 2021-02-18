local KeyToucheClose = 177 -- PhoneCancel
local menuIsOpen = false
 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if menuIsOpen then
			if IsControlJustPressed(0, KeyToucheClose) and menuIsOpen then
				closeGui()
				local playerPed = PlayerPedId()
				DisableControlAction(0, 1, true)
				DisableControlAction(0, 2, true)
				DisableControlAction(0, 24, true)
				DisablePlayerFiring(playerPed, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 106, true)
				DisableControlAction(0,KeyToucheClose,true)
			end
		end
	end
end)

RegisterNetEvent('gcl:openMeIdentity')
AddEventHandler('gcl:openMeIdentity', function()
	TriggerServerEvent('gc:openMeIdentity')
end)

RegisterNetEvent('gc:showItentity')
AddEventHandler('gc:showItentity', function(data)
	openGuiIdentity(data)
end)

function openGuiIdentity(data)
	SendNUIMessage({method = 'openGuiIdentity', data = data})
	menuIsOpen = true
end

function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({method = 'closeGui'})
	menuIsOpen = false
end