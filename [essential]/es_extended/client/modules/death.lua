local deathCauseList = {
	[GetHashKey('WEAPON_DROWNING')] = 'Drowned under water',
	[GetHashKey('WEAPON_DROWNING_IN_VEHICLE')] = 'Drowned under water inside an vehicle',
	[GetHashKey('WEAPON_BLEEDING')] = 'Bleeded to death',
	[GetHashKey('WEAPON_EXPLOSION')] = 'Died from an explosion',
	[GetHashKey('WEAPON_FALL')] = 'Feel to his/her death',
	[GetHashKey('WEAPON_HIT_BY_WATER_CANNON')] = 'Hit by a water cannon',
	[GetHashKey('WEAPON_RAMMED_BY_CAR')] = 'Death from world after exiting (or being exited from) vehicle (high speed exit/flying out of windscreen)',
	[GetHashKey('WEAPON_RUN_OVER_BY_CAR')] = 'Rammed by an vehicle',
	[GetHashKey('WEAPON_HELI_CRASH')] = 'Died from a heli crash',
	[GetHashKey('WEAPON_FIRE')] = 'Burned to death',
	[GetHashKey('WEAPON_UNARMED')] = 'Beaten to death in a fist fight', -- unsigned
	[-1569615261] = 'Beaten to death in a fist fight', -- int https://gtaforums.com/topic/717612-v-scriptnative-documentation-and-research/?do=findComment&comment=1067469487
	[GetHashKey('WEAPON_ANIMAL')] = 'Killed by an animal',
	[GetHashKey('WEAPON_COUGAR')] = 'Killed by an cougar',
	[GetHashKey('VEHICLE_WEAPON_PLANE_ROCKET')] = 'Killed by a helicopter rocket',
	[-1323279794] = 'Mowed over by an aircraft'
}

Citizen.CreateThread(function()
	local isDead = false

	while true do
		Citizen.Wait(0)

		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isDead then
				isDead = true

				local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
				local killerServerId = NetworkGetPlayerIndexFromPed(killer)
		
				if killer ~= playerPed and killerServerId and NetworkIsPlayerActive(killerServerId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
				else
					local deathCause = GetPedCauseOfDeath(playerPed)

					if deathCause == 0 and killerWeapon ~= 0 then
						deathCause = killerWeapon
					end

					PlayerKilled(deathCause, killer == playerPed)
				end
			elseif not IsPedFatallyInjured(playerPed) then
				isDead = false
			end
		end
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance     = GetDistanceBetweenCoords(victimCoords, killerCoords, true)

	local data = {
		victimCoords = { x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1) },
		killerCoords = { x = ESX.Math.Round(killerCoords.x, 1), y = ESX.Math.Round(killerCoords.y, 1), z = ESX.Math.Round(killerCoords.z, 1) },

		killedByPlayer = true,
		deathCause     = ProcessDeathCause(killerWeapon),
		distance       = ESX.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function PlayerKilled(deathCause, killedBySelf)
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(PlayerPedId())

	local data = {
		victimCoords = { x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1) },

		killedByPlayer = false,
		killedBySelf   = killedBySelf,
		deathCause     = ProcessDeathCause(deathCause)
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function ProcessDeathCause(deathHash)
	if not deathHash then
		return 'Could not reverse death cause! Hash is nil.'
	end

	-- process weapon death hash
	for k,v in ipairs(Config.Weapons) do
		if deathHash == GetHashKey(v.name) then
			return ('Killed using weapon "%s"'):format(v.label)
		end
	end

	if deathCauseList[deathHash] then
		return deathCauseList[deathHash]
	end

	return ('Could not reverse death cause! Hash: %s'):format(deathHash)
end