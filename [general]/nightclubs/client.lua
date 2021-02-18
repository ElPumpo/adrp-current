IsPlayerNearClub = false

function CreateDj(dj)
	if dj == "solomun" then
		model = "csb_sol"
	elseif dj == "dixon" then
		model = "csb_dix"
	end

	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(10)
	end

	local ped = CreatePed(26, model, -1604.664, -3012.583, -79.9999, 268.9422, false, false)
	SetEntityHeading(ped, 268.9422)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetModelAsNoLongerNeeded(model)

	return ped
end

function CleanUpInterior(interiorID)
	for k,v in pairs(interiorsProps) do
		if IsInteriorPropEnabled(interiorID, v) then
			DisableInteriorProp(interiorID, v)
			Wait(10)
		end
	end

	ReleaseScriptAudioBank()
	Wait(200)
	RefreshInterior(interiorID)
	UnpinInterior(interiorID)
end

function PrepareClubInterior(interiorID)
	for k,v in pairs(interiorsProps) do
		if not IsInteriorPropEnabled(interiorID, v) then
			EnableInteriorProp(interiorID, v)
			Wait(30)
		end
	end

	if DoesEntityExist(dj) then
		DeleteEntity(dj)
	end

	SetAmbientZoneState("IZ_ba_dlc_int_01_ba_Int_01_main_area", 0, 0)
	Wait(100)
	RefreshInterior(interiorID)
end

function TaskEnterNightClubGarage()
	Wait(100)
	interiorID = GetInteriorAtCoordsWithType(-1637.6218, -2989.1618, -77.5188, "ba_dlc_int_01_ba")

	if IsValidInterior(interiorID) then
		LoadInterior(interiorID)
		if IsInteriorReady(interiorID) then
			PrepareClubInterior(interiorID)
			if not DoesEntityExist(dj) then
				dj = CreateDj(current_dj)
			end

			if not IsPedInAnyVehicle(playerPed, false) then
				SetEntityCoords(playerPed, -1629.0, -3000.7, -78.1)
			else
				SetPedCoordsKeepVehicle(playerPed, -1629.0, -3000.7, -78.1)
			end

			DisplayRadar(false)
			SetEntityHeading(playerPed, 177.0)
		end
	end

	DoScreenFadeIn(200)
end

Citizen.CreateThread(function()
	DoScreenFadeIn(100)

	for k,v in pairs(locations) do
		if not IsIplActive(v["banner"]) then
			RequestIpl(v["banner"])
		end

		if not IsIplActive(v["barrier"]) then
			RequestIpl(v["barrier"])
		end
	end

	while true do
		Citizen.Wait(100)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)

		if not IsEntityDead(playerPed) then
			for k,v in pairs(locations) do
				local ix,iy,iz = table.unpack(v["markin"])
				local gix, giy, giz = table.unpack(v["garage_in"])
				local gox, goy, goz = table.unpack(v["garage_out"])
				local ox, oy, oz = table.unpack(v["markout"])

				if GetDistanceBetweenCoords(coords, gix, giy, giz, true) < 2.0 then
					if not IsScreenFadingOut() then
						DoScreenFadeOut(200)
					end
					TaskEnterNightClubGarage()
				end

				if GetDistanceBetweenCoords(coords, gox, goy, goz, true) < 3.0 then
					if not IsScreenFadedOut() then
						DoScreenFadeOut(200)
						Wait(250)
						CleanUpInterior(interiorID)
						local fex, fey, fez = table.unpack(v["garage_exit"])

						if not IsPedInAnyVehicle(playerPed, false) then
							SetEntityCoords(playerPed, fex, fey, fez-1.0)
						else
							SetPedCoordsKeepVehicle(playerPed, fex, fey, fez-1.0)
						end

						DisplayRadar(true)

						Wait(250)
						DoScreenFadeIn(300)
					end
				end

				if GetDistanceBetweenCoords(coords, ox, oy, oz, true) < 2.0 then
					if not IsScreenFadedOut() then
						DoScreenFadeOut(200)
						Wait(250)
						CleanUpInterior(interiorID)
						Wait(10)

						if k == k then
							local fex, fey, fez = table.unpack(v["exit"])
							SetEntityCoords(playerPed, fex, fey, fez-1.0)
							Wait(250)
							DoScreenFadeIn(300)
						end
					end
				end

				if GetDistanceBetweenCoords(coords, ix, iy, iz, true) < 1.0 then
					interiorID = GetInteriorAtCoordsWithType(-1604.664, -3012.583, -79.9999, "ba_dlc_int_01_ba")
					if IsValidInterior(interiorID) then
						LoadInterior(interiorID)
						if IsInteriorReady(interiorID) then
							PrepareClubInterior(interiorID)

							if not DoesEntityExist(dj) then
								dj = CreateDj(current_dj)
							end

							SetEntityCoords(playerPed,-1569.3452, -3014.5688, -74.4061, 1, false, 0, 1)
							SetEntityHeading(playerPed, 74.0804)

							SetGameplayCamRelativeHeading(12.1322)
							SetGameplayCamRelativePitch(-3.2652, 1065353216)

							DoScreenFadeIn(300)
							Wait(350)
						end
					end
				end
			end
		end
	end
end)