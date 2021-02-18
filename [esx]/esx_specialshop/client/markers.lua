local Markers = {}
local CurrentAction = nil
local CurrentActionData = nil
local LastClick = 0

Marker = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep = true

		if PlayerData ~= nil and PlayerData.job ~= nil then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

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
				local marker, allow = Markers[i], false

				if PlayerData ~= nil then
					if marker.job then
						for k,v in pairs(marker.job) do
							if v == PlayerData.job.name then
								allow = true
								break
							end
						end
					else
						allow = true
					end

					if allow then
						if GetDistanceBetweenCoords(coords, marker.position.x, marker.position.y, marker.position.z, true) < 25 then
							if marker.hideMarker ~= true then
								DrawMarker(1, marker.position.x, marker.position.y, marker.position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.75, 1.75, 0.75, 255, 160, 20, 75, false, false, 2, false, false, false, false)
								letSleep = false
							end

							if GetDistanceBetweenCoords(coords, marker.position.x, marker.position.y, marker.position.z, true) < 1.5 then
								CurrentAction = marker.id
								CurrentActionData = marker
							end
						end
					end
				end
			end

			if CurrentAction ~= nil then
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionData.message)

				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlPressed(0, 38) and (LastClick + 3000) < GetGameTimer() then
					CurrentActionData.callback()

					LastClick = GetGameTimer()
				end
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function Marker.AddMarker(id, position, message, job, jobGrade, callback, exitCallback, hideMarker)
	table.insert(Markers, {
		id = id,
		position = position,
		message = message,
		job = job,
		jobGrade = jobGrade,
		callback = callback,
		exitCallback = exitCallback,
		hideMarker = hideMarker
	})
end