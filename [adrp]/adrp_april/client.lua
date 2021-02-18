local soundList = {
	{'ERROR', 'HUD_AMMO_SHOP_SOUNDSET'},
	{"Turn", "DLC_HEIST_HACKING_SNAKE_SOUNDS"},
	{"GOLF_BIRDIE", "HUD_AWARDS"},
	{"Bed", "WastedSounds"},
	{"3_2_1", "HUD_MINI_GAME_SOUNDSET"},
	{"CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET"},
	{"WEAPON_AMMO_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"},
	{"WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"}
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsDisabledControlJustReleased(0, 0) and IsInputDisabled(0) then
			if not IsPedCuffed(PlayerPedId()) and not IsPedDeadOrDying(PlayerPedId(), true) then
				doSomething()
				Citizen.Wait(10000)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		SetFollowPedCamViewMode(4)
		DisableControlAction(0, 0, true)
	end
end)

function doSomething()
	math.randomseed(GetGameTimer())
	local what = math.random(1, 10)

	-- play random asset
	if what == 1 then
		local audioName, audioRef = getRandomSound()
		PlaySoundFrontend(-1, audioName, audioRef, false)

	-- black screen lol
	elseif what == 2 then
		DoScreenFadeOut(1)
		ShowLoadingPromt('Deleting character', 20000, 3)
		DoScreenFadeIn(1)

	-- drunk effects
	elseif what == 3 then
		SetPedMotionBlur(PlayerPedId(), true)
		SetTimecycleModifier("spectator5")
		Citizen.Wait(20000)
		SetPedMotionBlur(PlayerPedId(), false)
		ClearTimecycleModifier()

	-- char switch
	elseif what == 4 then
		SwitchOutPlayer(PlayerPedId(), 0, 1)
		while GetPlayerSwitchState() ~= 5 do
			Citizen.Wait(100)
		end

		Citizen.Wait(5000)
		SwitchInPlayer(PlayerPedId())
	-- spawn peds
	elseif what == 5 then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
		local forward   = GetEntityForwardVector(playerPed)
		local x, y, z   = table.unpack(coords + forward * 1.0)

		for i=0, 4 do
			spawnPed(1413662315, x,y,z)
		end
	end
end

function spawnPed(model, x, y, z)
	model = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))

	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end

	ped = CreatePed(5, model, x, y, z, 0.0, true, false)

	SetPedAsEnemy(ped, true)
end

function getRandomSound()
	math.randomseed(GetGameTimer() + GetGameplayCamFov())
	local sound = math.random(1, #soundList)
	sound = soundList[sound]

	return sound[1], sound[2]
end

function ShowLoadingPromt(msg, time, type)
	BeginTextCommandBusyString("STRING")
	AddTextComponentString(msg)
	EndTextCommandBusyString(type)
	Citizen.Wait(time)

	RemoveLoadingPrompt()
end