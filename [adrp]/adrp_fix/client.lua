ESX = nil
isDead = false
local talkingPlayers = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('esx:onPlayerDeath', function(data) isDead = true end)
AddEventHandler('playerSpawned', function() isDead = false end)

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		SetWeaponDrops()
		N_0xf4f2c0d4ee209e20() -- Disable the pedestrian idle camera
		N_0x9e4cfff989258472() -- Disable the vehicle idle camera
		SetPedConfigFlag(PlayerPedId(), 35, false)
	end
end)

Citizen.CreateThread(function()
	SetCreateRandomCops(false) -- disable random cops walking/driving around
	SetCreateRandomCopsNotOnScenarios(false) -- stop random cops (not in a scenario) from spawning
	SetCreateRandomCopsOnScenarios(false) -- stop random cops (in a scenario) from spawning

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedArmed(playerPed, 6) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end

		DisablePlayerVehicleRewards(PlayerId())
		HideHudComponentThisFrame(3)  -- SP Cash display
		HideHudComponentThisFrame(4)  -- MP Cash display
		HideHudComponentThisFrame(6)  -- Vehicle Name
		HideHudComponentThisFrame(7)  -- Area name
		HideHudComponentThisFrame(9)  -- Street name
		HideHudComponentThisFrame(13) -- Cash changes
		HideHudComponentThisFrame(20) -- Weapon Wheel Stats

		DisableControlAction(0, 26, true) -- Look Back

		SetParkedVehicleDensityMultiplierThisFrame(0.0) -- Disable parked vehicles as there spawns a lot of cop vehicles at mission row, etc
	end
end)

Citizen.CreateThread(function()
	RequestAnimDict('facials@gen_male@variations@normal')
	RequestAnimDict('mp_facial')

	while true do
		Citizen.Wait(300)
		local myId = PlayerId()

		for _,player in ipairs(GetActivePlayers()) do
			local boolTalking = NetworkIsPlayerTalking(player)

			if player ~= myId then
				if boolTalking and not talkingPlayers[player] then
					PlayFacialAnim(GetPlayerPed(player), 'mic_chatter', 'mp_facial')
					talkingPlayers[player] = true
				elseif not boolTalking and talkingPlayers[player] then
					PlayFacialAnim(GetPlayerPed(player), 'mood_normal_1', 'facials@gen_male@variations@normal')
					talkingPlayers[player] = nil
				end
			end
		end
	end
end)