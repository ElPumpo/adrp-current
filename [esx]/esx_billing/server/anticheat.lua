RegisterNetEvent('esx_billing:sendBill')
AddEventHandler('esx_billing:sendBill', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_billing: %s is using an lua executor!'):format(identifier))
	local message = (('**Source:** %s | %s'):format(source, identifier))

	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_billing lua executor detected (sendBill)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)