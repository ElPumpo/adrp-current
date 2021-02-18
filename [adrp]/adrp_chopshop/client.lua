ESX = nil

local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local isDead                    = false
local CurrentTask               = {}
local menuOpen 				    = false
local wasOpen 				    = false
local pedIsTryingToChopVehicle  = false
local ChoppingInProgress        = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('ADRP_DEV:SpawnChopVehicle')
AddEventHandler('ADRP_DEV:SpawnChopVehicle', function()
	local random = GetRandomIntInRange(1, #Config.CarModels)
	local randomSpawn = GetRandomIntInRange(1, #Config.CarSpawns)
	local vehicle = GetHashKey(Config.CarModels[random])
	local driverPed = GetHashKey('csb_anton')

	RequestModel(vehicle)
	while not HasModelLoaded(vehicle) do
		Citizen.Wait(0)
	end
	RequestModel(driverPed)
	while not HasModelLoaded(driverPed) do
		Citizen.Wait(0)
	end
	ESX.Game.SpawnVehicle(vehicle, Config.CarSpawns[randomSpawn], 180.00, function(vehicle)
		CreatePedInsideVehicle(vehicle, 5, driverPed, -1, true, false)
		SetVehicleEngineOn(vehicle, true, true)

		TaskVehicleDriveWander(driverPed, vehicle, 20.0, 319)
		SetVehicleNumberPlateText(vehicle, 'CHOP ME')
	end)
	SetModelAsNoLongerNeeded(vehicle)
end)


function CreateBlipCircle(coords, text, radius, color, sprite)

	local blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, color)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	if Config.EnableBlips == true then
		for k,zone in pairs(Config.Zones) do
			CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords, letSleep = GetEntityCoords(PlayerPedId()), true
		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance then
				DrawMarker(27, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, nil, nil, false)
				letSleep = false
				if IsControlJustReleased(0, 38) then
					chopVehicle()
				end
			end
		end
		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

function chopVehicle()

	for k,v in pairs(Config.MechanicPeds) do

		RequestModel(v.Model)
		while not HasModelLoaded(v.Model) do
			Citizen.Wait(0)
		end
	end
	print(Config.MechanicPeds.MechanicPed1.name)
	local mech1 = CreatePed(4, Config.MechanicPeds.MechanicPed1.Model, Config.MechanicPeds.MechanicPed1.coords, 180.0, true, true)
	local mech2 = CreatePed(4, Config.MechanicPeds.MechanicPed1.Model, Config.MechanicPeds.MechanicPed2.coords, 180.0, true, true)
	local mech3 = CreatePed(4, Config.MechanicPeds.MechanicPed1.Model, Config.MechanicPeds.MechanicPed3.coords, 180.0, true, true)
	local mech4 = CreatePed(4, Config.MechanicPeds.MechanicPed1.Model, Config.MechanicPeds.MechanicPed4.coords, 180.0, true, true)
	Citizen.Wait(500)
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	local door1pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_dside_f'))
	local door2pos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_pside_f'))
	local hoodpos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'door_pside_r'))
	local trunkpos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, 'platelight'))
	local vehCoords = GetEntityCoords(GetVehiclePedIsIn(PlayerPedId(), false))
	TaskPedSlideToCoord(mech1, trunkpos, GetEntityHeading(veh), 10.0)
	TaskPedSlideToCoord(mech2, hoodpos, 10.0)
	TaskPedSlideToCoord(mech3, door1pos, 0.0, 10.0)
	TaskPedSlideToCoord(mech4, door2pos, 0.0, 10.0)
	Citizen.Wait(20000)
	TaskChatToPed(mech2, PlayerPedId(), 16, 0.0, 0.0, 0.0, 0.0, 0.0)
	TaskChatToPed(mech3, PlayerPedId(), 16, 0.0, 0.0, 0.0, 0.0, 0.0)
	TaskChatToPed(mech4, PlayerPedId(), 16, 0.0, 0.0, 0.0, 0.0, 0.0)
	Citizen.Wait(5000)
	SetVehicleDoorOpen(veh, 4, false, false)
	SetVehicleDoorOpen(veh, 0, false, false)
	SetVehicleDoorOpen(veh, 1, false, false)
	SetVehicleDoorOpen(veh, 5, false, false)
	TaskStartScenarioInPlace(mech4, 'PROP_HUMAN_BUM_BIN', 0, true)
	TaskStartScenarioInPlace(mech1, 'PROP_HUMAN_BUM_BIN', 0, true)
	TaskStartScenarioInPlace(mech3, 'WORLD_HUMAN_WELDING', 0, true)
	TaskStartScenarioInPlace(mech2, 'WORLD_HUMAN_WELDING', 0, true)

end