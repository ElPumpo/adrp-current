local isSkinCreatorOpened = false
local heading = 332.2
local zoom = 'visage' -- Define which tab is shown first (Default: Head)
local cam

RegisterCommand('skin2', function()
	isSkinCreatorOpened = true
	SetSkinCreationMenuActive(true, 'Male') --TODO hardcoded as male

	startAsyncRestrictionLoop()
	SetEntityHeading(PlayerPedId(), heading)
end)

function startAsyncRestrictionLoop()
	local playerPed = PlayerPedId()
	SetPlayerInvincible(playerPed, true)
	FreezeEntityPosition(playerPed, true)

	while isSkinCreatorOpened do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(playerPed)

		DisableControlAction(2, 14, true)
		DisableControlAction(2, 15, true)
		DisableControlAction(2, 16, true)
		DisableControlAction(2, 17, true)
		DisableControlAction(2, 30, true)
		DisableControlAction(2, 31, true)
		DisableControlAction(2, 32, true)
		DisableControlAction(2, 33, true)
		DisableControlAction(2, 34, true)
		DisableControlAction(2, 35, true)
		DisableControlAction(0, 25, true)
		DisableControlAction(0, 24, true)
	
		if not DoesCamExist(cam) then
			cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
			SetCamCoord(cam, playerCoords)
			SetCamRot(cam, 0.0, 0.0, 0.0)
			SetCamActive(cam, true)
			RenderScriptCams(true, false, 0, true, true)
			SetCamCoord(cam, playerCoords)
		end

		if zoom == 'visage' or zoom == 'pilosite' then
			SetCamCoord(cam, playerCoords.x + 0.2, playerCoords.y + 0.5, playerCoords.z + 0.7)
			SetCamRot(cam, 0.0, 0.0, 150.0)
		elseif zoom == 'vetements' then
			SetCamCoord(cam, playerCoords.x + 0.3, playerCoords.y + 2.0, playerCoords.z + 0.0)
			SetCamRot(cam, 0.0, 0.0, 170.0)
		end
	end

	Citizen.Wait(500)

	FreezeEntityPosition(playerPed, false)
	SetPlayerInvincible(playerPed, false)
	SetSkinCreationMenuActive(false)

	RenderScriptCams(false, true, 500, true, true)
	SetCamActive(cam, false)
	DestroyCam(cam, true)
end

RegisterNUICallback('updateSkin', function(data)
	local creationComplete = data.value
	--TODO
	data.sex = 'Male'
	-- Face
	local dad = tonumber(data.dad)
	local mum = tonumber(data.mum)
	local dadmumpercent = tonumber(data.dadmumpercent)
	local skin = tonumber(data.skin)
	local eyecolor = tonumber(data.eyecolor)
	local acne = tonumber(data.acne)
	local skinproblem = tonumber(data.skinproblem)
	local freckle = tonumber(data.freckle)
	local wrinkle = tonumber(data.wrinkle)
	local wrinkleopacity = tonumber(data.wrinkleopacity)
	local hair = tonumber(data.hair)
	local haircolor = tonumber(data.haircolor)
	local eyebrow = tonumber(data.eyebrow)
	local eyebrowopacity = tonumber(data.eyebrowopacity)
	local beard = tonumber(data.beard)
	local beardopacity = tonumber(data.beardopacity)
	local beardcolor = tonumber(data.beardcolor)

	-- Clothes
	local hats = tonumber(data.hats)
	local glasses = tonumber(data.glasses)
	local ears = tonumber(data.ears)
	local tops = tonumber(data.tops)
	local pants = tonumber(data.pants)
	local shoes = tonumber(data.shoes)
	local watches = tonumber(data.watches)

	if creationComplete then
		local playerPed = PlayerPedId()
		local torso = GetPedDrawableVariation(playerPed, 3)
		local torsotext = GetPedTextureVariation(playerPed, 3)
		local leg = GetPedDrawableVariation(playerPed, 4)
		local legtext = GetPedTextureVariation(playerPed, 4)
		local shoes = GetPedDrawableVariation(playerPed, 6)
		local shoestext = GetPedTextureVariation(playerPed, 6)
		local accessory = GetPedDrawableVariation(playerPed, 7)
		local accessorytext = GetPedTextureVariation(playerPed, 7)
		local undershirt = GetPedDrawableVariation(playerPed, 8)
		local undershirttext = GetPedTextureVariation(playerPed, 8)
		local torso2 = GetPedDrawableVariation(playerPed, 11)
		local torso2text = GetPedTextureVariation(playerPed, 11)
		local prop_hat = GetPedPropIndex(playerPed, 0)
		local prop_hat_text = GetPedPropTextureIndex(playerPed, 0)
		local prop_glasses = GetPedPropIndex(playerPed, 1)
		local prop_glasses_text = GetPedPropTextureIndex(playerPed, 1)
		local prop_earrings = GetPedPropIndex(playerPed, 2)
		local prop_earrings_text = GetPedPropTextureIndex(playerPed, 2)
		local prop_watches = GetPedPropIndex(playerPed, 6)
		local prop_watches_text = GetPedPropTextureIndex(playerPed, 6)

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_skin:save', skin)
		end)

		isSkinCreatorOpened = false
	else
		SetPedDefaultComponentVariation(PlayerPedId())

		-- Face
		SetPedHeadBlendData			(PlayerPedId(), dad, mum, dad, skin, skin, skin, dadmumpercent * 0.1, dadmumpercent * 0.1, 1.0, true)
		SetPedEyeColor				(PlayerPedId(), eyecolor)
		if acne == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 0, acne, 0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 0, acne, 1.0)
		end
		SetPedHeadOverlay			(PlayerPedId(), 6, skinproblem, 1.0)
		if freckle == 0 then
			SetPedHeadOverlay		(PlayerPedId(), 9, freckle, 0.0)
		else
			SetPedHeadOverlay		(PlayerPedId(), 9, freckle, 1.0)
		end
		SetPedHeadOverlay       	(PlayerPedId(), 3, wrinkle, wrinkleopacity * 0.1)
		SetPedComponentVariation	(PlayerPedId(), 2, hair, 0, 2)
		SetPedHairColor				(PlayerPedId(), haircolor, haircolor)
		SetPedHeadOverlay       	(PlayerPedId(), 2, eyebrow, eyebrowopacity * 0.1)
		SetPedHeadOverlay       	(PlayerPedId(), 1, beard, beardopacity * 0.1)
		SetPedHeadOverlayColor  	(PlayerPedId(), 1, 1, beardcolor, beardcolor)
		SetPedHeadOverlayColor  	(PlayerPedId(), 2, 1, beardcolor, beardcolor)

		-- Clothes variations
		if hats == 0 then		ClearPedProp(PlayerPedId(), 0)
		elseif hats == 1 then	SetPedPropIndex(PlayerPedId(), 0, 3-1, 1-1, 2)
		elseif hats == 2 then	SetPedPropIndex(PlayerPedId(), 0, 3-1, 7-1, 2)
		elseif hats == 3 then	SetPedPropIndex(PlayerPedId(), 0, 4-1, 3-1, 2)
		elseif hats == 4 then	SetPedPropIndex(PlayerPedId(), 0, 5-1, 1-1, 2)
		elseif hats == 5 then	SetPedPropIndex(PlayerPedId(), 0, 5-1, 2-1, 2)
		elseif hats == 6 then	SetPedPropIndex(PlayerPedId(), 0, 6-1, 1-1, 2)
		elseif hats == 7 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 1-1, 2)
		elseif hats == 8 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 2-1, 2)
		elseif hats == 9 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 3-1, 2)
		elseif hats == 10 then	SetPedPropIndex(PlayerPedId(), 0, 8-1, 6-1, 2)
		elseif hats == 11 then	SetPedPropIndex(PlayerPedId(), 0, 11-1, 6-1, 2)
		elseif hats == 12 then	SetPedPropIndex(PlayerPedId(), 0, 10-1, 6-1, 2)
		elseif hats == 13 then	SetPedPropIndex(PlayerPedId(), 0, 11-1, 8-1, 2)
		elseif hats == 14 then	SetPedPropIndex(PlayerPedId(), 0, 10-1, 8-1, 2)
		elseif hats == 15 then	SetPedPropIndex(PlayerPedId(), 0, 13-1, 1-1, 2)
		elseif hats == 16 then	SetPedPropIndex(PlayerPedId(), 0, 13-1, 2-1, 2)
		elseif hats == 17 then	SetPedPropIndex(PlayerPedId(), 0, 14-1, 3-1, 2)
		elseif hats == 18 then	SetPedPropIndex(PlayerPedId(), 0, 15-1, 1-1, 2)
		elseif hats == 19 then	SetPedPropIndex(PlayerPedId(), 0, 15-1, 2-1, 2)
		elseif hats == 20 then	SetPedPropIndex(PlayerPedId(), 0, 16-1, 2-1, 2)
		elseif hats == 21 then	SetPedPropIndex(PlayerPedId(), 0, 16-1, 3-1, 2)
		elseif hats == 22 then	SetPedPropIndex(PlayerPedId(), 0, 21-1, 6-1, 2)
		elseif hats == 23 then	SetPedPropIndex(PlayerPedId(), 0, 22-1, 1-1, 2)
		elseif hats == 24 then	SetPedPropIndex(PlayerPedId(), 0, 26-1, 2-1, 2)
		elseif hats == 25 then	SetPedPropIndex(PlayerPedId(), 0, 27-1, 1-1, 2)
		elseif hats == 26 then	SetPedPropIndex(PlayerPedId(), 0, 28-1, 1-1, 2)
		elseif hats == 27 then	SetPedPropIndex(PlayerPedId(), 0, 35-1, 0, 2)
		elseif hats == 28 then	SetPedPropIndex(PlayerPedId(), 0, 56-1, 1-1, 2)
		elseif hats == 29 then	SetPedPropIndex(PlayerPedId(), 0, 56-1, 2-1, 2)
		elseif hats == 30 then	SetPedPropIndex(PlayerPedId(), 0, 56-1, 3-1, 2)
		elseif hats == 31 then	SetPedPropIndex(PlayerPedId(), 0, 77-1, 20-1, 2)
		elseif hats == 32 then	SetPedPropIndex(PlayerPedId(), 0, 97-1, 3-1, 2)
		end

		if glasses == 0 then		ClearPedProp(PlayerPedId(), 1)
		elseif glasses == 1 then	SetPedPropIndex(PlayerPedId(), 1, 4-1, 1-1, 2)
		elseif glasses == 2 then	SetPedPropIndex(PlayerPedId(), 1, 4-1, 10-1, 2)
		elseif glasses == 3 then	SetPedPropIndex(PlayerPedId(), 1, 5-1, 5-1, 2)
		elseif glasses == 4 then	SetPedPropIndex(PlayerPedId(), 1, 5-1, 10-1, 2)
		elseif glasses == 5 then	SetPedPropIndex(PlayerPedId(), 1, 6-1, 1-1, 2)
		elseif glasses == 6 then	SetPedPropIndex(PlayerPedId(), 1, 6-1, 9-1, 2)
		elseif glasses == 7 then	SetPedPropIndex(PlayerPedId(), 1, 8-1, 1-1, 2)
		elseif glasses == 8 then	SetPedPropIndex(PlayerPedId(), 1, 9-1, 2-1, 2)
		elseif glasses == 9 then	SetPedPropIndex(PlayerPedId(), 1, 10-1, 1-1, 2)
		elseif glasses == 10 then	SetPedPropIndex(PlayerPedId(), 1, 16-1, 7-1, 2)
		elseif glasses == 11 then	SetPedPropIndex(PlayerPedId(), 1, 18-1, 10-1, 2)
		elseif glasses == 12 then	SetPedPropIndex(PlayerPedId(), 1, 26-1, 1-1, 2)
		end

		if ears == 0 then		ClearPedProp(PlayerPedId(), 2)
		elseif ears == 1 then	SetPedPropIndex(PlayerPedId(), 2, 4-1, 1-1, 2)
		elseif ears == 2 then	SetPedPropIndex(PlayerPedId(), 2, 5-1, 1-1, 2)
		elseif ears == 3 then	SetPedPropIndex(PlayerPedId(), 2, 6-1, 1-1, 2)
		elseif ears == 4 then	SetPedPropIndex(PlayerPedId(), 2, 10-1, 2-1, 2)
		elseif ears == 5 then	SetPedPropIndex(PlayerPedId(), 2, 11-1, 2-1, 2)
		elseif ears == 6 then	SetPedPropIndex(PlayerPedId(), 2, 12-1, 2-1, 2)
		elseif ears == 7 then	SetPedPropIndex(PlayerPedId(), 2, 19-1, 4-1, 2)
		elseif ears == 8 then	SetPedPropIndex(PlayerPedId(), 2, 20-1, 4-1, 2)
		elseif ears == 9 then	SetPedPropIndex(PlayerPedId(), 2, 21-1, 4-1, 2)
		elseif ears == 10 then	SetPedPropIndex(PlayerPedId(), 2, 28-1, 1-1, 2)
		elseif ears == 11 then	SetPedPropIndex(PlayerPedId(), 2, 29-1, 1-1, 2)
		elseif ears == 12 then	SetPedPropIndex(PlayerPedId(), 2, 30-1, 1-1, 2)
		elseif ears == 13 then	SetPedPropIndex(PlayerPedId(), 2, 31-1, 1-1, 2)
		elseif ears == 14 then	SetPedPropIndex(PlayerPedId(), 2, 32-1, 1-1, 2)
		elseif ears == 15 then	SetPedPropIndex(PlayerPedId(), 2, 33-1, 1-1, 2)
		end

		local topOutfit, pantsOutfit

		if tops == 0 then
			topOutfit = Config[data.sex].Defaults.Tops
		else
			topOutfit = Config[data.sex].Tops[tops]
		end

		SetPedComponentVariation(PlayerPedId(), 3, topOutfit.torso[1], topOutfit.torso[2], topOutfit.torso[3])
		SetPedComponentVariation(PlayerPedId(), 7, topOutfit.accessory[1], topOutfit.accessory[2], topOutfit.accessory[3])
		SetPedComponentVariation(PlayerPedId(), 8, topOutfit.undershirt[1], topOutfit.undershirt[2], topOutfit.undershirt[3])
		SetPedComponentVariation(PlayerPedId(), 11, topOutfit.torso2[1], topOutfit.torso2[2], topOutfit.torso2[3])

		if pants == 0 then
			pantsOutfit = Config[data.sex].Defaults.Pants
		else
			pantsOutfit = Config[data.sex].Pants[pants]
		end

		SetPedComponentVariation(PlayerPedId(), 4, pantsOutfit.leg[1], pantsOutfit.leg[2], pantsOutfit.leg[3])

		if shoes == 0 then 	SetPedComponentVariation(PlayerPedId(), 6, 34, 0, 2)
		elseif shoes == 1 then	SetPedComponentVariation(PlayerPedId(), 6, 0, 10, 2)
		elseif shoes == 2 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 0, 2)
		elseif shoes == 3 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 1, 2)
		elseif shoes == 4 then	SetPedComponentVariation(PlayerPedId(), 6, 1, 3, 2)
		elseif shoes == 5 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 0, 2)
		elseif shoes == 6 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 6, 2)
		elseif shoes == 7 then	SetPedComponentVariation(PlayerPedId(), 6, 3, 14, 2)
		elseif shoes == 8 then	SetPedComponentVariation(PlayerPedId(), 6, 48, 0, 2)
		elseif shoes == 9 then	SetPedComponentVariation(PlayerPedId(), 6, 48, 1, 2)
		elseif shoes == 10 then SetPedComponentVariation(PlayerPedId(), 6, 49, 0, 2)
		elseif shoes == 11 then SetPedComponentVariation(PlayerPedId(), 6, 49, 1, 2)
		elseif shoes == 12 then SetPedComponentVariation(PlayerPedId(), 6, 5, 0, 2)
		elseif shoes == 13 then SetPedComponentVariation(PlayerPedId(), 6, 6, 0, 2)
		elseif shoes == 14 then SetPedComponentVariation(PlayerPedId(), 6, 7, 0, 2)
		elseif shoes == 15 then SetPedComponentVariation(PlayerPedId(), 6, 7, 9, 2)
		elseif shoes == 16 then SetPedComponentVariation(PlayerPedId(), 6, 7, 13, 2)
		elseif shoes == 17 then SetPedComponentVariation(PlayerPedId(), 6, 9, 3, 2)
		elseif shoes == 18 then SetPedComponentVariation(PlayerPedId(), 6, 9, 6, 2)
		elseif shoes == 19 then SetPedComponentVariation(PlayerPedId(), 6, 9, 7, 2)
		elseif shoes == 20 then SetPedComponentVariation(PlayerPedId(), 6, 10, 0, 2)
		elseif shoes == 21 then SetPedComponentVariation(PlayerPedId(), 6, 12, 0, 2)
		elseif shoes == 22 then SetPedComponentVariation(PlayerPedId(), 6, 12, 2, 2)
		elseif shoes == 23 then SetPedComponentVariation(PlayerPedId(), 6, 12, 13, 2)
		elseif shoes == 24 then SetPedComponentVariation(PlayerPedId(), 6, 15, 0, 2)
		elseif shoes == 25 then SetPedComponentVariation(PlayerPedId(), 6, 15, 1, 2)
		elseif shoes == 26 then SetPedComponentVariation(PlayerPedId(), 6, 16, 0, 2)
		elseif shoes == 27 then SetPedComponentVariation(PlayerPedId(), 6, 20, 0, 2)
		elseif shoes == 28 then SetPedComponentVariation(PlayerPedId(), 6, 24, 0, 2)
		elseif shoes == 29 then SetPedComponentVariation(PlayerPedId(), 6, 27, 0, 2)
		elseif shoes == 30 then SetPedComponentVariation(PlayerPedId(), 6, 28, 0, 2)
		elseif shoes == 31 then SetPedComponentVariation(PlayerPedId(), 6, 28, 1, 2)
		elseif shoes == 32 then SetPedComponentVariation(PlayerPedId(), 6, 28, 3, 2)
		elseif shoes == 33 then SetPedComponentVariation(PlayerPedId(), 6, 28, 2, 2)
		elseif shoes == 34 then SetPedComponentVariation(PlayerPedId(), 6, 31, 2, 2)
		elseif shoes == 35 then SetPedComponentVariation(PlayerPedId(), 6, 31, 4, 2)
		elseif shoes == 36 then SetPedComponentVariation(PlayerPedId(), 6, 36, 0, 2)
		elseif shoes == 37 then SetPedComponentVariation(PlayerPedId(), 6, 36, 3, 2)
		elseif shoes == 38 then SetPedComponentVariation(PlayerPedId(), 6, 42, 0, 2)
		elseif shoes == 39 then SetPedComponentVariation(PlayerPedId(), 6, 42, 1, 2)
		elseif shoes == 40 then SetPedComponentVariation(PlayerPedId(), 6, 42, 7, 2)
		elseif shoes == 41 then SetPedComponentVariation(PlayerPedId(), 6, 57, 0, 2)
		elseif shoes == 42 then SetPedComponentVariation(PlayerPedId(), 6, 57, 3, 2)
		elseif shoes == 43 then SetPedComponentVariation(PlayerPedId(), 6, 57, 8, 2)
		elseif shoes == 44 then SetPedComponentVariation(PlayerPedId(), 6, 57, 9, 2)
		elseif shoes == 45 then SetPedComponentVariation(PlayerPedId(), 6, 57, 10, 2)
		elseif shoes == 46 then SetPedComponentVariation(PlayerPedId(), 6, 57, 11, 2)
		elseif shoes == 47 then SetPedComponentVariation(PlayerPedId(), 6, 75, 4, 2)
		elseif shoes == 48 then SetPedComponentVariation(PlayerPedId(), 6, 75, 7, 2)
		elseif shoes == 49 then SetPedComponentVariation(PlayerPedId(), 6, 75, 8, 2)
		elseif shoes == 50 then SetPedComponentVariation(PlayerPedId(), 6, 77, 0, 2)
		end

		if watches == 0 then		ClearPedProp(PlayerPedId(), 6)
		elseif watches == 1 then	SetPedPropIndex(PlayerPedId(), 6, 1-1, 1-1, 2)
		elseif watches == 2 then	SetPedPropIndex(PlayerPedId(), 6, 2-1, 1-1, 2)
		elseif watches == 3 then	SetPedPropIndex(PlayerPedId(), 6, 4-1, 1-1, 2)
		elseif watches == 4 then	SetPedPropIndex(PlayerPedId(), 6, 4-1, 3-1, 2)
		elseif watches == 5 then	SetPedPropIndex(PlayerPedId(), 6, 5-1, 1-1, 2)
		elseif watches == 6 then	SetPedPropIndex(PlayerPedId(), 6, 9-1, 1-1, 2)
		elseif watches == 7 then	SetPedPropIndex(PlayerPedId(), 6, 11-1, 1-1, 2)
		end

		-- Unused yet
		-- These presets will be editable in V2 release
		SetPedHeadOverlay       	(PlayerPedId(), 4, 0, 0.0)   	-- Lipstick
		SetPedHeadOverlay       	(PlayerPedId(), 8, 0, 0.0) 		-- Makeup
		SetPedHeadOverlayColor  	(PlayerPedId(), 4, 1, 0, 0)      -- Makeup Color
		SetPedHeadOverlayColor  	(PlayerPedId(), 8, 1, 0, 0)      -- Lipstick Color
		SetPedComponentVariation	(PlayerPedId(), 1,  0,0, 2)    	-- Mask
	end
end)

RegisterNUICallback('rotateleftheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = currentHeading+tonumber(data.value)
	SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
	heading = currentHeading-tonumber(data.value)
	SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback('zoom', function(data)
	zoom = data.zoom
end)

function SetSkinCreationMenuActive(enable, sex)
	SetNuiFocus(enable, enable)

	if sex then
		local topList, pantsList = {}, {}

		for k,v in ipairs(Config[sex].Tops) do topList[k] = v.label end
		for k,v in ipairs(Config[sex].Pants) do pantsList[k] = v.label end
	
		SendNUIMessage({
			addItems = true,
			tops = topList,
			pants = pantsList
		})
	end

	SendNUIMessage({
		openSkinCreator = true,
		state = enable
	})
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if isSkinCreatorOpened then
			SetNuiFocus(false)
		end
	end
end)