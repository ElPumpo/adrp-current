local drawCinema = false
local showUi = true
local width = 10

RegisterNetEvent('esx_cinema:toggleCinema')
AddEventHandler('esx_cinema:toggleCinema', function()
	TriggerEvent('ui:toggle', drawCinema)
	drawCinema = not drawCinema

	-- Restore
	if not drawCinema then
		Citizen.Wait(100)
		DisplayRadar(true)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if drawCinema then
			DrawRect(0.0, 0.0, width / 100, 0.2, 0, 0, 0, 255)
			DrawRect(0.0, 1.0, width / 100, 0.2, 0, 0, 0, 255)
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		if drawCinema then
			DisplayRadar(false)
			local screenW, screenH = GetScreenResolution()
			local height = 1080
			local ratio = screenW / screenH
			width = height * ratio
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_cinema:toggleUi')
AddEventHandler('esx_cinema:toggleUi', function()
	showUi = not showUi
	TriggerEvent('ui:toggle', showUi)
	TriggerEvent('toggleLabel', showUi)
end)