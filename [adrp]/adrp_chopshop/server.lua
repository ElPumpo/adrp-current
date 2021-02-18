ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.Timer)
		--TriggerClientEvent('customNotification', -1 , "New chop car has been spawned, Go search for it") --last seen in x and has the plate number y
		--TriggerClientEvent('ADRP_DEV:SpawnChopVehicle', -1)
	end
end)

