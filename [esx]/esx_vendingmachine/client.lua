ESX = nil
local vendingItems, CurrentAction, CurrentActionMsg, hasAlreadyEnteredMarker, lastZone = {}

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_vendingmachine:relayItems')
AddEventHandler('esx_vendingmachine:relayItems', function(_vendingItems)
	vendingItems = _vendingItems
end)

function openMainMenu()
	ESX.UI.Menu.CloseAll()
	local elements = {{label = 'Buy Items', action = 'buy'}}

	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' and ESX.PlayerData.job.grade_name == 'comm' then
		table.insert(elements, {label = 'Edit Machine', action = 'edit'})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vending_menu_main', {
		title    = 'Vending Machine',
		align    = 'top',
		elements = elements
	}, function(data, menu)
		if data.current.action == 'buy' then
			openBuyItemsMenu()
		elseif data.current.action == 'edit' then
			openModifyItemPriceMenu()
		end
	end, function(data, menu)
		menu.close()
		CurrentAction = 'mrpd_menu'
		CurrentActionMsg = 'Press ~INPUT_PICKUP~ to access the ~y~Vending Machine~s~.'
	end)
end

function openModifyItemPriceMenu()
	local elements = {{label = 'Main Menu', action = 'main_menu'}}

	for k,v in ipairs(vendingItems) do
		table.insert(elements, {
			label = ('%s - <span style="color:green;">$%s</span> - Change Price'):format(v.label, ESX.Math.GroupDigits(v.price)),
			item = v.item,
			action = 'modify'
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vending_menu_edit', {
		title = 'Vending Machine',
		align = 'top',
		elements = elements
	}, function(data, menu)
		if data.current.action == 'main_menu' then
			menu.close()
		else
			openDialogEdit(data.current.item)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openDialogEdit(item)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vending_menu_edit_dialog', {
		title = 'Vending Machine'
	}, function(data, menu)
		local newPrice = tonumber(data.value)

		if newPrice and newPrice > 0 then
			ESX.TriggerServerCallback('esx_vendingmachine:modifyItemPrice', function(success)
				if success then
					ESX.UI.Menu.CloseAll()
					ESX.ShowNotification(('The price of ~y~%s~s~ has been modified to ~g~$%s~s~'):format(item, ESX.Math.GroupDigits(newPrice)))
					openMainMenu()
				else
					ESX.ShowNotification('Could not modify item price, try again later!')
				end
			end, item, newPrice)
		else
			ESX.ShowNotification('Invalid new price!')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function openBuyItemsMenu()
	local elements = {{label = 'Main Menu', item = 'main_menu'}}

	for k,v in ipairs(vendingItems) do
		table.insert(elements, {
			label = ('%s - <span style="color:green;">$%s</span>'):format(v.label, ESX.Math.GroupDigits(v.price)),
			price = v.price,
			item = v.item,
			itemLabel = v.label
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vending_menu_buy', {
		title = 'Vending Machine',
		align = 'top',
		elements = elements
	}, function(data, menu)
		if data.current.item == 'main_menu' then
			menu.close()
		else
			ESX.TriggerServerCallback('esx_vendingmachine:buyItem', function(bought)
				if bought then
					ESX.ShowNotification(('You bought a ~y~%s~s~ for ~g~$%s~s~'):format(data.current.itemLabel, ESX.Math.GroupDigits(data.current.price)))
				else
					ESX.ShowNotification('You cannot afford that purchase')
				end
			end, data.current.item)
		end
	end, function(data, menu)
		menu.close()
	end)
end

AddEventHandler('esx_vendingmachine:hasEnteredMarker', function(zone)
	CurrentAction     = 'mrpd_menu'
	CurrentActionMsg  = 'Press ~INPUT_PICKUP~ to access the ~y~Vending Machine~s~.'
end)

AddEventHandler('esx_vendingmachine:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, isInMarker, letSleep, currentZone = GetEntityCoords(PlayerPedId()), false, true

		for k,v in ipairs(Config.Zones) do
			local distance = #(playerCoords - v)

			if distance < 100 then
				letSleep = false
				DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 204, 204, 0, 100, false, true, 2, true, nil, nil, false)

				if distance < 0.5 then
					isInMarker = true
				end
			end
		end

		if (isInMarker and not hasAlreadyEnteredMarker) or (isInMarker and lastZone ~= currentZone) then
			hasAlreadyEnteredMarker, lastZone = true, currentZone
			TriggerEvent('esx_vendingmachine:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_vendingmachine:hasExitedMarker', lastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 103) then
				if CurrentAction == 'mrpd_menu' then
					openMainMenu()
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)