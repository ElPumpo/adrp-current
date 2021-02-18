local golfhole = 0
local golfstrokes = 0
local totalgolfstrokes = 0
local golfplaying = false

-- ballstate, 1 = in hole, 0 out of hole.
local ballstate = 1
local balllocation = 0

-- golfstate, 2 on ball ready to swing, 1 free roam
local golfstate = 1

-- 0 for putter, 1 iron, 2 wedge, 3 driver.
local golfclub = 1

-- am i in idle loop mode
local inLoop = false
local inTask = false
local power = 0.1
-- golfball object, only used while hitting.
local mygolfball = 0

local golfCourseCoords = vector3(-1332.7, 128.1, 56.5)

local doingdrop = false
local clubname = 'None'
local attachedProp

AddEventHandler('beginGolf', function()
	startGolf()
end)

AddEventHandler('beginGolfHud', function()
	startGolfHud()
end)

Citizen.CreateThread(function()
	local golfBlip = AddBlipForCoord(golfCourseCoords)

	SetBlipSprite(golfBlip, 358)
	SetBlipColour(golfBlip, 68)
	SetBlipAsShortRange(golfBlip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Golf Course')
	EndTextCommandSetBlipName(golfBlip)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local distance = #(playerCoords - golfCourseCoords)
		local letSleep = true

		if distance > 500 and golfplaying then
			TriggerEvent('fivem-golf:notification', 'You have abandoned the golf course.')
			endgame()
		end

		if distance < 50 then
			letSleep = false
			DrawMarker(0, golfCourseCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 519, 0, 105, false, false, 2, false, nil, nil, false)

			if distance < 1.5 then
				if golfplaying then
					DisplayHelpText('Press ~g~~INPUT_CONTEXT~~s~ to end golf.')
				else
					DisplayHelpText('Press ~g~~INPUT_CONTEXT~~s~ to play ~y~Golf~s~ for ~g~$100~s~.')
				end

				if IsControlJustReleased(0, 38) then
					if golfplaying then
						endgame()
					else
						spawnCart()
						startGolf() -- If you plan to have it cost money, you need to remove this and only call it when they paid
						TriggerEvent('fivem-golf:notification', 'Press E to swing, A-D to rotate, Y to swap club.')
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function spawnCart()
	local vehicle = GetHashKey('caddy')
	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Citizen.Wait(0)
	end

	local spawned_car = CreateVehicle(vehicle, golfCourseCoords, 180.0, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetPedIntoVehicle(PlayerPedId(), spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
end

function DisplayHelpText(str)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(str)
	EndTextCommandDisplayHelp(0, 0, 0, -1)
end

function startGolfHud()
	while golfplaying do
		Citizen.Wait(0)
		DrawRect(0.5,0.93,0.2,0.04,0,0,0,140) -- header

		if golfhole ~= 0 then
			local distance = math.ceil(#(GetEntityCoords(mygolfball) - Config.Holes[golfhole].endCoords))
			local text = ('%s~r~ - ~s~%s~r~ - ~s~%s~r~ - ~s~%s M'):format(golfstrokes, totalgolfstrokes, clubname, distance)
			drawGolfTxt(0.9193, 1.391, 1.0,1.0,0.4, text, 255, 255, 255, 255)
		end
	end
end

function startGolf()
	StopAllScreenEffects()
	inTask = false
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	golfplaying = true
	TriggerEvent('beginGolfHud')

	Citizen.CreateThread(function()
		while golfplaying do
			Citizen.Wait(1000)

			if ballstate == 1 then
				golfhole = golfhole + 1
				if golfhole == 10 then
					endgame()
				else
					startHole()
				end
			else
				if golfstate == 2 and not inTask and not doingdrop then
					idleShot()
				elseif golfstate == 1 and not inTask and not doingdrop then
					MoveToBall()
				end
			end
		end

		if spawned_car and DoesEntityExist(spawned_car) then
			DeleteVehicle(spawned_car)
		end
	end)
end

function rotateShot(moveType)
	local curHeading = GetEntityHeading(mygolfball)

	if curHeading >= 360.0 then
		curHeading = 0.0
	end

	if moveType then
		SetEntityHeading(mygolfball, curHeading - 0.7)
	else
		SetEntityHeading(mygolfball, curHeading + 0.7)
	end
end

function createBall(x,y,z)
	DeleteObject(mygolfball)
	mygolfball = CreateObject(GetHashKey('prop_golf_ball'), x, y, z, true, false, true)
	SetEntityRecordsCollisions(mygolfball,true)
	addBallBlip()
	SetEntityCollision(mygolfball, true, true)
	SetEntityHasGravity(mygolfball, true)
	FreezeEntityPosition(mygolfball, true)
	local curHeading = GetEntityHeading(PlayerPedId())
	SetEntityHeading(mygolfball, curHeading)
end

function endgame()
	TriggerEvent('fivem-golf:destroyProp')
	if startblip then
		RemoveBlip(startblip)
		RemoveBlip(endblip)
	end
	if ballBlip then
		RemoveBlip(ballBlip)
	end
	removeAttachedProp()
	DeleteObject(mygolfball)
	golfhole = 0
	golfstrokes = 0
	golfplaying = false
	ballstate = 1
	balllocation = 0
	golfstate = 1
	golfclub = 1
	inLoop = false
	inTask = false
end

function MoveToBall()
	while golfstate == 1 do
		Citizen.Wait(0)

		if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			local ballCoords = GetEntityCoords(mygolfball)
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - ballCoords)

			if distance < 50.0 then
				DisplayHelpText('Move to your ball, press ~g~E~s~ to ball drop if you are stuck.')
				if IsControlJustReleased(0, 38) then
					dropShot()
				end

				if distance < 5.0 and not doingdrop then
					golfstate = 2
					ballstate = 0
				end
			end
		end
	end
end

function endShot()
	TriggerEvent('fivem-golf:attachItem','golfbag01')
	inTask = false
	golfstrokes = golfstrokes + 1

	local distance = #(GetEntityCoords(mygolfball) - Config.Holes[golfhole].endCoords)

	if distance < 1.5 then
		TriggerEvent('fivem-golf:notification','You got the ball with in range!')
		totalgolfstrokes = golfstrokes + totalgolfstrokes
		golfstrokes = 0
		ballstate = 1
	end

	if golfstrokes > 12 then
		TriggerEvent('fivem-golf:notification','You took too many shots..')
		totalgolfstrokes = golfstrokes + totalgolfstrokes
		golfstrokes = 0
		ballstate = 1
	end
end

function dropShot()
	doingdrop = true

	while doingdrop do
		Citizen.Wait(0)

		local playerCoords = GetEntityCoords(PlayerPedId())
		local distance = #(playerCoords- GetEntityCoords(mygolfball))
		local distanceHole = #(playerCoords - Config.Holes[golfhole].endCoords)

		if distance < 50.0 and distanceHole > 50.0 then
			DisplayHelpText('Press ~g~E~s~ to drop here.')

			if IsControlJustReleased(0, 38) then
				doingdrop = false
				x,y,z = table.unpack(playerCoords)
				createBall(x,y,z-1)
				golfstrokes = golfstrokes + 1
			end
		else
			DisplayHelpText('Press ~g~E~s~ to drop - ~r~ too far from ball or to close to hole.')
		end
	end
end

function attachClub()
	if golfclub == 3 then
		TriggerEvent('fivem-golf:attachItem','golfdriver01')
		clubname = 'Wood'
	elseif golfclub == 2 then
		TriggerEvent('fivem-golf:attachItem','golfwedge01')
		clubname = 'Wedge'
	elseif golfclub == 1 then
		TriggerEvent('fivem-golf:attachItem','golfiron01')
		clubname = '1 Iron'
	elseif golfclub == 4 then
		TriggerEvent('fivem-golf:attachItem','golfiron03')
		clubname = '3 Iron'
	elseif golfclub == 5 then
		TriggerEvent('fivem-golf:attachItem','golfiron05')
		clubname = '5 Iron'
	elseif golfclub == 6 then
		TriggerEvent('fivem-golf:attachItem','golfiron07')
		clubname = '7 Iron'
	else
		TriggerEvent('fivem-golf:attachItem','golfputter01')
		clubname = 'Putter'
	end
end

function addBallBlip()
	ballBlip = AddBlipForEntity(mygolfball)

	SetBlipSprite(ballBlip, 161)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Ball')
	EndTextCommandSetBlipName(ballBlip)
end

function drawGolfTxt(x,y, width, height, scale, text, r,g,b,a)
	SetTextFont(2)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.025)
end

function idleShot()
	power = 0.1

	local distance = #(GetEntityCoords(mygolfball) - Config.Holes[golfhole].endCoords)

	if distance >= 200.0 then
		golfclub = 3 -- wood 200m-250m
	elseif distance >= 150.0 and distance < 200.0 then
		golfclub = 1 -- iron 1 140m-180m
	elseif distance >= 120.0 and distance < 250.0 then
		golfclub = 4 -- iron 3 -- 120m-150m
	elseif distance >= 90.0 and distance < 120.0 then
		golfclub = 5 -- -- iron 5 -- 70m-120m
	elseif distance >= 50.0 and distance < 90.0 then
		golfclub = 6 -- iron 7 -- 50m-100m
	elseif distance >= 20.0 and distance < 50.0 then
		golfclub = 2 --  wedge 50m-80m
	else
		golfclub = 0 -- else putter
	end

	attachClub()
	RequestScriptAudioBank('GOLF_I', false)

	while golfstate == 2 do
		Citizen.Wait(0)

		if IsControlPressed(0, 38) then
			addition = 0.5

			if power > 25 then
				addition = addition + 0.1
			elseif power > 50 then
				addition = addition + 0.2
			elseif power > 75 then
				addition = addition + 0.3
			end

			power = power + addition

			if power > 100.0 then
				power = 1.0
			end
		end

		local box = (power * 2) / 1000

		if power > 90 then
			DrawRect(0.5,0.93,box,0.02,255,22,22,210) -- header
		else
			DrawRect(0.5,0.93,box,0.02,22,235,22,210) -- header
		end

		DrawLine(GetEntityCoords(mygolfball), Config.Holes[golfhole].endCoords, 222, 111, 111, 0.2)
		DrawMarker(27, Config.Holes[golfhole].endCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 10.3, 212, 189, 0, 105, false, false, 2, false, nil, nil, false)

		if IsControlJustPressed(0, 246) then
			local newclub = golfclub+1
			if newclub > 6 then
				newclub = 0
			end
			golfclub = newclub
			attachClub()
		end

		if IsControlPressed(0, 34) then
			rotateShot(true)
		end
		if IsControlPressed(0, 9) then
			rotateShot(false)
		end

		local playerPed = PlayerPedId()

		if golfclub == 0 then
			AttachEntityToEntity(playerPed, mygolfball, 20, 0.14, -0.62, 0.99, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
		elseif golfclub == 3 then
			AttachEntityToEntity(playerPed, mygolfball, 20, 0.3, -0.92, 0.99, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
		elseif golfclub == 2 then
			AttachEntityToEntity(playerPed, mygolfball, 20, 0.38, -0.79, 0.94, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
		else
			AttachEntityToEntity(playerPed, mygolfball, 20, 0.4, -0.83, 0.94, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
		end

		if IsControlJustReleased(0, 38) then
			if golfclub == 0 then
				playAnim = puttSwing.puttswinglow
			else
				playAnim = ironSwing.ironswinghigh
				playGolfAnim(playAnim)
				playAnim = ironSwing.ironswinglow
				playGolfAnim(playAnim)
				playAnim = ironSwing.ironswinglow
			end

			golfstate = 1
			inLoop = false
			DetachEntity(playerPed, true, false)
		else
			if not inLoop then
				TriggerEvent('fivem-golf:loopStart')
			end
		end
	end

	PlaySoundFromEntity(-1, 'GOLF_SWING_FAIRWAY_IRON_LIGHT_MASTER', playerPed, nil, false, 0)

	playGolfAnim(playAnim)
	swing()

	Citizen.Wait(3380)
	endShot()
end

function swing()
	if golfclub ~= 0 then
		ballCam()
	end
	if not HasNamedPtfxAssetLoaded('scr_minigamegolf') then
		RequestNamedPtfxAsset('scr_minigamegolf')
		while not HasNamedPtfxAssetLoaded('scr_minigamegolf') do
			Wait(0)
		end
	end
	SetPtfxAssetNextCall('scr_minigamegolf')
	StartParticleFxLoopedOnEntity('scr_golf_ball_trail', mygolfball, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

	local enabledroll = false

	dir = GetEntityHeading(mygolfball)
	local x,y = quickmafs(dir)
	FreezeEntityPosition(mygolfball, false)
	local rollpower = power / 3

	if golfclub == 0 then -- putter
		power = power / 3
		local check = 5.0
		while check < power do
			SetEntityVelocity(mygolfball, x*check,y*check,-0.1)
			Citizen.Wait(20)
			check = check + 0.3
		end

		power = power
		while power > 0 do
			SetEntityVelocity(mygolfball, x*power,y*power,-0.1)
			Citizen.Wait(20)
			power = power - 0.3
		end

	elseif golfclub == 1 then -- iron 1 140m-180m
		power = power * 1.85
		airpower = power / 2.6
		enabledroll = true
		rollpower = rollpower / 4
	elseif golfclub == 3 then -- wood 200m-250m
		power = power * 2.0
		airpower = power / 2.6
		enabledroll = true
		rollpower = rollpower / 2
	elseif golfclub == 2 then -- wedge -- 50m-80m
		power = power * 1.5
		airpower = power / 2.1
		enabledroll = true
		rollpower = rollpower / 4.5
	elseif golfclub == 4 then -- iron 3 -- 110m-150m
		power = power * 1.8
		airpower = power / 2.55
		enabledroll = true
		rollpower = rollpower / 5
	elseif golfclub == 5 then -- iron 5 -- 70m-120m
		power = power * 1.75
		airpower = power / 2.5
		enabledroll = true
		rollpower = rollpower / 5.5
	elseif golfclub == 6 then -- iron 7 -- 50m-100m
		power = power * 1.7
		airpower = power / 2.45
		enabledroll = true
		rollpower = rollpower / 6.0
	end

	while power > 0 do
		SetEntityVelocity(mygolfball, x*power,y*power,airpower)
		Citizen.Wait(0)
		power = power - 1
		airpower = airpower - 1
	end

	if enabledroll then
		while rollpower > 0 do
			SetEntityVelocity(mygolfball, x*rollpower,y*rollpower,0.0)
			Citizen.Wait(5)
			rollpower = rollpower - 1
		end
	end

	Citizen.Wait(2000)
	SetEntityVelocity(mygolfball, 0.0,0.0,0.0)

	if golfclub ~= 0 then
		ballCamOff()
	end

	local x,y,z = table.unpack(GetEntityCoords(mygolfball))
	createBall(x,y,z)
	FreezeEntityPosition(mygolfball, true)
end

function quickmafs(dir)
	local x = 0.0
	local y = 0.0
	local dir = dir

	if dir >= 0.0 and dir <= 90.0 then
		local factor = (dir/9.2) / 10
		x = -1.0 + factor
		y = 0.0 - factor
	end

	if dir > 90.0 and dir <= 180.0 then
		dirp = dir - 90.0
		local factor = (dirp/9.2) / 10
		x = 0.0 + factor
		y = -1.0 + factor
	end

	if dir > 180.0 and dir <= 270.0 then
		dirp = dir - 180.0
		local factor = (dirp/9.2) / 10
		x = 1.0 - factor
		y = 0.0 + factor
	end

	if dir > 270.0 and dir <= 360.0 then
		dirp = dir - 270.0
		local factor = (dirp/9.2) / 10
		x = 0.0 - factor
		y = 1.0 - factor
	end

	return x, y
end

AddEventHandler('fivem-golf:loopStart', function()
	inLoop = true

	while inLoop do
		Citizen.Wait(0)
		idleLoop()
	end
end)

function idleLoop()
	if golfclub == 0 then
		playAnim = puttSwing.puttidle
	else
		if IsControlPressed(0, 38) then
			playAnim = ironSwing.ironidlehigh
		else
			playAnim = ironSwing.ironidle
		end
	end

	playGolfAnim(playAnim)
	Citizen.Wait(1200)
end

function reactBad()
	if golfclub == 0 then
		playAnim = reactBadPutt[math.random(10)]
	else
		playAnim = reactBadSwing[math.random(10)]
	end

	playGolfAnim(playAnim)
end

function playGolfAnim(anim)
	loadAnimDict('mini@golf')
	if IsEntityPlayingAnim(lPed, 'mini@golf', anim, 3) then else
		local length = GetAnimDuration('mini@golf', anim)
		TaskPlayAnim(PlayerPedId(), 'mini@golf', anim, 1.0, -1.0, length, 0, 1.0, false, false, false)
		Citizen.Wait(length)
	end
end

function ballCam()
	ballcam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	SetCamFov(ballcam, 90.0)
	RenderScriptCams(true, true, 3, 1, 0)

	TriggerEvent('fivem-golf:camFollowBall')
end

AddEventHandler('fivem-golf:camFollowBall', function()
	local timer = 20000

	while timer > 0 do
		Citizen.Wait(5)
		local x,y,z = table.unpack(GetEntityCoords(mygolfball))
		SetCamCoord(ballcam, x,y-10,z+9)
		PointCamAtEntity(ballcam, mygolfball, 0.0, 0.0, 0.0, true)
		timer = timer - 1
	end
end)

function ballCamOff()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(ballcam, false)
end

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(50)
	end
end

ironSwing = {
	ironshufflehigh = 'iron_shuffle_high',
	ironshufflelow = 'iron_shuffle_low',
	ironshuffle = 'iron_shuffle',
	ironswinghigh = 'iron_swing_action_high',
	ironswinglow = 'iron_swing_action_low',
	ironidlehigh = 'iron_swing_idle_high',
	ironidlelow = 'iron_swing_idle_low',
	ironidle = 'iron_shuffle',
	ironswingintro = 'iron_swing_intro_high'
}

puttSwing = {
	puttshufflelow = 'iron_shuffle_low',
	puttshuffle = 'iron_shuffle',
	puttswinglow = 'putt_action_low',
	puttidle = 'putt_idle_low',
	puttintro = 'putt_intro_low',
	puttintro = 'putt_outro'
}

function startHole()
	BlipsStartEnd()
	ballstate = 0
	golfstate = 1
end

function BlipsStartEnd()
	if startblip then
		RemoveBlip(startblip)
		RemoveBlip(endblip)
	end

	startblip = AddBlipForCoord(Config.Holes[golfhole].startCoords)
	SetBlipAsFriendly(startblip, true)
	SetBlipSprite(startblip, 161)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Start of Hole')
	EndTextCommandSetBlipName(startblip)

	endblip = AddBlipForCoord(Config.Holes[golfhole].endCoords)
	SetBlipAsFriendly(endblip, true)
	SetBlipSprite(endblip, 109)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('End of Hole')
	EndTextCommandSetBlipName(endblip)

	createBall(Config.Holes[golfhole].startCoords)
end

function playAudio(num)
	RequestScriptAudioBank('GOLF_I', false)
	PlaySoundFromEntity(-1, Config.Sounds[num], PlayerPedId(), nil, false, 0)
end

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

AddEventHandler('fivem-golf:notification', function(message)
	TriggerEvent('chatMessage', 'GOLF: ', { 0, 11, 0 }, message)
end)

AddEventHandler('fivem-golf:destroyProp', function()
	removeAttachedProp()
end)

AddEventHandler('fivem-golf:attachProp', function(propItem)
	local playerPed = PlayerPedId()
	local attachModel = GetHashKey(propItem.model)
	removeAttachedProp()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'))
	local boneIndex = GetPedBoneIndex(playerPed, propItem.boneId)

	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end

	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, true, false, true)
	AttachEntityToEntity(attachedProp, playerPed, boneIndex, propItem.pos, propItem.rot, true, true, false, false, 2, true)
end)

AddEventHandler('fivem-golf:attachItem', function(item)
	TriggerEvent('fivem-golf:attachProp', Config.AttachPropList[item])
end)