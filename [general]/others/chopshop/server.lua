RegisterServerEvent('ADRP:testing')
AddEventHandler('ADRP:testing', function(message)
	TriggerClientEvent('customNotification', -1, message)
end)

RegisterServerEvent('ADRP:sendPlate')
AddEventHandler('ADRP:sendPlate', function(plate)
	local src = source
	local vehiclePlate = plate

	TriggerClientEvent('ADRP:spawnVehicle', -1, vehiclePlate)
end)
