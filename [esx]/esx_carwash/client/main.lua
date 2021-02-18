ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for k,v in ipairs(Config.Locations) do
		if not v.hide then
			local blip = AddBlipForCoord(v.coords)
			SetBlipSprite(blip, 100)
			SetBlipAsShortRange(blip, true)
	
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_carwash'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local canSleep = true

		if CanWashVehicle(playerPed) then
			for k,v in ipairs(Config.Locations) do
				local distance = #(playerCoords - v.coords)

				if distance < 50 then
					DrawMarker(1, v.coords, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, false, false, 2, false, nil, nil, false)
					canSleep = false

					if distance < 5 then
						canSleep = false

						if Config.EnablePrice then
							ESX.ShowHelpNotification(_U('prompt_wash_paid', ESX.Math.GroupDigits(Config.Price)))
						else
							ESX.ShowHelpNotification(_U('prompt_wash'))
						end

						if IsControlJustReleased(0, 38) then
							local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

							if GetVehicleDirtLevel(vehicle) > 2 then
								WashVehicle()
							else
								ESX.ShowNotification(_U('wash_failed_clean'))
							end
						end
					end
				end
			end

			if canSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function CanWashVehicle(playerPed)
	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if GetPedInVehicleSeat(vehicle, -1) == playerPed then
			return true
		end
	end

	return false
end

function WashVehicle()
	ESX.TriggerServerCallback('esx_carwash:canAfford', function(canAfford)
		if canAfford then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			SetVehicleDirtLevel(vehicle, 0.1)

			if Config.EnablePrice then
				ESX.ShowNotification(_U('wash_successful_paid', ESX.Math.GroupDigits(Config.Price)))
			else
				ESX.ShowNotification(_U('wash_successful'))
			end
			Citizen.Wait(5000)
		else
			ESX.ShowNotification(_U('wash_failed'))
			Citizen.Wait(5000)
		end
	end)
end
