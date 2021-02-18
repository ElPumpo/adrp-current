local Markers = {}
local CurrentAction = nil
local CurrentActionData = nil

Marker = {}

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		
		Citizen.Wait(0)

		if CurrentAction ~= nil and CurrentActionData ~= nil and CurrentActionData.position ~= nil then
			if GetDistanceBetweenCoords(coords, CurrentActionData.position.x, CurrentActionData.position.y, CurrentActionData.position.z, true) > 1.5 then
				if CurrentActionData.exitCallback ~= nil then
					CurrentActionData.exitCallback()
				end
			end
		end

		CurrentAction = nil
		CurrentActionData = nil

		for i=1, #Markers, 1 do 
			local marker = Markers[i]

				if GetDistanceBetweenCoords(coords, marker.position.x, marker.position.y, marker.position.z, true) < 50 then
					local size = {
						x = 1.0,
						y = 1.0,
						z = 1.0
					}

					if marker.size ~= nil then
						size = marker.size
					end

					if marker.color == nil then
						DrawMarker(31, marker.position.x, marker.position.y, marker.position.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, size.x, size.y, size.z, 226, 88, 34, 75, false, false, 2, true, false, false, false)
					else
						DrawMarker(31, marker.position.x, marker.position.y, marker.position.z + 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, size.x, size.y, size.z, marker.color.red, marker.color.green, marker.color.blue, marker.color.alpha, false, false, 2, true, false, false, false)
					end

					if GetDistanceBetweenCoords(coords, marker.position.x, marker.position.y, marker.position.z, true) < 1.5 then
						CurrentAction = marker.id
						CurrentActionData = marker
					end
				
			
			end
		end

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionData.message)


			if IsControlJustReleased(0, 38) then
				CurrentActionData.callback()
			end
		end

	end
end)

function Marker.AddMarker(id, position, message, callback, exitCallback, color, size)
	table.insert(Markers, {
		id = id,
		position = position,
		message = message,
		callback = callback,
		exitCallback = exitCallback,
		color = color,
		size = size
	})
end

function Marker.RemoveMarker(id)
	for i=1, #Markers, 1 do
		local marker = Markers[i]

		if marker.id == id then
			table.remove(Markers, i)
		end
	end
end