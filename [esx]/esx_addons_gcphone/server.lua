ESX = nil
local phoneNumbers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function notifyAlertSMS(number, alert, listSrc)
	if phoneNumbers[number] then
		for playerId,_ in pairs(listSrc) do
			getPhoneNumber(playerId, function(phoneNumber)
				if phoneNumber then
					TriggerEvent('gcPhone:_internalAddMessage', number, phoneNumber, alert.message, 0, function(smsMess)
						TriggerClientEvent('gcPhone:receiveMessage', playerId, smsMess)
					end)

					if alert.coords then
						TriggerEvent('gcPhone:_internalAddMessage', number, phoneNumber, ('GPS: %.1f, %.1f'):format(alert.coords.x, alert.coords.y), 0, function(smsMess)
							TriggerClientEvent('gcPhone:receiveMessage', playerId, smsMess)
						end)
					end
				end
			end)
		end
	end
end

AddEventHandler('esx_phone:registerNumber', function(number, type, sharePos, hasDispatch, hideNumber, hidePosIfAnon)
	phoneNumbers[number] = {
		type    = type,
		sources = {},
		alerts  = {}
	}
end)

-- todo: in the future we can delete this entire event handler, no one should get job notifications without being onduty!
AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	TriggerEvent('esx_addons_gcphone:removeSource', lastJob.name, playerId)

	job = job.name
	if job ~= 'police' and job ~= 'sheriff' and job ~= 'state' and job ~= 'ambulance' and job ~= 'mecano' and job ~= 'taxi' and job ~= 'cardealer' and job ~= 'heli' then
		TriggerEvent('esx_addons_gcphone:addSource', job, playerId)
	end
end)

AddEventHandler('esx_addons_gcphone:addSource', function(number, playerId)
	if phoneNumbers[number] then
		phoneNumbers[number].sources[playerId] = true
	end
end)

AddEventHandler('esx_addons_gcphone:removeSource', function(number, playerId)
	if phoneNumbers[number] then
		phoneNumbers[number].sources[playerId] = nil
	end
end)

RegisterServerEvent('esx_addons_gcphone:startCall')
AddEventHandler('esx_addons_gcphone:startCall', function(number, message, coords)
	if phoneNumbers[number] then
		getPhoneNumber(source, function(phoneNumber)
			notifyAlertSMS(number, {
				message = message,
				coords = coords,
				numero = phoneNumber,
			}, phoneNumbers[number].sources)
		end)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		TriggerEvent('esx_addons_gcphone:removeSource', xPlayer.job.name, playerId)
	end
end)

function getPhoneNumber(playerId, callback)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer == nil then
		callback(nil)
	else
		callback(xPlayer.get('phoneNumber') or nil)
	end
end