RegisterNetEvent('esx_jail:updateRemaining')
AddEventHandler('esx_jail:updateRemaining', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jail: %s is using an lua executor!'):format(identifier))
	local message = (('**Source:** %s | %s'):format(source, identifier))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jail lua executor detected (updateRemaining)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_jail:sendToJail')
AddEventHandler('esx_jail:sendToJail', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jail: %s is using an lua executor!'):format(identifier))
	local message = (('**Source:** %s | %s'):format(source, identifier))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jail lua executor detected (sendToJail)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx-qalle-jail:jailPlayer')
AddEventHandler('esx-qalle-jail:jailPlayer', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jail: %s is using an lua executor!'):format(identifier))
	local message = (('**Source:** %s | %s'):format(source, identifier))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jail lua executor detected (jailPlayer)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx-qalle-jail:prisonWorkReward')
AddEventHandler('esx-qalle-jail:prisonWorkReward', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jail: %s is using an lua executor!'):format(identifier))
	local message = (('**Source:** %s | %s'):format(source, identifier))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jail lua executor detected (prisonWorkReward)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)