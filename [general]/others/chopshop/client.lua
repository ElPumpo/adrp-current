local waiting = false
local enabled = true
local carPlate = nil

local vehicleList = {
	"BLISTA",
	"ZENTORNO",
	"TAMPA",
}

local spawning = {
	{x = 2352.0627, y = 3132.855, z = 47.208},
}

local plates = {
	"ADRP",
	"CHOP",
	"CHUBB",
	"CASH",
	"MEME",
	"BLAH"
}

local chopshoplocations = {
	["ChopJunk"] = {
		coords = {x = 2352.0627, y = 3132.855, z = 47.208},
		minRequired = 5,
		sellRange = {min = 10, max = 35},
	},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlPressed(0, 38) then
			SpawnVehicle()
		end
	end
end)

RegisterNetEvent('ADRP:getPlate')
AddEventHandler('ADRP:getPlate', function(plate)
	print(plate)
	carPlate = plate
end)


function SpawnVehicle()
	local ped = PlayerPedId()
	local randomCar = math.random(1,#vehicleList)
	local randomPlate = math.random(1,#plates)
	local vehiclePlate = plates[randomPlate]..GetRandomIntInRange(1000, 9000)
	local randomSpawn = math.random(1, #spawning)
	local vehicle = GetHashKey(vehicleList[randomCar])

	local pedHash = GetHashKey("a_m_m_skater_01")

	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Wait(0)
	end

	RequestModel(pedHash)
	while not HasModelLoaded(pedHash) do
		Wait(0)
	end

	local vehicle_spawned = CreateVehicle(vehicle, 2352.0627, 3132.855, 48.208, 180.0, true, true)
	local vehicle_coords = GetEntityCoords(vehicle_spawned)

	local vehiclePlace = GetStreetNameAtCoord(vehicle_coords.x, vehicle_coords.y, vehicle_coords.z)
	local vehiclePlace2 = GetStreetNameFromHashKey(vehiclePlace)


	SetVehicleNumberPlateText(vehicle_spawned, vehiclePlate)
	local ped_spawned = CreatePed(4, pedHash, 2352.0627, 3132.855, 48.208, 180, true, true)
	SetPedIntoVehicle(ped_spawned, vehicle_spawned, -1)


	SetVehicleEngineOn(vehicle_spawned, true, true)
	TaskVehicleDriveWander(ped_spawned, vehicle_spawned, 80.0, 1074528293)
	Citizen.Wait(3000)
	local wantedPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle_spawned))
	local message = "The chopshop is looking for another vehicle. Plate is: "..wantedPlate.." leaving "..vehiclePlace2
	TriggerServerEvent("ADRP:testing", message)
	carPlate = wantedPlate
	TriggerServerEvent("ADRP:sendPlate", carPlate)
end


Citizen.CreateThread(function()
	for k,v in pairs(chopshoplocations) do
		local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
		SetBlipSprite(blip, 380)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(k)
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip, true)
	end

	while true do
		Citizen.Wait(10)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local canSleep = true

		for k,v in pairs(chopshoplocations) do
			local chopDistance = GetDistanceBetweenCoords(v.coords.x, v.coords.y, v.coords.z, playerCoords, true)

			if chopDistance < 150 then
				canSleep = false
				DrawMarker(1, v.coords.x, v.coords.y, v.coords.z-1, 0,0,0,0,0,0,10.001,10.0001,0.8001,0,155,255,175,0,0,0,0)
				if chopDistance < 10 then
					if IsPedInAnyVehicle(PlayerPedId(), true) then
						drawTxt('Press ENTER to CHOP vehicle',0,1,0.5,0.05,0.6,255,255,255,255)

						if IsControlJustPressed(0, 201) then
							TriggerEvent('ADRP:getPlate')
							TriggerServerEvent('ADRP:sendPlate', carPlate)
						end
					end
				end
			end
		end

		if canSleep then
			Citizen.Wait(1000)
		end
	end
end)



RegisterNetEvent('ADRP:chopVehicle')
AddEventHandler('ADRP:chopVehicle', function(plate)
	local vPlate = plate
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local vehiclePlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
	print(vPlate)
	if vPlate == vehiclePlate then
		local startTime = GetGameTimer()
		startChopTime = GetEntityCoords(ped, true)
		local timeinMS = math.floor(1000*60*chopshoplocations[key].minRequired)

		local ms = timeinMS
		local seconds = 0
		local minutes = 0
		local chopping = true

		Citizen.CreateThread(function()
			while chopping do
				Wait(0)
				if GetDistanceBetweenCoords(startChopTime, GetEntityCoords(ped, true)) < 3 then
					drawTxt("Chopping time remaing: ~o~" .. minutes .. "~s~ minutes and ~o~" .. seconds .. " ~s~seconds",0,1,0.5,0.8,0.6,255,255,255,255)
					showPVP()
				end
			end
		end)

		while chopping do
			if IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) then
				if GetGameTimer() < startTime + timeinMS then
					if GetDistanceBetweenCoords(startChopTime, GetEntityCoords(ped, true)) < 3 then
						local vehicle = GetVehiclePedIsIn(ped, false)
						ms = ms - 1000
						seconds = math.floor((ms/1000) % 60)
						mintues = math.floor(((ms-seconds) / 1000) / 60)
					else
						chopping = false
					end
					Wait(1000)
				else
					chopping = false
					buyprice = math.floor(((math.random(chopshoplocations[key].sellRange.min, chopshoplocations.sellRange.max))))
					TaskLeaveVehicle(ped, vehicle, 0)
					Wait(2000)
					DeleteVehicle(vehicle)
				end
			else
				chopping = false
				--must be in vehicle check
			end
		end
	else
		TriggerEvent('customNotification',  "This isn't the vehicle we are looking for!")
	end
end)


function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropshadow(0, 0, 0, 0,255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y) 
end

function showPVP()
	drawTxt('~r~You are chopping a vehicle meaning you are now in PVP and can be killed at any time',0,1,0.5,0.08,0.6,255,255,255,255)
end

function DeleteVehicle(vehicle)
	SetEntityCoords(vehicle, 9000.0, 9000.0, -10.0, 0.0, 0.0, 0.0)
	SetEntityAsMissionEntity(vehicle, true, true)
	Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
	DeleteEntity(vehicle)
end