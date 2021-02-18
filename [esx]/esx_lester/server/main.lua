ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('Lester:drugInformation')
AddEventHandler('Lester:drugInformation', function(drugAction,price)
	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()

	if drugAction == 'cokeCollect' then
		if money >= price then
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "The Wet, the damp and the bombs and guns, all the exitement of a battle zone but close to home. Process the powder at the end of the line." )
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Information isn't free, get your bread up!" )
		end
	elseif drugAction == 'methCollect' then
		if money >= price then
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Often annoying, rarely unsolved. Not so bad of a view, beach is very beautiful on sunset" )
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Information isn't free, get your bread up!" )
		end
	elseif drugAction == 'methProcess' then
		if money >= price then
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "The smoke and smog of a steel jungle" )
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Information isn't free, get your bread up!" )
		end
	elseif drugAction == 'moneyLaundering' then
		if money >= price then
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Not to be confused for prostitution." )
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Information isn't free, get your bread up!" )
		end
	elseif drugAction == 'blackweapons' then
		if money >= price then
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Seek out and find your friendly neighborhood arms dealer, get your gear in 4 locations, One at the end of the track in the warehouse near-by, Another in a construction site on north rockford, one you might get stabed, but not in the city, and the other is at the end of US-route 13, just north of paleto." )
			xPlayer.removeMoney(price)
		else
			TriggerClientEvent('chatMessage', source, 'Lester', {0, 255, 100}, "Information isn't free, get your bread up!" )
		end
	end
end)