ESX                           = nil
local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local PlayerData   = {}

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
	PlayerData.gang = gang
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	Citizen.Wait(5000)

	ESX.TriggerServerCallback('esx_shop:requestDBItems', function(ShopItems)
		for k,v in pairs(ShopItems) do
			if k == "BlackMarket" then
				Config.BlackZones[k].Items = v
			else
				Config.Zones[k].Items = v
			end
		end
	end)
end)

function OpenShopMenu(zone)
	local elements = {}

	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		table.insert(elements, {
			label     = item.label .. ' - <span style="color:green;">$' .. ESX.Math.GroupDigits(item.price) .. ' </span>',
			realLabel = item.label,
			value     = item.name,
			price     = item.price
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title  = _U('shop'),
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_shop:buyItem', data.current.value, data.current.price)
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end)
end

function OpenBlackShopMenu(zone)
	local elements = {}
	for i=1, #Config.BlackZones[zone].Items, 1 do

		local item = Config.BlackZones[zone].Items[i]
		table.insert(elements, {
			label     = item.label .. ' - <span style="color:green;">$' .. ESX.Math.GroupDigits(item.price) .. ' </span>',
			realLabel = item.label,
			value     = item.name,
			price     = item.price
		})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'black_shop', {
		title  = _U('shop'),
		elements = elements
	}, function(data, menu)
		if data.current.value == "zipties" then
			if PlayerData.gang and PlayerData.gang.name ~= 'nogang' then
				TriggerServerEvent('esx_shop:buyItem', data.current.value, data.current.price)
			else
				TriggerEvent("customNotification", "Only official gangs can aquire this item!")
			end
		else
			TriggerServerEvent('esx_shop:buyItem', data.current.value, data.current.price)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'blackshop_menu'
		CurrentActionMsg  = _U('press_menu')
		CurrentActionData = {zone = zone}
	end)
end

AddEventHandler('esx_shop:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_shop:hasEnteredBlackMarker', function(zone)
	CurrentAction     = 'blackshop_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_shop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
Citizen.CreateThread(function()
	for a,zone in pairs(Config.Zones) do
		for _,coords in ipairs(zone.Pos) do
			local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
			SetBlipSprite(blip, 52)
			SetBlipAsShortRange(blip, true)

			if coords.robbable then ShowTickOnBlip(blip, true) end

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(_U('shop'))
			EndTextCommandSetBlipName(blip)
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep = false, true
		local currentZone = nil
		local black = false

		for k,v in pairs(Config.Zones) do
			for i=1, #v.Pos do
				local distance = GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true)

				if distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(Config.Type, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, true, nil, nil, false)
				end

				if distance < 1.5 then
					isInMarker  = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end

		for k,v in pairs(Config.BlackZones) do
			for i=1, #v.Pos do
				local distance = GetDistanceBetweenCoords(coords, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, true)

				if distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(-1, v.Pos[i].x, v.Pos[i].y, v.Pos[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Size.x, Config.Size.y, Config.Size.z, Config.Color.r, Config.Color.g, Config.Color.b, 100, false, true, 2, false, false, false, false)
				end

				if distance < 1.5 then
					isInMarker  = true
					black = true
					ShopItems   = v.Items
					currentZone = k
					LastZone    = k
				end
			end
		end

		if isInMarker and black and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shop:hasEnteredBlackMarker', currentZone)
		end

		if isInMarker and not black and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_shop:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_shop:hasExitedMarker', LastZone)
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
				if CurrentAction == 'shop_menu' then
					OpenShopMenu(CurrentActionData.zone)
				elseif CurrentAction == 'blackshop_menu' then
					OpenBlackShopMenu(CurrentActionData.zone)
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)