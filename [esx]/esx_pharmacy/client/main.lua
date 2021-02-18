ESX = nil

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function setCurrentAction(action, msg, data)
	CurrentAction     = action
	CurrentActionMsg  = msg
	CurrentActionData = data
end

-- Create blips
Citizen.CreateThread(function()
	for k,shopCoords in ipairs(Config.Shops) do
		local blip = AddBlipForCoord(shopCoords)

		SetBlipSprite (blip, 403)
		SetBlipColour (blip, 8)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Medical Pharmacy')
		EndTextCommandSetBlipName(blip)
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true

		for k,shopCoords in ipairs(Config.Shops) do
			local distance = #(playerCoords - shopCoords)

			if distance < Config.DrawDistance then
				DrawMarker(Config.MarkerType, shopCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.MarkerSize.x, Config.MarkerSize.y, Config.MarkerSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, nil, nil, false)
				letSleep = false

				if distance < Config.MarkerSize.x then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('esx_pharmacy:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_pharmacy:hasExitedMarker', LastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'pharmacy_shop' then
					OpenShopMenu()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_pharmacy:hasEnteredMarker', function(zone)
	CurrentAction     = 'pharmacy_shop'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {}
end)

AddEventHandler('esx_pharmacy:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('esx_pharmacy:useKit')
AddEventHandler('esx_pharmacy:useKit', function(itemName, hp_regen)
	local ped    = PlayerPedId()
	local health = GetEntityHealth(ped)
	local max    = GetEntityMaxHealth(ped)

	if health > 0 and health < max then
		TriggerServerEvent('esx_pharmacy:removeItem', itemName)
		ESX.UI.Menu.CloseAll()
		ESX.ShowNotification(_U('use_firstaidkit'))

		health = health + (max / hp_regen)

		if health > max then
			health = max
		end

		SetEntityHealth(ped, health)
	end
end)

RegisterNetEvent('esx_pharmacy:onUseDefibrillateur')
AddEventHandler('esx_pharmacy:onUseDefibrillateur', function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

	if closestPlayer == -1 or closestDistance > 3.0 then
		ESX.ShowNotification(_U('no_players'))
	else
		local ped = GetPlayerPed(closestPlayer)
		local health = GetEntityHealth(ped)

		if health == 0 then
			local playerPed = PlayerPedId()
			ESX.ShowNotification(_U('revive_inprogress'))
			TriggerServerEvent('esx_pharmacy:removeItem', 'defibrillateur')

			local lib, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'

			for i=1, 15, 1 do
				Citizen.Wait(900)

				ESX.Streaming.RequestAnimDict(lib, function()
					TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
				end)
			end

			if GetEntityHealth(closestPlayerPed) == 0 then
				TriggerServerEvent('esx_ambulancejob:revivePlayer', GetPlayerServerId(closestPlayer))
				ESX.ShowNotification(_U('revive_complete') .. GetPlayerName(closestPlayer))
			else
				ESX.ShowNotification(GetPlayerName(closestPlayer) .. ' is not unconcious.')
			end
		else
			ESX.ShowNotification(GetPlayerName(closestPlayer) .. ' is not unconcious.')
		end
	end
end)