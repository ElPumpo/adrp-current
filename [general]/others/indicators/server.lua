RegisterServerEvent('MSQSetVehicleWindow')
AddEventHandler('MSQSetVehicleWindow', function(windowsDown)
	TriggerClientEvent('MSQSetVehicleWindow', -1, source, windowsDown)
end)