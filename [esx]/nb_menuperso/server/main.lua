ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('NB:getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()

	cb(group)
end)

TriggerEvent('es:addGroupCommand', 'getpos', 'admin', function(source, args, user)
	local coords = user.getCoords()
	local vectorFormat = ("vector3(%.1f, %.1f, %.1f)"):format(coords.x, coords.y, coords.z)

	print(vectorFormat)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Get your coords!"})

TriggerEvent('es:addGroupCommand', 'emotes', 'user', function(source, args, user)
	TriggerClientEvent('adrp:openAnimationMenu', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Access emotes faster"})

function getMaximumGradeJob(jobname)
	local result = MySQL.Sync.fetchAll('SELECT grade FROM job_grades WHERE job_name=@jobname  ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	})

	if result[1] ~= nil then
		return result[1].grade
	end

	return nil
end

function getMaximumGrade(gangname)
	local result = MySQL.Sync.fetchAll('SELECT grade FROM gang_grades WHERE gang_name=@gangname  ORDER BY `grade` DESC ;', {
		['@gangname'] = gangname
	})

	if result[1] ~= nil then
		return result[1].grade
	end

	return nil
end

RegisterServerEvent('AdminMenu:giveDirtyMoney')
AddEventHandler('AdminMenu:giveDirtyMoney', function(money)
	local xPlayer = ESX.GetPlayerFromId(source)
	local time = os.date('%Y-%m-%d %H:%M')

	if xPlayer.getGroup() == 'superadmin' then
		xPlayer.addAccountMoney('black_money', money)
		TriggerClientEvent('esx:showNotification', source, ('You have been granted ~g~$%s~s~ dirty money'):format(ESX.Math.GroupDigits(money)))
	else
		local formatted = ('KMENU CHEATER!\n\nSteamID: %s\nReason: attempted to run event giveDirtyMoney!'):format(xPlayer.identifier)
		TriggerEvent('adrp_anticheat:cheaterDetected', formatted)
		TriggerEvent('adrp_anticheat:banCheater', source)
	end
end)

RegisterServerEvent('NB:promouvoirplayer')
AddEventHandler('NB:promouvoirplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local maximumgrade = tonumber(getMaximumGradeJob(sourceXPlayer.job.name)) -1

	if targetXPlayer.job.grade == maximumgrade then
		TriggerClientEvent('esx:showNotification', _source, 'You must ask permission from the ~r~government~s~.')
	else
		if sourceXPlayer.job.name == targetXPlayer.job.name then
			local grade = tonumber(targetXPlayer.job.grade) + 1 
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, 'You have ~g~promoted '..targetXPlayer.name..'~s~.')
			TriggerClientEvent('esx:showNotification', target,  'You have been ~g~promoted by '.. sourceXPlayer.name..'~s~.')
		else
			TriggerClientEvent('esx:showNotification', _source, 'You do not have ~r~cleareance~s~.')
		end
	end
end)

RegisterServerEvent('NB:destituerplayer')
AddEventHandler('NB:destituerplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if targetXPlayer.gang.grade == 0 then
		TriggerClientEvent('esx:showNotification', _source, 'You can not ~r~demote~s~.')
	else
		if sourceXPlayer.gang.name == targetXPlayer.gang.name then
			local grade = tonumber(targetXPlayer.gang.grade) - 1 
			local gang = targetXPlayer.gang.name

			targetXPlayer.setGang(gang, grade)

			TriggerClientEvent('esx:showNotification', _source, 'You have ~r~demoted '..targetXPlayer.name..'~s~.')
			TriggerClientEvent('esx:showNotification', target,  'You have been ~r~demoted by '.. sourceXPlayer.name..'~s~.')
		else
			TriggerClientEvent('esx:showNotification', _source, 'You do not have ~r~cleareance~s~.')
		end
	end
end)

RegisterServerEvent('NB:recruterplayer')
AddEventHandler('NB:recruterplayer', function(target, job, grade)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job ~= nil and sourceXPlayer.job.grade_name == 'boss' then
		targetXPlayer.setJob(job, grade)

		TriggerClientEvent('esx:showNotification', _source, 'You have ~g~recruited '..targetXPlayer.name..'~s~.')
		TriggerClientEvent('esx:showNotification', target,  'You have been ~g~recruited by '.. sourceXPlayer.name..'~s~.')
	end
end)

RegisterServerEvent('NB:virerplayer')
AddEventHandler('NB:virerplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = 'unemployed'
	local grade = '0'

	if(sourceXPlayer.job.name == targetXPlayer.job.name)then
		targetXPlayer.setJob(job, grade)

		TriggerClientEvent('esx:showNotification', _source, 'You have ~r~fired '..targetXPlayer.name..'~s~.')
		TriggerClientEvent('esx:showNotification', target,  'You have been ~r~fired by '.. sourceXPlayer.name..'~s~.')	
	else
		TriggerClientEvent('esx:showNotification', _source, 'You do not have ~r~cleareance~s~.')
	end
end)

RegisterServerEvent('NB:promoteplayer')
AddEventHandler('NB:promoteplayer', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.gang.name)) -1

	if targetXPlayer.gang.grade == maximumgrade then
		TriggerClientEvent('esx:showNotification', _source, 'You must ask permission from the ~r~government~s~.')
	else
		if sourceXPlayer.gang.name == targetXPlayer.gang.name then
			local grade = tonumber(targetXPlayer.gang.grade) + 1 
			local gang = targetXPlayer.gang.name

			targetXPlayer.setGang(gang, grade)

			TriggerClientEvent('esx:showNotification', _source, 'You have ~g~promoted '..targetXPlayer.name..'~s~.')
			TriggerClientEvent('esx:showNotification', target,  'You have been ~g~promoted by '.. sourceXPlayer.name..'~s~.')		
		else
			TriggerClientEvent('esx:showNotification', _source, 'You do not have ~r~cleareance~s~.')
		end
	end
end)

RegisterServerEvent('NB:demoteplayer')
AddEventHandler('NB:demoteplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if targetXPlayer.gang.grade == 0 then
		TriggerClientEvent('esx:showNotification', source, 'You can not ~r~demote~s~.')
	else
		if sourceXPlayer.gang.name == targetXPlayer.gang.name then
			local grade = tonumber(targetXPlayer.gang.grade) - 1
			local gang = targetXPlayer.gang.name

			targetXPlayer.setGang(gang, grade)

			TriggerClientEvent('esx:showNotification', source, 'You have ~r~demoted '..targetXPlayer.name..'~s~.')
			TriggerClientEvent('esx:showNotification', target,  'You have been ~r~demoted by '.. sourceXPlayer.name..'~s~.')

		else
			TriggerClientEvent('esx:showNotification', source, 'You do not have ~r~cleareance~s~.')
		end
	end
end)

RegisterServerEvent('NB:recruitplayer')
AddEventHandler('NB:recruitplayer', function(target, gang, grade)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	targetXPlayer.setGang(gang, grade)

	TriggerClientEvent('esx:showNotification', source, 'You have ~g~recruited '..targetXPlayer.name..'~s~.')
	TriggerClientEvent('esx:showNotification', target,  'You have been ~g~recruited by '.. sourceXPlayer.name..'~s~.')
end)

RegisterServerEvent('NB:fireplayer')
AddEventHandler('NB:fireplayer', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local gang = 'nogang'
	local grade = '0'

	if(sourceXPlayer.gang.name == targetXPlayer.gang.name)then
		targetXPlayer.setGang(gang, grade)

		TriggerClientEvent('esx:showNotification', source, 'You have ~r~fired '..targetXPlayer.name..'~s~.')
		TriggerClientEvent('esx:showNotification', target,  'You have been ~r~fired by '.. sourceXPlayer.name..'~s~.')	
	else

		TriggerClientEvent('esx:showNotification', source, 'You do not have ~r~cleareance~s~.')
	end
end)
