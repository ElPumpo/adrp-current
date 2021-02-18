RegisterNetEvent('esx_spectate:kick')
AddEventHandler('esx_spectate:kick', function()
	local date = os.date('%Y-%m-%d %H:%M')
	local identifier = GetPlayerIdentifiers(source)[1]
	local message = (('adrp_anticheat: source attempted to run old event :esx_spectate:kick!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
	print(message)
	TriggerEvent('adrp_anticheat:cheaterDetected', message)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterServerEvent('esx_slotmachine:sv:1')
AddEventHandler('esx_slotmachine:sv:1', function()
	local date = os.date('%Y-%m-%d %H:%M')
	local identifier = GetPlayerIdentifiers(source)[1]
	local message = (('adrp_anticheat: source attempted to run old event :esx_slotmachine:sv:1!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
	print(message)
	TriggerEvent('adrp_anticheat:cheaterDetected', message)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterServerEvent('esx_slotmachine:sv:2')
AddEventHandler('esx_slotmachine:sv:2', function()
	local date = os.date('%Y-%m-%d %H:%M')
	local identifier = GetPlayerIdentifiers(source)[1]
	local message = (('adrp_anticheat: source attempted to run old event :esx_slotmachine:sv:2!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
	print(message)

	TriggerEvent('adrp_anticheat:cheaterDetected', message)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)