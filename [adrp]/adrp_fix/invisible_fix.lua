local running = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		local players = ESX.Game.GetPlayersInArea(coords, 100.0)

		if #players > 0 and isDead and not running then
			startRagdollWorkaround()
			Citizen.Wait(1000 * 60 * 5) -- cooldown
		end
	end
end)

RegisterNetEvent('adrp_fix:ragdoll')
AddEventHandler('adrp_fix:ragdoll', function()
	if not running then
		startRagdollWorkaround()
	end
end)

function startRagdollWorkaround()
	local work, running = true, true
	SetTimecycleModifier('hud_def_blur')
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		players[player] = true
	end

	Citizen.CreateThread(function()
		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName('Fixing your character')
		EndTextCommandBusyString(4)

		while work do
			Citizen.Wait(0)
			DisableAllControlActions(0)

			for k,v in pairs(players) do
				local targetPed = GetPlayerPed(k)

				SetEntityLocallyInvisible(targetPed)
				SetEntityNoCollisionEntity(PlayerPedId(), targetPed, true)
			end
		end
	end)

	for i=1, 10 do
		ClearPedTasksImmediately(PlayerPedId())
		Citizen.Wait(700)
	end

	for k,v in pairs(players) do
		if NetworkIsPlayerActive(k) then
			SetEntityLocallyVisible(GetPlayerPed(k))
		end
	end

	RemoveLoadingPrompt()
	SetTimecycleModifier('default')
	work, running = false, false
end