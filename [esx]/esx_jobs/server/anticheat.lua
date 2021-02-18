RegisterNetEvent('esx_jobs:caution')
AddEventHandler('esx_jobs:caution', function(type, amount)
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jobs: %s cheater attempted to run old event :caution!'):format(identifier))

	local message = ('**Source:** %s | %s\n**Type:** %s\n**Amount:** %s'):format(source, identifier, type, amount)
	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jobs: cheater attempted to run old event esx_jobs:caution!')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_jobs:handleCaution')
AddEventHandler('esx_jobs:handleCaution', function(type, amount)
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jobs: %s cheater attempted to run old event :handleCaution!'):format(identifier))

	local message = ('**Source:** %s | %s\n**Type:** %s\n**Amount:** %s'):format(source, identifier, type, amount)
	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jobs: cheater attempted to run old event esx_jobs:handleCaution!')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_jobs:startWork')
AddEventHandler('esx_jobs:startWork', function()
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jobs: %s cheater attempted to run old event :startWork!'):format(identifier))

	local message = ('**Source:** %s | %s'):format(source, identifier)
	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jobs: cheater attempted to run old event esx_jobs:startWork!')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_jobs:startTheWork')
AddEventHandler('esx_jobs:startTheWork', function(item)
	local identifier = GetPlayerIdentifiers(source)[1]
	print(('esx_jobs: %s cheater attempted to run old event :startTheWork!'):format(identifier))

	local message = ('**Source:** %s | %s'):format(source, identifier)
	TriggerEvent('adrp_anticheat:cheaterDetected', message, 'esx_jobs: cheater attempted to run old event esx_jobs:startTheWork!')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)