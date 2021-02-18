ESX = nil
inMenu = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(100)
	end

	for _,account in pairs(ESX.GetPlayerData().accounts) do
		if account.name == 'bank' then
			SendNUIMessage({action = 'setBalance', balance = ESX.Math.GroupDigits(account.money)})
			break
		end
	end
end)

RegisterNetEvent('esx:setName')
AddEventHandler('esx:setName', function(newName)
	SendNUIMessage({action = 'setPlayerName', playerName = newName})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == 'bank' then
		SendNUIMessage({action = 'setBalance', balance = ESX.Math.GroupDigits(account.money)})
	end
end)

-- Create Bank Blips
Citizen.CreateThread(function()
	for k,v in ipairs(Config.BankLocations) do
		local blip = AddBlipForCoord(v)

		SetBlipSprite(blip, 374)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Bank Office')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)
		local bank, atm = isNearBank(playerCoords), isNearATM(playerCoords)

		if bank or atm then
			if IsPedOnFoot(playerPed) and not inMenu then
				ESX.ShowHelpNotification('Press ~INPUT_PICKUP~ to access your ~y~Bank Account~s~.')

				if IsControlJustReleased(0, 38) then
					inMenu = true
					SetNuiFocus(true, true)
					SendNUIMessage({action = 'openGeneral'})
				end
			end
		elseif not bank and not atm then
			Citizen.Wait(500)
		end
	end
end)

RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('esx_atm:deposit', tonumber(data.amount))
end)

RegisterNUICallback('withdraw', function(data)
	TriggerServerEvent('esx_atm:withdraw', tonumber(data.amount))
end)

RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('esx_atm:transfer', tonumber(data.to), tonumber(data.amount))
end)

RegisterNUICallback('focus_off', function()
	inMenu = false
	SetNuiFocus(false)
	SendNUIMessage({action = 'closeAll'})
end)

function isNearBank(playerCoords)
	for _,bank in ipairs(Config.BankLocations) do
		local distance = #(playerCoords - bank)

		if distance < 3 then
			return true
		end
	end

	return false
end

function isNearATM(playerCoords)
	for _,atm in ipairs(Config.AtmLocations) do
		local distance = #(playerCoords - atm)
		if distance < 2 then
			return true
		end
	end

	return false
end

-- close the menu when script is stopping to avoid being stuck in NUI focus
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if inMenu then
			SetNuiFocus(false)
			SendNUIMessage({action = 'closeAll'})
		end
	end
end)