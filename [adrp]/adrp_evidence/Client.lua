local PlayerData = {}

Age = 1
DeathAge = 1

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end
end)



Weapons = {
	Melee = {
		'WEAPON_KNIFE', 'WEAPON_KNUCKLE', 'WEAPON_NIGHTSTICK', 'WEAPON_HAMMER', 'WEAPON_BAT', 'WEAPON_GOLFCLUB', 'WEAPON_CROWBAR', 'WEAPON_BOTTLE', 'WEAPON_DAGGER',
		'WEAPON_HATCHET', 'WEAPON_MACHETE', 'WEAPON_SWITCHBLADE', 'WEAPON_POOLCUE',
	},
	Pistol = {
		'WEAPON_REVOLVER', 'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_PISTOL50', 'WEAPON_SNSPISTOL',
		'WEAPON_HEAVYPISTOL','WEAPON_VINTAGEPISTOL', 'WEAPON_DOUBLEACTION', 'WEAPON_REVOLVER_MK2', 'WEAPON_SNSPISTOL_MK2',
	},
	SMG = {
		'WEAPON_MICROSMG','WEAPON_MINISMG','WEAPON_SMG','WEAPON_SMG_MK2','WEAPON_ASSAULTSMG', 'WEAPON_MACHINEPISTOL',
	},
	MG = {
		'WEAPON_MG','WEAPON_COMBATMG','WEAPON_COMBATMG_MK2',
	},
	Assault = {
		'WEAPON_ASSAULTRIFLE', 'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE',
		'WEAPON_BULLPUPRIFLE', 'WEAPON_COMPACTRIFLE', 'WEAPON_SPECIALCARBINE_MK2', 'WEAPON_BULLPUPRIFLE_MK2',
	},
	Shotgun = {
		 'WEAPON_PUMPSHOTGUN','WEAPON_SAWNOFFSHOTGUN','WEAPON_BULLPUPSHOTGUN','WEAPON_ASSAULTSHOTGUN','WEAPON_HEAVYSHOTGUN','WEAPON_DBSHOTGUN',
		 'WEAPON_PUMPSHOTGUN_MK2',
	},
	Sniper = {
		'WEAPON_SNIPERRIFLE'
	},
	}


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		Update()
		PositionUpdate()
	end
end)

function Update()
	Citizen.Wait(5000)
	local startHealth = GetEntityHealth(PlayerPedId())
	timer = GetGameTimer()
	local tick = 0
	while true do
		Citizen.Wait(0)
		tick = tick + 1
		local ped = PlayerPedId()
		local pedHealth = GetEntityHealth(ped)
		local pedShooting = IsPedShooting(ped)

		if pedHealth > startHealth then
			startHealth = pedHealth
		end
		if pedHealth < startHealth then
			startHealth = pedHealth
			TakeDamage(ped)
		end

		if pedShooting then
			PlayerShooting(ped)
		end

		if SpawnedObjs then
			HandleObject(timer)
		end

		if CurDNA and #CurDNA > 0 then
			if tick % 100 == 1 then
				GetClosest(ped)
			end
			DrawText(ped)
		end
	end
end

function PositionUpdate()
	Citizen.Wait(5000)
	local tick = 0
	while true do
		Citizen.Wait(0)
		tick = tick + 1
		if tick % 200 == 0 then
			ESX.TriggerServerCallback('adrp_evidence:PlayersJob', function(job)
				CurJob = job.name
			end)
			--if CurJob == 'ambulance' or CurJob == 'police' then
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local distA = #(pos - Config.AmmoAnalyzePos)
				local distB = #(pos - Config.DNAAnalyzePos)
				local drawing = false
				if distA and distA < Config.DrawTextDist then
					drawing = 'ammo'
					DrawText(Config.AmmoAnalyzePos.x,Config.AmmoAnalyzePos.y,Config.AmmoAnalyzePos.z, 'Press [~g~E~s~] to analyze ammo casings.')
				elseif distB and distB < Config.DrawTextDist then
					drawing = 'blood'
					DrawText(Config.DNAAnalyzePos.x,Config.DNAAnalyzePos.y,Config.DNAAnalyzePos.z, 'Press [~g~E~s~] to analyze DNA.')
				end
				if drawing then
					if (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) then
						if drawing == 'ammo' then
							TriggerEvent('adrp_evidence:AnalyzeCasing')
						elseif drawing == 'blood' then
							TriggerEvent('adrp_evidence:AnalyzeDNA')
						end
					end
				end
			--end
		end
	end
end


function PlayerShooting(ped)
	if not ped or IsShooting then
		return
	end
	IsShooting = true
	local plyPos = GetEntityCoords(ped)
	local pedWeapon = GetSelectedPedWeapon(ped)
	if pedWeapon < 0 then
		pedWeapon = pedWeapon%0x100000000
	end
	local weapon, weaponType
	for weaType, val in pairs(Weapons) do
		for k,v in pairs(val) do
			if ADRPGetHashKey(v) == pedWeapon then
				weapon = v
				weaponType = weaType
			end
		end
	end
	local found, newZ = GetGroundZFor_3dCoord(plyPos.x,plyPos.y,plyPos.z,newZ,false)
	local newPos = vector3(plyPos.x, plyPos.y, newZ)
	TriggerServerEvent('adrp_evidence:PlaceEvidenceS', newPos, Config.ResidueObject, weapon, weaponType)
	IsShooting = false
end

function TakeDamage(ped)
	if not ped or TakingDamage then
		return
	end
	TakingDamage = true
	local pedPos = GetEntityCoords(ped)
	local found, newZ = GetGroundZFor_3dCoord(pedPos.x, pedPos.y, pedPos.z, newZ, false)
	local newPos = vector3(pedPos.x, pedPos.y, newZ - 0.26)
	TriggerServerEvent('adrp_evidence:PlaceEvidenceS', newPos, Config.BloodObject)
	TakingDamage = false
end

function HandleObject()
	if not CurPlacing then
		if (Age - DeathAge) > Config.MaxObjCount then
			SetEntityAsMissionEntity(SpawnedObjs[DeathAge], false, false)
			DeleteObject(SpawnedObjs[DeathAge])
			CurDNA[DeathAge] = false
			SpawnedObjs[DeathAge] = false
			DeathAge = DeathAge + 1
		end
	end
end

function GetClosest(ped)
	local closest, closestDist
	for k,v in pairs(CurDNA) do
		if v and type(v) ~= 'boolean' then
			local dist = #(GetEntityCoords(ped) - v.pos)
			if not closestDist or dist < closestDist then
				closest = v
				closestDist = dist
			end
		end
	end
	Closest = closest or false
	ClosestDist = closestDist or false
end

function PickupEvidence(evidence)
	if not CurDNA then
		return
	end

	for k,v in pairs(CurDNA) do
		if v and v.pos and evidence and evidence.pos then
			if v.pos == evidence.pos then
				DeleteObject(v.go)
				table.remove(CurDNA, k)
			end
		end
	end
end

function CheckJob()
	if ESX and ESX.PlayerData and ESX.PlayerData.job then
		local job = ESX.PlayerData.job.name

		if job == 'police' or job == 'state' or job == 'sheriff' or job == 'usmarshal' or 'fib' or job == 'gruppe6' or job == 'ambulance' then
			return job
		end
	end

	return false
end

RegisterNetEvent('adrp_evidence:PlaceEvidenceC')
AddEventHandler('adrp_evidence:PlaceEvidenceC', function(pos, obj, name, weapon, weaponType)
	if not ESX.IsPlayerLoaded() then
		return
	end

	CurPlacing = true


	local plyPed = PlayerPedId()
	local plyJob = (CurJob or false)
	if obj == Config.BloodObject and CheckJob() ~= false then
		CurDNA = CurDNA or {}
		SpawnedObjs = SpawnedObjs or {}

		local closestPed = ESX.Game.GetClosestPed(pos, { plyPed })
		local closestVeh = ESX.Game.GetClosestVehicle(pos)
		local plyPos = GetEntityCoords(plyPed)
		local pedPos = GetEntityCoords(closestPed)
		local vehPos = GetEntityCoords(closestVeh)
		local distPed
		if pedpos and plyPos then
			distPed = #(pedPos - plyPo)
		end
		local distVeh
		if vehPos and plyPos then
			distVeh = #(plyPos - vehPos)
		end

		if distPed and distPed < 5.0 then
			SetEntityAsMissionEntity(closestPed, true, true)
		end

		if distVeh and distVeh < 5.0 then
			SetEntityAsMissionEntity(closestVeh, true, true)
		end

		local targetPosition = vector3(pos.x, pos.y, pos.z)
		local newObj = CreateObject(GetHashKey(obj), targetPosition)
		FreezeEntityPosition(newObj, true)
		SetEntityAsMissionEntity(newObj, true, true)
		SetEntityRotation(newObj, -90.0, 0.0, 0.0, 2, false)

		table.insert(CurDNA,{ pos = pos, obj = obj, name = name, go = newObj })

		if IsEntityAMissionEntity(closestPed) then
			SetEntityAsMissionEntity(closestPed,false,false)
		end
		if IsEntityAMissionEntity(closestVeh) then
			SetEntityAsMissionEntity(closestVeh,false,false)
		end

		SpawnedObjs[Age] = newObj
		Age = Age + 1

		for k,v in pairs(CurDNA) do
			if v and type(v) ~= boolean and type(v) == table then
				SetEntityNoCollisionEntity(v.go, newObj, true)
			end
		end

	elseif obj == Config.ResidueObject and CheckJob() ~= false and CheckJob() ~= 'ambulance' then
		CurDNA = CurDNA or {}
		SpawnedObjs = SpawnedObjs or {}
		local newObj = CreateObject(GetHashKey(obj), pos.x, pos.y, pos.z, false, false, false)
		SetEntityRotation(newObj, -90.0, 0.0, 0.0, 2, false)
		SetEntityAsMissionEntity(newObj, true, true)
		FreezeEntityPosition(newObj, true)
		table.insert(CurDNA,{ pos = pos, obj = obj, name = name, go = newObj, wea = weapon, weaType = weaponType})

		SpawnedObjs[Age] = newObj
		Age = Age + 1

	end
		SetModelAsNoLongerNeeded(GetHashKey(obj))
		CurPlacing = false
end)

RegisterNetEvent('adrp_evidence:PickupEvidenceC')
AddEventHandler('adrp_evidence:PickupEvidenceC', function(obj)
	PickupEvidence(obj)
end)

function DrawText(ped)
	local closest = Closest or false
	local closestDist = ClosestDist or false
	local actionTime, timeWaited, checkTime, lastCheckTime = 5, 0, 10, GetGameTimer()

	ESX.Streaming.RequestAnimDict('amb@medic@standing@kneel@idle_a')

	if closestDist and closestDist < 5.0 then
		if (IsControlJustPressed(1, 38) or IsDisabledControlJustPressed(0, 38)) and (GetGameTimer() - timer) > 150 then
			timer = GetGameTimer()
			if closest.obj == Config.BloodObject then
				TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@kneel@idle_a', 'idle_a', 1.0, -1.0, 8000, 1, 0, false, false, false)
				if not IsEntityPlayingAnim(PlayerPedId(), 'amb@medic@standing@kneel@idle_a', 'idle_a', 0) then
					while timeWaited < actionTime do
						Citizen.Wait(1)
						if GetGameTimer() > lastCheckTime + checkTime then
							timeWaited = timeWaited + 0.01
							lastCheckTime = GetGameTimer()
						end

						ESX.Game.Utils.ProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, 'Collecting blood sample...')
					end
				end
			else
				TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@kneel@idle_a', 'idle_a', 1.0, -1.0, 8000, 1, 0, false, false, false)
				if not IsEntityPlayingAnim(PlayerPedId(), 'amb@medic@standing@kneel@idle_a', 'idle_a', 0) then
					while timeWaited < actionTime do
						Citizen.Wait(1)
						if GetGameTimer() > lastCheckTime + checkTime then
							timeWaited = timeWaited + 0.01
							lastCheckTime = GetGameTimer()
						end

						ESX.Game.Utils.ProgressBar(timeWaited / actionTime, 0, -0.05, 25, 25, 250, 'Collecting empty casing...')
					end
				end
			end

			ESX.TriggerServerCallback('adrp_evidence:PickupEvidenceS', function(canPickup)
				if not canPickup then
					ESX.ShowNotification('You can\'t pick up any more of these.')
				else
					if closest.obj == Config.BloodObject then
						CurBlood = closest
					elseif closest.obj == Config.ResidueObject then
						CurBullet = closest
					end
				end
			end, closest)
		end
	end
end

RegisterNetEvent('adrp_evidence:AnalyzeDNA')
AddEventHandler('adrp_evidence:AnalyzeDNA', function()
	if not CurDNA or not CurBlood then
		return
	end
	ESX.Streaming.RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
	local actionTime, timeWaited, checkTime, lastCheckTime = 5, 0, 10, GetGameTimer()
	ESX.UI.Menu.CloseAll()
	TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,1.0, -1.0, 8000, 1, 0, false, false, false)

	if not IsEntityPlayingAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer', 0) then
		while timeWaited < actionTime do
			Citizen.Wait(1)
			if GetGameTimer() > lastCheckTime + checkTime then
				timeWaited = timeWaited + 0.01
				lastCheckTime = GetGameTimer()
			end

			ESX.Game.Utils.ProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, 'Analyzing blood sample...')
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Blood_Info', {
		title = 'DNA Analyzer',
		align = 'left',
		elements = {{label = 'Name: ' .. CurBlood.name}}
	}, function(data, menu)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)

RegisterNetEvent('adrp_evidence:AnalyzeCasing')
AddEventHandler('adrp_evidence:AnalyzeCasing', function()
	if not CurBullet or not CurBullet.wea then
		return
	end

	ESX.UI.Menu.CloseAll()

	ESX.Streaming.RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
	local actionTime, timeWaited, checkTime, lastCheckTime = 5, 0, 10, GetGameTimer()
	TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,1.0, -1.0, 9000, 1, 0, false, false, false)
	if not IsEntityPlayingAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer', 0) then
		while timeWaited < actionTime do
			Citizen.Wait(1)
			if GetGameTimer() > lastCheckTime + checkTime then
				timeWaited = timeWaited + .01
				lastCheckTime = GetGameTimer()
			end

			ESX.Game.Utils.ProgressBar(timeWaited / actionTime, 0, -0.05, 200, 25, 25, 'Analyzing bullet sample...')
		end
	end
	local weapon, hash = string.find(CurBullet.wea, 'WEAPON_')
	local foundHash = string.lower(string.sub(CurBullet.wea,hash+1))
	foundHash = foundHash:sub(1,1):upper()..foundHash:sub(2)
	local street, crossing = GetStreetNameAtCoord(CurBullet.pos.x, CurBullet.pos.y, CurBullet.pos.z)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Ammo_Info', {
		title = 'Ammo Analyzer',
		align = 'left',
		elements = {
			{label = 'Weapon: ' .. foundHash},
			{label = 'Type: ' .. CurBullet.weaType}
	}}, function(data, menu)
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)



--Need CheckPolice and CheckEMS Functions still

--utils

GetHashKeyPrev = GetHashKeyPrev or GetHashKey
GetHashKey		 = GetHashKey

function ADRPGetHashKey(strToHash)
	if type(strToHash) == 'number' then
		return strToHash
	end
	return GetHashKeyPrev(tostring(strToHash or '') or '')%0x100000000
end

