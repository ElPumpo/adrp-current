RegisterServerEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function(target)
	local identifier = GetPlayerIdentifier(source, 0)
	local msg = ('esx_policejob: %s attempted to trigger handcuff'):format(identifier)
	print(msg)

	TriggerEvent('adrp_anticheat:cheaterDetected', msg)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterServerEvent('esx_policejob:performHandcuff')
AddEventHandler('esx_policejob:performHandcuff', function(target)
	local identifier = GetPlayerIdentifier(source, 0)
	local msg = ('esx_policejob: %s attempted to trigger performHandcuff'):format(identifier)
	print(msg)

	TriggerEvent('adrp_anticheat:cheaterDetected', msg)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)