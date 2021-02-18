local playerCount = 0
local list = {}

RegisterServerEvent('hardcap:playerActivated')
AddEventHandler('hardcap:playerActivated', function()
	if not list[source] then
		playerCount = playerCount + 1
		list[source] = true
	end

	print(('hardcap: %s has joined'):format(GetPlayerName(source)))
end)

AddEventHandler('playerDropped', function()
	if list[source] then
		playerCount = playerCount - 1
		list[source] = nil
	end
end)

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	-- Mark this connection as deferred, this is to prevent problems while checking player identifiers.
	deferrals.defer()

	print(('hardcap: %s is joining'):format(name))

	local _source, maxClients = source, GetConvarInt('sv_maxclients', 32)

	-- Letting the user know what's going on.
	deferrals.update('hardcap: Checking if the server is full . . .')

	-- Needed, not sure why.
	Citizen.Wait(100)

	if playerCount >= maxClients then
		if Config.PrintWhenFull then
			print(('hardcap: %s couldn\'t join (full server)'):format(name))
		end

		deferrals.done('The server is full, sorry')
	else
		deferrals.done()
	end
end)

function getConnectedPlayers()
	return playerCount
end
