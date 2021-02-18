local inBed, lastCoords = false, {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local closestBed = getEntityInfrontOfEntity(playerPed)
		local playerCoords = GetEntityCoords(playerPed)

		if closestBed and not inBed and IsPedOnFoot(playerPed) then
			if IsControlJustReleased(0, 38) then
				inBed, lastCoords = true, {x = playerCoords.x, y = playerCoords.y, z = playerCoords.z}
				local coords = GetEntityCoords(closestBed)
				local heading = GetEntityHeading(closestBed)

				ESX.Game.Teleport(playerPed, {
					x = coords.x,
					y = coords.y,
					z = coords.z
				}, function()
					SetEntityHeading(playerPed, heading)

					local lib, anim = 'amb@world_human_sunbathe@male@back@idle_a', 'idle_a'
					ESX.Streaming.RequestAnimDict(lib, function()
						TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
					end)

					startBedHelper(closestBed)
				end)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

function startBedHelper(bedEntity)
	Citizen.CreateThread(function()
		local lib, anim = 'amb@world_human_sunbathe@male@back@idle_a', 'idle_a'

		while inBed do
			Citizen.Wait(1000)
			local playerPed = PlayerPedId()

			if not inBed then
				break
			end

			if not DoesEntityExist(bedEntity) then
				inBed, lastCoords = false, nil
				ClearPedTasks(playerPed)
			end

			if GetEntityHealth(playerPed) == 0 then
				inBed, lastCoords = false, nil
				ClearPedTasks(playerPed)
			end

			local distance = #(GetEntityCoords(playerPed) - GetEntityCoords(bedEntity))
	
			if distance > 3 then
				inBed, lastCoords = false, nil
				ClearPedTasks(playerPed)
			end

			if IsEntityPlayingAnim(playerPed, lib, anim, 3) ~= 1 then
				ESX.Streaming.RequestAnimDict(lib, function()
					TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
				end)
			end
		end
	end)

	Citizen.CreateThread(function()
		local form, timeHeld = setupScaleform('INSTRUCTIONAL_BUTTONS'), 0

		while inBed do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1

				if timeHeld > 60 then
					local playerPed = PlayerPedId()
					ESX.Game.Teleport(playerPed, lastCoords)

					inBed, lastCoords = false, nil
					ClearPedTasks(playerPed)
				end
			else
				timeHeld = 0
			end
		end
	end)
end

function getEntityInfrontOfEntity(entity)
	local playerCoords = GetEntityCoords(entity)
	local inDirection = GetOffsetFromEntityInWorldCoords(entity, 0.0, 1.0, 0.0)
	local rayHandle = StartShapeTestRay(playerCoords, inDirection, 16, entity, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and isEntityValidBed(entityHit) then
		ESX.Game.Utils.DrawText3D({
			x = endCoords.x,
			y = endCoords.y,
			z = endCoords.z
		}, '~y~[E]~s~ Bed', 0.6)

		return entityHit
	else
		return false
	end
end

function isEntityValidBed(entityHit)
	local modelHash = GetEntityModel(entityHit)
	local valid = false

	for _,hash in ipairs(Config.ValidBeds) do
		if hash == modelHash then
			valid = true
		end
	end

	return valid
end

function setupScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	BeginScaleformMovieMethod(scaleform, 'CLEAR_ALL')
	EndScaleformMovieMethod()
		
	BeginScaleformMovieMethod(scaleform, 'SET_CLEAR_SPACE')
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'SET_DATA_SLOT')
	ScaleformMovieMethodAddParamInt(0)
	PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(0, 38, true))
	BeginTextCommandScaleformString('STRING')
	AddTextComponentScaleform('Hold to leave bed')
	EndTextCommandScaleformString()
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'DRAW_INSTRUCTIONAL_BUTTONS')
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'SET_BACKGROUND_COLOUR')
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(80)
	EndScaleformMovieMethod()

	return scaleform
end