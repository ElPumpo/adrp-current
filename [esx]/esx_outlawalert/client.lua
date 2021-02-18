ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local timer = 1 --in minutes - Set the time during the player is outlaw
local gunshotAlert = true --Set if show alert when player use gun
local blipGunTime = 5 --in second
local timing = timer * 60000 --Don't touch
local street1, street2

RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
	if PlayerData.job ~= nil then
		if PlayerData.job.name == 'police' or PlayerData.job.name == 'state' or PlayerData.job.name == 'sheriff' then
			Notify(alert)
		end
	end
end)

function Notify(text)
	exports.pNotify:SendNotification({text = text ,type = 'error',timeout = 3000,layout = 'centerRight',queue = 'left'})
end

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(gx, gy, gz)
	if PlayerData.job ~= nil then
		if PlayerData.job.name == 'police' or PlayerData.job.name == 'state' or PlayerData.job.name == 'sheriff' then
			if gunshotAlert then
				local transG = 250
				local gunshotBlip = AddBlipForCoord(gx, gy, gz)
				SetBlipSprite(gunshotBlip,  1)
				SetBlipColour(gunshotBlip,  1)
				SetBlipAlpha(gunshotBlip,  transG)
				SetBlipAsShortRange(gunshotBlip,  1)
				while transG ~= 0 do
					Wait(blipGunTime * 4)
					transG = transG - 1
					SetBlipAlpha(gunshotBlip,  transG)
					if transG == 0 then
						RemoveBlip(gunshotBlip)
						return
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerCoords = GetEntityCoords(PlayerPedId())
		street1, street2 = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
		street1, street2 = GetStreetNameFromHashKey(street1), GetStreetNameFromHashKey(street2)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		local playerPed = PlayerPedId()
		local plyPos = GetEntityCoords(playerPed)

		if IsPedShooting(playerPed) then
			if GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_AUTOSHOTGUN')
				and GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_PETROLCAN')
				and GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_FIREEXTINGUISHER')
				and GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_STUNGUN')
				and GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_FLAREGUN')
				and GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_BALL')
				and GetSelectedPedWeapon(playerPed) ~= GetHashKey('WEAPON_SNOWBALL')
			then
				if not IsPedCurrentWeaponSilenced(playerPed) and getClosestPed() then
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
						local sex

						if skin.sex == 0 then
							sex = 'male'
						else
							sex = 'female'
						end

						TriggerServerEvent('gunshotInProgressPos', plyPos.x, plyPos.y, plyPos.z)
						if street2 == '' then
							TriggerServerEvent('gunshotInProgressS1', street1, sex)
						else
							TriggerServerEvent('gunshotInProgress', street1, street2, sex)
						end
					end)

					Citizen.Wait(3000)
				end
			end
		end
	end
end)

function getClosestPed()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local rped = GetRandomPedAtCoord(pos, 200.0, 200.0, 100.0, 26)

	if DoesEntityExist(rped) then
		TaskStartScenarioInPlace(rped, 'WORLD_HUMAN_STAND_MOBILE', 0, true)
		Wait(500)
		ClearPedTasksImmediately(rped)
		SetPedAsNoLongerNeeded(rped)
		return true
	else
		return false
	end
end