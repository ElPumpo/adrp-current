-- No need to modify any of this, but I tried to document what it's doing
local isBlackedOut = false
local oldBodyDamage = 0
local oldSpeed = 0

local function blackout()
	-- Only blackout once to prevent an extended blackout if both speed and damage thresholds were met
	if not isBlackedOut then
		isBlackedOut = true
		TriggerEvent('ui:toggle', false, true)

		Citizen.CreateThread(function()
			DoScreenFadeOut(100)

			while not IsScreenFadedOut() do
				Citizen.Wait(0)
			end
			Citizen.Wait(5000)
			DoScreenFadeIn(250)
			isBlackedOut = false

			TriggerEvent('ui:toggle', true)
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		-- Get the vehicle the player is in, and continue if it exists
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if DoesEntityExist(vehicle) then
			local currentSpeed = GetEntitySpeed(vehicle) * 2.23
			-- If the speed changed, see if it went over the threshold and blackout if necesary
			if currentSpeed ~= oldSpeed then
				if not isBlackedOut and (currentSpeed < oldSpeed) and ((oldSpeed - currentSpeed) >= 75) then
					blackout()
				end
				oldSpeed = currentSpeed
			end
		else
			oldBodyDamage = 0
			oldSpeed = 0
		end

		if isBlackedOut then
			DisableAllControlActions(0)
		end
	end
end)
