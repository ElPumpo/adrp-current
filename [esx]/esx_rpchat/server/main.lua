ESX = nil
local players = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('adrp_characterspawn:characterSet', function(character)
	players[character.playerId] = {
		fullname = character.fullname,
		firstname = character.firstname,
		job = character.job
	}
end)

AddEventHandler('playerDropped', function(reason)
	players[source] = nil
end)

AddEventHandler('es:invalidCommandHandler', function(source, commandArgs, user)
	CancelEvent()
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', ('^3%s^0 is not a valid command!'):format(commandArgs[1]) } })
end)

function getIdentity(playerId, cb)
	return cb(players[playerId])
end

AddEventHandler('chatMessage', function(source, name, message)
	if string.sub(message, 1, string.len("/")) ~= "/" then
		CancelEvent()

		getIdentity(source, function(data)
			TriggerClientEvent("sendProximityMessage", -1, source, "^1OOC | ".. data.fullname, "^7" ..message)
		end)
	end
end)

TriggerEvent('es:addCommand', 'me', function(source, args, user)
	getIdentity(source, function(data)
		TriggerClientEvent("sendProximityMessageMe", -1, source, data.firstname, table.concat(args, " "))
	end)
end, {help = '[Proximity] Describe actions or things that are happening with your character', params = {{name = 'message', help = 'the message'}}})

TriggerEvent('es:addCommand', 'do', function(source, args, user)
	getIdentity(source, function(data)
		TriggerClientEvent("sendProximityMessageDo", -1, source, data.firstname, table.concat(args, " "))
	end)
end, {help = '[Proximity] Describe actions that may be happening around you', params = {{name = 'message', help = 'the message'}}})

TriggerEvent('es:addCommand', 'pd', function(source, args, user)
	local _source = source

	getIdentity(source, function(data)
		local message = table.concat(args, ' ')

		if data.job == 'police' then
			TriggerClientEvent('chat:addMessage', -1, { templateId = 'police', args = { 'Police', message } })
		else
			TriggerClientEvent('customNotification', _source, "You must be police to use this command")
		end
	end)
end, {help = 'Send a global police formatted message.', params = {{name = 'message', help = 'the message'}}})

TriggerEvent('es:addCommand', 'ooc', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()

	getIdentity(source, function(data)
		if group == 'admin' or group == 'superadmin' then
			TriggerClientEvent('chatMessage', -1, "^0[^1ADMINISTRATION^0] OOC | " .. data.fullname, {128, 128, 128}, table.concat(args, " "))
		else
			TriggerClientEvent('chatMessage', -1, "OOC | " .. data.fullname, {128, 128, 128}, table.concat(args, " "))
		end
	end)
end, {help = 'Send a global out of character message.', params = {{name = 'message', help = 'the message'}}})

RegisterNetEvent("sendMECommand")
AddEventHandler("sendMECommand", function(msg)
	getIdentity(source, function(data)
		TriggerClientEvent("sendProximityMessageMe", -1, source, data.firstname, msg)
	end)
end)

RegisterNetEvent('esx_rpchat:sharePhoneNumber')
AddEventHandler('esx_rpchat:sharePhoneNumber', function(msg)
	local xPlayer = ESX.GetPlayerFromId(source)

	local phoneNumber = xPlayer.get('phoneNumber')

	if phoneNumber then
		TriggerClientEvent('sendProximityMessageMe', -1, source, xPlayer.name, ('Phone number: %s'):format(phoneNumber))
	end
end)