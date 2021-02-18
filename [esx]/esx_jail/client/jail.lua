RegisterNetEvent('esx_jail:jail')
AddEventHandler('esx_jail:jail', function(_jailTime)
	jailTime = _jailTime

	if isInJail then -- don't allow multiple jails, but allow the jail time to change
		return
	end

	startJailTimer()

	local playerPed = PlayerPedId()

	-- Assign jail skin to user
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.prison_wear.male)
		else
			TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.prison_wear.female)
		end
	end)

	SetPedArmour(playerPed, 0)
	ESX.Game.Teleport(playerPed, Config.JailLocation)
	isInJail, unjail = true, false

	while not unjail do
		Citizen.Wait(1000)

		RemoveAllPedWeapons(playerPed, true)

		if IsPedInAnyVehicle(playerPed, false) then
			ClearPedTasksImmediately(playerPed)
		end
	end

	-- jail time served
	ESX.Game.Teleport(playerPed, Config.JailBlip)
	isInJail = false

	-- Change back the user skin
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	local formattedCoords = {
		x = Config.JailBlip.x,
		y = Config.JailBlip.y,
		z = Config.JailBlip.z
	}

	ESX.SetPlayerData('lastPosition', formattedCoords)
	TriggerServerEvent('esx:updateLastPosition', formattedCoords)
end)

RegisterNetEvent('esx_jail:unjail')
AddEventHandler('esx_jail:unjail', function()
	unjail = true
	jailTime = 0
end)

-- When player respawns / joins
AddEventHandler('playerSpawned', function(spawn)
	if isInJail then
		ESX.Game.Teleport(PlayerPedId(), Config.JailLocation)
	end
end)

function startJailTimer()
	Citizen.CreateThread(function()
		while jailTime > 0 and isInJail do
			Citizen.Wait(1000)

			if isInJail and jailTime > 0 then
				jailTime = jailTime - 1
				local h,m,s = secondsToClock(jailTime)

				if tonumber(h) > 0 then
					TriggerEvent('esx_jail:updateRemainingTime', ('%s:%s:%s'):format(h,m,s))
				else
					TriggerEvent('esx_jail:updateRemainingTime', ('%s:%s'):format(m,s))
				end
			end
		end

		TriggerEvent('esx_jail:updateRemainingTime', '00:00')
	end)
end