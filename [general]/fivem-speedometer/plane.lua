function DrawFlightInstruments(playerPed)
	local vehicle = GetVehiclePedIsIn(playerPed)
	local speed = GetEntitySpeed(vehicle) * 1.943844492
	local altitude = GetEntityCoords(playerPed).z * 3.28084
	local heading = GetEntityHeading(vehicle)
	local verticalSpeed = GetEntityVelocity(vehicle).z * 196.850394

	if speed < 40 then speed = 20 end
	if speed > 200 then speed = 200 end
	if altitude < 0 then altitude = 0 end
	if verticalSpeed > 2000 then verticalSpeed = 2000 elseif verticalSpeed < -2000 then verticalSpeed = -2000 end

	DrawSprite('flightinstruments', 'speedometer', 0.9, 0.9, 0.08, 0.08*1.77777778, 0, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'speedometer_needle', 0.9, 0.9, 0.08, 0.08*1.77777778, ((speed-20)/20)*36, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'altimeter', 0.80, 0.9, 0.08, 0.08*1.77777778, 0, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'altimeter-needle100', 0.80, 0.9, 0.08, 0.08*1.77777778, altitude/100*36, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'altimeter-needle1000', 0.80, 0.9, 0.08, 0.08*1.77777778, altitude/1000*36, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'altimeter-needle10000', 0.80, 0.9, 0.08, 0.08*1.77777778, altitude/10000*36, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'heading', 0.70, 0.9, 0.08, 0.08*1.77777778, 0, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'heading_needle', 0.70, 0.9, 0.08, 0.08*1.77777778, heading, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'verticalspeedometer', 0.60, 0.9, 0.08, 0.08*1.77777778, 0, 255, 255, 255, 255)
	DrawSprite('flightinstruments', 'verticalspeedometer_needle', 0.60, 0.9, 0.08, 0.08 * 1.77777778, 270 + (verticalSpeed / 1000 * 90), 255, 255, 255, 255)
end

Citizen.CreateThread(function()
	if not HasStreamedTextureDictLoaded('flightinstruments') then
		RequestStreamedTextureDict('flightinstruments', true)
		while not HasStreamedTextureDictLoaded('flightinstruments') do
			Citizen.Wait(500)
		end
	end

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if (IsPedInAnyPlane(playerPed) or IsPedInAnyHeli(playerPed)) and not overwriteAlpha then
			DrawFlightInstruments(playerPed)
		else
			Citizen.Wait(1000)
		end
	end
end)