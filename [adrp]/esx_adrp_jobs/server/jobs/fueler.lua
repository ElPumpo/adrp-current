local peopleInJob = {}

RegisterNetEvent('esx_adrp_jobs:fueler:startJob')
AddEventHandler('esx_adrp_jobs:fueler:startJob', function()
	peopleInJob[source] = os.clock()
end)

RegisterNetEvent('esx_adrp_jobs:fueler:stopJob')
AddEventHandler('esx_adrp_jobs:fueler:stopJob', function()
	peopleInJob[source] = nil
end)

RegisterNetEvent('esx_adrp_jobs:fueler:queryPay')
AddEventHandler('esx_adrp_jobs:fueler:queryPay', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local minTime = 60 * 7

	if peopleInJob[source] then
		local timeSpent = os.clock() - peopleInJob[source]

		if timeSpent > minTime then
			peopleInJob[source] = os.clock()

			TriggerClientEvent('esx:showAdvancedNotification', source, 'title', 'subject', 'msg', 'CHAR_BANK_FLEECA', 2)

		else
			print(('esx_adrp_jobs: %s attempted to run fueler:queryPay!'):format(xPlayer.identifier))
		end
	else
		print(('esx_adrp_jobs: %s attempted to run fueler:queryPay!'):format(xPlayer.identifier))
	end
end)
