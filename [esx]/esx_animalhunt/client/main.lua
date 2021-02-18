local animalPed, entityBlip

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local blip = AddBlipForRadius(Config.HuntingGround, 270.0)

	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 46)
	SetBlipAlpha (blip, 70)

	blip = AddBlipForCoord(Config.HuntingGround)
	SetBlipSprite (blip, 141)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 17)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Hunting Ground')
	EndTextCommandSetBlipName(blip)

	blip = AddBlipForCoord(Config.HuntingShop)
	SetBlipSprite (blip, 141)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 17)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Hunting Shop')
	EndTextCommandSetBlipName(blip)

	blip = AddBlipForCoord(Config.MeatMarket)
	SetBlipSprite (blip, 52)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString('Meat Market')
	EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
	Marker.AddMarker('hunting_shop', Config.HuntingShop, 'Press ~INPUT_CONTEXT~ to access the ~o~Hunting Shop~s~.', function()
		ESX.TriggerServerCallback('esx_license:checkLicense', function(hasHuntingLicense)
			if hasHuntingLicense then
				OpenHuntingShopMenu()
			else
				OpenLicenceMenu()
			end
		end, GetPlayerServerId(PlayerId()), 'hunting')
	end)

	Marker.AddMarker('meat_shop', Config.MeatMarket, 'Press ~INPUT_CONTEXT~ to sell all your ~o~Meat~s~ to the ~o~Meat Shop~s~.', function()
		ESX.TriggerServerCallback('esx_animalhunt:sellMeat', function(money)
			if money > 0 then
				ESX.ShowNotification(('You recieved ~g~$%s~s~ for all your meat'):format(ESX.Math.GroupDigits(money)))
			else
				ESX.ShowNotification('You dont have any meat to sell!')
			end
		end)
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local distance = GetDistanceBetweenCoords(coords, Config.HuntingGround, true)

		if distance < 270.0 and IsPedOnFoot(playerPed) then

			if animalPed == nil then
				local chance = math.random(1, 3)

				if chance == 2 then
					local choosenAnimal = math.random(1, #Config.HuntingModels)
					choosenAnimal = Config.HuntingModels[choosenAnimal]
					local spawnpoint = GenerateRandomSpawnPoint()
	
					ESX.Streaming.RequestModel(choosenAnimal.hash)
	
					animalPed = CreatePed(28, choosenAnimal.hash, spawnpoint, 0.0, true, false)
	
					TaskWanderStandard(animalPed, 0, 0)
					SetEntityAsMissionEntity(animalPed, false, true)
					ESX.ShowNotification('A ~o~' .. choosenAnimal.name .. '~s~ has been spotted in the area.')
				else
					Citizen.Wait(7500)
				end

			end
		else
			if animalPed then
				if DoesEntityExist(animalPed) then
					DeletePed(animalPed)
				end

				if DoesBlipExist(entityBlip) then
					RemoveBlip(entityBlip)
				end

				animalPed, entityBlip = nil, nil
				ESX.ShowNotification('You have abandoned the ~o~Hunting Ground~s~')
			end
		end
	end
end)

function GenerateRandomSpawnPoint()
	while true do
		Citizen.Wait(10)
		local coordX, coordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-250, 250)

		Citizen.Wait(4000)
		math.randomseed(GetGameTimer() + GetGameplayCamFov())
		local modY = math.random(-250, 250)

		coordX = Config.HuntingGround.x + modX
		coordY = Config.HuntingGround.y + modY

		local coordZ = GetCoordZ(coordX, coordY)
		local coord = vector3(coordX, coordY, coordZ)

		local distance = GetDistanceBetweenCoords(coord, Config.HuntingGround, true)

		if distance < 250 then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = {}

	for i=1, 300 do
		table.insert(groundCheckHeights, i + 0.1)
	end

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 100.0
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if animalPed then
			if DoesEntityExist(animalPed) then
				local animalHealth = GetEntityHealth(animalPed)
				local isAnimalDead = animalHealth == 0

				local playerPed = PlayerPedId()
				local playerCoords = GetEntityCoords(playerPed)
				local targetCoords = GetEntityCoords(animalPed)
				local distance = GetDistanceBetweenCoords(playerCoords, targetCoords, true)

				if not DoesBlipExist(entityBlip) and distance < 100 then
					entityBlip = AddBlipForEntity(animalPed)

					SetBlipSprite(entityBlip, 433)
					SetBlipDisplay(entityBlip, 4)
					SetBlipScale(entityBlip, 1.0)
					SetBlipColour(entityBlip, 6)

					ESX.ShowNotification('The wild animal has been spotted!')
				elseif DoesBlipExist(entityBlip) and distance > 100 then
					RemoveBlip(entityBlip)
					ESX.ShowNotification('You have lost track of the animal..')
				end

				if GetDistanceBetweenCoords(targetCoords, Config.HuntingGround, true) > 280.0 then
					DeletePed(animalPed)

					if DoesBlipExist(entityBlip) then
						RemoveBlip(entityBlip)
					end
	
					animalPed, entityBlip = nil, nil
					ESX.ShowNotification('The wild animal has escaped the area!')
				end

				if distance < 4 and isAnimalDead and IsPedOnFoot(playerPed) then
					local death = GetPedCauseOfDeath(animalPed)

					if GetPedCauseOfDeath(animalPed) == GetHashKey('WEAPON_MUSKET') then
						if GetSelectedPedWeapon(playerPed) == GetHashKey('WEAPON_KNIFE') then
							ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to skin the ~o~Meat~s~.')
	
							if IsControlJustReleased(0, 38) then
								SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
								ESX.Streaming.RequestAnimDict('amb@medic@standing@kneel@base')
								ESX.Streaming.RequestAnimDict('anim@gangops@facility@servers@bodysearch@')
								TaskPlayAnim(playerPed, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
								TaskPlayAnim(playerPed, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48, 0, false, false, false )

								Citizen.Wait(5000)
								ClearPedTasksImmediately(playerPed)
								TriggerServerEvent('esx_animalhunt:harvestReward')
								RemoveBlip(entityBlip)
	
								animalPed, entityBlip = nil, nil
	
								ESX.ShowNotification('Now go find another target!')
							end
						else
							ESX.ShowHelpNotification('You must have a knife to skin the animal!')
						end
					else
						ESX.ShowHelpNotification('You can only skin animals killed using the Musket!')
						RemoveBlip(entityBlip)
						animalPed, entityBlip = nil, nil
					end

				else
					Citizen.Wait(500)
				end
			else
				animalPed = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)