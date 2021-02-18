RegisterNetEvent('MSQSetVehicleWindow')
AddEventHandler('MSQSetVehicleWindow', function(playerId, windowsDown)
	local target = GetPlayerFromServerId(playerId)
	local targetPed = GetPlayerPed(target)
	local vehicle = GetVehiclePedIsIn(targetPed, false)
	
	if windowsDown then
		RollDownWindow(vehicle, 0)
		RollDownWindow(vehicle, 1)
	else
		RollUpWindow(vehicle, 0)
		RollUpWindow(vehicle, 1)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, true) then
			local pressedUp = IsControlJustReleased(1, 27)
			local pressedDown = IsControlJustReleased(1, 173)
	
			if pressedUp or pressedDown then
				local vehicle = GetVehiclePedIsIn(playerPed, false)

				if GetPedInVehicleSeat(vehicle, -1) == playerPed then
					if pressedUp then
						TriggerServerEvent('MSQSetVehicleWindow', false)
					end

					if pressedDown then
						TriggerServerEvent('MSQSetVehicleWindow', true)
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)