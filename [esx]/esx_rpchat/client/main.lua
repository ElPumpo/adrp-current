Citizen.CreateThread(function()
	TriggerEvent('chat:addTemplate', 'police', "<img src='data:image/png;base64,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' height='16'> <b>{0}</b>: {1}")
end)

RegisterNetEvent('sendProximityMessage')
AddEventHandler('sendProximityMessage', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if pid == myId then
		TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "^4" .. name .. "", {0, 153, 204}, "^7 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if pid == myId then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6 " .. name .." ".."^6 " .. message)
	end
end)

RegisterNetEvent('sendProximityMessageDo')
AddEventHandler('sendProximityMessageDo', function(id, name, message)
	local myId = PlayerId()
	local pid = GetPlayerFromServerId(id)

	if pid == myId then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
	elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.999 then
		TriggerEvent('chatMessage', "", {255, 0, 0}, " ^0* " .. name .."  ".."^0  " .. message)
	end
end)

RegisterNetEvent("mecommand")
AddEventHandler("mecommand", function(msg)
	TriggerServerEvent("sendMECommand", msg)
end)