ESX = nil
local itemWeights, activePlayers = {}, {}

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj

	local players = ESX.GetPlayers()

	for _,playerId in ipairs(players) do
		activePlayers[playerId] = true
	end
end)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i=1, #result, 1 do
			if result[i].weight then
				itemWeights[result[i].name] = result[i].weight
			else
				itemWeights[result[i].name] = Config.DefaultWeight
			end
		end
	end)
end)

AddEventHandler('playerDropped', function(reason)
	if activePlayers[source] then
		activePlayers[source] = nil
	end
end)

function isPlayerActive(source)
	return activePlayers[source] == true
end

function getInventoryWeight(pPlayer)
	if not isPlayerActive(pPlayer.source) then
		return 50000
	end

	local weight, itemWeight = 0, 0

	if #pPlayer.inventory > 0 then
		for i=1, #pPlayer.inventory, 1 do
			if pPlayer.inventory[i] then
				itemWeight = Config.DefaultWeight

				if itemWeights[pPlayer.inventory[i].name] then
					itemWeight = itemWeights[pPlayer.inventory[i].name]
				end

				weight = weight + (itemWeight * pPlayer.inventory[i].count)
			end
		end
	end

	return weight
end

AddEventHandler('char:characterSet', function(character)
	local playerId = character.playerId

	SetTimeout(2000, function()
		activePlayers[playerId] = true

		local xPlayer = ESX.GetPlayerFromId(playerId)
		local currentInventoryWeight = getInventoryWeight(xPlayer)

		TriggerClientEvent('adrp_ui:updateWeight', playerId, currentInventoryWeight)
	end)
end)

RegisterServerEvent('esx:onAddInventoryItem')
AddEventHandler('esx:onAddInventoryItem', function(source, item, count)
	local _source = source

	if not isPlayerActive(_source) then
		return false
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	local currentInventoryWeight = getInventoryWeight(xPlayer)

	if currentInventoryWeight > Config.Limit then
		local itemWeight = Config.DefaultWeight

		-- Get weight if it exists of current item
		if itemWeights[item.name] then
			itemWeight = itemWeights[item.name]
		end

		local qty = 0
		local weightTooMuch = 0
		weightTooMuch = currentInventoryWeight - Config.Limit
		qty = math.floor(weightTooMuch / itemWeight) + 1

		-- Should be false all the time. But can be true on fresh install
		if qty > count then
			qty = count
		end

		TriggerClientEvent('esx:showNotification', _source, 'You lose ~r~your items~s~: ~y~' .. item.label .. ' ~b~x' .. qty)
		xPlayer.removeInventoryItem(item.name, qty)
	else
		TriggerClientEvent('adrp_ui:updateWeight', _source, currentInventoryWeight)
	end
end)

RegisterServerEvent('esx:onRemoveInventoryItem')
AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
	local _source = source

	if not isPlayerActive(_source) then
		return
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	local currentInventoryWeight = getInventoryWeight(xPlayer)
	TriggerClientEvent('adrp_ui:updateWeight', _source, currentInventoryWeight)
end)