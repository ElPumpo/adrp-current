Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if visable then
			local sourcePed = PlayerPedId()
			local sourceCoords = GetEntityCoords(sourcePed)

			for _,id in ipairs(GetActivePlayers()) do
				local playerPed = GetPlayerPed(id)

				if playerPed ~= sourcePed then
					local playerCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.0, 1.3)
					local distance = #(sourceCoords - playerCoords)

					if distance < 15 and HasEntityClearLosToEntity(sourcePed, playerPed, 17) then
						ESX.Game.Utils.DrawText3D(playerCoords, GetPlayerServerId(id))
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)