local relationshipTypes = {
	'GANG_1',
	'GANG_2',
	'GANG_9',
	'GANG_10',
	'AMBIENT_GANG_LOST',
	'AMBIENT_GANG_MEXICAN',
	'AMBIENT_GANG_FAMILY',
	'AMBIENT_GANG_BALLAS',
	'AMBIENT_GANG_MARABUNTE',
	'AMBIENT_GANG_CULT',
	'AMBIENT_GANG_SALVA',
	'AMBIENT_GANG_WEICHENG',
	'AMBIENT_GANG_HILLBILLY',
	'DEALER',
	'COP',
	'PRIVATE_SECURITY',
	'SECURITY_GUARD',
	'ARMY',
	'MEDIC',
	'FIREMAN',
	'HATES_PLAYER',
	'NO_RELATIONSHIP',
	'SPECIAL',
	'MISSION2',
	'MISSION3',
	'MISSION4',
	'MISSION5',
	'MISSION6',
	'MISSION7',
	'MISSION8',
	'PLAYER',
	'CIVMALE',
	'CIVFEMALE'
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)

		local playerHash, groupHash = GetHashKey('PLAYER')

		for _,group in ipairs(relationshipTypes) do
			groupHash = GetHashKey(group)

			SetRelationshipBetweenGroups(1, playerHash, groupHash)
			SetRelationshipBetweenGroups(1, groupHash, playerHash)
		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicle) then
			local lock = GetVehicleDoorLockStatus(vehicle)
			local driverPed = GetPedInVehicleSeat(vehicle, -1)

			if lock == 7 then
				SetVehicleDoorsLocked(vehicle, 2)
			end

			if driverPed then
				SetPedCanBeDraggedOut(driverPed, false)
			end
		end
	end
end)

local holstered = true
local lastWeapon = nil

local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_PISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_APPISTOL',
	'WEAPON_MINISMG',
	'WEAPON_MICROSMG',
	'WEAPON_MACHINEPISTOl',
	'WEAPON_DBSHOTGUN',
	'WEAPON_PISTOL_MK2',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_SNSPISTOL',
}

Citizen.CreateThread(function()
	loadAnimDict('reaction@intimidation@1h')

	while true do
		Citizen.Wait(200)

		local ped = PlayerPedId()

		if DoesEntityExist(ped) and not IsEntityDead(ped) and IsPedOnFoot(ped) then

			if CheckWeapon(ped) then
				if holstered then
					local weapon = GetSelectedPedWeapon(ped)

					SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)

					TaskPlayAnim(ped, 'reaction@intimidation@1h', 'intro', 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					
					Citizen.Wait(1200)

					SetCurrentPedWeapon(ped, weapon, true)
					DisablePlayerFiring(ped, true)
					

					Citizen.Wait(800)

					DisablePlayerFiring(ped, false)

					ClearPedTasks(ped)

					holstered = false
				end
			else
				if not holstered then
					if lastWeapon ~= nil then
						SetCurrentPedWeapon(ped, lastWeapon, true)
					end

					TaskPlayAnim(ped, 'reaction@intimidation@1h', 'outro', 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					
					Citizen.Wait(1500)

					SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
					
					ClearPedTasks(ped)
					holstered = true
				else
					Citizen.Wait(100)
				end
			end

			lastWeapon = GetSelectedPedWeapon(ped)
		end
	end
end)

function CheckWeapon(ped)
	for i=1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end

	return false
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)

		Citizen.Wait(10)
	end
end