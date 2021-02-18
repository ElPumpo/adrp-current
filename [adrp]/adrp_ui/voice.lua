local gamerTags = {}
local nearbyPlayers = {}
local playersTyping = {}

RegisterNetEvent('chat:updateTyping')
AddEventHandler('chat:updateTyping', function(players)
	for playerId,isTalking in ipairs(players) do
		local player = GetPlayerFromServerId(playerId)

		playersTyping[player] = isTalking
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed)

		for _,id in ipairs(GetActivePlayers()) do
			if id ~= PlayerId() then
				local targetPlayer = id
				local targetPed = GetPlayerPed(targetPlayer)
				local targetCoords = GetEntityCoords(targetPed)

				-- check the ped, because changing player models may recreate the ped
				-- also check gamer tag activity in case the game deleted the gamer tag
				if not gamerTags[targetPlayer] or gamerTags[targetPlayer].ped ~= targetPed or not IsMpGamerTagActive(gamerTags[targetPlayer].tag) then
					-- remove any existing tag
					if gamerTags[targetPlayer] then
						RemoveMpGamerTag(gamerTags[targetPlayer].tag)
					end

					-- store the new tag
					gamerTags[targetPlayer] = {
						tag = CreateMpGamerTag(targetPed, '', false, false, '', 0),
						ped = targetPed
					}
				end

				local tag = gamerTags[targetPlayer].tag
				local distance = #(targetCoords - playerCoords)
	
				-- hide name tag
				SetMpGamerTagVisibility(tag, 0, false)

				-- show/hide based on nearbyness/line-of-sight
				-- nearby checks are primarily to prevent a lot of LOS checks
				if distance < 50 and HasEntityClearLosToEntity(playerPed, targetPed, 17) then
					nearbyPlayers[targetPlayer] = true
				else
					nearbyPlayers[targetPlayer] = nil
					SetMpGamerTagVisibility(tag, 9, false)
				end
			elseif gamerTags[id] then
				RemoveMpGamerTag(gamerTags[id].tag)
				gamerTags[id] = nil
				nearbyPlayers[id] = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)

		for playerId,_ in pairs(nearbyPlayers) do
			local tag = gamerTags[playerId].tag
			SetMpGamerTagVisibility(tag, 9, NetworkIsPlayerTalking(playerId))

			if playersTyping[playerId] then
				SetMpGamerTagVisibility(tag, 16, true)
			else
				SetMpGamerTagVisibility(tag, 16, false)
			end
		end

		if next(nearbyPlayers) == nil then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for k,v in pairs(gamerTags) do
			RemoveMpGamerTag(v.tag)
		end
	end
end)