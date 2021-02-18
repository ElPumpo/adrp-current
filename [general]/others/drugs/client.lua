local isSelling = false
local blah = false
local customer = {ped = nil, tmr = 9, drug = nil}
local hasAsked = {}
local validZones = {AIRP = "high", ALAMO = "Alamo Sea", ALTA = "low", ARMYB = "Fort Zancudo", BANHAMC = "Banham Canyon Dr", BANNING = "Banning", BAYTRE = "Baytree Canyon", BEACH = "Vespucci Beach", BHAMCA = "Banham Canyon", BRADP = "Braddock Pass", BRADT = "Braddock Tunnel", BURTON = "Burton", CALAFB = "Calafia Bridge", CANNY = "Raton Canyon", CCREAK = "Cassidy Creek", CHAMH = "low", CHIL = "Vinewood Hills", CHU = "Chumash", CMSW = "Chiliad Mountain State Wilderness", CYPRE = "low", DAVIS = "low", DELBE = "low", DELPE = "high", DELSOL = "La Puerta", DESRT = "low", DOWNT = "low", DTVINE = "high", EAST_V = "low", EBURO = "low", ELGORL = "El Gordo Lighthouse", ELYSIAN = "Elysian Island", GALFISH = "Galilee", GALLI = "Galileo Park", golf = "GWC and Golfing Society", GRAPES = "Grapeseed", GREATC = "Great Chaparral", HARMO = "Harmony", HAWICK = "Hawick", HORS = "Vinewood Racetrack", HUMLAB = "high", KOREAT = "high", LACT = "Land Act Reservoir", LAGO = "Lago Zancudo", LDAM = "Land Act Dam", LEGSQU = "high", LMESA = "low", LOSPUER = "La Puerta", MIRR = "low", MORN = "Morningwood", MOVIE = "Richards Majestic", MTCHIL = "Mount Chiliad", MTGORDO = "Mount Gordo", MTJOSE = "Mount Josiah", MURRI = "high", NCHU = "North Chumash", NOOSE = "N.O.O.S.E", OBSERV = "Galileo Observatory", OCEANA = "Pacific Ocean", PALCOV = "Paleto Cove", PALETO = "Paleto Bay", PALFOR = "Paleto Forest", PALHIGH = "Palomino Highlands", PALMPOW = "Palmer-Taylor Power Station", PBLUFF = "Pacific Bluffs", PBOX = "high", PROCOB = "Procopio Beach", RANCHO = "low", RGLEN = "Richman Glen", RICHM = "Richman", ROCKF = "Rockford Hills", RTRAK = "Redwood Lights Track", SanAnd = "San Andreas", SANCHIA = "San Chianski Mountain Range", SANDY = "low", SKID = "high", SLAB = "low", STAD = "high", STRAW = "low", TATAMO = "Tataviam Mountains", TERMINA = "Terminal", TEXTI = "high", TONGVAH = "Tongva Hills", TONGVAV = "Tongva Valley", VCANA = "Vespucci Canals", VESP = "Vespucci", VINE = "Vinewood", WINDF = "Ron Alternates Wind Farm", WVINE = "West Vinewood", ZANCUDO = "Zancudo River", ZP_ORT = "Port of South Los Santos", ZQ_UAR = "Davis Quartz"}
inanim = false
cancelled = false
attachedProp = 0
local has = false

function DrawMissionText(m_text, showtime)
	ClearPrints()
	BeginTextCommandPrint("STRING")
	AddTextComponentSubstringPlayerName(m_text)
	EndTextCommandPrint(showtime, true)
	SetTextFont(1)
end

function isValidZone(playerCoords)
	local zone = GetNameOfZone(playerCoords.x, playerCoords.y, playerCoords.z)

	if validZones[tostring(zone)] then
		return true
	end

	return false
end

function StopJob(delPed)
	if customer.ped then
		if DoesEntityExist(customer.ped) then
			if customer.blip and DoesBlipExist(customer.blip) then
				RemoveBlip(customer.blip)
				customer.blip = nil
			end

			--[[
				if delPed then
					SetEntityAsNoLongerNeeded(customer.ped)
					DeleteEntity(customer.ped)
				end
			--]]
		end
	end

	isSelling = false
	customer = {ped = nil, tmr = 9, drug = nil}
end

function canPedBeUsed(ped)
	if ped == nil then
		return false
	end

	if not IsEntityAPed(ped) then
		return false
	end

	if ped == PlayerPedId() then
		return false
	end

	if not DoesEntityExist(ped) then
		return false
	end

	if IsPedAPlayer(ped) then
		return false
	end

	if tablefind(hasAsked, tostring(ped)) then
		return false
	end

	if IsPedFatallyInjured(ped) then
		return false
	end

	if IsPedFleeing(ped) or IsPedRunning(ped) or IsPedSprinting(ped) then
		return false
	end

	if IsPedInCover(ped) or IsPedGoingIntoCover(ped) or IsPedGettingUp(ped) then
		return false
	end

	if IsPedInMeleeCombat(ped) then
		return false
	end

	if IsPedShooting(ped) then
		return false
	end

	if IsPedDucking(ped) then
		return false
	end

	if IsPedBeingJacked(ped) then
		return false
	end

	if IsPedSwimming(ped) then
		return false
	end

	if not IsPedOnFoot(ped) then
		return false
	end

	local pedType = GetPedType(ped)
	if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
		return false
	end

	return true
end

function GetZoneType()
	local zone = GetNameOfZone(GetEntityCoords(PlayerPedId()))
	local zoneType = validZones[tostring(zone)]

	if zoneType ~= nil then
		if zoneType == 'low' or zoneType == 'high' then
			return zoneType
		end
	end

	return 'normal'
end

function NpcBuy()
	local rand = GetRandomIntInRange(0,100)
	local zoneType = GetZoneType()

	if zoneType == 'low' then -- 70% chance of selling in low-risk zones
		return rand > 30
	elseif zoneType == 'high' then -- 30% chance of selling in high-risk zones
		return rand > 70
	else -- 50% chance in normal zones
		return rand > 50
	end
end

function NpcReport()
	local rand = GetRandomIntInRange(0,100)
	local zoneType = GetZoneType()

	if zoneType == 'low' then -- 5% chance of being reported in low-risk zones
		return rand > 95
	elseif zoneType == 'high' then -- 50% chance of being reported in high-risk zones
		return rand > 50
	else -- 15% chance in normal zones
		return rand > 85
	end
end

function GetPedInfrontOfEntity(entity)
	local playerCoords = GetEntityCoords(entity)
	local inDirection  = GetOffsetFromEntityInWorldCoords(entity, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords, inDirection, 10, entity, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and canPedBeUsed(entityHit) then
		return entityHit
	else
		return nil
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		if isValidZone(playerCoords) and IsPedOnFoot(playerPed) then
			if customer.ped == nil then
				local randomPed = GetPedInfrontOfEntity(playerPed)

				if not randomPed then
					Citizen.Wait(1000)
				else
					TriggerServerEvent('sell:check')
					if has then
						if IsControlJustPressed(0, 74) then
							customer.ped = randomPed
							customer.drug = drug
							SetBlockingOfNonTemporaryEvents(customer.ped, 1)
							TaskStandStill(customer.ped, 3500)
							TaskLookAtEntity(customer.ped, playerPed, 3500, 1, 1)
							DrawMissionText("Asking the ~g~person~s~ if they are interested...", 2000)
							customer.blip = AddBlipForEntity(customer.ped)
							SetBlipColour(customer.blip, 2)
							SetBlipCategory(customer.blip, 3)
							table.insert(hasAsked, tostring(randomPed))
							if #hasAsked > 25 then
								table.remove(hasAsked, 1)
							end
						else
							StopJob(true)
						end
					end -- control end
				end

			else
				if isSelling then
					if not IsPedFatallyInjured(customer.ped) then
						if GetDistanceBetweenCoords(playerCoords, GetEntityCoords(customer.ped), true) < 2.501 then
							if customer.tmr > 1 then
								TaskStandStill(customer.ped, 1500)
								TaskLookAtEntity(customer.ped, playerPed, 1500, 2048, 3)
								TaskTurnPedToFaceEntity(customer.ped, playerPed, 1500)
								customer.tmr = customer.tmr - 1
								DrawMissionText(string.format("Stay beside the ~g~buyer~s~ for another ~b~%s~s~ seconds to make the deal", customer.tmr), 1000)
								Citizen.Wait(1000)
							else -- customer.tmr else
								if GetDistanceBetweenCoords(playerCoords, GetEntityCoords(customer.ped), true) < 2.0 then
									blah = true
									TriggerEvent("attachItemDrugs", "drugpackage02")
									TaskStandStill(customer.ped, 4500)
									TaskLookAtEntity(customer.ped, playerPed, 3500, 2048, 3)
									TaskTurnPedToFaceEntity(customer.ped, playerPed, 3500)
									Citizen.Wait(4500)
									StopJob(true)
								else -- distance else
									DrawMissionText("The buyer has ~r~canceled~s~ the transaction.", 3000)
									StopJob(true)
								end -- distance end
							end -- customer.tmr end
						else -- distance else
							DrawMissionText("The buyer is too far away, the transaction has been ~r~canceled~s~.", 3000)
							StopJob(true)
						end --distance end
					else -- dead/injured else
						DrawMissionText("The buyer is ~r~dead~s~.", 3000)
						StopJob(true)
					end --dead/injured end
				else -- isSelling else
					Citizen.Wait(2000)
					if NpcBuy() then
						isSelling = true
						TaskStandStill(customer.ped, 3500)
						TaskLookAtEntity(customer.ped, playerPed, 3500, 1, 1)
						Citizen.Wait(3000)
					else -- NpcBuy else
						DrawMissionText("The buyer has ~r~rejected~s~ your offer!", 1000)
						if NpcReport() then
							reportPlayer()
						end
						StopJob(false)
						Citizen.Wait(1000)
					end -- NpcBuy end
				end -- isSelling end
			end -- customer.ped end
		else
			Citizen.Wait(500)
		end
	end -- while end
end)

function tablefind(tab,el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end

function reportPlayer()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_addons_gcphone:startCall', 'police', "Someone just tried to sell me drugs!", {x = coords.x, y = coords.y, z = coords.z})
end

RegisterNetEvent('drugGiveAnim')
AddEventHandler('drugGiveAnim', function()
	local player = PlayerPedId()
	if DoesEntityExist(player) and not IsEntityDead(player) then
		ESX.Streaming.RequestAnimDict('mp_safehouselost@')
		if IsEntityPlayingAnim(player, "mp_safehouselost@", "package_dropoff", 3) then
			TaskPlayAnim(player, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
		else
			TaskPlayAnim(player, "mp_safehouselost@", "package_dropoff", 8.0, 1.0, -1, 16, 0, 0, 0, 0)
		end
	end
end)

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end

RegisterNetEvent('attachPropDrugsObject')
AddEventHandler('attachPropDrugsObject', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	TriggerEvent("drugGiveAnim")
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	ESX.Streaming.RequestModel(attachModel)
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(3000)
	removeAttachedProp()
end)

RegisterNetEvent('attachPropDrugs')
AddEventHandler('attachPropDrugs', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	TriggerEvent("drugGiveAnim")
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	ESX.Streaming.RequestModel(attachModel)
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(4000)
	item = "money01"
	attachPropCash(attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

function attachPropCash(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'))
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)

	ESX.Streaming.RequestModel(attachModel)

	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
	Citizen.Wait(2500)

	removeAttachedProp()
end

attachPropList = {
	["money01"] = {
		["model"] = "prop_anim_cash_note", ["bone"] = 28422, ["x"] = 0.1,["y"] = 0.04,["z"] = 0.0,["xR"] = 25.0,["yR"] = 0.0, ["zR"] = 10.0
	},

	["drugpackage02"] = {
		["model"] = "prop_meth_bag_01", ["bone"] = 28422, ["x"] = 0.1,["y"] = 0.0,["z"] = -0.01,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 40.0
	},


	["drugpackage01"] = {
		["model"] = "prop_weed_bottle", ["bone"] = 28422, ["x"] = 0.09,["y"] = 0.0,["z"] = -0.03,["xR"] = 135.0,["yR"] = -100.0, ["zR"] = 40.0
	},

	["money01"] = {
		["model"] = "prop_anim_cash_note", ["bone"] = 28422, ["x"] = 0.1,["y"] = 0.04,["z"] = 0.0,["xR"] = 25.0,["yR"] = 0.0, ["zR"] = 10.0
	}
}

RegisterNetEvent('attachItemObject')
AddEventHandler('attachItemObject', function(item)
	TriggerEvent("attachPropDrugsObject",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('attachItemDrugs')
AddEventHandler('attachItemDrugs', function(item)
	TriggerEvent("attachPropDrugs",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('currentlySelling')
AddEventHandler('currentlySelling', function()
	selling = true
	secondsRemaining = 10
end)

RegisterNetEvent('cancel')
AddEventHandler('cancel', function()
	blah = false
end)

RegisterNetEvent('done')
AddEventHandler('done', function()
	selling = false
	secondsRemaining = 0
	StopJob(false)
end)

RegisterNetEvent('notify')
AddEventHandler('notify', function()
	ESX.ShowHelpNotification("Press ~INPUT_VEH_HEADLIGHT~ to ~o~Sell Drugs~s~ to the ~y~Pedestrian~s~.")
	has = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		if blah then
			TriggerServerEvent('sell:check1')
			blah = false
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_drugs:onPot')
AddEventHandler('esx_drugs:onPot', function()
	ESX.Streaming.RequestAnimSet('MOVE_M@DRUNK@SLIGHTLYDRUNK')

	TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_SMOKING_POT", 0, true)
	Citizen.Wait(5000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	ClearPedTasksImmediately(PlayerPedId())
	SetTimecycleModifier("spectator5")
	SetPedMotionBlur(PlayerPedId(), true)
	SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(PlayerPedId(), true)
	DoScreenFadeIn(1000)
	Citizen.Wait(180000)
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	DoScreenFadeIn(1000)
	ClearTimecycleModifier()
	ResetScenarioTypesEnabled()
	ResetPedMovementClipset(PlayerPedId(), 0)
	SetPedIsDrunk(PlayerPedId(), false)
	SetPedMotionBlur(PlayerPedId(), false)
end)

RegisterNetEvent('esx_drugs:NZT')
AddEventHandler('esx_drugs:NZT', function()
	ESX.Streaming.RequestAnimDict('mp_suicide')

	TaskPlayAnim(PlayerPedId(), "mp_suicide", "pill", -1, 8.0, -1, 16, 1, 0, 0, 0)
	Citizen.Wait(7000)
	SetPedMoveRateOverride(PlayerPedId(), true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.20)
	SetSeethrough(true)
	SetPedArmour(PlayerPedId(), 1.5)
	TriggerEvent("enableCurser", true)
	Citizen.Wait(58000)
	SetPedToRagdoll(PlayerPedId(), 6000, 6000, 0, 0, 0, 0)
	Citizen.Wait(1000)
	DoScreenFadeOut(2000)
	Citizen.Wait(2000)
	DoScreenFadeIn(2000)
	ClearTimecycleModifier()
	SetSeethrough(false)
	SetPedMoveRateOverride(PlayerPedId(), false)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.00)
	SetPedArmour(PlayerPedId(), 0.0)
	TriggerEvent("enableCurser", false)
end)

RegisterNetEvent('drugs:Moonshine')
AddEventHandler('drugs:Moonshine', function()
	ESX.Streaming.RequestAnimSet('MOVE_M@DRUNK@VERYDRUNK')

	SetTimecycleModifier("drunk")
	SetPedIsDrunk(PlayerPedId(), true)
	ShakeGameplayCam("DRUNK_SHAKE", 1.0)
	SetPedConfigFlag(PlayerPedId(), 100, true)
	SetPedMovementClipset(PlayerPedId(), "MOVE_M@DRUNK@VERYDRUNK", 1.0)
	Citizen.Wait(180000)
	ClearTimecycleModifier()
	SetPedIsDrunk(PlayerPedId(), false)
	ShakeGameplayCam("DRUNK_SHAKE", 0.0)
	SetPedConfigFlag(PlayerPedId(), 100, false)
	ResetPedMovementClipset(PlayerPedId())
end)

RegisterNetEvent('esx_drugs:onTheV')
AddEventHandler('esx_drugs:onTheV', function()
	ESX.Streaming.RequestAnimDict('mp_suicide')

	TaskPlayAnim(PlayerPedId(), "mp_suicide", "pill", -1, 8.0, -1, 16, 1, 0, 0, 0)
	Citizen.Wait(7000)

	SetTimecycleModifier("LostTimeDark")
	GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), 100, 0, 1)
	SetPedMoveRateOverride(PlayerPedId(), true)
	SetRunSprintMultiplierForPlayer(PlayerId(), 1.20)
	SetPedArmour(PlayerPedId(), 1.5)
end)