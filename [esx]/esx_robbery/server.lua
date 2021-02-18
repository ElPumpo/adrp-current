ESX = nil
local availableUnits, availableToNotify, cooldownEnabled = {}, {}, false

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job)
	if job == 'police' or job == 'state' or job == 'sheriff' then
		availableUnits[source] = true
	elseif job == 'usmarshal' or job == 'securoserv' or job == 'fib' then
		availableToNotify[source] = true
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	availableUnits[source], availableToNotify[source] = nil, nil
end)

AddEventHandler('playerDropped', function(reason)
	availableUnits[source], availableToNotify[source] = nil, nil
end)

AddEventHandler('char:characterSet', function(character)
	TriggerClientEvent('esx_robbery:setCooldown', character.playerId, cooldownEnabled)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)

		for name,spot in pairs(Config.RobbableSpots) do
			if spot.currentMoney < spot.maxMoney then
				spot.currentMoney = spot.currentMoney + spot.moneyRengerationRate
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1800000)

		for name,spot in pairs(Config.RobbableSpots) do
			if not spot.isBank then
				local aFourth = ESX.Math.Round(spot.currentMoney / 4)
				local randomAmount = math.random(aFourth, aFourth * 3)
				local deliverTo = Config.RobbableSpots[spot.bankToDeliverTo]
	
				spot.currentMoney = spot.currentMoney - randomAmount
				deliverTo.currentMoney = deliverTo.currentMoney + randomAmount
	
				if deliverTo.currentMoney > deliverTo.maxMoney then
					deliverTo.currentMoney = deliverTo.maxMoney
				end
			end
		end
	end
end)

RegisterServerEvent('esx_robbery:robberyOver')
AddEventHandler('esx_robbery:robberyOver', function(spot)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		xPlayer.addAccountMoney('black_money', Config.RobbableSpots[spot].currentMoney)
		TriggerClientEvent('customNotification', playerId, ('The robbery was successful, you stole <span style="color:red;">$%s</span>.'):format(ESX.Math.GroupDigits(Config.RobbableSpots[spot].currentMoney)))
		Config.RobbableSpots[spot].currentMoney = 0
	end
end)

RegisterServerEvent('esx_robbery:robberyOverNotification')
AddEventHandler('esx_robbery:robberyOverNotification', function(name)
	for k,v in pairs(availableUnits) do
		TriggerClientEvent('esx_robbery:robberyOverNotification', k, name)
	end

	for k,v in pairs(availableToNotify) do
		TriggerClientEvent('esx_robbery:robberyOverNotification', k, name)
	end

	cooldownEnabled = true
	TriggerClientEvent('esx_robbery:setCooldown', -1, true)
	Citizen.Wait(5 * 60000)
	cooldownEnabled = false
	TriggerClientEvent('esx_robbery:setCooldown', -1, false)
end)

RegisterServerEvent('esx_robbery:robberyStartedNotification')
AddEventHandler('esx_robbery:robberyStartedNotification', function(name)
	for k,v in pairs(availableUnits) do
		TriggerClientEvent('esx_robbery:robberyStartedNotification', k, name)
	end

	for k,v in pairs(availableToNotify) do
		TriggerClientEvent('esx_robbery:robberyStartedNotification', k, name)
	end
end)

RegisterServerEvent('esx_robbery:syncSpots')
AddEventHandler('esx_robbery:syncSpots', function(spots)
	TriggerClientEvent('esx_robbery:syncSpotsClient', -1, spots)
end)

RegisterServerEvent('esx_robbery:policeCheck')
AddEventHandler('esx_robbery:policeCheck', function()
	if not cooldownEnabled then
		TriggerClientEvent('esx_robbery:startRobbery', source, ESX.Table.SizeOf(availableUnits))
	end
end)