local function setOutfit(outfit)
	local playerPed = PlayerPedId()

	--[[
		if GetEntityModel(playerPed) ~= GetHashKey(outfit.ped) then
			RequestModel(outfit.ped)

			while not HasModelLoaded(outfit.ped) do
				Wait(0)
			end

			SetPlayerModel(PlayerId(), outfit.ped)
			playerPed = PlayerPedId()
		end
	]]

	if GetEntityModel(playerPed) ~= GetHashKey(outfit.ped) then
		SetNotificationTextEntry('STRING')
		AddTextComponentSubstringPlayerName('You cannot choose that outfit as it\'s for the opposite gender.')
		DrawNotification(false, true)
		return
	end

	for _,comp in ipairs(outfit.components) do
		SetPedComponentVariation(playerPed, comp[1], comp[2] - 1, comp[3] - 1, 0)
	end

	for _,comp in ipairs(outfit.props) do
		if comp[2] == 0 then
			ClearPedProp(playerPed, comp[1])
		else
			SetPedPropIndex(playerPed, comp[1], comp[2] - 1, comp[3] - 1, true)
		end
	end
end

local categoryOutfits = {}

for name, outfit in pairs(Config.Outfits) do
	if not categoryOutfits[outfit.category] then
		categoryOutfits[outfit.category] = {}
	end

	categoryOutfits[outfit.category][name] = outfit
end

local menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu('EUP Menu', 'Pick your outfit!')

for name, list in pairs(categoryOutfits) do
	local subMenu = menuPool:AddSubMenu(mainMenu, name)

	for id, outfit in pairs(list) do
		outfit.item = NativeUI.CreateItem(id, 'Select this outfit.')
		subMenu:AddItem(outfit.item)
	end

	subMenu.OnItemSelect = function(sender, item, index)
		-- find the outfit
		for _,outfit in pairs(list) do
			if outfit.item == item then
				Citizen.CreateThread(function()
					setOutfit(outfit)
				end)
			end
		end
	end
end

menuPool:Add(mainMenu)
menuPool:RefreshIndex()

AddEventHandler('eup-ui:showMenu', function()
	mainMenu:Visible(not mainMenu:Visible())
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		menuPool:ProcessMenus()
	end
end)