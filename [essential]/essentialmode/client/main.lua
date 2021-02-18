Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('es:firstJoinProper')
			TriggerEvent('es:allowedToSpawn')
			return
		end
	end
end)

local previousCoords
local pvpEnabled = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local playerCoords = GetEntityCoords(PlayerPedId())

		if previousCoords ~= playerCoords then
			TriggerServerEvent('es:updatePositions', playerCoords.x, playerCoords.y, playerCoords.z)
			previousCoords = playerCoords
		end
	end
end)

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

local enableNative = {}

local firstSpawn = true
AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	TriggerServerEvent('playerSpawn')
end)

RegisterNetEvent('es:setMoneyIcon')
AddEventHandler('es:setMoneyIcon', function(i)

end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)

end)

RegisterNetEvent('es:displayMoney')
AddEventHandler('es:displayMoney', function(a)

end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(a)

end)

RegisterNetEvent("es:addedMoney")
AddEventHandler("es:addedMoney", function(m, native)

end)

RegisterNetEvent("es:removedMoney")
AddEventHandler("es:removedMoney", function(m, native, current)

end)

RegisterNetEvent('es:addedBank')
AddEventHandler('es:addedBank', function(m)

end)

RegisterNetEvent('es:removedBank')
AddEventHandler('es:removedBank', function(m)

end)

RegisterNetEvent("es:setMoneyDisplay")
AddEventHandler("es:setMoneyDisplay", function(val)

end)

RegisterNetEvent("es:enablePvp")
AddEventHandler("es:enablePvp", function()
	pvpEnabled = true
end)

AddEventHandler('playerSpawned', function(spawn)
	if pvpEnabled then
		SetCanAttackFriendly(PlayerPedId(), true, false)
		NetworkSetFriendlyFireOption(true)
	end
end)