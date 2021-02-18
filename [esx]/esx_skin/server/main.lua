ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
	{
		['@skin']       = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)
	local date = os.date('%Y-%m-%d %H:%M')
	local identifier = GetPlayerIdentifiers(source)[1]
	local message = (('esx_skin: player attempted to run old event :responseSaveSkin!\n\nSource: %s | %s\nTime & Day: %s'):format(source, identifier, date))
	print(message)

	TriggerEvent('adrp_anticheat:cheaterDetected', message)
	TriggerEvent('adrp_anticheat:banCheater', source)
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			local jobSkin = {
				skin_male   = xPlayer.job.skin_male,
				skin_female = xPlayer.job.skin_female
			}
	
			if result[1] and result[1].skin then
				skin = json.decode(result[1].skin)
			end
	
			cb(skin, jobSkin)
		end)
	else
		cb('', {skin_female = '', skin_male = ''})
	end
end)

-- Commands
-- TriggerEvent('es:addGroupCommand', 'skin', 'pr', function(source, args, user)
-- 	TriggerClientEvent('esx_skin:openSaveableMenu', source)
-- end, function(source, args, user)
-- 	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
-- end, {help = _U('skin')})


TriggerEvent('es:addGroupCommand', 'skin', 'mod', function(source, args, user)
	if tonumber(args[1]) then
		local xPlayer = ESX.GetPlayerFromId(args[1])

		if xPlayer then
			TriggerClientEvent('esx_skin:openSaveableMenu', args[1])
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		end
	else
		TriggerClientEvent('esx_skin:openSaveableMenu', source)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {
	help = 'Set skin for player',
	params = {
		{ name = "id", help = 'ID'},
	}
})