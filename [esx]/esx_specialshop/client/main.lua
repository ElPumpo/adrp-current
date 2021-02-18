ESX = nil
PlayerData = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj

			if ESX.IsPlayerLoaded() then
				PlayerData = ESX.GetPlayerData()
			end

			for k,v in pairs(Config.Shops) do
				Marker.AddMarker(k .. '_shop_marker', v.Position, 'Press ~INPUT_CONTEXT~ access the ~o~Special Shop~s~.', v.jobs, 0,
					function()
						OpenShopMenu(k, v)
					end,
					function()
						ESX.UI.Menu.CloseAll()
					end, v.HideMarker
				)
			end
		end)

		Citizen.Wait(0)
	end
end)

local HadArmor = false

AddEventHandler('skinchanger:modelLoaded', function()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			local ped = PlayerPedId()
			local armor = GetPedArmour(ped)

			if armor > 0 then
				HadArmor = true
			else
				if HadArmor == true then
					HadArmor = false

					TriggerEvent('skinchanger:getSkin', function(skin)
						local clothes = {
							['bproof_1'] = 0,
							['bproof_2'] = 0
						}

						TriggerEvent('skinchanger:loadClothes', skin, clothes)
					end)
				end
			end
		end
	end)
end)

function OpenShopMenu(title, values)
	local elements = {}

	for i=1, #values.Content, 1 do
		local item = values.Content[i]

		table.insert(elements, {
			label = ('%s - <span style="color:green;">$%s</span>'):format(item.Label, ESX.Math.GroupDigits(item.Price)),
			value = item.Item,
			amount = item.Amount,
			cost = item.Price
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), title .. '_shop_menu', {
		title    = title,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if data.current.value == 'bulletproof_vest' then
			ESX.TriggerServerCallback('revenge-specialshop:buyBulletproofVest', function(success)
				if success == false then
					TriggerEvent('esx:showNotication', 'You do not have enough money.')
				else
					SetPedArmour(PlayerPedId(), 100)

					TriggerEvent('skinchanger:getSkin', function(skin)
						local clothes = {
							['bproof_1'] = 28,
							['bproof_2'] = 9
						}

						TriggerEvent('skinchanger:loadClothes', skin, clothes)
					end)
				end
			end, data.current.cost)
		else
			ESX.TriggerServerCallback('revenge-specialshop:buyItem', function(success)
				if success == false then
					TriggerEvent('esx:showNotication', 'You do not have enough money.')
				end
			end, data.current.value, data.current.amount, data.current.cost)
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)