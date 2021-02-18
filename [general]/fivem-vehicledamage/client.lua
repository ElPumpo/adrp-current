local damageFactorEngine = 2.0					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
local damageFactorBody = 2.0					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
local damageFactorPetrolTank = 6.0				-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 64
local cascadingFailureSpeedFactor = 4.0			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8
local degradingHealthSpeedFactor = 8			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving.
local degradingFailureThreshold = 400.0			-- Below this value, slow health degradation will set in
local cascadingFailureThreshold = 195.0			-- Below this value, health cascading failure will set in
local engineSafeGuard = 100.0					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

local pedInCarLast=false
local healthEngineLast = 1000.0
local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyLast = 1000.0
local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankLast = 1000.0
local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0
local lastVehicleSpeed = 0
local vehicleSpeedDropLimit = 24
local vehicleSpeedDropDisableChance = 70
local vehiclePDSpeedDropDisableChance = 75

function isPedInVehicle()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(50)
		local ped = PlayerPedId()
		if isPedInVehicle() then
			vehicle = GetVehiclePedIsIn(ped, false)

			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthBodyLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * damageFactorEngine

			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * damageFactorBody

			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * damageFactorPetrolTank

			if healthEngineCurrent <= engineSafeGuard+1 then
				SetVehicleUndriveable(vehicle,true)
				SetThisVehicleUndriveable(vehicle, true, "engineHealthLowerThanSafeguard")
			end

			if pedInCarLast == true then
				local currentSpeed = GetEntitySpeed(vehicle) * 2.236936

				if lastVehicleSpeed - currentSpeed > vehicleSpeedDropLimit then
					local rand = math.random(1,100)
					local limit = vehicleSpeedDropDisableChance
					if isPDCar(vehicle) then
						limit = vehiclePDSpeedDropDisableChance
					end

					if rand > limit then
						SetThisVehicleUndriveable(vehicle, true, "speedDropDetected")
					end
				end

				-- Damage happened while in the car, can be multiplied

				-- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then

					-- Combine the delta values
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)

					-- If huge damage, scale back a bit
					if healthEngineCombinedDelta > (healthEngineCurrent - engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.4
					end

					-- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (cascadingFailureThreshold / 5)
					end

					------- Calculate new value

					healthEngineNew = healthEngineLast - healthEngineCombinedDelta


					------- Sanity Check on new values and further manipulations

					-- If somewhat damaged, slowly degrade until slightly before cascading failure sets in, then stop

					if healthEngineNew > (cascadingFailureThreshold + 5) and healthEngineNew < degradingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.038 * degradingHealthSpeedFactor)
					end

					-- If Damage is near catastrophic, cascade the failure
					if healthEngineNew < cascadingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.1 * cascadingFailureSpeedFactor)
					end

					-- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
					if healthEngineNew < engineSafeGuard then
						healthEngineNew = engineSafeGuard
					end

					-- Prevent Explosions
					if healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end

					-- Prevent negative body damage.
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else
				-- Just got in the vehicle. Damage can not be multiplied this round

				-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
				if healthBodyCurrent < cascadingFailureThreshold then
					healthBodyNew = cascadingFailureThreshold
				end
				pedInCarLast = true
			end

			-- set the actual new values
			if healthEngineNew ~= healthEngineCurrent then SetVehicleEngineHealth(vehicle, healthEngineNew) end
			if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

			-- Store current values, so we can calculate delta next time around
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
		else
			pedInCarLast = false
		end
	end
end)

function SetThisVehicleUndriveable(vehicle, bool, caller)
	DecorSetBool(vehicle, "undriveable", 1)
	SetVehicleUndriveable(vehicle, true)
	SetVehicleEngineOn(vehicle, false, false, true)
	--SetVehicleEngineHealth(vehicle, 0)
	SetVehicleEngineCanDegrade(vehicle, false)
end