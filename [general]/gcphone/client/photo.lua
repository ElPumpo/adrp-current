-- Author: Xinerki (https://forum.fivem.net/t/release-cellphone-camera/43599)

phone = false

RegisterNetEvent('camera:open')
AddEventHandler('camera:open', function()
	CreateMobilePhone(1)
	CellCamActivate(true, true)
	phone = true
	PhonePlayOut()
end)

frontCam = false

function CellFrontCamActivate(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if phone then
			if IsControlJustPressed(0, 177) and phone then -- CLOSE PHONE
				DestroyMobilePhone()
				phone = false
				CellCamActivate(false, false)
				if firstTime then
					firstTime = false
					Citizen.Wait(2500)
					displayDoneMission = true
				end
			end
	
			if IsControlJustPressed(0, 27) and phone then -- SELFIE MODE
				frontCam = not frontCam
				CellFrontCamActivate(frontCam)
			end
	
			if phone then
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
			end
	
			ren = GetMobilePhoneRenderId()
			SetTextRenderId(ren)
	
			-- Everything rendered inside here will appear on your phone.
			SetTextRenderId(1) -- NOTE: 1 is default
		else
			Citizen.Wait(1000)
		end
	end
end)
