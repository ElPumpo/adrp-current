
local MissionStarted = nil
local PlayerData = {}
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




Citizen.CreateThread(function()
	while not ESX do
		Citizen.Wait(0)
	end
	while not ESX.IsPlayerLoaded() do
		Citizen.Wait(0)
	end
	Config.PoliceCount = Config.PoliceCount or 0
	DoBlips()
	Update()
end)

function DoBlips()
	local blip = AddBlipForCoord(Config.HintLocation.x, Config.HintLocation.y, Config.HintLocation.z)
	SetBlipSprite               (blip, 205)
	SetBlipDisplay              (blip, 3)
	SetBlipScale                (blip, 1.0)
	SetBlipColour               (blip, 4)
	SetBlipAsShortRange         (blip, false)
	SetBlipHighDetail           (blip, true)
	BeginTextCommandSetBlipName ("STRING")
	AddTextComponentString      ("TEST")
	EndTextCommandSetBlipName   (blip)
  end

  function GetVecDist(v1,v2)
	if not v1 or not v2 or not v1.x or not v2.x then
		return 0
	end
	return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

function Update()
	local timer = 0
	local noteTemplate = DrawTextTemplate()
	local SmokeActive = false
	noteTemplate.x = 0.5
  	noteTemplate.y = 0.5
	while true do
		Wait(0)
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)

		if not MissionStarted then

			local dist = GetVecDist(pos, Config.HintLocation)
			if dist < Config.DrawTextDistance then
				local p = Config.HintLocation
				ESX.Game.Utils.DrawText3D(Config.HintLocation, 'Press [~g~E~s~] to knock on the door', 1.0)
				if IsControlJustPressed(0, 38) and GetGameTimer() - timer > 150 then
					--check cops
					timer = GetGameTimer()
					TaskGoStraightToCoord(ped, p.x, p.y, p.z, 10.0, 10, 134.55, 0.5)
					Wait(3000)
					ClearPedTasksImmediately(ped)
					while not HasAnimDictLoaded("timetable@jimmy@doorknock@") do
						RequestAnimDict("timetable@jimmy@doorknock@"); Citizen.Wait(0)
					end
					TaskPlayAnim(ped, "timetable@jimmy@doorknock@", "knockdoor_idle", 8.0, 8.0, -1, 4, 0, 0, 0, 0 )
					Citizen.Wait(0)
					  while IsEntityPlayingAnim(plyPed, "timetable@jimmy@doorknock@", "knockdoor_idle", 3) do
						Citizen.Wait(0);
					end
					Citizen.Wait(1000)
					TriggerEvent('mecommand', 'notices a note slide under the door')
					ClearPedTasksImmediately(ped)

					local random = math.random( 1, #Config.TruckLocations)
					local spawn = Config.TruckLocations[random]
					local near = GetStreetNameFromHashKey(GetStreetNameAtCoord(spawn.x, spawn.y, spawn.z))
					noteTemplate.text = "You can find the truck near "..near..".\nDon't be late!"
					--store message to find the truck near street near

					MissionStarted = {
						TruckLoc = spawn,
						Dropoff = Config.DropoffLocations[math.random(1, #Config.DropoffLocations)],
						Count = 0,
					}

					SetNewWaypoint(spawn.x, spawn.y)

					local timer = GetGameTimer()
					while (GetGameTimer() - timer) < (Config.NotificationTime * 1000) do
						Citizen.Wait(0)
						DrawSprite("commonmenu", "", 0.5, 0.53, 0.2, 0.1, 0.0, 125, 125, 125, 200)
						DrawTemplateText(noteTemplate)
					end
				end
			end
		else
			if not TruckSpawned and MissionStarted then
				local dist = GetVecDist(pos, MissionStarted.TruckLocations)
				if dist < Config.TruckSpawnDistance then
					local random = math.random(1, #Config.TruckModels)
					local vehModel = Config.TruckModels[random]

					local hash = GetHashKey(vehModel)
					while not HasModelLoaded(hash) do
						RequestModel(hash)
						Citizen.Wait(0)
					end

					local coords = MissionStarted.TruckLoc
					local veh = CreateVehicle(hash, coords, true, true)
					SetEntityAsMissionEntity(veh, true, true)
					TruckSpawned = veh
				end
			else
				if IsPedInAnyVehicle(ped) then
					local veh = GetVehiclePedIsIn(ped, false)
					if veh  == TruckSpawned then
						if not WaypointSet then
							WaypointSet = true
							SetNewWaypoint(MissionStarted.Dropoff.x, MissionStarted.Dropoff.y)
							ESX.ShowNotification("Find a passenger to cook the meth in the back before delivery.")
						end

						if not MethCook then
							local foundCook = false
							for k=1,4,1 do
								if not foundCook and not IsVehicleSeatFree(TruckSpawned, k) then
									local passenger = GetPedInVehicleSeat(TruckSpawned, k)
									if passenger ~= -1 and passenger ~= ped and DoesEntityExist(passenger) then
										foundCook = passenger
									end
								end
							end
							if foundCook and foundCook ~= ped then
								if GetEntitySpeed(TruckSpawned) * 2.236936 > Config.MinSpeedtoCook then
									ESX.ShowNotification("Your passenger has started cooking the meth.")
									MethCook = NetworkGetPlayerIndexFromPed(foundCook)
									TriggerServerEvent('adrp_meth:BeginCooking', GetPlayerServerId(MethCook))
								else
									if not notified then
										ESX.ShowNotification("Drive above "..Config.MinSpeedtoCook.."MPH to begin the cook.")
										notified = true
									end
								end
							end
						else

							if not SmokeActive then
								TriggerServerEvent('adrp_meth:SyncSmoke', NetworkGetNetworkIdFromEntity(TruckSpawned))
								SmokeActive = true
							end

							if CookFinished then
								local dis = #(pedPos - MissionStarted.Dropoff)
								if dist < Config.DrawTextDistance*2 then
									local pos = MissionStarted.Dropoff
									ESX.Game.Utils.DrawText3D(pedPos.x, pedPos.y, pedPos.z, 'Press [~g~E~s~] to deliver the meth', 1.0)
									if dist < Config.DrawTextDistance and IsControlJustPressed(0, 38) and GetGameTimer() - timer > 150 then
										timer = GetGameTimer()
										local veh = TruckSpawned
										local maxSeats = GetVehicleMaxNumberOfPassengers(veh)
										for seat = -1, maxSeats-1,1 do
											local player = GetPedInVehicleSeat(veh, seat)
											if player and player ~= 0 then
												TaskLeaveVehicle(player, veh, 16)
											end
										end
										--reward players and remove truck clean up on server side
										Citizen.Wait(0)
										ESX.Game.DeleteVehicle(veh)
										MissionStarted = false
										TruckSpawned = false
										WaypointSet = false
										MethCook = false
										SmokeActive = false
										notified = false
										ESX.ShowNotification("You delivered the meth.")
									end
								else
									local vehicle = false
									if IsPedInAnyVehicle(player) then
										vehicle = GetVehiclePedIsIn(player, false)
									end
									if not vehicle or vehicle ~= TruckSpawned then
										--cancel and remove truck server side
										Citizen.Wait(0)
										DeleteVehicle(veh)
										MissionStarted = false
										TruckSpawned = false
										WaypointSet = false
										MethCook = false
										SmokeActive = false
										notified = false
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function DrawTemplateText(t)
	SetTextFont (t.font)
	SetTextScale (t.scale1, t.scale2)
	SetTextColour (t.colour1,t.colour2,t.colour3,t.colour4)
	SetTextWrap (t.wrap1,t.wrap2)
	SetTextCentre (t.centre)
	SetTextOutline (t.outline)
	SetTextDropshadow (t.dropshadow1,t.dropshadow2,t.dropshadow3,t.dropshadow4,t.dropshadow5)
	SetTextEdge (t.edge1,t.edge2,t.edge3,t.edge4,t.edge5)
	SetTextEntry ("STRING")

	-- Draw Text
	AddTextComponentSubstringPlayerName (t.text)
	DrawText (t.x,t.y)
end

function DrawTextTemplate(text,x,y,font,scale1,scale2,colour1,colour2,colour3,colour4,wrap1,wrap2,centre,outline,dropshadow1,dropshadow2,dropshadow3,dropshadow4,dropshadow5,edge1,edge2,edge3,edge4,edge5)
    return {
      text         =                    "",
      x            =                    -1,
      y            =                    -1,
      font         =  font         or    6,
      scale1       =  scale1       or  0.5,
      scale2       =  scale2       or  0.5,
      colour1      =  colour1      or  255,
      colour2      =  colour2      or  255,
      colour3      =  colour3      or  255,
      colour4      =  colour4      or  255,
      wrap1        =  wrap1        or  0.0,
      wrap2        =  wrap2        or  1.0,
      centre       =  ( type(centre) ~= "boolean" and true or centre ),
      outline      =  outline      or    1,
      dropshadow1  =  dropshadow1  or    2,
      dropshadow2  =  dropshadow2  or    0,
      dropshadow3  =  dropshadow3  or    0,
      dropshadow4  =  dropshadow4  or    0,
      dropshadow5  =  dropshadow5  or    0,
      edge1        =  edge1        or  255,
      edge2        =  edge2        or  255,
      edge3        =  edge3        or  255,
      edge4        =  edge4        or  255,
      edge5        =  edge5        or  255,
    }
end

function BeginCooking(driver)
	local Driver = driver
	print("Driver: "..driver)
	--if MissionStarted or Driver then
		--ESX.ShowNotification("You already have a mission active.")
		--return
	--end
	ESX.ShowNotification("You started cooking the meth")
	local Truck = GetVehiclePedIsIn(PlayerPedId())
	local doCount = true
	Citizen.CreateThread(function()
		while Driver do
			Citizen.Wait(0)
			print("running?")
			local doBreak, driverMsg
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			if not IsPedInAnyVehicle(ped) then
				doBreak = "You a hoe for leaving the driver"
				driverMsg = "The cook said fuck this i'm out!"
			else
				if GetEntitySpeed(vehicle) * 2.236936 < Config.MinSpeedtoCook then
					if not CurrentlyStopped then
						local CanContinue = false
						CurrentlyStopped = true
						Citizen.CreateThread(function()
							local timer = GetGameTimer()
							while (GetGameTimer() - timer) < Config.MaxVehicleStopTime * 1000 do
								Citizen.Wait(0)
							end
							if GetEntitySpeed(vehicle) * 2.236936 < Config.MinSpeedtoCook then
								CanContinue = true
								ESX.ShowNotification("Somebody snitched, get the fuck outta here!")
								Citizen.Wait(1000)
								--server event notify police
							else
								CanContinue = true
								CurrentlyStopped = false
							end
						end)
					end
				else
					if CanContinue then
						CurrentlyStopped = false
					end
				end
			end
			if doBreak then
				ESX.ShowNotification(doBreak)
				TriggerServerEvent('adrp_meth:RemoveTruck', NetworkGetNetworkIdFromEntity(Truck))
				TriggerServerEvent('adrp_meth:FinishCook', Driver, false, driverMsg)
				Driver = false
				Truck = false
				doCount = false
				CurrentlyStopped = false
				exports['progressBars']:closeUI()
			end
		end
	end)

	exports['progressBars']:startUI(math.floor(Config.CookTimerA * 60 * 1000), "Preparing ingredients")
	Citizen.Wait(math.floor(Config.CookTimerA * 60 * 1000) + 5000)

	if doCount then
		exports['progressBars']:startUI(math.floor(Config.CookTimerB * 60 * 1000), "Cooking meth")
		Citizen.Wait(math.floor(Config.CookTimerB * 60 * 1000) + 5000)
	else
		return
	end

	if doCount then
		exports['progressBars']:startUI(math.floor(Config.CookTimerC * 60 * 1000), "Allowing meth to set")
		Citizen.Wait(math.floor(Config.CookTimerC * 60 * 1000) + 5000)
	else
		return
	end

	if doCount then
		exports['progressBars']:startUI(math.floor(Config.CookTimerD * 60 * 1000), "Packaging meth")
		Citizen.Wait(math.floor(Config.CookTimerD * 60 * 1000) + 5000)
	else
		return
	end

	if doCount then
		ESX.ShowNotification("You finished the cook.")
		TriggerServerEvent('adrp_meth:FinishCook', Driver, true, "The cook has finished.")
		Driver = false
	end
end

SmokingTrucks = {}

function SyncSmoke(netId)
	SmokingTrucks[netId] = false
end

local SmokeSpawnDist = 50.0
function SmokeTracker()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		local plypos = GetEntityCoords(ped)
		local removeList = {}
		for k,v in pairs(SmokingTrucks) do
			local doesExist = NetworkDoesEntityExistWithNetworkId(k)
			local ent
			if doesExist then
				ent = NetworkGetEntityFromNetworkId(k)
			end
			if not v then
				if DoesEntityExist(ent) then
					local pos = GetEntityCoords(ent)
					local dist = GetVecDist(pos, plypos)
					print("[ adrp_meth ] Added smoking truck to the list (in range, should begin smoking).")
					if dist < SmokeSpawnDist then
						if not HasNamedPtfxAssetLoaded("core") then
							RequestNamedPtfxAsset("core")
						end
						while not HasNamedPtfxAssetLoaded("core") do
							Citizen.Wait(0)
						end
						SetPtfxAssetNextCall("core")
						StartNetworkedParticleFxLoopedOnEntity("exp_grd_grenade_smoke", ent, 0.0,0.0,0.5, 0.0,0.0,0.0, 1.0, false,false,false)
						SmokingTrucks[k] = true
					end
				end
			else
				if (not ent and SmokingTrucks[k]) or (ent and not DoesEntityExist(ent)) then
					SmokingTrucks[k] = false
				end
			end
		end
	end
end

Citizen.CreateThread(function()
	SmokeTracker()
end)

function FinishCooking(result, msg)
	if result then
		ESX.ShowNotification(msg)
		CookFinished = true
	else
		ESX.ShowNotification(msg)
		MethCook = false
		DidNotify = false
	end
end

function NotifyPolice(pos, msg)
	ESX.ShowNotification(msg)
	local blip = AddBlipForRadius(pos.x, pos.y, pos.z, 50.0)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 80)
	local timer = GetGameTimer()
	while GetGameTimer - timer < Config.TrackableNotifyTimer * 1000 do
		Citizen.Wait(0)
		if IsControlJustPressed(0, 36) then
			SetNewWaypoint(pos.x, pos.y)
		end
	end
	RemoveBlip(blip)
end

function RemoveTruck(netId)
	if not netId then
		return
	end
	SmokingTrucks[netId] = nil
	Citizen.CreateThread(function()
		local doesExist = NetworkDoesEntityExistWithNetworkId(netId)
		local ent
		if doesExist then
			Citizen.Wait(60000)
			ent = NetworkGetEntityFromNetworkId(netId)
			DeleteVehicle(ent)
			DeleteEntity(ent)

		end
	end)
end


function SetJob(job)
	local playerjob = PlayerData.job
	--if not CheckPolice() then
		--TriggerServerEvent("ADRP:RemoveCop")
		--PlayerData.job = job
	--else
		TriggerServerEvent("ADRP:SetCop")
		PlayerData.job = job
	--end
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	SetJob(job)
end)

RegisterNetEvent('adrp_meth:BeginCooking')
AddEventHandler('adrp_meth:BeginCooking', function(target, source)
	print(target)
	print(source)
	BeginCooking(target)
end)

RegisterNetEvent('adrp_meth:FinishCook')
AddEventHandler('adrp_meth:FinishCook', function(result, msg)
	FinishCooking(result, msg)
end)

RegisterNetEvent('adrp_meth:SyncSmoke')
AddEventHandler('adrp_meth:SyncSmoke', function(netId)
	SyncSmoke(netId)
end)

RegisterNetEvent('adrp_meth:NotifyCops')
AddEventHandler('adrp_meth:NotifyCops', function(pos,msg)
	Citizen.CreateThread(function()
		NotifyPolice(pos,msg)
	end)
end)

RegisterNetEvent('adrp_meth:RemoveSmoke')
AddEventHandler('adrp_meth:RemoveSmoke', function(netId)
	RemoveTruck(netId)
end)