Citizen.CreateThread(function()
	local moveDict, moveOBbwd, moveOBfwd, moveOFbwdm, moveOFfwd, facing = 'move_crawl', 'onback_bwd', 'onback_fwd', 'onfront_bwd', 'onfront_fwd', 0
	local goProneDict, goProneAnim = 'get_up@directional@transition@prone_to_knees@crawl', 'front'
	local getUpDict, getUpAnim = 'get_up@directional@movement@from_knees@standard', 'getup_l_0'
	local runDiveDict, runDiveAnim = 'move_jump', 'dive_start_run'

	--Prone/Crawling around
	RequestAnimDict(moveDict)
	while not HasAnimDictLoaded(moveDict) do
		Citizen.Wait(100)
	end

	RequestAnimDict(goProneDict)
	while not HasAnimDictLoaded(goProneDict) do
		Citizen.Wait(100)
	end

	RequestAnimDict(getUpDict)
	while not HasAnimDictLoaded(getUpDict) do
		Citizen.Wait(100)
	end

	RequestAnimDict(runDiveDict)
	while not HasAnimDictLoaded(runDiveDict) do
		Citizen.Wait(100)
	end

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		-- Go Prone
		if IsControlJustReleased(0, 20) then
			if IsPauseMenuActive() then
				Citizen.Wait(500)
			elseif not IsInputDisabled(0) then
				Citizen.Wait(500)
			elseif not IsPedOnFoot(playerPed) then
				Citizen.Wait(500)
			elseif IsEntityDead(playerPed) then
				Citizen.Wait(500)
			elseif IsPedCuffed(playerPed) then
				Citizen.Wait(500)
			elseif onHandsUp then
				Citizen.Wait(500)
			else
				if not isCrouching then
					if not isProne then
						if IsPedRunning(playerPed) or IsPedSprinting(playerPed) then
							TaskPlayAnim(playerPed, runDiveDict, runDiveAnim, 4.0, 0, -1, 15, 1.0, false, true, false)
							Citizen.Wait(1250)
						end

						facing = GetEntityHeading(playerPed)
						isProne = true
						ClearPedTasks(playerPed)
						TaskPlayAnim(playerPed, moveDict, moveOFfwd, 8.0, 0.0, -1, 0, 1.0, false, true, false)
					elseif isProne then
						isProne = false
						isOnBack = false
						TaskPlayAnim(playerPed, getUpDict, getUpAnim, 8.0, 0.0, -1, 2, 0.0, false, false, false)
						Citizen.Wait(1875)
						ClearPedTasksImmediately(playerPed)
					end
				end
			end
		end

		DisableControlAction(0, 36, true) -- Duck

		-- Crouch
		if IsDisabledControlJustReleased(0, 36) then
			if IsPauseMenuActive() then
				Citizen.Wait(500)
			elseif not IsInputDisabled(0) then
				Citizen.Wait(500)
			elseif not IsPedOnFoot(playerPed) then
				Citizen.Wait(500)
			elseif IsEntityDead(playerPed) then
				Citizen.Wait(500)
			elseif IsPedCuffed(playerPed) then
				Citizen.Wait(500)
			elseif onHandsUp then
				Citizen.Wait(500)
			else
				RequestAnimSet('move_ped_crouched')
				while not HasAnimSetLoaded('move_ped_crouched') do
					Citizen.Wait(100)
				end

				RequestAnimSet('move_m@casual@d')
				while not HasAnimSetLoaded('move_m@casual@d') do
					Citizen.Wait(100)
				end

				if isCrouching then
					SetPedMovementClipset(playerPed, 'move_m@casual@d', 0.45)
					isCrouching = false
					Citizen.CreateThread(function()
						Citizen.Wait(800)
						resetWalk()
					end)
				elseif not isCrouching then
					SetPedMovementClipset(playerPed, 'move_ped_crouched', 0.45)
					isCrouching = true
				end
			end
		end

		if isProne then
			if IsControlPressed(0,34) then
				facing = facing + 2.0

				if facing >= 360 then
					facing = 0
				end

				SetEntityHeading(playerPed, facing)
			end

			if IsControlPressed(0,9) then
				facing = facing - 2.0

				if facing <= 0 then
					facing = 360
				end

				SetEntityHeading(playerPed, facing)
			end

			if IsControlJustPressed(0,21) then -- SHIFT
				if isOnBack then
					isOnBack = false
					TaskPlayAnim(playerPed, moveDict, moveOFfwd, 8.0, 1, -1, 2, 1.0, false, true, false)
				else
					isOnBack = true
					TaskPlayAnim(playerPed, moveDict, moveOBbwd, 8.0, 1, -1, 2, 1.0, false, true, false)
				end
			end

			if isOnBack then
				if IsControlPressed(0,32) then
					TaskPlayAnim(playerPed, moveDict, moveOBfwd, 8.0, 1, -1, 2, 0.0, false, false, false)
					Citizen.Wait(1100)
				end

				if IsControlPressed(0,8) then
					TaskPlayAnim(playerPed, moveDict, moveOBbwd, 8.0, 1, -1, 2, 0.0, false, false, false)
					Citizen.Wait(1100)
				end
			end

			if not isOnBack then
				if IsControlPressed(0, 32) then
					TaskPlayAnim(playerPed, moveDict, moveOFfwd, 8.0, 1, -1, 2, 0.0, false, false, false)
					Citizen.Wait(750)
				end

				if IsControlPressed(0, 8) then
					TaskPlayAnim(playerPed, moveDict, moveOFbwd, 8.0, 1, -1, 2, 0.0, false, false, false)
					Citizen.Wait(950)
				end
			end
		end
	end
end)
