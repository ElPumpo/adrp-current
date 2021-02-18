ESX = nil
local playersSelling = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_oceansalvage:giveItem')
AddEventHandler('esx_oceansalvage:giveItem', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(Config.Zones.Sell.ItemRequires).count

	if quantity >= 15 then
		TriggerClientEvent('esx:showNotification', source, _U('stop_npc'))
	else
		local amount = Config.Zones.Sell.ItemAdd
		local item = Config.Zones.Sell.ItemDb_name
		xPlayer.addInventoryItem(item, amount)
		TriggerClientEvent('esx:showNotification', source, _U('salvage_collected'))
	end
end)

local function Sell(playerId)
	Citizen.SetTimeout(Config.Zones.Sell.ItemTime, function()
		if playersSelling[playerId] then
			local xPlayer = ESX.GetPlayerFromId(playerId)

			if xPlayer then
				local quantity = xPlayer.getInventoryItem(Config.Zones.Sell.ItemRequires).count

				if quantity < Config.Zones.Sell.ItemRemove then
					TriggerClientEvent('esx:showNotification', playerId, _U('sell_nomorebills'))
					playersSelling[playerId] = false
				else
					local amount = Config.Zones.Sell.ItemRemove
					local item = Config.Zones.Sell.ItemRequires
	
					Citizen.Wait(1500)
					xPlayer.removeInventoryItem(item, amount)
					xPlayer.addMoney(Config.Zones.Sell.ItemPrice)
					TriggerClientEvent('esx:showNotification', playerId, _U('sell_earned', ESX.Math.GroupDigits(Config.Zones.Sell.ItemPrice)))
					Sell(playerId)
				end
			else
				playersSelling[playerId] = nil
			end
		end
	end)
end

RegisterServerEvent('esx_oceansalvage:startSell')
AddEventHandler('esx_oceansalvage:startSell', function()
	if playersSelling[source] then
		TriggerClientEvent('esx:showNotification', source, _U('sell_nobills'))
		playersSelling[source] = nil
	else
		playersSelling[source] = true
		TriggerClientEvent('esx:showNotification', source, _U('sell_cashing'))
		Sell(source)
	end
end)

RegisterServerEvent('esx_oceansalvage:stopSell')
AddEventHandler('esx_oceansalvage:stopSell', function()
	if playersSelling[source] then
		playersSelling[source] = nil
	else
		playersSelling[source] = true
	end
end)
