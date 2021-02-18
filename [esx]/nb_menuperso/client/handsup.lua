local canHandsUp, onHandsUp, animDict = true, false, 'random@mugging3'

AddEventHandler('handsup:toggle', function(param)
	canHandsUp = param
end)

Citizen.CreateThread(function()
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end

	while true do
		Citizen.Wait(10)

		if onHandsUp then
			DisableControlAction(0, 21, true) -- left shift
		end

		if isProne or isOnBack or isOnKnees or isCrouching then
			DisableControlAction(0, 323, true)
		end

		if IsControlPressed(0, 323) then
			local playerPed = PlayerPedId()

			if canHandsUp and IsPedOnFoot(playerPed) and not IsPedCuffed(playerPed) then
				if not onHandsUp then
					DisablePlayerFiring(playerPed, true)
					SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
					onHandsUp = true
					TaskPlayAnim(playerPed, animDict, 'handsup_standing_base', 2.0, -2.0, -1, 49, 0.0, false, false, false)
					TriggerServerEvent('esx_thief:update', onHandsUp)
				end
			end
		end

		if IsControlJustReleased(0, 323) then
			local playerPed = PlayerPedId()

			if canHandsUp and IsPedOnFoot(playerPed) and not IsPedCuffed(playerPed) then
				if onHandsUp then
					onHandsUp = false
					ClearPedSecondaryTask(playerPed)
					DisablePlayerFiring(playerPed, false)
					TriggerServerEvent('esx_thief:update', onHandsUp)
				end
			end
		end
	end
end)



