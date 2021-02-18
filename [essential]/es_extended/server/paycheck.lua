local inService = {}

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	inService[character.playerId] = nil
end)

RegisterServerEvent('es_extended:setService')
AddEventHandler('es_extended:setService', function(putInService)
	if putInService then
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer then
			inService[source] = xPlayer.job.grade_salary
		end
	else
		inService[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	inService[source] = nil
end)

ESX.StartPayCheck = function()
	function payCheck()
		for playerId,salary in pairs(inService) do
			if salary > 0 then
				local xPlayer = ESX.GetPlayerFromId(playerId)
				xPlayer.addAccountMoney('bank', salary)

				local randomID = math.random(100000, 999999)
				local message = ('You\'ve received your paycheck ~g~$%s~s~. You will recieve your next paycheck in 24 minutes.'):format(ESX.Math.GroupDigits(salary))
				TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Maze Bank', 'Received Deposit refID: ' .. randomID, message, 'CHAR_BANK_MAZE', 9)
			end
		end

		SetTimeout(Config.PaycheckInterval, payCheck)
	end

	SetTimeout(Config.PaycheckInterval, payCheck)
end
