local isMining, isProcessing, isSelectingOre, currentProgress, currentProgressLabel, currentOreIndex, selectedOreIndex, selectedOre, selectableOres = false, false, false, 0, '', 0, 0, 'NONE', {}
local pickaxeObject, selectOreScaleform

local scaleformButtons = {
	{label = 'Previous Ore', action = 'previous', control = 27},
	{label = 'Next Ore', action = 'next', control = 173},
	{label = 'Cancel', action = 'cancel', control = 177},
	{label = 'Confirm', action = 'confirm', control = 191}
}

function startAsyncProcessingCount()
	Citizen.CreateThread(function()
		while currentProgress < 100 and isProcessing do
			currentProgress = currentProgress + 1

			if currentProgress >= 75 then
				currentProgressLabel = ('~g~%s~s~'):format(currentProgress) .. '%'
			elseif currentProgress >= 50 then
				currentProgressLabel = ('~y~%s~s~'):format(currentProgress) .. '%'
			elseif currentProgress >= 25 then
				currentProgressLabel = ('~o~%s~s~'):format(currentProgress) .. '%'
			else
				currentProgressLabel = ('~r~%s~s~'):format(currentProgress) .. '%'
			end
			Citizen.Wait(500) --500 = 50 seconds
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed, letSleep = PlayerPedId(), true
		local playerCoords = GetEntityCoords(playerPed)

		for zone,v in pairs(Config.Mining.Zones) do
			local distance = #(playerCoords - v.coords)

			if distance < 50 then
				letSleep = false

				if zone == 'MineProcessing' then
					if distance < 2 then

						if currentOreIndex ~= 0 and not isProcessing then
							ESX.Game.Utils.DrawText3D(v.coords, ('SELECTED ORE: ~y~%s~s~\nPRESS ~y~E~s~ TO START PROCESS\nPRESS ~b~F~s~ TO SWITCH ORE'):format(string.upper(selectableOres[selectedOreIndex].label)), 1.2, 4)
							if IsControlJustReleased(0, 23) then
								currentOreIndex = 0
							elseif IsControlJustReleased(0, 38) and not waiting then
								local waiting = true

								ESX.TriggerServerCallback('esx_adrp_jobs:mining:startProcessing', function(success)
									if success then
										isProcessing = true
										startAsyncProcessingCount()
									else
										ESX.ShowNotification('Could not process item, and you know why!')
									end

									waiting = false
								end, selectableOres[selectedOreIndex].name)

								while waiting do Citizen.Wait(100) end
							end
						elseif isProcessing then
							ESX.Game.Utils.DrawText3D(v.coords, ('PROCESSING %s (%s)...'):format(string.upper(selectableOres[selectedOreIndex].label), currentProgressLabel), 1.2, 4)

							if currentProgress == 100 then
								Citizen.Wait(200)
								isProcessing, currentProgress, currentOreIndex = false, 0, 0
							end
						elseif isSelectingOre then
							local text = ('SELECTED ORE: ~y~%s~s~'):format(string.upper(selectedOre))

							if selectableOres[selectedOreIndex] and selectableOres[selectedOreIndex].count >= 9 then
								text = ('%s\nCAN PROCESS: ~g~%s~s~ / 9'):format(text, selectableOres[selectedOreIndex].count)
							elseif selectableOres[selectedOreIndex] then
								text = ('%s\nCAN PROCESS: ~r~%s~s~ / 9'):format(text, selectableOres[selectedOreIndex].count)
							end

							ESX.Game.Utils.DrawText3D(v.coords, text, 1.2, 4)

							if selectOreScaleform then
								DrawScaleformMovieFullscreen(selectOreScaleform, 255, 255, 255, 255, nil)

								for k,v in ipairs(scaleformButtons) do
									if IsControlJustReleased(0, v.control) then
										if v.action == 'cancel' then
											isSelectingOre = false
											PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
										elseif v.action == 'confirm' then

											-- verify index
											if selectableOres[selectedOreIndex] then
												if selectableOres[selectedOreIndex].count >= 9 then
													isSelectingOre = false
													PlaySoundFrontend(-1, 'SELECT', 'HUD_FREEMODE_SOUNDSET', false)
													currentOreIndex = selectedOreIndex
												else
													PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
												end
											end
										elseif v.action == 'next' then
											PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
											local max = #selectableOres
											if selectedOreIndex < max then
												selectedOreIndex = selectedOreIndex + 1
												selectedOre = selectableOres[selectedOreIndex].label
											else
												PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
											end
										elseif v.action == 'previous' then
											PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)

											if selectedOreIndex > 1 then
												selectedOreIndex = selectedOreIndex - 1
												selectedOre = selectableOres[selectedOreIndex].label
											else
												PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
											end
										end
									end
								end
							else
								selectOreScaleform = setupScaleform()
							end
						else
							ESX.Game.Utils.DrawText3D(v.coords, 'PRESS ~y~E~s~ TO SELECT ORE TO PROCESS', 1.2, 4)
							if IsControlJustReleased(0, 38) then
								PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)

								ESX.PlayerData = ESX.GetPlayerData()
								selectableOres = {}

								for k,v in ipairs(ESX.PlayerData.inventory) do
									if (v.name == 'iron_ore' or v.name == 'gold_ore' or v.name == 'diamond_uncut') and v.count > 0 then
										table.insert(selectableOres, {
											name = v.name,
											label = v.label,
											count = v.count
										})
									end
								end

								isSelectingOre = true
							end
						end

					end
				elseif zone == 'JewelryStore' then
					DrawMarker(20, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 106, 196, 191, 100 - (ESX.Math.Round(distance) * 5), false, false, 2, true, nil, nil, false)

					if distance < 2 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'jewelry_store') then
						ESX.Game.Utils.DrawText3D(v.coords, 'PRESS ~y~E~s~ TO ACCESS THE ~b~JEWELRY STORE~s~', 1.2, 4)

						if IsControlJustReleased(0, 38) then
							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jewelry_store', {
								title    = 'Jewerly Store',
								align    = 'center',
								elements = {{label = 'Sell all diamonds'}}
							}, function(data, menu)
								TriggerServerEvent('esx_adrp_jobs:mining:sellItem', 'diamond')
							end, function(data, menu)
								menu.close()
							end)
						end
					end
				elseif zone == 'CommodityTrader' then
					DrawMarker(20, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 50, 100, 170, 100 - (ESX.Math.Round(distance) * 5), false, false, 2, true, nil, nil, false)

					if distance < 2 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'commodity_trader') then
						ESX.Game.Utils.DrawText3D(v.coords, 'PRESS ~y~E~s~ TO ACCESS THE ~b~COMMODITY TRADER~s~', 1.2, 4)

						if IsControlJustReleased(0, 38) then
							ESX.PlayerData = ESX.GetPlayerData()
							local elements = {}

							for k,v in ipairs(ESX.PlayerData.inventory) do
								if (v.name == 'iron' or v.name == 'gold') and v.count > 0 then
									table.insert(elements, {
										label = ('Sell x%s %s for <span style="color:green;">$%s</span>'):format(v.count, v.label, ESX.Math.GroupDigits(Config.Mining.Prices[v.name] * v.count)),
										item = v.name
									})
								end
							end

							ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'commodity_trader', {
								title    = 'Commodity Trader',
								align    = 'center',
								elements = elements
							}, function(data, menu)
								TriggerServerEvent('esx_adrp_jobs:mining:sellItem', data.current.item)
								menu.close()
							end, function(data, menu)
								menu.close()
							end)
						end
					end
				end

				break
			end
		end
	end
end)

function ButtonMessage(text)
	BeginTextCommandScaleformString('STRING')
	AddTextComponentScaleform(text)
	EndTextCommandScaleformString()
end

function setupScaleform()
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('instructional_buttons')

	BeginScaleformMovieMethod(scaleform, 'CLEAR_ALL')
	EndScaleformMovieMethod()
	
	BeginScaleformMovieMethod(scaleform, 'SET_CLEAR_SPACE')
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	for k,v in ipairs(scaleformButtons) do
		BeginScaleformMovieMethod(scaleform, 'SET_DATA_SLOT')
		ScaleformMovieMethodAddParamInt(k - 1)
		PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, v.control, true))
		ButtonMessage(v.label)
		EndScaleformMovieMethod()
	end

	BeginScaleformMovieMethod(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'SET_BACKGROUND_COLOUR')
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(80)
	EndScaleformMovieMethod()

	return scaleform
end

RegisterNetEvent('esx_adrp_jobs:mining:startMining')
AddEventHandler('esx_adrp_jobs:mining:startMining', function()
	isMining = true

	while isMining do
		local playerPed = PlayerPedId()

		if IsEntityPlayingAnim(playerPed, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 3) ~= 1 then
			ESX.Streaming.RequestAnimDict('melee@large_wpn@streamed_core', function()
				TaskPlayAnim(playerPed, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 1, 0.0, false, false, false)
			end)
		end

		if not pickaxeObject then
			ESX.Game.SpawnObject('prop_tool_pickaxe', {x = 0, y = 0, z = 0}, function(object)
				local boneIndex = GetPedBoneIndex(playerPed, 57005)
				local position = vector3(0.1, -0.02, -0.02)
				local rotation = vector3(90.0, 170.0, 220.0)
				AttachEntityToEntity(object, playerPed, boneIndex, position, rotation, true, true, false, true, 1, true)
				pickaxeObject = object
			end)
		end

		Citizen.Wait(1000)
	end
end)

RegisterNetEvent('esx_adrp_jobs:mining:cancel')
AddEventHandler('esx_adrp_jobs:mining:cancel', function(overrideProcessing)
	if isMining then
		isMining = false
		ClearPedTasks(PlayerPedId())
		if pickaxeObject and DoesEntityExist(pickaxeObject) then
			DetachEntity(pickaxeObject, true, true)
			ESX.Game.DeleteObject(pickaxeObject)
			pickaxeObject = false
		end
	end

	if not overrideProcessing and isProcessing then
		isProcessing, currentProgress, currentOreIndex = false, 0, 0
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Mining.Zones) do
		local blip = AddBlipForCoord(v.coords)

		SetBlipSprite (blip, v.sprite)
		SetBlipColour (blip, v.color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(v.label)
		EndTextCommandSetBlipName(blip)

		if v.circle then
			local blip = AddBlipForRadius(v.coords, v.circle)

			SetBlipHighDetail(blip, true)
			SetBlipColour(blip, 3)
			SetBlipAlpha (blip, 128)
		end
	end
end)

-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if pickaxeObject and DoesEntityExist(pickaxeObject) then
			ClearPedTasks(PlayerPedId())
			DetachEntity(pickaxeObject, true, true)
			ESX.Game.DeleteObject(pickaxeObject)
		end

		if selectOreScaleform then
			SetScaleformMovieAsNoLongerNeeded(selectOreScaleform)
		end
	end
end)