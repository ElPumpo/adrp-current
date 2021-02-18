RegisterServerEvent("RequestTrain")
AddEventHandler("RequestTrain", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local money = xPlayer.getMoney()

	if money >= 250 then
		TriggerClientEvent("AskForTrainConfirmed", _source)
		xPlayer.removeMoney(250)
		TriggerClientEvent('customNotification', _source, 'You have bought a train ticket for $250.')
	else
		TriggerClientEvent('customNotification', _source, 'A train ticket costs $250 and you do not have enough!')
	end
end)