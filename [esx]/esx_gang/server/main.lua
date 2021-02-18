ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_gang:putInVehicle')
AddEventHandler('esx_gang:putInVehicle', function(target)
	TriggerClientEvent('esx_gang:putInVehicle', target)
end)

RegisterServerEvent('esx_gang:outVehicle')
AddEventHandler('esx_gang:outVehicle', function(target)
	TriggerClientEvent('esx_gang:outVehicle', target)
end)