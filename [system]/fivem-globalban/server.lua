function checkIdentifierBanned(info, type)
	PerformHttpRequest(('https://www.family-v.fr/global_ban_api/bans/search.php/?id=%s&warning=%s'):format(info, Config.WarningLevel), function(err, rText, headers)
		if err == 200 then
			return false
		end
	end, 'GET', '', {['Content-Type'] = 'application/json'})

	return true
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	local playerId = source
	deferrals.defer()
	deferrals.update('Making sure you are not globally banned')

	Citizen.Wait(300)

	local identifiers = GetPlayerIdentifiers(playerId)

	local steam = checkIdentifierBanned(identifiers[1], 'steam')
	Citizen.Wait(1000)

	local license = checkIdentifierBanned(identifiers[2], 'licence')
	Citizen.Wait(1000)

	local ip = checkIdentifierBanned(identifiers[3], 'ip')
	Citizen.Wait(1000)

	if steam and license and ip then
		deferrals.done()
	else
		TriggerEvent('adrp_anticheat:sendLog', ('Rejecting user %s due to global ban'):format(steam))
		deferrals.done('The Ban Hammer has spoken\nYou\'re globally permanently banned from the united federation of FiveM communities.')
	end
end)
