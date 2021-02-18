RegisterNetEvent('player:serviceOn')
AddEventHandler('player:serviceOn', function(job)
	if job == 'police' or job == 'state' or job == 'sheriff' then
		availablePolice[source] = true
	end
end)

RegisterNetEvent('player:serviceOff')
AddEventHandler('player:serviceOff', function(job)
	availablePolice[source] = nil
end)

ESX.RegisterServerCallback('esx_jail:attemptJailBreak', function(source, cb)
	if jailBreakCooldown then
		cb(false, _U('jailbreak_cooldown'))
	elseif ESX.Table.SizeOf(availablePolice) < Config.PrisonBreakRequiredCops then
		cb(false, _U('jailbreak_enoughcops'))
	elseif ESX.Table.SizeOf(playersInJail) == 0 then
		cb(false, _U('jailbreak_noprisoners'))
	elseif jailBreak then
		cb(false, _U('jailbreak_inprogress'))
	else
		TriggerClientEvent('esx_jail:prisonBreakStarted', -1)
		jailBreak, breakoutPlayer = true, source

		Citizen.CreateThread(function()
			startPrisonBreakTimer()
		end)

		cb(true)
	end
end)

function startPrisonBreakTimer()
	Citizen.Wait(Config.PrisonBreakTime)

	if jailBreak then
		for playerId,_ in pairs(playersInJail) do
			Citizen.Wait(10)
			unjailPlayer(playerId, true)
		end

		TriggerClientEvent('esx:showAdvancedNotification', -1, _U('noti_title_success'), '', _U('noti_msg_success'), 'CHAR_CALL911', 1)
		TriggerClientEvent('esx_jail:cancelPrisonBreak', -1)
		startCooldownTimer()
	end
end

function startCooldownTimer()
	if jailBreakCooldown then
		return
	end

	Citizen.CreateThread(function()
		jailBreakCooldown = true
		TriggerClientEvent('esx_jail:updateCooldownStatus', -1, jailBreakCooldown)
		Citizen.Wait(Config.PrisonBreakCooldown)
		jailBreakCooldown = false

		TriggerClientEvent('esx:showAdvancedNotification', -1, _U('noti_title_cooldown_end'), '', _U('noti_msg_cooldown_end'), 'CHAR_CALL911', 1)
		TriggerClientEvent('esx_jail:updateCooldownStatus', -1, jailBreakCooldown)
	end)
end

AddEventHandler('playerDropped', function()
	-- save the source in case we lose it (which happens a lot)
	local playerId = source
	
	-- did the player ever join?
	if playerId and playerId < 5000 then
		if jailBreak and breakoutPlayer == playerId then
			jailBreak, breakoutPlayer = false, nil

			TriggerClientEvent('esx_jail:cancelPrisonBreak', -1, true)
			startCooldownTimer()
		end
	end
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	if jailBreak and breakoutPlayer == source then
		jailBreak, breakoutPlayer = false, nil

		TriggerClientEvent('esx_jail:cancelPrisonBreak', -1, true)
		startCooldownTimer()
	end
end)

RegisterNetEvent('esx_jail:cancelPrisonBreak')
AddEventHandler('esx_jail:cancelPrisonBreak', function()
	if jailBreak and breakoutPlayer == source then
		jailBreak, breakoutPlayer = false, nil

		TriggerClientEvent('esx_jail:cancelPrisonBreak', -1, true)
		startCooldownTimer()
	end
end)