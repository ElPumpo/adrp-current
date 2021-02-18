ESX = nil
local HasAlreadyEnteredMarker = false
local LastZone
local CurrentAction
local CurrentActionMsg = ''
local CurrentActionData = {}
local menuOpen = false
local Licenses = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.TriggerServerCallback('esx_weaponshop:getShop', function(shopItems)
		for k,v in pairs(shopItems) do
			Config.Zones[k].Items = v
		end
	end)
end)

RegisterNetEvent('esx_weashop:loadLicenses')
AddEventHandler('esx_weashop:loadLicenses', function (licenses)
	for i = 1, #licenses, 1 do
		Licenses[licenses[i].type] = true
	end
end)

RegisterNetEvent('esx_weaponshop:sendShop')
AddEventHandler('esx_weaponshop:sendShop', function(shopItems)
	for k,v in pairs(shopItems) do
		Config.Zones[k].Items = v
	end
end)

function OpenMainMenu(zone)
	menuOpen = true
	PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'main_menu', {
		title = 'Ammu-Nation - Weapon Categories',
		align = 'center',
		elements = {
			{label = 'Weapons Level: 1', value = 'wl_1'},
			{label = 'Weapons Level: 2', value = 'wl_2'},
			{label = 'Weapons Level: 3', value = 'wl_3'},
			{label = 'Weapon Attachments', value = 'attachments'}
	}}, function (data, menu)
		local rValue = data.current.value
		PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)

		if rValue == 'wl_1' then
			if Licenses['weapon'] or Licenses['weapon2'] or Licenses['weapon3'] then
				OpenWeaponShopMenu(rValue, zone)
			else
				OpenBuyLicenseMenu(rValue, zone)
			end
		elseif rValue == 'wl_2' then
			if Licenses['weapon2'] or Licenses['weapon3'] then
				OpenWeaponShopMenu(rValue, zone)
			else
				OpenBuyLicenseMenu(rValue, zone)
			end
		elseif rValue == 'wl_3' then
			if Licenses['weapon3'] then
				OpenWeaponShopMenu(rValue, zone)
			else
				OpenBuyLicenseMenu(rValue, zone)
			end
		elseif rValue == 'attachments' then
			openAttachmentsShopMenu()
		end
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menuOpen = false
		menu.close()
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function openAttachmentsShopMenu()
	local playerPed, elements = PlayerPedId(), {}

	for k,v in ipairs(Config.Attachments) do
		local weaponNum, weapon = ESX.GetWeapon(v.weapon)
		local hasWeapon = HasPedGotWeapon(playerPed, GetHashKey(v.weapon), false)

		if hasWeapon then
			table.insert(elements, {
				label = ('%s [%s mods available)'):format(weapon.label, ESX.Table.SizeOf(v.components)),
				weapon = weapon.name,
				index = k
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'attachments_select_weapon', {
		title = 'Ammu-Nation - Select Weapon',
		align = 'top',
		elements = elements
	}, function(data, menu)
		PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
		elements = {}
		local weaponNum, weapon = ESX.GetWeapon(data.current.weapon)

		for componentIndex,component in pairs(weapon.components) do
			local price = Config.Attachments[data.current.index].components[componentIndex]

			if price then
				table.insert(elements, {
					label = ('%s: <span style="color:green;">$%s</span>'):format(component.label, ESX.Math.GroupDigits(price)),
					weaponName = weapon.name,
					componentName = component.name,
					componentLabel = component.label,
					componentIndex = componentIndex,
					price = price
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'attachments_available', {
			title = ('Ammu-Nation - Available Attachments for %s'):format(weapon.label),
			align = 'top',
			elements = elements
		}, function(data2, menu2)
			ESX.TriggerServerCallback('esx_weaponshop:buyWeaponAttachment', function(bought)
				if bought then
					PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)
					ESX.ShowNotification(('You bought a ~y~%s~s~ for ~g~$%s~s~'):format(data2.current.componentLabel, ESX.Math.GroupDigits(data2.current.price)))
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, data2.current.weaponName, data2.current.componentIndex)
		end, function(data2, menu2)
			menu2.close()
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end, function(data2, menu2)
			PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end)
	end, function(data, menu)
		menu.close()
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenBuyLicenseMenu(rValue, zone)
	local price, wType, wNum

	if rValue == 'wl_1' then
		price = Config.LicensePrice * 1
		wType = 'weapon'
		wNum = 1
	elseif rValue == 'wl_2' then
		price = Config.LicensePrice * 2
		wType = 'weapon2'
		wNum = 2
	elseif rValue == 'wl_3' then
		price = Config.LicensePrice * 3
		wType = 'weapon3'
		wNum = 3
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'license_shop', {
		title = 'Ammu-Nation - Buy License',
		align = 'center',
		elements = {
			{label = 'No', value = 'no'},
			{label = ('<span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(price)), value = 'yes'}
	}}, function (data, menu)
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_weaponshop:buyLicense', function(bought)
				if bought then
					menu.close()
					PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)
				else
					PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
				end
			end, wType, wNum)
		else
			menu.close()
			PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end
	end, function(data, menu)
		menu.close()
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function OpenWeaponShopMenu(rValue, zone)
	local elements = {}
	menuOpen = true

	if zone == 'BlackWeashop' and rValue == 'black' then
		for i=1, #Config.Zones[zone].Items, 1 do
			local item = Config.Zones[zone].Items[i]
	
			table.insert(elements, {
				label = ('%s - <span style="color: green;">%s</span>'):format(item.label, _U('shop_menu_item', ESX.Math.GroupDigits(item.price))),
				price = item.price,
				weaponName = item.item
			})
		end
	end

	if rValue == 'wl_1' then
		for i=1, #Config.Zones[zone].Items1, 1 do
			local item = Config.Zones[zone].Items1[i]

			table.insert(elements, {
				label = ('%s - <span style="color: green;">%s</span>'):format(item.label, _U('shop_menu_item', ESX.Math.GroupDigits(item.price))),
				price = item.price,
				weaponName = item.name
			})
		end
	elseif rValue == 'wl_2' then
		for i=1, #Config.Zones[zone].Items2, 1 do
			local item = Config.Zones[zone].Items2[i]

			table.insert(elements, {
				label = ('%s - <span style="color: green;">%s</span>'):format(item.label, _U('shop_menu_item', ESX.Math.GroupDigits(item.price))),
				price = item.price,
				weaponName = item.name
			})
		end
	elseif rValue == 'wl_3' then
		for i=1, #Config.Zones[zone].Items3, 1 do
			local item = Config.Zones[zone].Items3[i]

			table.insert(elements, {
				label = ('%s - <span style="color: green;">%s</span>'):format(item.label, _U('shop_menu_item', ESX.Math.GroupDigits(item.price))),
				price = item.price,
				weaponName = item.name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'available_weapons', {
		title = _U('shop_menu_title'),
		align = 'center',
		elements = elements
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function(bought)
			if bought then
				DisplayBoughtScaleform(data.current.weaponName, data.current.price)
			else
				PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
			end
		end, data.current.weaponName, zone)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		menuOpen = false
		menu.close()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu_prompt')
		CurrentActionData = { zone = zone }
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function DisplayBoughtScaleform(weaponName, price)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
	local sec = 4

	BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')

	PushScaleformMovieMethodParameterString(_U('weapon_bought', ESX.Math.GroupDigits(price)))
	PushScaleformMovieMethodParameterString(ESX.GetWeaponLabel(weaponName))
	PushScaleformMovieMethodParameterInt(GetHashKey(weaponName))
	PushScaleformMovieMethodParameterString('')
	PushScaleformMovieMethodParameterInt(100)

	EndScaleformMovieMethod()

	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

	Citizen.CreateThread(function()
		while sec > 0 do
			Citizen.Wait(0)
			sec = sec - 0.01
	
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

AddEventHandler('esx_weaponshop:hasEnteredMarker', function(zone)
	if zone == 'GunShop' or zone == 'BlackWeashop' then
		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu_prompt')
		CurrentActionData = { zone = zone }
	end
end)

AddEventHandler('esx_weaponshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	menuOpen = false
	ESX.UI.Menu.CloseAll()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	for k,v in pairs(Config.Zones) do
		if v.Legal then
			for index,coords in ipairs(v.Locations) do
				local blip = AddBlipForCoord(coords)

				SetBlipSprite(blip, 110)
				SetBlipColour(blip, 81)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentSubstringPlayerName(_U('map_blip'))
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, currentZone, letSleep = false, nil, true

		for k,v in pairs(Config.Zones) do
			for index,coords in ipairs(v.Locations) do
				local distance = #(playerCoords - coords)

				if distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(Config.Type, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, true, nil, nil, false)

					if distance < Config.Size.x then
						isInMarker, ShopItems, currentZone, LastZone = true, v.Items, k, k
					end
				end
			end
		end

		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_weaponshop:hasEnteredMarker', currentZone)
		end
		
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_weaponshop:hasExitedMarker', LastZone)
		end

		if letSleep then
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'shop_menu' then
					if Config.Zones[CurrentActionData.zone].Legal then
						OpenMainMenu(CurrentActionData.zone)
					else
						PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
						OpenWeaponShopMenu('black', CurrentActionData.zone)
					end
				end

				CurrentAction = nil
			end
		end
	end
end)

RegisterNetEvent('esx_weashop:clipcli')
AddEventHandler('esx_weashop:clipcli', function()
	ped = PlayerPedId()
	if IsPedArmed(ped, 4) then
		hash=GetSelectedPedWeapon(ped)
		if hash~=nil then
			TriggerServerEvent('esx_weashop:remove')
			AddAmmoToPed(PlayerPedId(), hash,25)
			ESX.ShowNotification('You have used an ammo clip')
		else
			ESX.ShowNotification('You have no weapon in your hand')
		end
	else
		ESX.ShowNotification('This weapon is not suitable')
	end
end)