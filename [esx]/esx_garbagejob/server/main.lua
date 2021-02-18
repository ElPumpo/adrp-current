ESX = nil
local playerTimeouts = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	playerTimeouts[playerId] = nil
end)

RegisterNetEvent('esx_garbagejob:pay')
AddEventHandler('esx_garbagejob:pay', function(amount)
	local identifier = GetPlayerIdentifier(source, 0)
	local formatted = ('**SteamID:** %s\n**Amount:** %s'):format(identifier, amount)
	TriggerEvent('adrp_anticheat:cheaterDetected', formatted, 'esx_garbagejob cheater detected! (pay)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_garbagejob:theRealPay')
AddEventHandler('esx_garbagejob:theRealPay', function(amount)
	local identifier = GetPlayerIdentifier(source, 0)
	local formatted = ('**SteamID:** %s\n**Amount:** %s'):format(identifier, amount)
	TriggerEvent('adrp_anticheat:cheaterDetected', formatted, 'esx_garbagejob cheater detected! (theRealPay)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_garbagejob:payForWork')
AddEventHandler('esx_garbagejob:payForWork', function(amount)
	local identifier = GetPlayerIdentifier(source, 0)
	local formatted = ('**SteamID:** %s\n**Amount:** %s'):format(identifier, amount)
	TriggerEvent('adrp_anticheat:cheaterDetected', formatted, 'esx_garbagejob cheater detected! (payForWork)')
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

RegisterNetEvent('esx_garbagejob:giveCash')
AddEventHandler('esx_garbagejob:giveCash', function(amount)
	if amount > 20000 then
		local identifier = GetPlayerIdentifier(source, 0)
		local formatted = ('**SteamID:** %s\n**Amount:** %s'):format(identifier, amount)
		TriggerEvent('adrp_anticheat:cheaterDetected', formatted, 'esx_garbagejob cheater detected! (giveCash money limit)')
		TriggerEvent('adrp_anticheat:banCheater', source)
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer then
			local pay, timeNow = false, os.clock()

			if playerTimeouts[source] then
				local timeSpent = timeNow - playerTimeouts[source]
				playerTimeouts[source] = timeNow

				if timeSpent >= 5 then
					pay = true
				else
					local formatted = ('**SteamID:** %s\n**Amount:** %s'):format(xPlayer.identifier, amount)
					TriggerEvent('adrp_anticheat:cheaterDetected', formatted, 'esx_garbagejob cheater detected! (giveCash timeout)')
					TriggerEvent('adrp_anticheat:banCheater', source)
				end
			else
				playerTimeouts[source] = timeNow
				pay = true
			end

			if pay then
				if amount > 0 then
					xPlayer.addMoney(amount)
				else
					if math.abs(amount) < 20000 then
						if xPlayer.getMoney() >= math.abs(amount) then
							xPlayer.removeMoney(math.abs(amount))
						else
							xPlayer.setMoney(0)
						end
					end
				end
			end
		end
	end
end)