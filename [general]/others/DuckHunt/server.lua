local activated = false
local generatedNumbers = {}

TriggerEvent('es:addGroupCommand', 'duckhunt', 'admin', function(source, args, user)
	if activated == false then
		TriggerClientEvent('ADRP:DuckHunt', -1, true)
		activated = true
	else
		TriggerClientEvent('ADRP:DuckHunt', -1, false)
		activated = false
	end
end, function(source, args, user)
	TriggerClientEvent('customNotification', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end)

TriggerEvent('es:addGroupCommand', 'choosesniper', 'admin', function(source, args, user)
	local xPlayers = ESX.GetPlayers()

	local randomNumber = math.random(1, #xPlayers)

	local chosenSniper = (xPlayers[randomNumber])
	TriggerClientEvent('ADRP:chosenSniper', chosenSniper)
	TriggerClientEvent("chatMessage", -1, "SERVER EVENT (DUCK HUNT)", {255, 0, 0}, "The chosen sniper will be..."..GetPlayerName(chosenSniper).." With a id of "..chosenSniper)
end, function(source, args, user)
	TriggerClientEvent('customNotification', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end)

function GetPlayers()
	local players = {}

	for i = 0, 31 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, i)
		end
	end

	return players
end