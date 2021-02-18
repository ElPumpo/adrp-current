ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_atm:deposit')
AddEventHandler('esx_atm:deposit', function(amount)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local randomID = math.random(100000, 999999)

	if not amount or not xPlayer or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', 'Deposit Money refID: '..randomID, 'Invalid amount', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))

		TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', 'Deposit Money refID: '..randomID, 'Deposited ~g~$' .. ESX.Math.GroupDigits(amount) .. '~s~ to your bank account.', 'CHAR_BANK_MAZE', 9)
		TriggerClientEvent('esx_atm:relayBankBalance', playerId, xPlayer.getAccount('bank').money)
	end
end)

RegisterNetEvent('esx_atm:withdraw')
AddEventHandler('esx_atm:withdraw', function(amount)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local bankAccount = xPlayer.getAccount('bank')
	amount = tonumber(amount)
	local randomID = math.random(100000, 999999)

	if not amount or not xPlayer or amount <= 0 or amount > bankAccount.money then
		TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', 'Withdraw Money refID: '..randomID, 'Invalid amount of money', 'CHAR_BANK_MAZE', 9)
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', 'Withdraw Money refID: '..randomID, 'You have withdrawn ~r~$' .. ESX.Math.GroupDigits(amount) .. '~s~ from your bank account.', 'CHAR_BANK_MAZE', 9)
	end
end)

RegisterNetEvent('esx_atm:transfer')
AddEventHandler('esx_atm:transfer', function(targetId, amount)
	local playerId, amount, targetId = source, tonumber(amount), tonumber(targetId)

	if type(amount) ~= 'number' then return end
	if type(targetId) ~= 'number' then return end
	if not GetPlayerName(targetId) then return end

	local xSource, xTarget = ESX.GetPlayerFromId(playerId), ESX.GetPlayerFromId(targetId)
	local sourceBalance = xSource.getAccount('bank').money
	local randomID = math.random(100000, 999999)
	local header = 'Money Transfer refID: ' .. randomID

	if not xTarget then
		return
	end

	if playerId == targetId then
		TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', header, 'You can not transfer to yourself', 'CHAR_BANK_MAZE', 9)
	else
		amount = ESX.Math.Round(amount)

		if sourceBalance < 1 or amount < 1 or sourceBalance < amount then
			TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', header, 'You cannot afford that transfer!', 'CHAR_BANK_MAZE', 9)
		else
			xSource.removeAccountMoney('bank', amount)
			xTarget.addAccountMoney('bank', amount)
			TriggerClientEvent('esx:showAdvancedNotification', playerId, 'Maze Bank', header, ('You have transferred ~g~$%s~s~ to ~b~%s~s~.'):format(ESX.Math.GroupDigits(amount), xTarget.name), 'CHAR_BANK_MAZE', 9)
			TriggerClientEvent('esx:showAdvancedNotification', targetId, 'Maze Bank', header, ('You have received ~g~$%s~s~ from ~y~%s~s~.'):format(ESX.Math.GroupDigits(amount), xSource.name), 'CHAR_BANK_MAZE', 9)
		end
	end
end)