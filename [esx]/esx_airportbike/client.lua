ESX              = nil
local PlayerData = {}
local vendingItems, CurrentAction, CurrentActionMsg, hasAlreadyEnteredMarker, lastZone = {}
local bikes = 0
local rentedbike

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local playerCoords, isInMarker, letSleep, currentZone = GetEntityCoords(PlayerPedId()), false, true
        local type
        
			for k,v in pairs(Config.Locations) do
				for i=1, #v.Rent, 1 do
					local distance = GetDistanceBetweenCoords(playerCoords, v.Rent[i], true)

					if distance < 100.0 then
						DrawMarker(37, v.Rent[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 204, 204, 0, 100, false, true, 2, true, nil, nil, false)
						letSleep = false
					end

					if distance < 0.7 then
						isInMarker = true
						currentZone = "rent"
					end
					for i=1, #v.Return, 1 do
						local distance = GetDistanceBetweenCoords(playerCoords, v.Return[i], true)
	
						if distance < 100.0 then
							DrawMarker(37, v.Return[i], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 204, 204, 0, 100, false, true, 2, true, nil, nil, false)
							letSleep = false
						end
						if distance < 0.7 then
							if not isInShopMenu then
								isInMarker = true
								currentZone = "return"
							end
						end
                    end
                    
				if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
					hasAlreadyEnteredMarker, lastZone = true, currentZone
					TriggerEvent('esx_airportbike:hasEnteredMarker', currentZone)
				end

				if not isInMarker and hasAlreadyEnteredMarker then
					hasAlreadyEnteredMarker = false
					TriggerEvent('esx_airportbike:hasExitedMarker', lastZone)
				end

				if letSleep then
					Citizen.Wait(500)
				end
			end
		end
	end
end)

AddEventHandler('esx_airportbike:hasEnteredMarker', function(zone)
    if zone == 'rent' then
        CurrentAction = 'rent'
        CurrentActionMsg = "Press ~INPUT_PICKUP~ to ~y~Rent a FREE Bike~s~"
    elseif zone == "return" then
        CurrentAction = "return"
		CurrentActionMsg = "Press ~INPUT_PICKUP~ to ~y~Return a Rented bike~s~"
	end
end)

AddEventHandler('esx_airportbike:hasExitedMarker', function(zone)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 103) then
				if CurrentAction == 'rent' then
					menu()
				elseif CurrentAction == 'return' then
					returnbike()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function returnbike()
    local vehicle = rentedbike

    if IsPedInAnyVehicle(GetPlayerPed(-1)) then
        if GetVehiclePedIsIn(GetPlayerPed(-1), false) == vehicle then
            ESX.Game.DeleteVehicle(vehicle)
            bikes = 0
            ESX.ShowAdvancedNotification('ADRP Bike Rentals', 'RE: Bike Rental Update', 'You have returned a rented bike, thank you for your time!', 'CHAR_CARSITE2', 2)
        else
            ESX.ShowAdvancedNotification('ADRP Bike Rentals', 'RE: Bike Rental Update', 'That vehicle does not belong to us, bring a rented bike from us!', 'CHAR_CARSITE2', 2)
        end
    else
        ESX.ShowNotification('~r~You are not in a vehicle!')
    end
end

Citizen.CreateThread(function()
    for k,v in pairs(Config.Locations) do
        for i=1, #v.Rent do
            local blip = AddBlipForCoord(v.Rent[i])
    
            SetBlipSprite (blip, 226)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 1.0)
            SetBlipColour (blip, 1)
            SetBlipAsShortRange(blip, true)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Rent a Bike')
            EndTextCommandSetBlipName(blip)
        end
        for i=1, #v.Return do
            local blip = AddBlipForCoord(v.Return[i])
    
            SetBlipSprite (blip, 226)
            SetBlipDisplay(blip, 4)
            SetBlipScale  (blip, 1.0)
            SetBlipColour (blip, 1)
            SetBlipAsShortRange(blip, true)
        
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Return a Rented Bike')
            EndTextCommandSetBlipName(blip)
        end
    end
end)

function menu()
    local elements = {}
    table.insert(elements, {
        label = ('%s - <span style="color:green;">%s</span>'):format('Rent a Bike', "FREE"),
        action = 'buybike'
    })
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bike_rental', {
        title    = 'Airport Bike Rental',
        align    = 'top',
        elements = elements
    }, function(data, menu)
        if data.current.action == 'buybike' then
            if bikes == 0 then
                local pcoords = GetEntityCoords(GetPlayerPed(-1), true)
                local heading = GetEntityHeading(GetPlayerPed(-1))
                ESX.ShowAdvancedNotification('ADRP Bike Rentals', 'RE: Bike Rental Update', 'Your Bike rental has been processed, please return your bicycle to rent another one. Enjoy!', 'CHAR_CARSITE2', 2)
                ESX.Game.SpawnVehicle('cruiser', pcoords, heading, function(vehicle)
                    bikes = 1
                    rentedbike = vehicle
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
                    ESX.UI.Menu.CloseAll()
                end)
            else
                ESX.ShowAdvancedNotification('ADRP Bike Rentals', 'RE: Bike Rental Update', 'You have not returned your previously rented Bike, please return it before renting another!', 'CHAR_CARSITE2', 2)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end