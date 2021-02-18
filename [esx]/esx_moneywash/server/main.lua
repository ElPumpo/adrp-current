local playersWashing = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function WhiteningMoney(playerId, percent)
	playersWashing[playerId] = ESX.SetTimeout(10000, function()
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if not xPlayer then
			playersWashing[playerId] = nil
			return
		end

		local blackMoney = xPlayer.getAccount('black_money')
		local _percent = Config.Percentage

		if blackMoney.money < Config.Slice then
			TriggerClientEvent('esx_moneywash:notify', playerId, 'CHAR_LESTER_DEATHWISH', 1, _U('Notification'), false, _U('nocash', ESX.Math.GroupDigits(Config.Slice)))
		else
			local bonus = math.random(Config.Bonus.min, Config.Bonus.max)
			local washedMoney = ESX.Math.Round((Config.Slice / 100) * (_percent + bonus))

			xPlayer.removeAccountMoney('black_money', Config.Slice)
			xPlayer.addMoney(washedMoney)
			WhiteningMoney(playerId, _percent)

			TriggerClientEvent('esx_moneywash:notify', playerId, 'CHAR_LESTER_DEATHWISH', 1, _U('Notification'), false, _U('cash_washed', ESX.Math.GroupDigits(washedMoney)))
		end
	end)
end

RegisterServerEvent('esx_moneywash:startWhitening')
AddEventHandler('esx_moneywash:startWhitening', function(percent)
	TriggerClientEvent('esx_moneywash:notify', source, 'CHAR_LESTER_DEATHWISH', 1, _U('Notification'), false, _U('Whitening'))

	if not playersWashing[source] then
		WhiteningMoney(source, percent)
	end
end)

RegisterServerEvent('esx_moneywash:Nothere')
AddEventHandler('esx_moneywash:Nothere', function()
	if playersWashing[source] then
		ESX.ClearTimeout(playersWashing[source])
		playersWashing[source] = nil
	end

	TriggerClientEvent('esx_moneywash:notify', source, 'CHAR_LESTER_DEATHWISH', 1, _U('Notification'), false, _U('Nothere'))
end)

RegisterServerEvent('esx_moneywash:stopWhitening')
AddEventHandler('esx_moneywash:stopWhitening', function()
	if playersWashing[source] then
		ESX.ClearTimeout(playersWashing[source])
		playersWashing[source] = nil
	end
end)
