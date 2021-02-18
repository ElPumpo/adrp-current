ESX = nil
local HasAlreadyEnteredMarker, LastZone, CurrentAction, CurrentActionMsg = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function teleport(x, y, z, zone)
	local hours = tonumber(GetClockHours())

	if zone == 'visitInmate' then
		if hours > 5 and hours < 17 then
			SetEntityCoords(PlayerPedId(),  x, y, z)
		else
			TriggerEvent('customNotification', 'Rec yard opens at 6am')
		end
	elseif zone == 'yardvisit' then
		if hours > 5 and hours < 17 then
			SetEntityCoords(PlayerPedId(),  x, y, z)
		else
			TriggerEvent('customNotification', 'Visiting hours are between 9am - 12pm')
		end
	elseif zone == 'yardvisit2' then
		if hours > 5 and hours < 17 then
			SetEntityCoords(PlayerPedId(),  x, y, z)
		else
			TriggerEvent('customNotification', 'Visiting hours are between 9am - 12pm')
		end
	elseif zone == 'chowhall' then
		if hours > 11 and hours < 14 then
			SetEntityCoords(PlayerPedId(),  x, y, z)
		else
			TriggerEvent('customNotification', 'Chow hours are between 12pm - 6pm')
		end
	elseif zone == 'exitchow' then
		SetEntityCoords(PlayerPedId(),  x, y, z)
	elseif zone == 'leaveVisitation' then
		SetEntityCoords(PlayerPedId(),  x, y, z)
	elseif zone == 'cellblock' then
		SetEntityCoords(PlayerPedId(),  x, y, z)
	elseif zone == 'visitation' then
		SetEntityCoords(PlayerPedId(), x, y, z)
	elseif zone == 'leaveVisitationVisitor' then
		SetEntityCoords(PlayerPedId(), x, y, z)
	end
end

AddEventHandler('esx_jailvisiting:hasEnteredMarker', function(zone)
	if zone == 'EnterVisitation' then
		CurrentAction = 'visitation'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to leave the ~y~Cell Block~s~.'
	elseif zone == 'LeaveVisitation' then
		CurrentAction = 'leaveVisitation'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to leave the ~y~visitation Room~s~.'
	elseif zone == 'LeaveVisitationVisitor' then
		CurrentAction = 'leaveVisitationVisitor'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to leave the ~y~visitation Room~s~.'
	elseif zone == 'EnterVisitationInmate' then
		CurrentAction = 'visitInmate'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to enter the ~y~Visitation Room~s~.'
	elseif zone == 'ExitVisitation' then
		CurrentAction = 'fuckoff'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to leave the ~y~visitation Room~s~.'
	elseif zone == 'yardVisitation' then
		CurrentAction = 'yardvisit'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to enter the ~y~Visitation Room~s~.'
	elseif zone == 'yardVisitation2' then
		CurrentAction = 'yardvisit2'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to enter the ~y~Visitation Room~s~.'
	elseif zone == 'cellblock' then
		CurrentAction = 'cellblock'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to return to the ~y~Cell Block~s~.'
	elseif zone == 'chowhall' then
		CurrentAction = 'chowhall'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to enter the ~y~Chow Hall~s~.'
	elseif zone == 'exitchow' then
		CurrentAction = 'exitchow'
		CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to leave the ~y~Chow Hall~s~.'
	end
end)

AddEventHandler('esx_jailvisiting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local isInMarker, letSleep, playerCoords, currentZone = false, true, GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.Zones) do
			local distance = #(playerCoords - v.Pos)

			if distance < Config.DrawDistance then
				letSleep = false
				DrawMarker(v.Type, v.Pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, nil, nil, false)

				if distance < v.Size.x then
					isInMarker  = true
					currentZone = k
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			TriggerEvent('esx_jailvisiting:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_jailvisiting:hasExitedMarker', LastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'visitInmate' then
					teleport(1636.3, 2565.4, 44.5, CurrentAction)
				elseif CurrentAction == 'visitation' then
					teleport(1777.3, 2584.9, 44.5, CurrentAction)
				elseif CurrentAction == 'leaveVisitation' then
					teleport(1818.6, 2594.2, 44.7, CurrentAction)
				elseif CurrentAction == 'fuckoff' then
					SetEntityCoords(PlayerPedId(),  1847.0, 2586.0, 44.5)
					--TriggerEvent('customNotification', 'Your phone has been <font color="#00ea1b"> Returned')
				elseif CurrentAction == 'yardvisit' then
					teleport(1791.6, 2593.7, 44.7, CurrentAction)
				elseif CurrentAction == 'yardvisit2' then
					teleport(1774.2, 2573.8, 44.5, CurrentAction)
				elseif CurrentAction == 'cellblock' then
					teleport(1737.1, 2622.8, 44.5, CurrentAction)
				elseif CurrentAction == 'chowhall' then
					teleport(1729.4, 2592.0, 44.5, CurrentAction)
				elseif CurrentAction == 'exitchow' then
					teleport(1729.3, 2563.6, 44.5, CurrentAction)
				elseif CurrentAction == 'EnterVisitation' then
					teleport(1636.2, 2565.2, 44.5, CurrentAction)
				elseif CurrentAction == 'leaveVisitationVisitor' then
					teleport(1846.7, 2585.8, 44.6, CurrentAction)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)