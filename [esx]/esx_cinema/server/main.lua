ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx_cinema:payPrice',function(source, cb, showName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPriceFromShowName(showName)

	if not price then
		print(('esx_cinema: %s parsed invalid show'):format(xPlayer.identifier))
		cb(false)
	end

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		cb(true)
	else
		cb(false)
	end
end)

function GetPriceFromShowName(showName)
	for k, v in pairs(Config.AvailableCinemaShows) do
		if v.showName == showName then
			return v.price
		end
	end

	return nil
end

TriggerEvent('es:addGroupCommand', 'openeditor', 'pr', function (source, args, user)
	TriggerClientEvent('esx_cinema:openEditor', source)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficienct permissions!' } })
end, { help = 'Open the rockstar editor. Opening the editor menu will instance you.' })

TriggerEvent('es:addGroupCommand', 'recordstart', 'pr', function (source, args, user)
	TriggerClientEvent('esx_cinema:recordStart', source)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficienct permissions!' } })
end, { help = 'Start recording' })

TriggerEvent('es:addGroupCommand', 'recordstop', 'pr', function (source, args, user)
	TriggerClientEvent('esx_cinema:recordStop', source)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficienct permissions!' } })
end, { help = 'Stop recording. Use /recorddiscard instead if you want to discard the recording.' })

TriggerEvent('es:addGroupCommand', 'recorddiscard', 'pr', function (source, args, user)
	TriggerClientEvent('esx_cinema:recordDiscard', source)
end, function (source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficienct permissions!' } })
end, { help = 'Stop & discard recording' })

TriggerEvent('es:addCommand', 'togglecinema', function(source, args, user)
	TriggerClientEvent('esx_cinema:toggleCinema', source)
end, {help = 'Toggle the cinema mode'})

TriggerEvent('es:addCommand', 'toggleui', function(source, args, user)
	TriggerClientEvent('esx_cinema:toggleUi', source)
end, {help = 'Toggle most UI elements'})
