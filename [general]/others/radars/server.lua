ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('adrp_characterspawn:characterSet', function(char)
	local vehicles = char.vehicles
	TriggerClientEvent('grabVehs', char.playerId, vehicles)
end)

RegisterServerEvent('others:speedingTicket')
AddEventHandler('others:speedingTicket', function(cost)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bankMoney = xPlayer.getAccount('bank').money

	if xPlayer.getMoney() >= cost then
		xPlayer.removeMoney(cost)
	elseif bankMoney >= cost then
		xPlayer.removeAccountMoney('bank', cost)
	end
end)