-- fake event, used to ban cheaters
RegisterNetEvent('esx_status:set')
AddEventHandler('esx_status:set', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	local message = (('**Source:** %s | %s'):format(source, identifier))
	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_status: source ran booby trapped event esx_status:set')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)