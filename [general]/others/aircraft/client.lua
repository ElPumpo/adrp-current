local harvesting, harvestLoc = false

--Main Loop
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(playerPed), true

		if IsPedOnFoot(playerPed) then
			if harvesting then
				letSleep = false
				ESX.ShowHelpNotification('Press ~INPUT_VEH_DUCK~ to stop your current action.')

				if IsControlJustReleased(0, Keys['X']) then
					stopHarvest()
				else
					if #(playerCoords - harvestLoc.location) > 2.0 then
						stopHarvest()
					end
				end
			else
				for k,v in pairs(Config2.Zones) do
					if #(playerCoords - v.location) < 2.0 then
						letSleep = false
						ESX.ShowHelpNotification(('Press ~INPUT_CONTEXT~ to %s.'):format(v.label))
						if IsControlJustReleased(0, Keys['E']) then
							startHarvest(v)
						end
					end
				end

				for k,v in pairs(Config2.WhitelistedDrugs) do
					if ESX.PlayerData.gang and (
						ESX.PlayerData.gang.name == 'cartel'
						or ESX.PlayerData.gang.name == 'armsdealer'
						or ESX.PlayerData.gang.name == 'company'
					) then
						if #(playerCoords - v.location) < 5.0 then
							letSleep = false
							ESX.ShowHelpNotification(('Press ~INPUT_CONTEXT~ to %s.'):format(v.label))
							if IsControlJustReleased(0, Keys['E']) then
								startHarvest2(v)
							end
						end
					end
				end
			end
		else
			if harvesting then
				stopHarvest()
			end

			Citizen.Wait(1000)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function startHarvest2(loc)
	ESX.TriggerServerCallback('drugs:tryCollect', function(rval)
		if rval then
			TriggerServerEvent('drugs:startHarvest', loc)
			harvesting = true
			harvestLoc = loc
			ESX.ShowNotification('You started harvesting.')
		end
	end, loc)
end

function startHarvest(loc)
	ESX.TriggerServerCallback('drugs:tryCollect', function(rval)
		if rval then
			TriggerServerEvent('drugs:startHarvest', loc)
			harvesting = true
			harvestLoc = loc
			ESX.ShowNotification('You started harvesting.')
		end
	end, loc)
end

function stopHarvest()
	TriggerServerEvent('drugs:stopHarvest')
	harvestLoc = nil
	harvesting = false

	ESX.ShowNotification('You stopped harvesting.')
end

RegisterNetEvent('drugs:stopHarvestClient')
AddEventHandler('drugs:stopHarvestClient', function()
	stopHarvest()
end)