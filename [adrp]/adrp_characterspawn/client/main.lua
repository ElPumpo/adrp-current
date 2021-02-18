ESX = nil
local firstSpawn = true
local cam, cam2

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	initialize()
end)

function initialize()
	NetworkSetTalkerProximity(1.0)
	StartAudioScene('MP_LEADERBOARD_SCENE')
end

initialize()

AddEventHandler('playerSpawned', function(spawn)
	if firstSpawn then
		firstSpawn = false
		TriggerEvent('adrp_characterspawn:spawnFreeze')
		TriggerServerEvent('adrp_characterspawn:getCharacterData') -- todo rewrite

		SetEntityVisible(PlayerPedId(), false)
		SetPlayerInvincible(PlayerId(), true)

		StopAudioScene('MP_LEADERBOARD_SCENE')

		ShutdownLoadingScreenNui()
	end
end)

RegisterNetEvent('adrp_characterspawn:spawnFreeze')
AddEventHandler('adrp_characterspawn:spawnFreeze', function()
	local playerPed = PlayerPedId()

	FreezeEntityPosition(playerPed, true)
	TriggerEvent('ui:toggle', false, true)
	DisplayRadar(false)
	SetTimecycleModifier('hud_def_blur')

	cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', Config.IntroCoords, 300.00, 0.0, 0.0, 100.0, false, 0)
	SetCamActive(cam, true)
	RenderScriptCams(true, false, 1, true, true)
end)

RegisterNetEvent('adrp_characterspawn:setPosition')
AddEventHandler('adrp_characterspawn:setPosition', function(coords)
	local playerPed, setVoice = PlayerPedId(), true

	if not IsCamActive(cam) then
		setVoice = false -- the code only gets here if we trigger the event from eg ambulancejob
		FreezeEntityPosition(playerPed, true)
		TriggerEvent('ui:toggle', false, true)
		DisplayRadar(false)
		SetTimecycleModifier('hud_def_blur')

		cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', Config.IntroCoords, 300.00, 0.0, 0.0, 100.0, false, 0)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 1, true, true)
	end

	SetEntityVisible(playerPed, true)
	SetPlayerInvincible(PlayerId(), false)
	SetTimecycleModifier('default')
	--check job and teleport to starting position of job if away from job
	-- if GetDistanceBetweenCoords(Config.FishingSpot, false) < 30 then
	-- 	ESX.Game.Teleport(playerPed, Config.FishingDocks)
	-- else

	-- 	ESX.Game.Teleport(playerPed, coords)
	-- end
	ESX.Game.Teleport(playerPed, coords)
	FreezeEntityPosition(playerPed, false)
	DoScreenFadeIn(500)
	Citizen.Wait(500)

	cam2 = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', Config.IntroCoords, 300.0, 0.0, 0.0, 100.0, false, 0)
	PointCamAtCoord(cam2, coords.x, coords.y, coords.z + 200.0)
	SetCamActiveWithInterp(cam2, cam, 900, true, true)

	Citizen.Wait(900)

	cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y, coords.z + 200.0, 300.0, 0.0, 0.0, 100.0, false, 0)
	PointCamAtCoord(cam, coords.x, coords.y, coords.z + 2.0)
	SetCamActiveWithInterp(cam, cam2, 3700, true, true)

	Citizen.Wait(3700)

	PlaySoundFrontend(-1, 'Zoom_Out', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', true)
	RenderScriptCams(false, true, 500, true, true)
	PlaySoundFrontend(-1, 'CAR_BIKE_WHOOSH', 'MP_LOBBY_SOUNDS', true)
	FreezeEntityPosition(playerPed, false)

	Citizen.Wait(500)

	SetCamActive(cam, false)
	DestroyCam(cam, true)
	DisplayRadar(true)
	TriggerEvent('ui:toggle', true, true)

	if setVoice then
		NetworkSetTalkerProximity(10.0)
	end
end)

RegisterNUICallback('charAction', function(data, cb)
	ESX.TriggerServerCallback('adrp_characterspawn:executeAction', function(response)
		if data.action == 'selectCharacter' and response.success then
			SendNUIMessage({type = 'char', action = 'close'})
		end

		TriggerEvent('adrp_characterspawn:loadSkinAgain') -- todo rewrite/delete

		cb(response)
	end, data)
end)

-- todo rewrite/delete
RegisterNetEvent('adrp_characterspawn:loadSkinAgain')
AddEventHandler('adrp_characterspawn:loadSkinAgain', function()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if not skin then
			TriggerEvent('skinchanger:loadSkin', {sex = 0}, OpenSaveableMenu)
		else
			TriggerEvent('skinchanger:loadSkin', skin)
		end
	end)
end)

RegisterNUICallback('close', function()
	SetNuiFocus(false)
end)

RegisterNetEvent('adrp_characterspawn:openMenu')
AddEventHandler('adrp_characterspawn:openMenu', function(characterData)
	openMenu(characterData)
end)

function openMenu(data)
	SendNUIMessage({type = 'char', action = 'open', charData = data})
	SetNuiFocus(true, true)
end

RegisterNetEvent('adrp_characterspawn:restoreLoadout')
AddEventHandler('adrp_characterspawn:restoreLoadout', function(loadout)
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for i=1, #loadout, 1 do
		local weaponName = loadout[i].name
		local weaponHash = GetHashKey(weaponName)

		GiveWeaponToPed(playerPed, weaponHash, 0, false, false)
		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponHash)

		for j=1, #loadout[i].components, 1 do
			local weaponComponent = loadout[i].components[j]
			local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

			GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponHash, loadout[i].ammo)
			ammoTypes[ammoType] = true
		end
	end
end)