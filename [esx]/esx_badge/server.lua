local availableUnits = {}

RegisterServerEvent('esx_badge:openBadgeServer')
AddEventHandler('esx_badge:openBadgeServer', function(targetPlayerId, data)
	if availableUnits[source] then
		TriggerClientEvent('esx_badge:openBadgeTwo', targetPlayerId, data)
	else
		local identifier = GetPlayerIdentifier(source, 0)
		local msg = ('esx_badge: %s attempted to openBadgeServer'):format(identifier)
		print(msg)
	
		TriggerEvent('adrp_anticheat:cheaterDetected', msg)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

AddEventHandler('esx_policejob:updateAvailableUnits', function(units)
	availableUnits = units
end)