ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

function IsAbleToSteal(playerId, err)
	ESX.TriggerServerCallback('esx_thief:getValue', function(result)
		if result.value then
			err(false)
		else
			err(_U('no_hands_up'))
		end
	end, playerId)
end

function OpenStealMenu(target)
	ESX.UI.Menu.CloseAll()

	ESX.TriggerServerCallback('esx_thief:getOtherPlayerData', function(data)
		local elements = {}

		if Config.EnableCash then
			table.insert(elements, {
				label      = '[' .. _U('cash') .. '] $' .. data.money,
				value      = 'money',
				type       = 'item_money',
				amount     = data.money,
			})
		end

		if Config.EnableBlackMoney then
			local blackMoney = 0

			for i=1, #data.accounts, 1 do
				if data.accounts[i].name == 'black_money' then
					blackMoney = data.accounts[i].money
					break
				end
			end

			table.insert(elements, {
				label          = '[' .. _U('black_money') .. '] $' .. blackMoney,
				value          = 'black_money',
				type           = 'item_account',
				amount         = blackMoney,
			})
		end

		if Config.EnableInventory then
			table.insert(elements, {label = '--- ' .. _U('inventory') .. ' ---', value = nil})

			for i=1, #data.inventory, 1 do
				if data.inventory[i].count > 0 then
					table.insert(elements, {
						label          = data.inventory[i].label .. ' x' .. data.inventory[i].count,
						value          = data.inventory[i].name,
						type           = 'item_standard',
						amount         = data.inventory[i].count
					})
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'steal_inventory', {
			title  = _U('target_inventory'),
			elements = elements,
			align = 'top-left'
		}, function(data, menu)
			if data.current.value then
				local itemType = data.current.type
				local itemName = data.current.value
				local amount   = data.current.amount

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'steal_inventory_item', {
					title = _U('action_choice'),
					align = "top-left",
					elements = {
						{label = _U('steal'), action = "steal", itemType, itemName, amount},
						{label = _U('return'), action = "return"}
				}}, function(data2, menu2)
					if data2.current.action == 'steal' then
						if itemType == 'item_standard' then
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'steal_inventory_item_standard', {
								title = _U('amount')
							}, function(data3, menu3)
								local quantity = tonumber(data3.value)
								TriggerServerEvent('esx_thief:stealPlayerItem', GetPlayerServerId(target), itemType, itemName, quantity)
								OpenStealMenu(target)

								menu3.close()
								menu2.close()
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							TriggerServerEvent('esx_thief:stealPlayerItem', GetPlayerServerId(target), itemType, itemName, amount)
							OpenStealMenu(target)
						end
					elseif data2.current.action == 'return' then
						ESX.UI.Menu.CloseAll()
						OpenStealMenu(target)
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(target))
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = PlayerPedId()

		if IsControlJustPressed(0, 38) and IsPedArmed(ped, 7) and not IsEntityDead(ped) and IsPedOnFoot(ped) then
			if PlayerData.job and PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'state' and PlayerData.job.name ~= 'usmarshal' and PlayerData.job.name ~= 'ambulance' then
				if PlayerData.gang and PlayerData.gang.name ~= 'nogang' then
					local target, distance = ESX.Game.GetClosestPlayer()

					if target ~= -1 and distance ~= -1 and distance <= 2.0 then
						local playerId = GetPlayerServerId(target)

						IsAbleToSteal(playerId, function(err)
							if(not err)then
								OpenStealMenu(target)
							else
								ESX.ShowNotification(err)
							end
						end)
					end
				else
					Citizen.Wait(500)
				end
			else
				Citizen.Wait(500)
			end
		end

		if target and (target < 5 and distance > 2) then
			ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'steal_inventory')
		end
	end
end)