--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================

local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[
	ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
		local xPlayer = ESX.GetPlayerFromId(source)
		local items = xPlayer.getInventoryItem(item)
		if items == nil then
			cb(0)
		else
			cb(items.count)
		end
	end)
--]]


-- Used when restarting resource midgame
RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
	local playerId = source
	local identifier = GetPlayerIdentifier(playerId, 0)
	local phoneNumber = getNumberPhone(identifier)

	if phoneNumber then
		TriggerClientEvent('gcPhone:myPhoneNumber', playerId, phoneNumber)
		TriggerClientEvent('gcPhone:contactList', playerId, getContacts(identifier, phoneNumber))
		TriggerClientEvent('gcPhone:allMessage', playerId, getMessages(phoneNumber))
		TriggerClientEvent('gcPhone:getBourse', playerId, getBourse())
		sendHistoriqueCall(playerId, phoneNumber)
	end
end)

MySQL.ready(function()
	MySQL.Async.fetchAll('DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)')
end)

function getPlayerIdFromIdentifier(identifier, cb)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

	if xPlayer then
		cb(xPlayer.source)
	else
		cb(nil)
	end
end

function getNumberPhone(identifier)
	local result = MySQL.Sync.fetchAll('SELECT phone_number FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})

	if result[1] then
		return result[1].phone_number
	end

	return nil
end

function getIdentifierByPhoneNumber(phone_number)
	local result = MySQL.Sync.fetchAll('SELECT identifier FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phone_number
	})

	if result[1] then
		return result[1].identifier
	end

	return nil
end

--====================================================================================
--  Contacts
--====================================================================================

function getContacts(identifier, phoneNumber)
	local result = MySQL.Sync.fetchAll('SELECT * FROM phone_users_contacts WHERE identifier = @identifier AND identifier_phone = @phone_number', {
		['@identifier'] = identifier,
		['@phone_number'] = phoneNumber
	})

	return result
end

function addContact(source, identifier, number, display)
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	local myNumber = xPlayer.get('phoneNumber')

	MySQL.Async.insert('INSERT INTO phone_users_contacts (`identifier`, `identifier_phone`, `number`, `display`) VALUES (@identifier, @identifier_phone, @number, @display)', {
		['@identifier'] = identifier,
		['@identifier_phone'] = myNumber,
		['@number'] = number,
		['@display'] = display,
	}, function()
		notifyContactChange(sourcePlayer, identifier)
	end)
end

function updateContact(source, identifier, id, number, display)
	local sourcePlayer = tonumber(source)
	MySQL.Async.insert('UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id', {
		['@number'] = number,
		['@display'] = display,
		['@id'] = id,
	}, function()
		notifyContactChange(sourcePlayer, identifier)
	end)
end

function deleteContact(playerId, identifier, id)
	MySQL.Sync.execute('DELETE FROM phone_users_contacts WHERE identifier = @identifier AND id = @id', {
		['@identifier'] = identifier,
		['@id'] = id,
	})

	notifyContactChange(playerId, identifier)
end

function deleteAllContact(playerId, identifier)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Sync.execute('DELETE FROM phone_users_contacts WHERE identifier = @identifier AND identifier_phone = @identifier_phone', {
		['@identifier'] = identifier,
		['@identifier_phone'] = xPlayer.get('phoneNumber')
	})
end

function notifyContactChange(source, identifier)
	local sourcePlayer = tonumber(source)

	if sourcePlayer then
		local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
		TriggerClientEvent('gcPhone:contactList', sourcePlayer, getContacts(identifier, xPlayer.get('phoneNumber')))
	end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
	local identifier = GetPlayerIdentifier(source, 0)
	deleteContact(source, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================

function getMessages(phoneNumber)
	local result = MySQL.Sync.fetchAll('SELECT * FROM phone_messages WHERE receiver = @receiver', {
		['@receiver'] = phoneNumber
	})

	return result
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
	cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
	local id = MySQL.Sync.insert('INSERT INTO phone_messages (`transmitter`, `receiver`, `message`, `isRead`, `owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner)', {
		['@transmitter'] = transmitter,
		['@receiver'] = receiver,
		['@message'] = message or '',
		['@isRead'] = owner,
		['@owner'] = owner
	})

	return MySQL.Sync.fetchAll('SELECT * FROM phone_messages WHERE `id` = @id', {
		['@id'] = id
	})[1]
end

function addMessage(source, identifier, phone_number, message)
	local sourcePlayer = tonumber(source)
	local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
	local myPhone = getNumberPhone(identifier)

	if otherIdentifier then
		local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
		getPlayerIdFromIdentifier(otherIdentifier, function(targetPlayer)
			if targetPlayer then
				TriggerClientEvent('gcPhone:receiveMessage', targetPlayer, tomess)
			end
		end)
	end

	local memess = _internalAddMessage(phone_number, myPhone, message, 1)
	TriggerClientEvent('gcPhone:receiveMessage', sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
	local mePhoneNumber = getNumberPhone(identifier)
	MySQL.Sync.execute('UPDATE phone_messages SET isRead = 1 WHERE receiver = @receiver AND transmitter = @transmitter', {
		['@receiver'] = tostring(mePhoneNumber),
		['@transmitter'] = tostring(num)
	})
end

function deleteMessage(msgId)
	MySQL.Sync.execute('DELETE FROM phone_messages WHERE `id` = @id', {
		['@id'] = msgId
	})
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
	local source = source
	local identifier = identifier
	local mePhoneNumber = getNumberPhone(identifier)

	MySQL.Sync.execute('DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number', {
		['@mePhoneNumber'] = tostring(mePhoneNumber),
		['@phone_number'] = tostring(phone_number)
	})
end

function deleteAllMessage(identifier)
	local mePhoneNumber = getNumberPhone(identifier)

	MySQL.Sync.execute('DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber', {
		['@mePhoneNumber'] = tostring(mePhoneNumber)
	})
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
	deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	deleteAllMessage(identifier)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
	local identifier = GetPlayerIdentifier(source, 0)
	setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	deleteAllMessage(identifier)
	deleteAllContact(sourcePlayer, identifier)
	appelsDeleteAllHistorique(identifier)
	TriggerClientEvent('gcPhone:contactList', sourcePlayer, {})
	TriggerClientEvent('gcPhone:allMessage', sourcePlayer, {})
	TriggerClientEvent('appelsDeleteAllHistorique', sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================

function getHistoriqueCall(num)
	local result = MySQL.Sync.fetchAll('SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120', {
		['@num'] = num
	})

	return result
end

function sendHistoriqueCall(src, num)
	local histo = getHistoriqueCall(num)
	TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels(appelInfo)
	if not appelInfo.extraData or not appelInfo.extraData.useNumber then
		MySQL.Async.insert('INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES (@owner, @num, @incoming, @accepts)', {
			['@owner'] = appelInfo.transmitter_num,
			['@num'] = appelInfo.receiver_num,
			['@incoming'] = 1,
			['@accepts'] = appelInfo.is_accepts
		}, function()
			notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
		end)
	end

	if appelInfo.is_valid then
		local num = appelInfo.transmitter_num

		if appelInfo.hidden then
			mun = '###-####' -- todo change
		end

		MySQL.Async.insert('INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES (@owner, @num, @incoming, @accepts)', {
			['@owner'] = appelInfo.receiver_num,
			['@num'] = num,
			['@incoming'] = 0,
			['@accepts'] = appelInfo.is_accepts
		}, function()
			if appelInfo.receiver_src then
				notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
			end
		end)
	end
end

function notifyNewAppelsHisto(src, num)
	sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
	local srcIdentifier = GetPlayerIdentifier(source, 0)
	local srcPhone = getNumberPhone(srcIdentifier)
	sendHistoriqueCall(source, num)
end)

RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
	if FixePhone[phone_number] then
		onCallFixePhone(source, phone_number, rtcOffer, extraData)
		return
	end

	local rtcOffer = rtcOffer

	if not phone_number or phone_number == '' then
		return
	end

	local hidden = string.sub(phone_number, 1, 1) == '#' -- todo hidden?

	if hidden then
		phone_number = string.sub(phone_number, 2)
	end

	local indexCall = lastIndexCall
	lastIndexCall = lastIndexCall + 1
	local sourcePlayer = tonumber(source)
	local srcIdentifier = GetPlayerIdentifier(source, 0)
	local srcPhone = ''

	if extraData and extraData.useNumber then
		srcPhone = extraData.useNumber
	else
		srcPhone = getNumberPhone(srcIdentifier)
	end

	local destPlayer = getIdentifierByPhoneNumber(phone_number)
	local is_valid = destPlayer and destPlayer ~= srcIdentifier

	AppelsEnCours[indexCall] = {
		id = indexCall,
		transmitter_src = sourcePlayer,
		transmitter_num = srcPhone,
		receiver_src = nil,
		receiver_num = phone_number,
		is_valid = destPlayer,
		is_accepts = false,
		hidden = hidden,
		rtcOffer = rtcOffer,
		extraData = extraData
	}

	if is_valid then
		getPlayerIdFromIdentifier(destPlayer, function (targetPlayer)
			if targetPlayer then
				AppelsEnCours[indexCall].receiver_src = targetPlayer
				TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
				TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
				TriggerClientEvent('gcPhone:waitingCall', targetPlayer, AppelsEnCours[indexCall], false)
			else
				TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
				TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
			end
		end)
	else
		TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
		TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
	end
end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
	TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
	if AppelsEnCours[callId] then
		local source = source
		local to = AppelsEnCours[callId].transmitter_src

		if source == to then
			to = AppelsEnCours[callId].receiver_src
		end

		TriggerClientEvent('gcPhone:candidates', to, candidates)
	end
end)

RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
	local id = infoCall.id

	if AppelsEnCours[id] then
		if PhoneFixeInfo[id] then
			onAcceptFixePhone(source, infoCall, rtcAnswer)
			return
		end

		AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src

		if AppelsEnCours[id].transmitter_src and AppelsEnCours[id].receiver_src~= nil then
			AppelsEnCours[id].is_accepts = true
			AppelsEnCours[id].rtcAnswer = rtcAnswer
			TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)

			SetTimeout(1000, function() -- change to +1000, if necessary.
				TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
			end)

			saveAppels(AppelsEnCours[id])
		end
	end
end)

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
	local id = infoCall.id

	if AppelsEnCours[id] then
		if PhoneFixeInfo[id] then
			onRejectFixePhone(source, infoCall)
			return
		end

		if AppelsEnCours[id].transmitter_src then
			TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
		end

		if AppelsEnCours[id].receiver_src then
			TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
		end

		if AppelsEnCours[id].is_accepts == false then
			saveAppels(AppelsEnCours[id])
		end

		TriggerEvent('gcPhone:removeCall', AppelsEnCours)
		AppelsEnCours[id] = nil
	end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
	local sourcePlayer = tonumber(source)
	local srcIdentifier = GetPlayerIdentifier(source, 0)
	local srcPhone = getNumberPhone(srcIdentifier)

	MySQL.Sync.execute('DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num', {
		['@owner'] = srcPhone,
		['@num'] = numero
	})
end)

function appelsDeleteAllHistorique(srcIdentifier)
	local srcPhone = getNumberPhone(srcIdentifier)
	MySQL.Sync.execute('DELETE FROM phone_calls WHERE `owner` = @owner', {
		['@owner'] = srcPhone
	})
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)
	appelsDeleteAllHistorique(identifier)
end)

--====================================================================================
--  App bourse
--====================================================================================

function getBourse()
	--  Format
	--  Array
	--    Object
	--      -- libelle type String    | Nom
	--      -- price type number      | Prix actuelle
	--      -- difference type number | Evolution
	--
	-- local result = MySQL.Sync.fetchAll('SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC',{})
	local result = {
		{
			libelle = 'Google',
			price = 125.2,
			difference =  -12.1
		},
		{
			libelle = 'Microsoft',
			price = 132.2,
			difference = 3.1
		},
		{
			libelle = 'Amazon',
			price = 120,
			difference = 0
		}
	}
	return result
end

function onCallFixePhone(source, phone_number, rtcOffer, extraData)
	local indexCall = lastIndexCall
	lastIndexCall = lastIndexCall + 1
	local hidden = string.sub(phone_number, 1, 1) == '#'

	if hidden then
		phone_number = string.sub(phone_number, 2)
	end

	local sourcePlayer = tonumber(source)
	local identifier = GetPlayerIdentifier(source, 0)

	local srcPhone = ''

	if extraData and extraData.useNumber then
		srcPhone = extraData.useNumber
	else
		srcPhone = getNumberPhone(identifier)
	end

	AppelsEnCours[indexCall] = {
		id = indexCall,
		transmitter_src = sourcePlayer,
		transmitter_num = srcPhone,
		receiver_src = nil,
		receiver_num = phone_number,
		is_valid = false,
		is_accepts = false,
		hidden = hidden,
		rtcOffer = rtcOffer,
		extraData = extraData,
		coords = FixePhone[phone_number].coords
	}

	PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

	TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
	TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end

function onAcceptFixePhone(source, infoCall, rtcAnswer)
	local id = infoCall.id
	AppelsEnCours[id].receiver_src = source

	if AppelsEnCours[id].transmitter_src and AppelsEnCours[id].receiver_src~= nil then
		AppelsEnCours[id].is_accepts = true
		AppelsEnCours[id].forceSaveAfter = true
		AppelsEnCours[id].rtcAnswer = rtcAnswer
		PhoneFixeInfo[id] = nil

		TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)

		SetTimeout(1000, function() -- change to +1000, if necessary.
			TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
		end)

		saveAppels(AppelsEnCours[id])
	end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
	local id = infoCall.id
	PhoneFixeInfo[id] = nil
	TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
	TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)

	if not AppelsEnCours[id].is_accepts then
		saveAppels(AppelsEnCours[id])
	end

	AppelsEnCours[id] = nil
end