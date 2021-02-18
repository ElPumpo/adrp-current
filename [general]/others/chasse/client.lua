DecorRegister('Seatbelt', 2)
DecorSetBool(PlayerPedId(), 'Seatbelt', false)

local speedBuffer = {}
local velBuffer = {}
local wasInCar = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()

		if IsPedJumping(playerPed) and IsPedRunning(playerPed) then
			if math.random(1, 5) >= 4 then
				SetPedToRagdoll(playerPed, 250, 250, 0, false, false, false)
			end
		elseif DecorGetBool(playerPed, 'Seatbelt') then
			DisableControlAction(0, 75)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('customNotification')
AddEventHandler('customNotification', function(msg, time)
	TriggerEvent('pNotify:SendNotification', { theme = 'gta', text = ''.. msg .. '', layout = 'centerRight', type = 'info', timeout = time or 5000, animation = {open = 'gta_effects_open_left', close = 'gta_effects_close_left'} } )
end)

local enableCruise = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local inVehicle = IsPedSittingInAnyVehicle(playerPed)

		if inVehicle then
			if IsControlJustReleased(0, Keys['Z']) and IsInputDisabled(0) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local speed = GetEntitySpeed(vehicle)

				if inVehicle and GetPedInVehicleSeat(vehicle, -1) == playerPed then
					if not enableCruise then
						SetEntityMaxSpeed(vehicle, speed)
						TriggerEvent('pNotify:SendNotification', {text = 'Cruise control enabled', type = 'info', queue = 'left', timeout = 3000, layout = 'centerRight'})
						enableCruise = true
					else
						SetEntityMaxSpeed(vehicle, 1000.0)
						TriggerEvent('pNotify:SendNotification', {text = 'Cruise control disabled', type = 'info', queue = 'left', timeout = 3000, layout = 'centerRight'})
						enableCruise = false
					end
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local playerPed = PlayerPedId()
		local inVehicle = IsPedSittingInAnyVehicle(playerPed)

		if not inVehicle then
			Citizen.Wait(500)
		end

		if not inVehicle and enableCruise then
			enableCruise = false
		end

		if not enableCruise then
			if inVehicle then
				local veh = GetVehiclePedIsUsing(playerPed, false)

				if GetVehicleClass(veh) == 18 then
					SetEntityMaxSpeed(veh, 80.9968) -- 160 mph
				elseif GetVehicleClass(veh) == 0 then
					SetEntityMaxSpeed(veh, 1000.0) -- 115mph compacts
				elseif GetVehicleClass(veh) == 1 then
					SetEntityMaxSpeed(veh, 51.4096) -- 115mph sedans
				elseif GetVehicleClass(veh) == 2 then
					SetEntityMaxSpeed(veh, 51.4096) -- 115mph suv
				elseif GetVehicleClass(veh) == 3 then
					SetEntityMaxSpeed(veh, 53.6448) -- 115mph coupes
				elseif GetVehicleClass(veh) == 4 then
					SetEntityMaxSpeed(veh, 58.1152) -- 130mph muscle
				elseif GetVehicleClass(veh) == 5 then
					SetEntityMaxSpeed(veh, 62.5111) -- 140mph sports classics
				elseif GetVehicleClass(veh) == 6 then
					SetEntityMaxSpeed(veh, 62.5111) -- 140mph sports
				elseif GetVehicleClass(veh) == 7 then
					SetEntityMaxSpeed(veh, 75.9968)
				elseif GetVehicleClass(veh) == 8 then
					SetEntityMaxSpeed(veh, 80.4711) -- 180mph motorcycles
				elseif GetVehicleClass(veh) == 15 then
					SetEntityMaxSpeed(veh, 1000.0) -- 200mph CHOPP
				elseif GetVehicleClass(veh) == 19 then
					SetEntityMaxSpeed(veh, 1000.0) -- 200mph CHOPP
				elseif GetVehicleClass(veh) == 16 then
					SetEntityMaxSpeed(veh, 1000.0) -- 200mph CHOPP
				else
					SetEntityMaxSpeed(veh, 51.4096)
				end
			end
		end
	end
end)

local beltNotification = false

Citizen.CreateThread(function()
	Citizen.Wait(100)

	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and (wasInCar or isVehicleValid(vehicle)) then
			if not beltNotification then
				TriggerEvent('customNotification', 'Click It or Ticket! Press <span style="color:#00ea1b">Ctrl+S</span> to toggle your seatbelt')
				beltNotification = true
			end
			wasInCar = true
			speedBuffer[2] = speedBuffer[1]
			speedBuffer[1] = GetEntitySpeed(vehicle)
			if speedBuffer[2] ~= nil and GetEntitySpeedVector(vehicle, true).y > 1.0 and speedBuffer[2] > 18.00 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[2] * 0.465) and DecorGetBool(PlayerPedId(), 'Seatbelt') == false then
				local playerCoords = GetEntityCoords(playerPed)
				local fw = Fwv(playerPed)
				SetEntityCoords(playerPed, playerCoords.x + fw.x, playerCoords.y + fw.y, playerCoords.z - 0.47, true, true, true)
				SetEntityVelocity(playerPed, velBuffer[2].x-10/2, velBuffer[2].y-10/2, velBuffer[2].z-10/4)
				Citizen.Wait(1)
				SetPedToRagdoll(playerPed, 1000, 1000, 0, false, false, false)
			end
			velBuffer[2] = velBuffer[1]
			velBuffer[1] = GetEntityVelocity(vehicle)

			local actionTime = 1
			local timeWaited = 0
			local timeIncrement = .01
			local checkTime = 10 -- in milli
			local lastCheckTime = GetGameTimer()
			if IsControlPressed(1, 224) and IsControlJustPressed(1, 8) then
				while timeWaited < actionTime do
					Citizen.Wait(1)
					if GetGameTimer() > lastCheckTime + checkTime then
						timeWaited = timeWaited + timeIncrement
						lastCheckTime = GetGameTimer()
					end
					drawProgressBar(timeWaited / actionTime, 0, -0.05, 1, 176, 240, 'Using seatbelt')
				end
				if not DecorGetBool(playerPed, 'Seatbelt') then
					DecorSetBool(playerPed, 'Seatbelt', true)
					TriggerEvent('mecommand', 'has put on their seatbelt')
					TriggerEvent('customNotification', 'Seatbelt <span style="color:#00ea1b">buckled!</span>')
				else
					DecorSetBool(playerPed, 'Seatbelt', false)
					TriggerEvent('mecommand', 'has taken off their seatbelt')
					TriggerEvent('customNotification', 'Seatbelt <span style="color:red">un-buckled!</span>')
				end
			end
		elseif wasInCar then
			wasInCar = false
			DecorSetBool(playerPed, 'Seatbelt', false)
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
		end
	end
end)

function isVehicleValid(vehicle)
	local vc = GetVehicleClass(vehicle)

	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function drawProgressBar(completion, xoffset, yoffset, r, g, b, text)
	if xoffset == nil then
		xoffset = 0
	end

	if yoffset == nil then
		yoffset = 0
	end

	local percentage = 100 * completion
	local width = 0.0014 * percentage
	local progressBar = {
		x = 0.016 + xoffset,
		y = 0.8 + yoffset,
		width = 0.3,
		height = 0.009,
	}

	--x, y, width, height, r, g, b, a
	DrawRect(progressBar.x + 0.07, progressBar.y, 0.143, progressBar.height + .004, 0, 0, 0, 60)
	DrawRect(progressBar.x + (width/2), progressBar.y, width, progressBar.height, r, g, b, 200)
	drawTxt2(progressBar.x + (width/2) + 0.06, progressBar.y - 0.01, width, progressBar.height,0.10, percentage..' %', 255,255,255, 255)
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(0)
	SetTextScale(0.23, 0.23)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function Fwv(entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end

	hr = hr * 0.0174533

	return {
		x = math.cos(hr) * 2.0,
		y = math.sin(hr) * 2.0
	}
end

local enableCurser = false

RegisterNetEvent('enableCurser')
AddEventHandler('enableCurser', function(newState)
	enableCurser = newState
end)

local trafficDensity = 0.1
local pedDensity = 0.1

RegisterNetEvent('esx:setTraffic')
AddEventHandler('esx:setTraffic', function(density)
	trafficDensity = tonumber(density)
end)

RegisterNetEvent('esx:setPeds')
AddEventHandler('esx:setPeds', function(density)
	pedDensity = tonumber(density)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if not IsAimCamActive() or not IsFirstPersonAimCamActive() and not enableCurser then
			HideHudComponentThisFrame(14)
		end

		if IsPedInAnyVehicle(playerPed, false) then
			RemoveSeatShuffle(playerPed)
		end

		SetVehicleDensityMultiplierThisFrame(trafficDensity) -- set traffic density to 0
		SetPedDensityMultiplierThisFrame(pedDensity) -- set npc/ai peds density to 0
		SetRandomVehicleDensityMultiplierThisFrame(trafficDensity) -- set random vehicles (car scenarios / cars driving off from a parking spot etc.) to 0
	end
end)

function RemoveSeatShuffle(playerPed)
	local vehicle = GetVehiclePedIsIn(playerPed, false)

	if GetPedInVehicleSeat(vehicle, 0) == playerPed then
		if GetIsTaskActive(playerPed, 165) then
			SetPedIntoVehicle(playerPed, vehicle, 0)
		end
	end
end