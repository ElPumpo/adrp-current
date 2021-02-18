RegisterNetEvent('esx_policejob:updateAvailableUnits')
AddEventHandler('esx_policejob:updateAvailableUnits', function(availableUnits)
	local policeCount = 0

	for _,info in pairs(availableUnits) do
		if info.job == 'police' or info.job == 'state' or info.job == 'sheriff' then
			policeCount = policeCount + 1
		end
	end

	SendNUIMessage({
		action = 'updatePlayerJob',
		job = 'police',
		count = policeCount
	})
end)

RegisterNetEvent('esx_ambulancejob:updateAvailableUnits')
AddEventHandler('esx_ambulancejob:updateAvailableUnits', function(availableUnits)
	SendNUIMessage({
		action = 'updatePlayerJob',
		job = 'ems',
		count = ESX.Table.SizeOf(availableUnits)
	})
end)

RegisterNetEvent('esx_mecanojob:updateAvailableUnits')
AddEventHandler('esx_mecanojob:updateAvailableUnits', function(availableUnits)
	SendNUIMessage({
		action = 'updatePlayerJob',
		job = 'mechanic',
		count = ESX.Table.SizeOf(availableUnits)
	})
end)

RegisterNetEvent('esx_taxijob:updateAvailableUnits')
AddEventHandler('esx_taxijob:updateAvailableUnits', function(availableUnits)
	SendNUIMessage({
		action = 'updatePlayerJob',
		job = 'taxi',
		count = ESX.Table.SizeOf(availableUnits)
	})
end)

RegisterNetEvent('esx_vehicleshop:updateAvailableUnits')
AddEventHandler('esx_vehicleshop:updateAvailableUnits', function(availableUnits)
	SendNUIMessage({
		action = 'updatePlayerJob',
		job = 'cardealer',
		count = ESX.Table.SizeOf(availableUnits)
	})
end)

RegisterNetEvent('esx_helijob:updateAvailableUnits')
AddEventHandler('esx_helijob:updateAvailableUnits', function(availableUnits)
	SendNUIMessage({
		action = 'updatePlayerJob',
		job = 'heli',
		count = ESX.Table.SizeOf(availableUnits)
	})
end)