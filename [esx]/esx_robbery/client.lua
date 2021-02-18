local distanceForMarkerToShow, distanceToInteractWithMarker = 15, 1.5
local isRobbing, cooldownEnabled, spotBeingRobbed = false, false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx_robbery:setCooldown')
AddEventHandler('esx_robbery:setCooldown', function(state)
	cooldownEnabled = state
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local letSleep = true

		for name,robbableSpot in pairs(Config.RobbableSpots) do
			local distance = #(coords - vector3(robbableSpot.x, robbableSpot.y, robbableSpot.z))

			if distance < distanceToInteractWithMarker and not isRobbing and not robbableSpot.beingRobbed then
				letSleep = false
				if cooldownEnabled then
					DisplayHelpText('All stores around San-Andreas are under ~o~High Security~s~.')
				else
					spotBeingRobbed = robbableSpot

					if robbableSpot.isSafe then
						DisplayHelpText('Press ~INPUT_CONTEXT~ to ~o~Crack the Safe~s~.')
					else
						DisplayHelpText('Press ~INPUT_CONTEXT~ to ~o~Pry Open the Register~s~.')
					end
	
					if IsControlJustReleased(0, 38) then
						TriggerServerEvent('esx_robbery:policeCheck')
					end
				end
			elseif isRobbing and robbableSpot.beingRobbed and distance > 3.0 then
				StopRobbery()
			end
		end

		if IsControlJustReleased(0, 38) and isRobbing then
			StopRobbery()
		end

		if letSleep and not isRobbing then
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_robbery:startRobbery')
AddEventHandler('esx_robbery:startRobbery', function(cops)
	local ongoingRobberies = 0
	for i,v in pairs(Config.RobbableSpots) do
		if v.beingRobbed then
			ongoingRobberies = ongoingRobberies + 1
		end
	end

	if ongoingRobberies > 0 then
		TriggerEvent('customNotification', 'There\'s already an robbery ongoing nearby, please wait for it to play out.')
		return
	end

	Citizen.CreateThread(function()
		if cops >= spotBeingRobbed.copsNeeded then
			TriggerServerEvent('esx_robbery:robberyStartedNotification', spotBeingRobbed.name)
			ESX.Streaming.RequestAnimDict('mini@safe_cracking')

			local playerPed = PlayerPedId()
			TaskPlayAnim(playerPed, 'mini@safe_cracking','dial_turn_anti_normal', 8.0, 0.0, -1, 1, 0.0, false, false, false)
			isRobbing = true
			spotBeingRobbed.beingRobbed = true
			Config.RobbableSpots[spotBeingRobbed.name] = spotBeingRobbed
			TriggerServerEvent('esx_robbery:syncSpots', Config.RobbableSpots)
			FreezeEntityPosition(playerPed, true)
			local currentSecondCount = 0

			Citizen.CreateThread(function()
				while isRobbing do
					Citizen.Wait(0)

					if spotBeingRobbed then
						if spotBeingRobbed.isSafe then
							DisplayHelpText(('You are ~o~cracking the safe~s~, ~y~%s~s~ seconds remain'):format(spotBeingRobbed.timeToRob - currentSecondCount))
						else
							DisplayHelpText(('You are ~o~prying open the cash register~s~, ~y~%s~s~ seconds remain'):format(spotBeingRobbed.timeToRob - currentSecondCount))
						end
					end
				end
			end)

			while isRobbing do
				Citizen.Wait(1000)
				currentSecondCount = currentSecondCount + 1

				if spotBeingRobbed then
					if currentSecondCount == spotBeingRobbed.timeToRob then
						RobberyOver()
					end
				end
			end
		else
			TriggerEvent('customNotification', 'Not enough cops are online to start a robbery!')
		end
	end)
end)

RegisterNetEvent('esx_robbery:syncSpotsClient')
AddEventHandler('esx_robbery:syncSpotsClient', function(spots)
	Config.RobbableSpots = spots
end)

function StopRobbery()
	isRobbing = false
	spotBeingRobbed.beingRobbed = false
	Config.RobbableSpots[spotBeingRobbed.name] = spotBeingRobbed
	TriggerServerEvent('esx_robbery:robberyOverNotification', spotBeingRobbed.name)
	TriggerServerEvent('esx_robbery:syncSpots', Config.RobbableSpots)
	spotBeingRobbed = nil
	local playerPed = PlayerPedId()
	FreezeEntityPosition(playerPed, false)
	ClearPedTasksImmediately(playerPed)
end

function RobberyOver()
	DisplayHelpText('You have successfully robbed this spot!')
	TriggerServerEvent('esx_robbery:robberyOver', spotBeingRobbed.name)
	StopRobbery()
end

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, false, false, -1)
end

RegisterNetEvent('esx_robbery:robberyOverNotification')
AddEventHandler('esx_robbery:robberyOverNotification', function(name)
	TriggerEvent('pNotify:SendNotification', {
		text = '10-90: Somebody was seen fleeing the area ( '..name..' )',
		type = 'warning',
		timeout = 10000,
		layout = 'centerRight',
		queue = 'right'
	})
end)

RegisterNetEvent('esx_robbery:robberyStartedNotification')
AddEventHandler('esx_robbery:robberyStartedNotification', function(name)
	TriggerEvent('pNotify:SendNotification', {
		text = '10-90: A silent alarm has been triggered ( '..name..' )',
		type = 'warning',
		timeout = 10000,
		layout = 'centerRight',
		queue = 'right'
	})
end)