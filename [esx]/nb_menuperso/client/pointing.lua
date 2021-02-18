local isPointingFinger = false
local keyPressed = false

local function startPointing()
	local playerPed = PlayerPedId()

	RequestAnimDict('anim@mp_point')
	while not HasAnimDictLoaded('anim@mp_point') do
		Citizen.Wait(0)
	end

	SetPedCurrentWeaponVisible(playerPed, 0, 1, 1, 1)
	SetPedConfigFlag(playerPed, 36, true)
	TaskMoveNetwork(playerPed, 'task_mp_pointing', 0.5, 0, 'anim@mp_point', 24)
	RemoveAnimDict('anim@mp_point')
end

local function stopPointing()
	local playerPed = PlayerPedId()
	Citizen.InvokeNative(0xD01015C7316AE176, playerPed, 'Stop')

	if not IsPedInjured(playerPed) then
		ClearPedSecondaryTask(playerPed)
	end
	if not IsPedInAnyVehicle(playerPed, 1) then
		SetPedCurrentWeaponVisible(playerPed, 1, 1, 1, 1)
	end
	SetPedConfigFlag(playerPed, 36, false)
	ClearPedSecondaryTask(playerPed)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()

		if not keyPressed then
			if IsControlPressed(0, 29) and IsInputDisabled(0) and not isPointingFinger and IsPedOnFoot(playerPed) then
				Citizen.Wait(200)
				if not IsPedCuffed(playerPed) then
					if not IsControlPressed(0, 29) then
						keyPressed = true
						startPointing()
						isPointingFinger = true
					else
						keyPressed = true
						while IsControlPressed(0, 29) do
							Citizen.Wait(50)
						end
					end
				end
			elseif IsControlPressed(0, 29) and not IsPedCuffed(playerPed) and isPointingFinger then
				keyPressed = true
				isPointingFinger = false
				stopPointing()
			end
		end

		if keyPressed then
			if not IsControlPressed(0, 29) then
				keyPressed = false
			end
		end

		local isPedPointing = Citizen.InvokeNative(0x921CE12C489C4C41, playerPed)

		if isPedPointing and not isPointingFinger then
			stopPointing()
		end

		if isPedPointing then
			if not IsPedOnFoot(playerPed) then
				stopPointing()
			else

				local camPitch = GetGameplayCamRelativePitch()

				if camPitch < -70.0 then
					camPitch = -70.0
				elseif camPitch > 42.0 then
					camPitch = 42.0
				end

				camPitch = (camPitch + 70.0) / 112.0
				local camHeading = GetGameplayCamRelativeHeading()
				local cosCamHeading = Cos(camHeading)
				local sinCamHeading = Sin(camHeading)
				if camHeading < -180.0 then
					camHeading = -180.0
				elseif camHeading > 180.0 then
					camHeading = 180.0
				end
				camHeading = (camHeading + 180.0) / 360.0

				local coords = GetOffsetFromEntityInWorldCoords(playerPed, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
				local rayHandle = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, playerPed, 7)
				local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

				SetTaskPropertyFloat(playerPed, 'Pitch', camPitch)
				SetTaskPropertyFloat(playerPed, 'Heading', camHeading * -1.0 + 1.0)
				SetTaskPropertyBool(playerPed, 'isBlocked', hit)
				SetTaskPropertyBool(playerPed, 'isFirstPerson', Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

			end
		end
	end
end)
