ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	local players = ESX.GetPlayers()

	for _,playerId in ipairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		MySQL.Async.fetchAll('SELECT status FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local data = {}

			if result[1].status then
				data = json.decode(result[1].status)
			end

			xPlayer.set('status', data)
			TriggerClientEvent('esx_status:load', playerId, data)
		end)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		local status = xPlayer.get('status')

		if status then
			MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
				['@status'] = json.encode(status),
				['@identifier'] = xPlayer.identifier
			})
		end
	end
end)

AddEventHandler('esx_status:getStatus', function(playerId, statusName, cb)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local status  = xPlayer.get('status')

	for i=1, #status, 1 do
		if status[i].name == statusName then
			cb(status[i])
			break
		end
	end
end)

RegisterServerEvent('esx_status:update')
AddEventHandler('esx_status:update', function(status)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.set('status', status)
	end
end)

function SaveData()
	print('esx_status: SaveData()')
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer then
			local status = xPlayer.get('status')

			if status then
				MySQL.Async.execute('UPDATE users SET status = @status WHERE identifier = @identifier', {
					['@status'] = json.encode(status),
					['@identifier'] = xPlayer.identifier
				})
			end
		end

		Citizen.Wait(100)
	end

	SetTimeout(10 * 60 * 1000, SaveData)
end

-- SaveData()
